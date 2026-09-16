# PlumeMD — agent context

## What this is

A native macOS Markdown document editor with live rendering and PDF export. A document-based app: your files stay yours, on disk, in Markdown.

Platform: macOS 26.4+. Build system: Xcode project. Bundle ID `dev.gwennha.PlumeMD`.

## Build and test

```sh
make build   # release, warnings are errors
make test
make lint    # charter compliance — run before declaring anything done
```

Never invoke `swift build`, `xcodebuild` or a build script directly; go through
the `Makefile`. It is the same interface in every project here.

## Invariants — do not break these

- **No hard-coded user-visible strings.** Everything goes through
  `Resources/Localizable.xcstrings`, present in both `en` and `fr`. Adding a
  string means adding both translations in the same change.
- **No build artefacts committed.** No `.app`, no `build/`, no `.build/`.
- **Dependencies: swift-markdown.** Adding another requires documenting it in the
  README's *Dependencies* section.
- **`README.md` and `README.fr.md` stay in sync.** Editing one means editing the other.
- **The icon is generated**, never hand-placed: `outils/icone.swift` is the
  source, `make icon` rebuilds `Resources/AppIcon.icns`.
- Code, comments and commit messages are in **English**.

## Layout

```
.github/
.gitignore
CHANGELOG.md
CONTRIBUTING.md
Info.plist
LICENSE
Makefile
PlumeMD.xcodeproj/
PlumeMD/
README.md
Resources/
icon.jpg
outils/
scripts/
```

## The charter

The full norm this project follows lives at `../../Charte/CHARTE.md`.
