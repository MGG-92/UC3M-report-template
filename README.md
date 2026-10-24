# UC3M report template

Template for university assignments and a quick LaTeX package reference.

## Package reference

Open `Package Reference.pdf` at the repository root. Packages are grouped by
class and sorted alphabetically within each class. The guide uses 10 pt
serif text and ordinary selectable PDF code. Code and rendered examples live
together in each `LaTeX/dev/<class>/packages.tex` file.

Place the rendered example directly after its code, without a Result heading.
Keep both versions in sync when editing. Package-loading instructions do not
need a separate output example.

To update the reference:

1. Edit the relevant `LaTeX/dev/<class>/packages.tex` file.
2. Compile `dev.tex` twice from `LaTeX/`.
3. Copy `LaTeX/dev.pdf` to the root as `Package Reference.pdf`.

`dev.tex` loads the same `Packages/*/usepackages.tex` files as `main.tex`.
The examples use the actual `matlab` / `latex` listing styles and shared TikZ
styles from the template. Table examples additionally use `booktabs` and `tabularx`.

`dev/guide-config.tex` contains only the reference's layout adjustments and a few
formatting helpers. It is optional as a separate file: those settings could be
placed directly in `dev.tex`. It does not redefine the template's shared styles.
The coursework template keeps its existing settings. Use `lipsum` for placeholder prose.
