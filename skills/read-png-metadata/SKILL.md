---
name: read-png-metadata
description: Use when inspecting PNG metadata, A1111/ComfyUI generation parameters, or custom PNG text chunks. Use when debugging why metadata is missing or wrong, verifying PNG writes, or recovering generation settings from an image file.
---

# Read PNG Metadata

## Overview

PNG stores metadata as named text chunks (`tEXt`, `iTXt`). Stable Diffusion images typically contain chunks like `parameters` (A1111 format) and `comfyui` (JSON). Applications may add their own custom chunks as well. Skip exiftool and Python — use Node.js or the raw binary approach below.

## Quick Commands

### Read all tEXt chunks (one-liner)

```bash
node -e "
const fs = require('fs');
const buf = fs.readFileSync('path/to/image.png');
let pos = 8;
while (pos < buf.length - 12) {
  const len = buf.readUInt32BE(pos);
  const type = buf.slice(pos+4, pos+8).toString('ascii');
  const data = buf.slice(pos+8, pos+8+len);
  if (type === 'tEXt') {
    const n = data.indexOf(0);
    console.log('KEY:', data.slice(0, n).toString());
    console.log('VAL:', data.slice(n+1).toString());
    console.log('---');
  }
  pos += 12 + len;
}
"
```

### Read a specific chunk with meta-png (if available as a project dependency)

```bash
node -e "
const { getMetadata } = require('meta-png');
const fs = require('fs');
const buf = fs.readFileSync('path/to/image.png');
console.log('parameters:', getMetadata(buf, 'parameters'));
console.log('comfyui:   ', getMetadata(buf, 'comfyui'));
"
```

Run from the repo root. Adjust chunk key names to match what your application writes.

## Common Chunk Keys

| Chunk key | Format | Typical contents |
|-----------|--------|------------------|
| `parameters` | A1111 plain text | Prompt, negative prompt, Steps, Sampler, Schedule type, CFG scale, Seed, Size, Model |
| `comfyui` | JSON | prompt, negativePrompt, generationParams, model, timestamp, workflow |
| Custom app keys | JSON or plain text | Application-specific metadata (upscaling params, video info, etc.) |

## A1111 Format (`parameters` chunk)

```
hamburger and fries
Negative prompt: blurry, low quality
Steps: 30, Sampler: Euler a, Schedule type: Karras, CFG scale: 7, Seed: 885271872, Size: 512x512, Model: stableDiffusionXL_final, Token merging ratio: 0.5
```

- Line 1: positive prompt
- Line 2 (if present): `Negative prompt: ...`
- Last line: comma-separated key: value pairs
- Model name has extension stripped

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Reaching for `exiftool` | May not be installed. Use Node.js one-liner above |
| Reaching for Python | Works but unnecessary if the project is Node.js-based |
| Reading only `parameters` | Images may have additional chunks with richer structured data |
| `iTXt` vs `tEXt` | Most SD tools use `tEXt`. `iTXt` has a different binary layout (extra bytes before the text payload) — adjust parsing if you encounter it |
