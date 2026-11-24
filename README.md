# UC3M report template

A ready-to-use LaTeX report template for university assignments, with shared styles, a rendered package reference, and MATLAB helpers for exporting results.

## Start a report

1. Copy the entire `template/` folder into your coursework project, or upload its contents to Overleaf.
2. Edit `settings.tex` with your subject, title, authors, and date.
3. Replace `sections/introduction.tex` with your content and compile `main.tex` from the template folder.

The folder is self-contained: its images and styles travel with the report. See the [quick start](docs/quickstart.md) for local compilation, Overleaf, and adding sections.

## Package reference

Open [Package Reference.pdf](Package%20Reference.pdf) for selectable code and rendered examples. Its sources live in `docs/reference/` and load the same `uc3m-report.sty` as the template. The guide includes block diagrams, tables, row-height presets, phase and gain margins, units, and code listings.

## MATLAB helpers

Export calculated values with `export2latex`, export tables with `table2latex`, and standardize plot appearance with `initialize_plot_configuration`. See the [MATLAB guide](docs/matlab.md) for options and the [runnable examples](matlab/examples/README.md) for complete workflows.

## Repository layout

| Path | Purpose |
| --- | --- |
| `template/` | Copyable report, metadata, sections, images, and shared styles. |
| `docs/` | Quick start, MATLAB guide, and package-reference sources. |
| `matlab/` | Reusable MATLAB functions and runnable examples. |
| `scripts/` | Local and CI build command. |
| `.github/workflows/` | Automatic compilation and downloadable build artifacts. |
| `build/` | Generated PDFs, logs, and template ZIP; ignored by Git. |

## Build and contribute

With Python 3.10+ and pdfLaTeX on your PATH, run `python scripts/build.py` from the repository root. The command compiles both documents, checks their logs, and creates `build/uc3m-report-template.zip`. Tectonic is also supported with `--engine tectonic`. See [building and maintenance](docs/building.md) for targets and publishing the reference.

GitHub Actions runs the same build on pushes, pull requests, and manual dispatch. Successful runs provide the two PDFs and a copyable template ZIP as an artifact. Maintenance conventions are in [AGENTS.md](AGENTS.md), and structural changes are recorded in [CHANGELOG.md](CHANGELOG.md).

## License

Distributed under the [MIT License](LICENSE).
