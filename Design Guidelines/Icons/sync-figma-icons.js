#!/usr/bin/env node
/**
 * Figma Icon Sync Script for Filo
 * 
 * Automatically fetches icons from the specified Figma frame and exports them as SVGs.
 * 
 * Setup:
 * 1. Generate a Figma Personal Access Token at: https://www.figma.com/developers/api#access-tokens
 * 2. Set the environment variable: export FIGMA_ACCESS_TOKEN="your-token-here"
 * 3. Run: node sync-figma-icons.js
 * 
 * For automatic updates, set up a webhook or GitHub Action (see README).
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
const OUTPUT_DIR = path.join(__dirname, config.output.iconsDirectory);

if (!FIGMA_TOKEN) {
  console.error('Error: FIGMA_ACCESS_TOKEN environment variable is not set.');
  console.error('Generate a token at: https://www.figma.com/developers/api#access-tokens');
  console.error('Then run: export FIGMA_ACCESS_TOKEN="your-token-here"');
  process.exit(1);
}

// Ensure output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
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
 * Download a file from URL
 */
function downloadFile(url, filepath) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(filepath);
    https.get(url, (response) => {
      if (response.statusCode === 302 || response.statusCode === 301) {
        // Follow redirect
        https.get(response.headers.location, (res) => {
          res.pipe(file);
          file.on('finish', () => {
            file.close();
            resolve();
          });
        }).on('error', reject);
      } else {
        response.pipe(file);
        file.on('finish', () => {
          file.close();
          resolve();
        });
      }
    }).on('error', reject);
  });
}

/**
 * Convert Figma node name to valid filename
 */
function toFileName(name) {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
}

/**
 * Recursively find all component/icon nodes in the frame
 */
function findIconNodes(node, icons = []) {
  // Look for components or frames that represent icons
  if (node.type === 'COMPONENT' || node.type === 'INSTANCE' || 
      (node.type === 'FRAME' && node.children && node.children.length > 0 && !hasNestedFrames(node))) {
    icons.push({
      id: node.id,
      name: node.name,
      type: node.type
    });
  }
  
  // Recurse into children
  if (node.children) {
    for (const child of node.children) {
      findIconNodes(child, icons);
    }
  }
  
  return icons;
}

/**
 * Check if a frame has nested frames (not a leaf icon)
 */
function hasNestedFrames(node) {
  if (!node.children) return false;
  return node.children.some(child => 
    child.type === 'FRAME' || child.type === 'COMPONENT' || child.type === 'INSTANCE'
  );
}

/**
 * Main sync function
 */
async function syncIcons() {
  console.log('🔄 Starting Figma icon sync...');
  console.log(`   File: ${config.figma.fileName}`);
  console.log(`   Frame: node-id=${NODE_ID}`);
  
  try {
    // Step 1: Get file info and check version
    console.log('\n📥 Fetching Figma file info...');
    const fileInfo = await figmaRequest(`/v1/files/${FILE_KEY}?depth=1`);
    const currentVersion = fileInfo.version;
    
    console.log(`   File version: ${currentVersion}`);
    console.log(`   Last modified: ${fileInfo.lastModified}`);
    
    // Step 2: Get the specific frame/node
    console.log('\n📦 Fetching icon frame...');
    const nodeData = await figmaRequest(`/v1/files/${FILE_KEY}/nodes?ids=${NODE_ID}`);
    const frameNode = nodeData.nodes[NODE_ID]?.document;
    
    if (!frameNode) {
      throw new Error(`Could not find frame with node-id: ${NODE_ID}`);
    }
    
    console.log(`   Frame name: ${frameNode.name}`);
    
    // Step 3: Find all icon components in the frame
    const iconNodes = findIconNodes(frameNode);
    console.log(`   Found ${iconNodes.length} icons`);
    
    if (iconNodes.length === 0) {
      console.log('\n⚠️  No icons found in the specified frame.');
      console.log('   Make sure the frame contains COMPONENT or FRAME nodes.');
      return;
    }
    
    // Step 4: Request SVG exports for all icons
    console.log('\n🎨 Requesting SVG exports...');
    const iconIds = iconNodes.map(n => n.id).join(',');
    const imagesData = await figmaRequest(
      `/v1/images/${FILE_KEY}?ids=${iconIds}&format=svg`
    );
    
    // Step 5: Download all SVGs
    console.log('\n⬇️  Downloading SVGs...');
    const iconMetadata = [];
    
    for (const icon of iconNodes) {
      const svgUrl = imagesData.images[icon.id];
      if (!svgUrl) {
        console.log(`   ⚠️  No SVG URL for: ${icon.name}`);
        continue;
      }
      
      const fileName = toFileName(icon.name) + '.svg';
      const filePath = path.join(OUTPUT_DIR, fileName);
      
      await downloadFile(svgUrl, filePath);
      console.log(`   ✓ ${fileName}`);
      
      iconMetadata.push({
        name: icon.name,
        fileName: fileName,
        figmaId: icon.id,
        type: icon.type
      });
    }
    
    // Step 6: Update icons.json metadata
    console.log('\n📝 Updating icons metadata...');
    const iconsJsonPath = path.join(__dirname, 'icons.json');
    const existingConfig = JSON.parse(fs.readFileSync(iconsJsonPath, 'utf8'));
    
    existingConfig.icons = iconMetadata;
    existingConfig.figmaSync = {
      fileKey: FILE_KEY,
      nodeId: NODE_ID,
      lastSyncedAt: new Date().toISOString(),
      figmaVersion: currentVersion,
      totalIcons: iconMetadata.length
    };
    
    fs.writeFileSync(iconsJsonPath, JSON.stringify(existingConfig, null, 2));
    
    // Step 7: Update sync config
    config.sync.lastSyncedAt = new Date().toISOString();
    config.sync.lastFigmaVersion = currentVersion;
    fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    
    console.log('\n✅ Sync complete!');
    console.log(`   ${iconMetadata.length} icons synced to ${OUTPUT_DIR}`);
    
  } catch (error) {
    console.error('\n❌ Sync failed:', error.message);
    process.exit(1);
  }
}

// Run sync
syncIcons();
