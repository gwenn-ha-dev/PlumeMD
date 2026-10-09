# Changelog

All notable changes to PlumeMD are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] — 2026-10-09

First release signed with a Developer ID and notarized: it opens with a double
click on any Mac running macOS 26.4 or later.

### Added
- `PlumeMD-1.1.0.dmg`, signed with a Developer ID, notarized and stapled, the
  app and the disk image both.
- README captures in English and French, taken from sample documents by
  `outils/captures.sh`.
- `make sign`, `make dmg`, `make shots`, `make release-check`.
- A project site (`site/`) for GitHub Pages.

### Fixed
- Documents can be saved again, and PDF export works: the sandbox granted
  read-only access to user-selected files, which allows opening a document but
  neither writing it nor showing a save panel.
- The PDF export is paginated, on the paper size of the print settings (A4 or
  US Letter). It used to draw the whole document on one page as tall as the
  text. Page breaks fall between blocks, and a heading keeps a few lines of
  what follows.
- In the exported PDF, a code line that wrapped came out white on white.
- The Edit/Preview button and its tooltip stayed in French on an English
  system.
- The app icon now comes from the generated `Resources/AppIcon.icns`. The
  build was picking up hand-placed PNGs in the asset catalog instead, so the
  shipped icon ignored `make icon` entirely.

## [0.1.0] — 2026-09-16

### Added
- Initial release.

[Unreleased]: https://github.com/gwenn-ha-dev/PlumeMD/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/gwenn-ha-dev/PlumeMD/releases/tag/v1.1.0
