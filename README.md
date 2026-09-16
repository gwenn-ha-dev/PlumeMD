# PlumeMD

[![CI](https://github.com/gwenn-ha-dev/PlumeMD/actions/workflows/ci.yml/badge.svg)](https://github.com/gwenn-ha-dev/PlumeMD/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
![Platform](https://img.shields.io/badge/Platform-macOS%2014%2B-black?logo=apple)
![Swift 6](https://img.shields.io/badge/Swift-6-orange?logo=swift)

*🇬🇧 English · 🇫🇷 [Français](./README.fr.md)*

A native macOS Markdown document editor with live rendering and PDF export. A document-based app: your files stay yours, on disk, in Markdown.

## Features

- **Document-based** (`DocumentGroup`) — open, edit and save plain `.md` files.
- **Live rendering** with a typographic design system (`DesignTokens`).
- **PDF export** with proper pagination.
- No lock-in: what you save is the Markdown you wrote.

## Install

```sh
git clone https://github.com/gwenn-ha-dev/PlumeMD.git
cd PlumeMD
make build
```

## How it works

The name carries its format: *Plume* for writing, *MD* for Markdown.

## Build

| Command | What it does |
|---|---|
| `make build` | Release build, warnings are errors |
| `make test` | Run the test suite |
| `make run` | Launch the app |
| `make icon` | Regenerate `Resources/AppIcon.icns` |
| `make package` | Produce a distributable bundle in `build/` |
| `make lint` | Check compliance with the project charter |
| `make help` | List every target |

## Dependencies

[swift-markdown](https://github.com/swiftlang/swift-markdown) (0.7.3+, Apache-2.0),
Apple's CommonMark parser. PlumeMD renders the document tree it produces rather
than parsing Markdown itself; everything else is Apple frameworks.

## License

MIT © 2026 gwenn-ha-dev — see [LICENSE](./LICENSE).
