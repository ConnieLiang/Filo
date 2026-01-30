#!/usr/bin/env node
/**
 * Figma Color Sync Script for Filo
 * 
 * Automatically fetches color styles from Light and Dark Figma frames.
 * 
 * Setup:
 * 1. Generate a Figma Personal Access Token at: https://www.figma.com/developers/api#access-tokens
 * 2. Set the environment variable: export FIGMA_ACCESS_TOKEN="your-token-here"
 * 3. Run: node sync-figma-colors.js
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// Load configuration
const configPath = path.join(__dirname, 'figma-sync-config.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

const FIGMA_TOKEN = process.env.FIGMA_ACCESS_TOKEN;
const FILE_KEY = config.figma.fileKey;

if (!FIGMA_TOKEN) {
  console.error('Error: FIGMA_ACCESS_TOKEN environment variable is not set.');
  console.error('Generate a token at: https://www.figma.com/developers/api#access-tokens');
  console.error('Then run: export FIGMA_ACCESS_TOKEN="your-token-here"');
  process.exit(1);
}

/**
 * Make a request to the Figma API
 */
function figmaRequest(endpoint) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'api.figma.com',
      path: endpoint,
      method: 'GET',
      headers: {
        'X-Figma-Token': FIGMA_TOKEN
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 200) {
          resolve(JSON.parse(data));
        } else {
          reject(new Error(`Figma API error ${res.statusCode}: ${data}`));
        }
      });
    });

    req.on('error', reject);
    req.end();
  });
}

/**
 * Convert Figma color (0-1 range) to hex
 */
function figmaColorToHex(color) {
  const r = Math.round((color.r || 0) * 255);
  const g = Math.round((color.g || 0) * 255);
  const b = Math.round((color.b || 0) * 255);
  return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`.toUpperCase();
}

/**
 * Extract color from a node's fills
 */
function extractColor(node) {
  // Look for solid fills
  if (node.fills && node.fills.length > 0) {
    const fill = node.fills[0];
    if (fill.type === 'SOLID' && fill.color) {
      const hex = figmaColorToHex(fill.color);
      const opacity = fill.opacity !== undefined ? fill.opacity : 1;
      
      if (opacity < 1) {
        return `${hex} ${Math.round(opacity * 100)}%`;
      }
      return hex;
    }
  }
  
  // Check background color
  if (node.backgroundColor) {
    return figmaColorToHex(node.backgroundColor);
  }
  
  return null;
}

/**
 * Extract token number from node name (e.g., "01", "02", etc.)
 */
function extractToken(name) {
  const match = name.match(/^(\d+)/);
  return match ? match[1].padStart(2, '0') : null;
}

/**
 * Clean color name by removing token prefix
 */
function cleanColorName(name) {
  return name
    .replace(/^\d+[\s\-_\.]*/, '') // Remove leading numbers and separators
    .replace(/\s+/g, ' ')           // Normalize whitespace
    .trim();
}

/**
 * Recursively find all color nodes in the frame
 */
function findColorNodes(node, colors = []) {
  // Look for rectangles, frames, or components that represent color swatches
  if ((node.type === 'RECTANGLE' || node.type === 'FRAME' || node.type === 'COMPONENT' || node.type === 'INSTANCE') 
      && node.fills && node.fills.length > 0) {
    const color = extractColor(node);
    const token = extractToken(node.name);
    
    if (color && token) {
      colors.push({
        token: token,
        name: cleanColorName(node.name) || node.name,
        color: color,
        figmaId: node.id
      });
    }
  }
  
  // Also check for color rectangles inside frames (common pattern)
  if (node.children) {
    // If this is a color swatch container, look for the color rectangle inside
    const token = extractToken(node.name);
    if (token && node.type === 'FRAME') {
      for (const child of node.children) {
        if (child.type === 'RECTANGLE' && child.fills && child.fills.length > 0) {
          const color = extractColor(child);
          if (color) {
            colors.push({
              token: token,
              name: cleanColorName(node.name) || node.name,
              color: color,
              figmaId: node.id
            });
            break; // Found the color, don't recurse further into this node
          }
        }
      }
    }
    
    // Recurse into children
    for (const child of node.children) {
      findColorNodes(child, colors);
    }
  }
  
  return colors;
}

/**
 * Remove duplicate colors (keep first occurrence)
 */
function deduplicateColors(colors) {
  const seen = new Set();
  return colors.filter(c => {
    if (seen.has(c.token)) return false;
    seen.add(c.token);
    return true;
  });
}

/**
 * Merge light and dark colors into combined format
 */
function mergeColorModes(lightColors, darkColors) {
  const colorMap = new Map();
  
  // Add light colors
  for (const color of lightColors) {
    colorMap.set(color.token, {
      token: color.token,
      name: color.name,
      light: color.color,
      dark: null
    });
  }
  
  // Merge dark colors
  for (const color of darkColors) {
    if (colorMap.has(color.token)) {
      colorMap.get(color.token).dark = color.color;
    } else {
      colorMap.set(color.token, {
        token: color.token,
        name: color.name,
        light: null,
        dark: color.color
      });
    }
  }
  
  // Convert to array and sort by token
  return Array.from(colorMap.values())
    .sort((a, b) => a.token.localeCompare(b.token, undefined, { numeric: true }));
}

/**
 * Generate semantic aliases based on color names
 */
function generateSemanticAliases(colors) {
  const aliases = {};
  
  const semanticMappings = [
    { keywords: ['primary', 'accent', 'brand'], alias: 'primary' },
    { keywords: ['secondary', 'text secondary'], alias: 'secondary' },
    { keywords: ['background primary', 'bg primary'], alias: 'background' },
    { keywords: ['background secondary', 'surface', 'bg secondary'], alias: 'surface' },
    { keywords: ['error', 'destructive', 'danger'], alias: 'error' },
    { keywords: ['warning', 'caution'], alias: 'warning' },
    { keywords: ['success', 'positive'], alias: 'success' },
    { keywords: ['info', 'link', 'information'], alias: 'info' },
    { keywords: ['divider', 'border', 'separator'], alias: 'divider' }
  ];
  
  for (const color of colors) {
    const nameLower = color.name.toLowerCase();
    
    for (const mapping of semanticMappings) {
      if (!aliases[mapping.alias]) {
        for (const keyword of mapping.keywords) {
          if (nameLower.includes(keyword)) {
            aliases[mapping.alias] = color.token;
            break;
          }
        }
      }
    }
  }
  
  return aliases;
}

/**
 * Main sync function
 */
async function syncColors() {
  console.log('🔄 Starting Figma color sync...');
  console.log(`   File: ${config.figma.fileName}`);
  
  try {
    // Step 1: Get file info
    console.log('\n📥 Fetching Figma file info...');
    const fileInfo = await figmaRequest(`/v1/files/${FILE_KEY}?depth=1`);
    const currentVersion = fileInfo.version;
    
    console.log(`   File version: ${currentVersion}`);
    console.log(`   Last modified: ${fileInfo.lastModified}`);
    
    // Step 2: Fetch light mode colors
    console.log('\n☀️  Fetching light mode colors...');
    const lightNodeId = config.figma.frames.light.nodeId;
    const lightData = await figmaRequest(`/v1/files/${FILE_KEY}/nodes?ids=${lightNodeId}`);
    const lightFrame = lightData.nodes[lightNodeId]?.document;
    
    if (!lightFrame) {
      throw new Error(`Could not find light frame with node-id: ${lightNodeId}`);
    }
    
    console.log(`   Frame name: ${lightFrame.name}`);
    const lightColors = deduplicateColors(findColorNodes(lightFrame));
    console.log(`   Found ${lightColors.length} colors`);
    
    // Step 3: Fetch dark mode colors
    console.log('\n🌙 Fetching dark mode colors...');
    const darkNodeId = config.figma.frames.dark.nodeId;
    const darkData = await figmaRequest(`/v1/files/${FILE_KEY}/nodes?ids=${darkNodeId}`);
    const darkFrame = darkData.nodes[darkNodeId]?.document;
    
    if (!darkFrame) {
      throw new Error(`Could not find dark frame with node-id: ${darkNodeId}`);
    }
    
    console.log(`   Frame name: ${darkFrame.name}`);
    const darkColors = deduplicateColors(findColorNodes(darkFrame));
    console.log(`   Found ${darkColors.length} colors`);
    
    // Step 4: Merge light and dark colors
    console.log('\n🎨 Merging color modes...');
    const mergedColors = mergeColorModes(lightColors, darkColors);
    console.log(`   Total color tokens: ${mergedColors.length}`);
    
    if (mergedColors.length === 0) {
      console.log('\n⚠️  No colors found in the specified frames.');
      console.log('   Make sure the frames contain RECTANGLE or FRAME nodes with fills.');
      console.log('   Node names should start with a number (e.g., "01 Blue Accent").');
      return;
    }
    
    // Step 5: Generate semantic aliases
    const semanticAliases = generateSemanticAliases(mergedColors);
    
    // Step 6: Build colors.json
    const colorsJson = {
      name: "Filo Color Palette",
      description: `${mergedColors.length} color tokens with light and dark mode variants - synced from Figma`,
      colors: mergedColors,
      semanticAliases: semanticAliases,
      figmaSync: {
        fileKey: FILE_KEY,
        frames: {
          light: config.figma.frames.light.nodeId,
          dark: config.figma.frames.dark.nodeId
        },
        lastSyncedAt: new Date().toISOString(),
        figmaVersion: currentVersion,
        totalColors: mergedColors.length
      }
    };
    
    // Step 7: Write colors.json
    console.log('\n📝 Writing colors.json...');
    const outputPath = path.join(__dirname, 'colors.json');
    fs.writeFileSync(outputPath, JSON.stringify(colorsJson, null, 2));
    
    // Step 8: Update sync config
    config.sync.lastSyncedAt = new Date().toISOString();
    config.sync.lastFigmaVersion = currentVersion;
    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    
    console.log('\n✅ Sync complete!');
    console.log(`   ${mergedColors.length} color tokens synced`);
    
    // Print summary
    console.log('\n📋 Color Summary (first 10):');
    mergedColors.slice(0, 10).forEach(c => {
      console.log(`   ${c.token} ${c.name}: ${c.light || '—'} / ${c.dark || '—'}`);
    });
    if (mergedColors.length > 10) {
      console.log(`   ... and ${mergedColors.length - 10} more`);
    }
    
    if (Object.keys(semanticAliases).length > 0) {
      console.log('\n🏷️  Semantic Aliases:');
      for (const [alias, token] of Object.entries(semanticAliases)) {
        console.log(`   ${alias} → ${token}`);
      }
    }
    
  } catch (error) {
    console.error('\n❌ Sync failed:', error.message);
    process.exit(1);
  }
}

// Run sync
syncColors();
