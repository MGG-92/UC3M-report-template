# MATLAB examples

Run either script from MATLAB, from any working directory. The scripts locate the shared helpers from their own file paths and write all generated files into `build/matlab-examples/`.

| Script | Demonstrates | Output directory |
| --- | --- | --- |
| `export_values.m` | Exporting named scalar values, then inserting them with units. | `build/matlab-examples/values/` |
| `export_table.m` | Exporting a table with custom headers, caption, and precision. | `build/matlab-examples/table/` |

Each script creates `main.tex` and its generated data file. Change into that output directory and run `pdflatex main.tex` twice. The small example document loads the repository's actual template styles. Run `export_values` again after changing a calculation, then recompile to update the displayed values.

The scripts require MATLAB R2021a or later and write only generated examples. See the [MATLAB guide](../../docs/matlab.md) for the full function options. To copy this workflow into coursework, update the helper and output paths for your project.
