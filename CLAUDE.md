# CLAUDE.md

Guidance for working in the TPME repository.

## Project overview

This repository publishes the Chinese translation of *The Product-Minded Engineer* by Drew Hoskins. It uses Hugo Extended and the OINK Go module pinned in `go.mod`. The enabled language is Simplified Chinese (`zh`); `content/en/` holds the English reference. The book has four parts and nine chapters. Read `hugo.yaml` for the current language and output configuration.

## Development commands

```sh
make dev          # Current ~/pgsty/oink checkout; Hugo Extended 0.168.0
make check-local  # Strict build against the local theme
make build        # Theme pinned in go.mod
make check        # Verify modules and build the pinned theme and review diagnostics
make serve        # Pinned theme with production preview settings
```

Use `make dev OINK_LOCAL=/path/to/oink PORT=1314` to override the theme directory and port. Development bypasses OINK vendor files and both workspaces; production commands clear inherited local replacements. No filesystem replacement belongs in `go.mod`.

`make translate` and `make epub` are explicit generation utilities. Translation generation writes a Traditional Chinese copy; it does not enable another site language. Review their inputs and outputs before running them. Do not edit generated translations directly.

## Source and rendering

- `content/zh/`: maintained translation, `ch1.md` through `ch9.md`, four part dividers, and front/back matter.
- `content/en/`: retained English reference.
- `static/`: required book assets.
- `data/`, `layouts/`, and `assets/`: OINK homepage data and site overrides.
- `bin/`: translation and EPUB tools.
- `hugo.yaml`, `go.mod`, and `go.sum`: configuration and the pinned theme.
- `public/` and `resources/`: generated output; do not edit manually or commit.

OINK provides the Book shell, offline search, command palette, math rendering, Markdown, print, and `llms.txt` outputs. Keep source identities, chapter order, explicit anchors, links, math notation, figures, captions, and technical meaning intact. Use the real content tree and configuration when changing routes; the default Chinese URLs have no `/zh/` prefix.

Inspect Git state before editing and preserve unrelated work. This is a translation project: prefer necessary corrections, preserve citation and licensing information, and respect the terms in `LICENSE` and `README.md`. Building locally does not publish the site.
