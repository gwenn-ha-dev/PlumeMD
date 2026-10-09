# PlumeMD — agent context

## What this is

A native macOS Markdown editor with a rendered view and paginated PDF export. A document-based app: your files stay yours, on disk, in Markdown.

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
- Identifiers, commit messages and both READMEs are in **English**; comments may
  be in English or French (charter §2).
- `Localizable.xcstrings` uses the **French source phrase as key** (`Text("Éditer")`).
  `Text(cond ? "a" : "b")` is never translated — a ternary of literals is a
  `String`, which `Text`, `Label` and `.help` take verbatim. Write
  `cond ? Text("a") : Text("b")` or `LocalizedStringKey` on both branches.
- The sandbox needs `ENABLE_USER_SELECTED_FILES = readwrite`: with `readonly`
  the app opens documents but can neither save them nor show a save panel.
- The PDF export (`PDFExporter`) renders each top-level block with
  `ImageRenderer` and packs them into pages; `PDFExporterTests` holds it to
  paper size and page count. In that renderer, `.background` + `.clipShape`
  drew a wrapped code line in white: draw backgrounds `in:` a shape instead.

## Public identity and releases (charter §12)

- Commit as `gwenn-ha-dev <13298867+gwenn-ha-dev@users.noreply.github.com>` (set
  in this repo's git config) and in UTC: `TZ=UTC git commit …`. No personal name,
  email or `/Users/…` path in tracked files. `../../Charte/outils/identite.sh .` checks.
- A release: `make package && make sign && make dmg && make shots && make release-check`,
  then tag `v<version>` and attach `build/PlumeMD-<version>.dmg` — see
  `../../Charte/DISTRIBUTION-AGENT.md`, phase 3. The version is `MARKETING_VERSION`
  in `PlumeMD.xcodeproj`, three numbers.
- `make package` archives with Xcode and copies the app out of the archive to
  `build/PlumeMD.app`. Xcode signs it ad hoc ("Sign to Run Locally") with
  `get-task-allow`; `make sign` re-signs it with the Developer ID, keeping the
  sandbox and read-write file access, minus `get-task-allow`. There is no nested
  code: swift-markdown is linked statically.
- `make shots` opens the sample documents of `outils/exemples/` (English and
  French, written for the captures) in light and dark appearance;
  `-startInEditor YES` at launch opens the editor instead of the rendered view.
  On a Mac in Dark Mode, `-AppleInterfaceStyle Light` does not give a light
  window; `-NSRequiresAquaSystemAppearance YES` does.

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
PlumeMDTests/
README.md
Resources/
docs/img/          # README captures, social preview
icon.jpg
outils/            # icone.swift, captures.sh, exemples/
site/              # GitHub Pages
```

## The charter

The full norm this project follows lives at `../../Charte/CHARTE.md`.
