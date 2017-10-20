# Hass.io Add-on Changelog: SSH - Secure Shell

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- Added CodeClimate
- Added CircleCI
- Added support for hass.io's extended label schema
- Added persistency of the ~/.ssh folder
- Added compatibility mode

### Changed

- Migrated to the new Hass.io build system
- Migrated to our new base images
- Rewrite of add-on onto the S6 process supervisor
- Upgraded the hassio CLI tool to the latest version
- Updated documentation

## 1.0.3 - 2017-08-16

### Changed

- Fix issue: User with key and without password was unable to log in
  This time for real ;)

## 1.0.2 - 2017-08-16

### Changed

- Fix issue: User with key and without password was unable to log in

## 1.0.1 - 2017-08-16

### Changed

- Fix issue: User with key and without password was unable to log in

## 1.0.0 - 2017-08-16

### Added

- First version of the SSH Add-on
- This CHANGELOG file
