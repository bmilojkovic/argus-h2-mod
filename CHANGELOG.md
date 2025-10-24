# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Cleaned up python imports.
- Updated dependencies.
- Further reduced logging messages.

## [0.0.3] - 2025-10-24

### Added

- Generated tests for backend and frontend. There is less need to do actual runs for testing now.
- Modified the code to start using the plugins_data folder. Now Argus logins should persist through mod updates.
- Tiny bugfixes.

## [0.0.2] - 2025-10-17

### Changed

- Small stabilization fixes.
- Reduced logging message levels to have less spam. Lots of warnings are now info.
- Updated README files.
- Updated directory structure.

## [0.0.1] - 2025-10-13

### Added

- First version of the mod!
- Full integration with our Argus Twitch extension.
- Authentication through Twitch to ensure that streamers can not be impersonated.
- Viewers can see run information in four panels.
- Panel 1: Run
  - Weapon
  - Familiar
  - Boons from all 9 primary Gods
  - Boons / Gifts from: Artemis, Hades, Arachne, Medea, Circe, Icarus, Athena, Dionysus, Hermes, Chaos
  - Keepsake
  - Hex
- Panel 2: Arcana
- Panel 3: Vows of Night
- Panel 4: Pinned boons. Up to three boons pinned in the codex will be shown here as targets for this run. If these boons have requirements, they will be shown as well.

[unreleased]: https://github.com/bmilojkovic/argus-h2-mod/compare/0.0.3...HEAD
[0.0.3]: https://github.com/bmilojkovic/argus-h2-mod/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/bmilojkovic/argus-h2-mod/compare/0.0.1...0.0.2
[0.0.1]: https://github.com/bmilojkovic/argus-h2-mod/compare/911d8b2a84c1786466335a47bbc6db64bae286b7...0.0.1
