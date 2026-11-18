# UC3M report template

Template for university assignments and a quick LaTeX package reference.

## Package reference

Open `Package Reference.pdf` at the repository root. Packages are grouped by
class and sorted alphabetically within each class. The guide uses 10 pt
serif text and ordinary selectable PDF code. Code and rendered examples live
together in the topic files under `LaTeX/dev/<class>/` (for example,
`math/amsmath.tex` and `graphics/tikz.tex`). Each class's `packages.tex` contains
only its heading and the ordered `\input` statements. Longer entries include
separate files for their subsections, such as `graphics/feedback.tex`.

Place the rendered example directly after its code, without a Result heading.
Keep both versions in sync when editing. Package-loading instructions do not
need a separate output example.

To update the reference:

1. Edit the topic file under `LaTeX/dev/<class>/`; update `packages.tex` only to add or reorder topics.
2. Compile `dev.tex` twice from `LaTeX/`.
3. Copy `LaTeX/dev.pdf` to the root as `Package Reference.pdf`.

`dev.tex` loads the same `Packages/*/usepackages.tex` files as `main.tex`.
The examples use the actual `matlab` / `latex` listing styles and shared TikZ
styles from the template. Table examples additionally use `booktabs` and `tabularx`.

`dev/guide-config.tex` contains only the reference's layout adjustments and a few
formatting helpers. It is optional as a separate file: those settings could be
placed directly in `dev.tex`. It does not redefine the template's shared styles.
The coursework template keeps its existing settings. Use `lipsum` for placeholder prose.

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
