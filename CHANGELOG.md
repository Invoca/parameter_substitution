# CHANGELOG for `parameter_substitution`

Inspired by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Note: This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2025-11-06
### Added
- Added optional `parameter_start` and `parameter_end` arguments for the following methods:
  - `ParameterSubstitution.find_tokens`
  - `ParameterSubstitution.find_formatters`
  - `ParameterSubstitution.find_warnings`

## [2.0.0] - 2024-07-11
### Removed
- Remove support for eol ruby versions 2.7
- Remove support for activesupport 5

### Changed
- Loosen activesupport dependency to allow for rails 7

## [1.4.0] - 2024-01-22
### Added
- Add string_to_base64 formatter, which converts a string to base64 format.
- Remove support for ruby 2.6

## [1.3.0] - 2021-03-31
### Removed
- Removed support for rails 4
- https://github.com/Invoca/parameter_substitution/pull/59

## [1.2.0] - 2020-05-28
### Added
- Add if_truthy formatter, which replaces the input with the first argument if the input is truthy (i.e. true, "t", 1, "on", "yes"), the second argument otherwise.

## [1.1.0] - 2020-05-28
### Added
- Added support for rails 5 and 6.
- Added appraisal tests for all supported rails version: 4/5/6

## [1.0.0] - 2020-05-18
### Changed
- Replace hobo_support with invoca-utils

[2.0.0]: https://github.com/Invoca/parameter_substitution/compare/v1.4.0...v2.0.0
[1.4.0]: https://github.com/Invoca/parameter_substitution/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/Invoca/parameter_substitution/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/Invoca/parameter_substitution/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Invoca/parameter_substitution/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Invoca/parameter_substitution/compare/v0.2.3...v1.0.0
