# Changelog

All notable changes to PlumeMD are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning: [SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- The app icon now comes from the generated `Resources/AppIcon.icns`. The
  build was picking up hand-placed PNGs in the asset catalog instead, so the
  shipped icon ignored `make icon` entirely.

## [0.1.0] — 2026-09-16

### Added
- Initial release.

[Unreleased]: https://github.com/gwenn-ha-dev/PlumeMD/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/gwenn-ha-dev/PlumeMD/releases/tag/v0.1.0
