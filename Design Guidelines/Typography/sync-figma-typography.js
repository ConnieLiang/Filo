#!/usr/bin/env node
/**
 * Figma Typography Sync Script for Filo
 * 
 * Automatically fetches text styles from the specified Figma frame.
 * 
 * Setup:
 * 1. Generate a Figma Personal Access Token at: https://www.figma.com/developers/api#access-tokens
 * 2. Set the environment variable: export FIGMA_ACCESS_TOKEN="your-token-here"
 * 3. Run: node sync-figma-typography.js
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// Load configuration
const configPath = path.join(__dirname, 'figma-sync-config.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

const FIGMA_TOKEN = process.env.FIGMA_ACCESS_TOKEN;
const FILE_KEY = config.figma.fileKey;
const NODE_ID = config.figma.nodeId;

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
 * Map Figma font weight to standard weight name
 */
function mapFontWeight(fontWeight) {
  const weightMap = {
    100: 'Thin',
    200: 'ExtraLight',
    300: 'Light',
    400: 'Regular',
    500: 'Medium',
    600: 'SemiBold',
    700: 'Bold',
    800: 'ExtraBold',
    900: 'Black'
  };
  return weightMap[fontWeight] || `Weight${fontWeight}`;
}

/**
 * Extract text style info from a TEXT node
 */
function extractTextStyle(node) {
  if (node.type !== 'TEXT' || !node.style) {
    return null;
  }

  const style = node.style;
  
  return {
    name: node.name,
    fontFamily: style.fontFamily || 'SF Pro',
    fontWeight: style.fontWeight || 400,
    weightName: mapFontWeight(style.fontWeight || 400),
    fontSize: style.fontSize || 16,
    lineHeight: style.lineHeightPx || Math.round(style.fontSize * 1.4),
    letterSpacing: style.letterSpacing || 0,
    textCase: style.textCase || 'ORIGINAL',
    italic: style.italic || false
  };
}

/**
 * Recursively find all text nodes in the frame
 */
function findTextNodes(node, textNodes = []) {
  if (node.type === 'TEXT') {
    const style = extractTextStyle(node);
    if (style) {
      textNodes.push(style);
    }
  }
  
  if (node.children) {
    for (const child of node.children) {
      findTextNodes(child, textNodes);
    }
  }
  
  return textNodes;
}

/**
 * Categorize styles into headings and body
 */
function categorizeStyles(styles) {
  const headings = [];
  const body = [];
  
  for (const style of styles) {
    const name = style.name.toLowerCase();
    
    // Determine weight string with italic
    let weight = style.weightName;
    if (style.italic) {
      weight += ' Italic';
    }
    
    const formatted = {
      name: style.name,
      font: style.fontFamily,
      weight: weight,
      size: style.fontSize,
      lineHeight: Math.round(style.lineHeight),
      kerning: Math.round(style.letterSpacing * 10) / 10
    };
    
    // Categorize based on name pattern
    if (name.startsWith('h') && /^h\d/.test(name)) {
      headings.push(formatted);
    } else {
      body.push(formatted);
    }
  }
  
  // Sort headings by H number, body by size descending
  headings.sort((a, b) => {
    const aNum = parseInt(a.name.match(/\d+/)?.[0] || 0);
    const bNum = parseInt(b.name.match(/\d+/)?.[0] || 0);
    return aNum - bNum;
  });
  
  body.sort((a, b) => b.size - a.size);
  
  return { headings, body };
}

/**
 * Main sync function
 */
async function syncTypography() {
  console.log('🔄 Starting Figma typography sync...');
  console.log(`   File: ${config.figma.fileName}`);
  console.log(`   Frame: node-id=${NODE_ID}`);
  
  try {
    // Step 1: Get file info
    console.log('\n📥 Fetching Figma file info...');
    const fileInfo = await figmaRequest(`/v1/files/${FILE_KEY}?depth=1`);
    const currentVersion = fileInfo.version;
    
    console.log(`   File version: ${currentVersion}`);
    console.log(`   Last modified: ${fileInfo.lastModified}`);
    
    // Step 2: Get the specific frame/node
    console.log('\n📦 Fetching typography frame...');
    const nodeData = await figmaRequest(`/v1/files/${FILE_KEY}/nodes?ids=${NODE_ID}`);
    const frameNode = nodeData.nodes[NODE_ID]?.document;
    
    if (!frameNode) {
      throw new Error(`Could not find frame with node-id: ${NODE_ID}`);
    }
    
    console.log(`   Frame name: ${frameNode.name}`);
    
    // Step 3: Find all text nodes with styles
    const textNodes = findTextNodes(frameNode);
    console.log(`   Found ${textNodes.length} text styles`);
    
    if (textNodes.length === 0) {
      console.log('\n⚠️  No text styles found in the specified frame.');
      return;
    }
    
    // Step 4: Categorize into headings and body
    const { headings, body } = categorizeStyles(textNodes);
    console.log(`   Headings: ${headings.length}, Body: ${body.length}`);
    
    // Step 5: Build typography.json
    const typography = {
      name: "Filo Typography",
      description: "Type scale for Filo design system - synced from Figma",
      fontFamilies: {
        iOS: "SF Pro",
        macOS: "SF Pro",
        android: "Roboto",
        windows: "Segoe UI"
      },
      note: "Use platform-native typefaces to respect each OS's visual language. The type scale below applies across all platforms — only the font family changes.",
      headings: headings,
      body: body,
      figmaSync: {
        fileKey: FILE_KEY,
        nodeId: NODE_ID,
        frameUrl: config.figma.frameUrl,
        lastSyncedAt: new Date().toISOString(),
        figmaVersion: currentVersion,
        totalStyles: textNodes.length
      }
    };
    
    // Step 6: Write typography.json
    console.log('\n📝 Writing typography.json...');
    const outputPath = path.join(__dirname, 'typography.json');
    fs.writeFileSync(outputPath, JSON.stringify(typography, null, 2));
    
    // Step 7: Update sync config
    config.sync.lastSyncedAt = new Date().toISOString();
    config.sync.lastFigmaVersion = currentVersion;
    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    
    console.log('\n✅ Sync complete!');
    console.log(`   ${headings.length} heading styles`);
    console.log(`   ${body.length} body styles`);
    
    // Print summary
    console.log('\n📋 Typography Summary:');
    console.log('   Headings:');
    headings.forEach(h => console.log(`     ${h.name}: ${h.size}px/${h.lineHeight}px ${h.weight}`));
    console.log('   Body (top 5):');
    body.slice(0, 5).forEach(b => console.log(`     ${b.name}: ${b.size}px/${b.lineHeight}px ${b.weight}`));
    if (body.length > 5) {
      console.log(`     ... and ${body.length - 5} more`);
    }
    
  } catch (error) {
    console.error('\n❌ Sync failed:', error.message);
    process.exit(1);
  }
}

// Run sync
syncTypography();
