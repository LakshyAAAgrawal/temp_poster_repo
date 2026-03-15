---
name: make-poster
description: Generate an HTML conference poster from a paper and project website, printable to PDF
argument-hint: <any formatting notes, conference name, or instructions URL>
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, Agent
---

# Conference Poster Generator (HTML)

Generate a professional HTML poster. User notes: $ARGUMENTS

The poster is an HTML page styled with CSS for print. The user prints the page to PDF to get the final poster.

## Project folder structure

The skill expects this directory layout:

```
poster/
├── overleaf/          # Paper source from Overleaf
│   ├── paper.tex      # Main paper content
│   ├── main.tex       # Document root (inputs paper.tex)
│   ├── preamble.tex
│   ├── figures/       # Paper figures
│   ├── tables/
│   └── ...
├── references/        # Reference posters for style matching
│   ├── *.pdf
│   ├── *.png
│   └── ...
├── assets/            # GENERATED: figures/images copied here for the poster
│   ├── teaser.png
│   ├── architecture.png
│   ├── qr.png
│   └── ...
├── poster.html        # GENERATED: the poster
└── .claude/skills/make-poster/
```

- **`overleaf/`** contains the paper source. Read `paper.tex` and any files it `\input{}`s.
- **`references/`** contains example posters showing the user's preferred visual style. Read/view ALL files in this folder to match their design language.
- **`assets/`** is created during generation. Figures are copied/converted here from overleaf, the project website, or the author website. The poster HTML references these.
- The generated poster is written to the project root as `poster.html`.

## Inputs

1. **Paper source** - Auto-discovered from `overleaf/`. Read `paper.tex` and any `\input{}` files (e.g., `preamble.tex`, `tables/*.tex`).
2. **Project website** - Ask the user for the URL if not already known. Fetch with WebFetch to extract author info, hosted images, and links.
3. **Reference posters** - Auto-discovered from `references/`. View all files there and match their style.
4. **Author website** (optional) - The user may provide a personal/lab website URL for brand matching. Fetch it with WebFetch and extract design signals: color palette, typography, layout aesthetic (minimal vs. bold), spacing preferences, and overall visual identity. Use these as soft style hints — the reference posters take priority for poster-specific layout, but the author's brand should influence color choices, font selections, and overall tone.
5. **Formatting requirements** - The user may provide these as:
   - **A URL** to the conference poster instructions page (fetch with WebFetch to extract requirements)
   - **Text** describing their constraints directly
   - **Both** a URL and additional notes

   Extract or ask for:
   - Poster dimensions (e.g., A0, A1 landscape, 48"x36", custom size)
   - Orientation (portrait or landscape)
   - Number of columns (e.g., 2, 3, 4)
   - Required sections or content ordering
   - Color scheme or branding constraints
   - Font requirements
   - Logo placement
   - Any conference-specific formatting rules (poster board size limits, etc.)

If the user doesn't specify formatting, ask them before proceeding. Don't assume defaults for dimensions, orientation, or column count.

## Process

### Step 0: Analyze style references
**Reference posters:** Look in `references/` for any PDF, PNG, or image files. Read/view each one and note:
- Overall layout structure (number of columns, box styles, spacing)
- Color palette (primary, secondary, accent colors)
- Typography choices (font families, weights, sizes)
- Figure-to-text ratio and figure placement style
- Header/title bar design
- How sections are visually separated (lines, boxes, cards, whitespace)
- QR code placement and footer style
- Any distinctive design elements to replicate

Use these observations to override the default template styling.

**Author website:** If the user provides a personal or lab website URL, fetch it and extract design signals: color palette, font choices, layout density, and overall aesthetic. Use these as soft hints for the poster's visual identity (colors, fonts, tone). Reference posters take priority for layout decisions.

### Step 1: Extract content from paper source
Read `overleaf/paper.tex` and extract:
- Title, authors, affiliations
- Abstract (shortened for poster - 2-3 sentences max)
- Key method description and architecture figure references
- Main results (tables and qualitative figures)
- Key equations (only the most important 1-2, render with KaTeX)
- Conclusion / key takeaways

### Step 2: Fetch the project website
Use WebFetch to get:
- Author names and affiliations (with correct formatting)
- Any additional figure URLs or hosted images
- Project URL for the QR code
- Links to code, arxiv, video

### Step 3: Design the poster layout
Adapt the layout to the user's formatting requirements. If not specified, ask first.

**General structure (adjust columns/sections per user requirements):**

**Header (full width):**
- Conference name/logo (top corner)
- Paper title (large, bold)
- Authors with affiliations
- Institutional logos if available

**Typical content sections (distribute across columns as appropriate):**
- TL;DR / Abstract (2-3 sentences in a highlight box)
- Motivation / Problem Setting
- Key contributions (numbered list)
- Method overview (with architecture figure)
- Key equations (rendered with KaTeX)
- Qualitative results (main figures)
- Quantitative results (styled tables, bold best)
- Conclusion / key takeaways
- QR code to project page + links to code/paper/video

**Footer (full width):**
- Acknowledgements (small text)
- Institutional logos

Adjust the CSS grid to match the requested number of columns. Scale font sizes proportionally to the poster dimensions.

### Step 4: Gather assets
Copy any figures, images, or logos you need into an `assets/` directory at the project root. Sources:
- **From `overleaf/figures/`** - copy and convert PDFs to PNGs (use `sips -s format png` on macOS or `pdftoppm`). Keep filenames descriptive.
- **From the project website** - download hosted images (use `curl`) that are higher quality or more poster-appropriate than the paper figures.
- **From the author website** - download logos, headshots, or branding assets if useful.
- **QR code** - generate and save to `assets/qr.png`.

Reference figures in `poster.html` as `assets/filename.png`. This keeps the poster self-contained and avoids broken paths.

### Step 5: Generate the HTML poster
Use the template at `${{CLAUDE_SKILL_DIR}}/template.html` as a starting point. Customize it with the extracted content. Write the output to `poster.html` in the project root.

### Step 6: Iterate with the user
After generating the first draft, expect feedback. The user will likely want to adjust:
- Layout, spacing, or column balance
- Which figures to include or swap
- Text content (too much, too little, wording)
- Colors, fonts, or visual style
- Figure sizing or placement

When the user gives feedback, make targeted edits to `poster.html` (and `assets/` if swapping figures). Don't regenerate from scratch unless asked — preserve their previous feedback. Keep iterating until they're happy.

## Important guidelines

- **Keep text minimal.** Posters are visual. Use bullet points, not paragraphs. Aim for someone to understand the work in 2 minutes.
- **Prioritize figures.** Include the most impactful figures. Copy them into `assets/` and convert to PNG. Reference as `assets/filename.png` in the HTML.
- **Print-optimized CSS.** Use `@media print` and `@page` rules. Set page size to match the user's specified dimensions. Use `print-color-adjust: exact` for backgrounds.
- **Color scheme.** Use the reference poster colors, user-specified colors, or conference branding. Fall back to the conference color schemes below if nothing else is specified.
- **Font sizes for print.** Scale proportionally to poster size. For A0 portrait: title ~60-72pt, headers ~32-36pt, body ~20-24pt, captions ~16-18pt. For smaller posters (e.g., A1 landscape), scale down accordingly.
- **QR code.** Use a QR code image (generate via API or embed an SVG). Link to the project page.
- **Equations.** Use KaTeX (loaded via CDN) for math rendering. Only include 1-2 key equations.
- **Tables.** Style tables cleanly with alternating row colors. Bold the best results.
- **Self-contained.** The HTML file should work when opened locally in a browser. Use relative paths for local figures and CDN for fonts/KaTeX.
- **Test.** After generating, remind the user to open in Chrome and use Print > Save as PDF with:
  - Paper size: set to match their specified dimensions (or use "Custom" in Chrome print dialog)
  - Margins: None
  - Background graphics: ON

## Conference color schemes (fallback)
- **3DV**: `#2178B5` (steel blue)
- **CVPR**: `#005294` (dark blue)
- **ICCV**: `#008040` (green)
- **NeurIPS**: `#663399` (purple)
- **ECCV**: `#B32626` (red)
- **SIGGRAPH**: `#333333` (dark gray)

## Figure handling
- Always copy needed figures into `assets/` — don't reference `overleaf/` paths directly in the HTML.
- Convert PDFs to PNGs: `sips -s format png input.pdf --out assets/output.png` (macOS) or `pdftoppm -png -r 300 input.pdf assets/output` (Linux).
- If the project website has higher-res or more poster-friendly images, download those instead: `curl -o assets/filename.png URL`.
- PNGs already in `overleaf/figures/` (e.g., `model-architecture-all.png`) can be copied directly.
