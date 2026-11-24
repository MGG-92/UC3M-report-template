# Quick start

## Create a report

Copy the complete `template/` directory to your project. Open `settings.tex` and set the institution, subject, title, subtitle, authors, and date. LaTeX commands such as `\\` are allowed in the author list. Replace `\today` if the report needs a fixed date.

The template uses English by default. Change the `babel` option in `main.tex` if your assignment uses another language. Choose the document font size in `\documentclass`.

Edit `sections/introduction.tex` or create more section files and add them to `main.tex`:

```latex
\input{sections/introduction}
\input{sections/method}
\input{sections/results}
```

Compile from the folder containing `main.tex`, twice to resolve the contents and references:

```sh
pdflatex -interaction=nonstopmode -halt-on-error -no-shell-escape main.tex
pdflatex -interaction=nonstopmode -halt-on-error -no-shell-escape main.tex
```

## Overleaf

Upload the contents of `template/` as a ZIP project, keeping its internal directories. Select `main.tex` as the main document and pdfLaTeX as the compiler. The repository build also creates `build/uc3m-report-template.zip`, which contains only the template sources and images.

## Styles and images

`\usepackage{uc3m-report}` loads the shared styles in dependency order. Edit reusable formatting under `styles/`; put report-specific content in `sections/` and metadata in `settings.tex`.

Add figures to `images/` and reference them relative to `main.tex`, for example `\includegraphics[width=0.7\linewidth]{images/my-plot.png}`. See the [package reference](../Package%20Reference.pdf) for complete examples.

## MATLAB results

Keep `matlab/` next to your report folder or add it to the MATLAB path. If you rename or move the report folder, update export destinations accordingly. The [MATLAB guide](matlab.md) explains generated values and tables; [runnable examples](../matlab/examples/README.md) demonstrate the workflow without changing the starter report.

## Migrating an existing checkout

`LaTeX/main.tex` is now `template/main.tex`; `LaTeX/dev.tex` is now `docs/reference/main.tex`; `MATLAB-scripts/` is now `matlab/`. Shared `Packages/<Class>/` files are under `template/styles/<class>/`. Reports already copied to another project continue to work with their existing files. When adopting this version, copy the entire new template and update section, image, and MATLAB paths together.
