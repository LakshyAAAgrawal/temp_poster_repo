# posterskill

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that generates conference posters from your paper and project website.

Give it your Overleaf source, a project website, and optionally some reference posters for style — it produces a print-ready HTML poster.

## Setup

1. Clone this repo into your project's poster directory:
   ```bash
   git clone git@github.com:ethanweber/posterskill.git poster
   cd poster
   ```

2. Add your paper source (e.g., clone from Overleaf):
   ```bash
   git clone https://git.overleaf.com/YOUR_PROJECT_ID overleaf
   ```

3. Add reference posters (optional — for style matching):
   ```bash
   mkdir -p references
   cp ~/path/to/example_poster.pdf references/
   ```

## Directory structure

```
poster/
├── overleaf/              # Your Overleaf paper source
│   ├── paper.tex
│   ├── figures/
│   └── ...
├── references/            # Example posters for style matching (optional)
│   └── example_poster.pdf
├── poster.html            # Generated output
├── .claude/
│   └── skills/
│       └── make-poster/
│           ├── SKILL.md       # Skill instructions
│           └── template.html  # HTML poster template
├── .gitignore
└── README.md
```

- `overleaf/` and `references/` are gitignored — they contain your project-specific content.
- `poster.html` (the output) is also gitignored.

## Usage

Open Claude Code in the poster directory and run:

```
/make-poster
```

The skill will:
1. Read your paper from `overleaf/`
2. View any reference posters in `references/`
3. Ask you for your project website URL and formatting requirements (poster size, orientation, columns, etc.)
4. Generate `poster.html`

You can also pass notes directly:

```
/make-poster 3DV, A1 landscape, 3 columns
/make-poster https://3dvconf.github.io/2026/poster-instructions/
```

## Printing to PDF

Open `poster.html` in Chrome, then **Print > Save as PDF** with:
- **Paper size:** Custom, matching your poster dimensions
- **Margins:** None
- **Background graphics:** ON

## Customization

- Drop multiple reference posters into `references/` to guide the visual style.
- The skill supports formatting requirements as plain text or a URL to the conference's poster instructions page.
- Edit `.claude/skills/make-poster/SKILL.md` to customize the skill behavior.
