# MATLAB to LaTeX

`matlab/` includes `export2latex.m` for individual values and `table2latex.m` for MATLAB tables. Run your calculation script from that folder, or add it to the MATLAB path with `addpath`. Both functions generate `.tex` files that you include in the report with `\input`; they are MATLAB helpers, not LaTeX packages, so their usage is documented here rather than in the Package Reference.

## Optional settings and named arguments

Both functions use MATLAB `arguments` blocks. Supply only the options you need, in any order, using `name=value`. You can also provide a scalar struct through `settings`, or combine the two styles:

```matlab
settings = struct('caption', 'Measured forces.', 'decimals', 2);
table2latex(T, settings=settings, filename="results_table.tex", decimals=3);
```

The priority is **defaults < `settings` < explicit named options**. The example uses three decimal places, even though `settings.decimals` is two. This priority does not depend on where `settings` appears in the call. Omitted fields keep their defaults; `settings` itself is optional. Use the option names listed below as struct fields. Unsupported settings and invalid values are rejected, rather than silently ignored.

The `name=value` examples require MATLAB R2021a or later. Comma-separated name-value pairs also work, for example `table2latex(T, 'filename', 'results_table.tex', 'decimals', 3)`. See the [MATLAB name-value documentation](https://www.mathworks.com/help/matlab/matlab_prog/validate-name-value-arguments.html).

## Keep reported values up to date with `export2latex`

This is particularly useful if you discover a mistake in one part of a lab:

- correct the calculation,
- rerun the MATLAB script,
- and recompile the report.

Every occurrence of the exported values then updates automatically, without copying the corrected numbers into the text by hand. This applies to values inserted using the generated commands; numbers typed directly into the report are not updated.

For a script saved in `matlab/`:

```matlab
scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
valuesFile = fullfile(projectDir, 'template', 'results.tex');

% Replace these example calculations with your own.
mass = 2.5;
acceleration = 9.81;
force = mass * acceleration;
massFlow = 0.25;

values = struct('Force', force, 'MassFlow', massFlow);
export2latex(values, filename=valuesFile, reset=true);
```

The first argument contains the **data** to export; `settings` contains only the **configuration**. For example, you can share settings between calls and override only the precision:

```matlab
settings = struct('filename', valuesFile, 'precision', 12);
export2latex(values, settings=settings, precision=17, reset=true);
```

Load the generated commands once, after the template's packages and before their first use. When compiling from `template/`:

```latex
\input{results}

The calculated force is \MATForce~\unit{\newton}.
The mass flow is \MATMassFlow~\unit{\kilogram\per\second}.
```

The generated commands are `\MAT` followed by the data field name, preserving its case: `Force` becomes `\MATForce`. Each command already contains `\num{...}`, so use it directly and add units with `\unit`; do not put it inside another `\num` or the numeric argument of `\qty`. The template loads `siunitx` through its Math group.

| Option      | Default         | Meaning                                                                        |
| ----------- | --------------- | ------------------------------------------------------------------------------ |
| `filename`  | `"results.tex"` | Destination file; the folder must already exist.                               |
| `precision` | `12`            | Significant digits in the exported representation; integer from 1 to 17.       |
| `reset`     | `false`         | With data, clear old definitions before writing when `true`; otherwise append. |
| `settings`  | `struct()`      | Optional configuration fields, overridden by explicit named options.           |

Data fields may contain letters only: no digits, spaces, or underscores. Values must be finite, real numeric scalars; arrays, `NaN`, and `Inf` are not accepted. Precision affects the exported text, not the MATLAB calculations.

Use `reset=true` for the first export of each script run. Subsequent calls can append more values with the default `reset=false`. Reusing a data field produces a warning and a LaTeX redefinition; its last value takes effect. To clear a file without exporting data, omit the data struct: `export2latex(filename=valuesFile)`. `export2latex()` clears `results.tex`.

## Export MATLAB tables with `table2latex`

```matlab
scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
tableFile = fullfile(projectDir, 'template', 'results_table.tex');

T = table(["A"; "B"], [24.525; 19.620], ...
    'VariableNames', {'Test', 'ForceN'});

table2latex(T, filename=tableFile, caption="Measured forces.", ...
    label="tab:measurements", decimals=3, ...
    headers={'Test', 'Force (\unit{\newton})'});
```

Only the MATLAB table `T` is required. For example, `table2latex(T, decimals=3)` changes only the number of decimal places. The settings struct can supply any of the options in the following table.

| Option     | Default               | Meaning                                                                          |
| ---------- | --------------------- | -------------------------------------------------------------------------------- |
| `filename` | `"table.tex"`         | Destination file; `.tex` is added if missing.                                    |
| `label`    | Derived from filename | For example, `tab:table` for `table.tex`; an empty label also uses this default. |
| `caption`  | `"Results."`          | Table caption in LaTeX.                                                          |
| `headers`  | Table variable names  | One text header per variable; default headers escape underscores.                |
| `decimals` | `4`                   | Decimal places in the output; nonnegative integer.                               |
| `settings` | `struct()`            | Optional configuration fields, overridden by explicit named options.             |

Include the complete generated table where it belongs in the report:

```latex
\input{results_table}
See Table~\ref{tab:measurements}.
```

Numeric columns use `siunitx`'s `S` alignment; text columns and optional MATLAB row names are supported. Numeric variables must contain one value per row. `NaN` is shown as a dash, and infinities as infinity symbols. Missing output folders are created, and each call overwrites the table. Rerunning MATLAB and recompiling LaTeX therefore updates the report's table.

The generated table requires `booktabs`, `siunitx`, and `float`, all supplied by the template's Graphics and Math groups. With another template, load those packages yourself. Custom headers, captions, and text cells are treated as LaTeX: escape special characters where needed. Supply explicit headers for mathematical labels.

## Updating older calls

The former positional optional arguments have been replaced by named options:

```matlab
% Old: table2latex(T, tableFile, [], [], [], 3)
table2latex(T, filename=tableFile, decimals=3);

% Old: export2latex(valuesFile, 'Force', force, 'MassFlow', massFlow)
export2latex(struct('Force', force, 'MassFlow', massFlow), filename=valuesFile);

% Old: export2latex(valuesFile) to clear the output
export2latex(filename=valuesFile);
```

## Runnable examples

Run `matlab/examples/export_values.m` or `matlab/examples/export_table.m` in MATLAB. Both resolve paths from their own location and write into `build/matlab-examples/`. Each example also creates a small LaTeX document that can be compiled from that folder with `pdflatex main.tex` (twice). See [examples/README.md](../matlab/examples/README.md).
