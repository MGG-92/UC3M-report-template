# Changelog

## Unreleased

### Changed

- Separate the copyable report (`template/`), documentation (`docs/`), and MATLAB utilities (`matlab/`).
- Introduce `uc3m-report.sty` as the shared style entry point and `settings.tex` for report metadata.
- Rename the reference entry point from `LaTeX/dev.tex` to `docs/reference/main.tex` and update internal paths.
- Move the detailed MATLAB documentation out of the README.

### Added

- A minimal report body, quick start, and build documentation.
- Runnable MATLAB value and table export examples with accompanying LaTeX documents.
- A cross-platform build script and GitHub Actions compilation workflow, including PDF and template ZIP artifacts.

The root `Package Reference.pdf` remains the published reference. Existing coursework is outside this migration.
