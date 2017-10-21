# Community Hass.io Add-ons: SSH - Secure Shell

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog][keep-a-changelog]
and this project adheres to [Semantic Versioning][semantic-versioning].

## Unreleased

No unreleased changes yet.

## [v2.0.2][v2.0.2] (2017-10-21)

[Full Changelog][v2.0.1-v2.0.2]

### Fixed

- Directory `/etc/ssh/` has incorrect permissions

## [v2.0.1][v2.0.1] (2017-10-21)

[Full Changelog][v2.0.0-v2.0.1]

### Fixed

- File `authorized_keys` has incorrect permissions

## [v2.0.0][v2.0.0] (2017-10-20)

[Full Changelog][v1.0.3-v2.0.0]

### Added

- Added CodeClimate
- Added CircleCI
- Added support for Hass.io's extended label schema
- Added persistency of the ~/.ssh folder
- Added compatibility mode

### Changed

- Migrated to the new Hass.io build system
- Migrated to our new base images
- Rewrite of add-on onto the S6 process supervisor
- Upgraded the hassio CLI tool to the latest version
- Updated documentation

## [v1.0.3][v1.0.3] - 2017-08-16

[Full Changelog][v1.0.2-v1.0.3]

### Changed

- Fix issue: User with key and without password was unable to log in
  This time for real ;)

## [v1.0.2][v1.0.2] - 2017-08-16

[Full Changelog][v1.0.1-v1.0.2]

### Changed

- Fix issue: User with key and without password was unable to log in

## [v1.0.1][v1.0.1] - 2017-08-16

[Full Changelog][v1.0.0-v1.0.1]

### Changed

- Fix issue: User with key and without password was unable to log in

## [v1.0.0][v1.0.0] - 2017-08-16

### Added

- First version of the SSH Add-on
- This CHANGELOG file

[keep-a-changelog]: http://keepachangelog.com/en/1.0.0/
[semantic-versioning]: http://semver.org/spec/v2.0.0.html
[v1.0.0-v1.0.1]: https://github.com/hassio-addons/addon-ssh/compare/v1.0.0...v1.0.1
[v1.0.0]: https://github.com/hassio-addons/addon-ssh/tree/v1.0.0
[v1.0.1-v1.0.2]: https://github.com/hassio-addons/addon-ssh/compare/v1.0.1...v1.0.2
[v1.0.1]: https://github.com/hassio-addons/addon-ssh/tree/v1.0.1
[v1.0.2-v1.0.3]: https://github.com/hassio-addons/addon-ssh/compare/v1.0.2...v1.0.3
[v1.0.2]: https://github.com/hassio-addons/addon-ssh/tree/v1.0.2
[v1.0.3-v2.0.0]: https://github.com/hassio-addons/addon-ssh/compare/v1.0.3...v2.0.0
[v1.0.3]: https://github.com/hassio-addons/addon-ssh/tree/v1.0.3
[v2.0.0-v2.0.1]: https://github.com/hassio-addons/addon-ssh/compare/v2.0.0...v2.0.1
[v2.0.0]: https://github.com/hassio-addons/addon-ssh/tree/v2.0.0
[v2.0.1-v2.0.2]: https://github.com/hassio-addons/addon-ssh/compare/v2.0.1...v2.0.2
[v2.0.1]: https://github.com/hassio-addons/addon-ssh/tree/v2.0.1
[v2.0.2]: https://github.com/hassio-addons/addon-ssh/tree/v2.0.2