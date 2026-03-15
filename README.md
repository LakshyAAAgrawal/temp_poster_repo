# posterskill

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that generates print-ready conference posters from your paper.

## Quick start

```bash
git clone git@github.com:ethanweber/posterskill.git poster && cd poster
git clone https://git.overleaf.com/YOUR_PROJECT_ID overleaf   # your paper
```

Optionally add reference posters for style matching:

```bash
mkdir references && cp ~/some_poster.pdf references/
```

Then in Claude Code:

```
/make-poster
```

It reads your paper, fetches your project website, matches your reference style, and outputs `poster.html`. Print to PDF from Chrome (margins: none, background graphics: on).

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| Paper | `overleaf/` directory | Yes |
| Project website | URL (asked at runtime) | Yes |
| Reference posters | `references/` directory | No |
| Author website | URL for brand/style matching | No |
| Formatting specs | Text or conference instructions URL | Asked if missing |
