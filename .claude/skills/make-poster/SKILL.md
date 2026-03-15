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
│   ├── *.pdf          # Example posters the user likes
│   ├── *.png
│   └── ...
├── poster.html        # OUTPUT: generated poster
└── .claude/skills/make-poster/
```

- **`overleaf/`** contains the paper source. Read `paper.tex` and any files it `\input{}`s.
- **`references/`** contains example posters showing the user's preferred visual style. Read/view ALL files in this folder to match their design language.
- The generated poster is written to the project root as `poster.html`.

## Inputs

1. **Paper source** - Auto-discovered from `overleaf/`. Read `paper.tex` and any `\input{}` files (e.g., `preamble.tex`, `tables/*.tex`).
2. **Project website** - Ask the user for the URL if not already known. Fetch with WebFetch to extract author info, hosted images, and links.
3. **Reference posters** - Auto-discovered from `references/`. View all files there and match their style.
4. **Formatting requirements** - The user may provide these as:
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

### Step 0: Analyze reference posters
Look in `references/` for any PDF, PNG, or image files. Read/view each one and note:
- Overall layout structure (number of columns, box styles, spacing)
- Color palette (primary, secondary, accent colors)
- Typography choices (font families, weights, sizes)
- Figure-to-text ratio and figure placement style
- Header/title bar design
- How sections are visually separated (lines, boxes, cards, whitespace)
- QR code placement and footer style
- Any distinctive design elements to replicate

Use these observations to override the default template styling.

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

### Step 4: Generate the HTML poster
Use the template at `${{CLAUDE_SKILL_DIR}}/template.html` as a starting point. Customize it with the extracted content. Write the output to `poster.html` in the project root.

## Important guidelines

- **Keep text minimal.** Posters are visual. Use bullet points, not paragraphs. Aim for someone to understand the work in 2 minutes.
- **Prioritize figures.** Include the most impactful figures. Use relative paths from the poster root, e.g., `overleaf/figures/teaser_small.pdf`. Prefer PNG versions since browsers can't render PDFs inline.
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
- If figures exist as PDFs in `overleaf/figures/`, note that browsers can't display PDFs inline. Convert them with a tool like `pdftoppm` or `sips`, or ask the user for PNG versions.
- If the project website has hosted images, use those URLs directly.
- For the architecture figure, the PNG version is often available (e.g., `model-architecture-all.png`).
