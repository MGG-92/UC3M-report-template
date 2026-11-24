# Building and maintenance

## Requirements

Use Python 3.10+ and a recent TeX distribution (TeX Live or MiKTeX) with pdfLaTeX, or Tectonic. The template uses `siunitx` v3 and a LaTeX kernel from November 2021 or later. Install missing LaTeX packages through your distribution's package manager. No third-party Python libraries are needed for the build command.

## Build commands

Run these commands from the repository root:

```sh
python scripts/build.py
python scripts/build.py --target template
python scripts/build.py --target reference
python scripts/build.py --engine tectonic
```

The default engine is pdfLaTeX when available, followed by Tectonic. The script runs each document from its own source directory, so paths work consistently. It compiles at least twice, checks the final log for errors, undefined references, unresolved rerun requests, and overfull boxes, then returns a nonzero exit code if validation fails.

On Windows, `./scripts/build.ps1` forwards its arguments to the same Python command. If your installation names the Python executable `python3` or `py`, call `scripts/build.py` using that executable directly.

| Output | Purpose |
| --- | --- |
| `build/template/main.pdf` | Example report, including its cover and contents. |
| `build/reference/main.pdf` | Rebuilt package reference. |
| `build/uc3m-report-template.zip` | Self-contained template ready for copying or uploading to Overleaf. |
| `build/<target>/main.log` | Compiler diagnostics. |

Tectonic can download support files on its first run and manages its own cache. See its [cache documentation](https://tectonic-typesetting.github.io/book/latest/getting-started/first-document.html) if you need a custom location.

## Publish the package reference

Build and visually inspect the reference, including the contents, example outputs, margins, and section boundaries. Then run:

```sh
python scripts/build.py --target reference --publish-reference
```

This rebuilds and validates the reference before replacing the tracked root `Package Reference.pdf`. Review the resulting PDF before committing it together with its source changes. Ordinary builds leave the tracked PDF unchanged.

## GitHub Actions

`.github/workflows/build.yml` installs TeX Live on Ubuntu and runs the same Python build on pushes, pull requests, and manual dispatch. The successful run includes the two PDFs and the template ZIP in a downloadable artifact. Failed runs retain available compiler logs. The workflow has read-only repository access and does not commit PDFs or create releases.

The workflow uses the official [checkout](https://github.com/actions/checkout) and [upload-artifact](https://github.com/actions/upload-artifact) actions. Download artifacts from the completed run in the repository's Actions tab. The tracked root reference remains available directly from the README.

## Contributing

Keep `template/` self-contained. Shared style definitions belong under `template/styles/` and are loaded through `template/uc3m-report.sty`; reference-only presentation belongs in `docs/reference/guide-config.tex`. Update examples and documentation when changing public helpers. For the detailed guide maintenance rules, see [AGENTS.md](../AGENTS.md).
