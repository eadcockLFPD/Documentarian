# Documentarian

Research and documentation on automated **GitHub-to-demo-video** pipelines — turning a
code change into a narrated screen capture of the live product.

The documentation lives in [`doc/`](doc/) and is published as a browsable site with
[MkDocs](https://www.mkdocs.org/) + [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

## Getting started

Requires Python 3.12+.

```bash
# Create an isolated environment and install dependencies
python3 -m venv .venv
./.venv/bin/pip install -r requirements.txt

# Preview the docs with live reload at http://localhost:8000
./.venv/bin/mkdocs serve
```

## Common commands

| Task | Command |
|---|---|
| Live-reload dev server | `./.venv/bin/mkdocs serve` |
| Build the static site into `site/` | `./.venv/bin/mkdocs build` |
| Strict build (fail on warnings) | `./.venv/bin/mkdocs build --strict` |

## Repository layout

```
doc/                     Documentation sources (Markdown)
  index.md               Landing page
  competitive-analysis.md
mkdocs.yml               Site configuration
requirements.txt         Pinned Python dependencies
```
