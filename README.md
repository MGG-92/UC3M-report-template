# UC3M report template

Template for university assignments and a quick LaTeX package reference.

## Package reference

Open `Package Reference.pdf` at the repository root. Packages are grouped by
class and sorted alphabetically within each class. The guide uses 10 pt
serif text, selectable code, and rendered examples.

The reference is generated from `LaTeX/dev.tex` and shares package definitions
with the report template. For source organization, editing conventions, and the
build and verification workflow, see [AGENTS.md](AGENTS.md).

The template also provides the Homework-3 row-height presets:
`\begin{array}[c]{columns}[L]` (or `[XL]`) and `\begin{cases}[L]`
(or `[XL]`). Omitting the preset preserves the ordinary syntax.
Graphics loads `array` and defines the struts; Math defines the extended
`cases`, so load Graphics before Math, as in `main.tex` and `dev.tex`.
The Layout group defines `\spacedpar` for selected paragraph breaks.
These helpers and their rendered examples are documented in the reference.

The Homework-4 additions provide `\PM` and `\GM` as upright phase- and
gain-margin labels in `Packages/Math/package_config.tex`. They are available
in math mode after loading the Math group; do not redefine them in `main.tex`.
The `amsmath` entry documents their use, and the `siunitx` entry includes
decibels, angular frequencies in rad/s, and scientific notation.
