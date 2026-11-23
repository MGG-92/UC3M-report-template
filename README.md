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

## MATLAB to LaTeX

`MATLAB-scripts/` includes `export2latex.m` for individual values and
`table2latex.m` for MATLAB tables. Run your calculation script from that
folder, or add it to the MATLAB path with `addpath`. Both functions generate
`.tex` files that you include in the report with `\input`; they are MATLAB
helpers, not LaTeX packages, so their usage is documented here rather than
in the Package Reference.

### Keep reported values up to date with `export2latex`

This is particularly useful if you discover a mistake in one part of a lab:
correct the calculation, rerun the MATLAB script, and recompile the report.
Every occurrence of the exported values then updates automatically, without
copying the corrected numbers into the text by hand. This applies to values
inserted using the generated commands; numbers typed directly into the
report are not updated.

For a script saved in `MATLAB-scripts/`:

```matlab
scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
valuesFile = fullfile(projectDir, 'LaTeX', 'results.tex');

% Reset the generated file once at the start of each run.
export2latex(valuesFile);

% Replace these example calculations with your own.
mass = 2.5;
acceleration = 9.81;
force = mass * acceleration;
massFlow = 0.25;

export2latex(valuesFile, 'Force', force, 'MassFlow', massFlow);
```

Load the generated commands once, after loading the template's packages and
before their first use. When compiling from `LaTeX/`:

```latex
\input{results}

The calculated force is \MATForce~\unit{\newton}.
The mass flow is \MATMassFlow~\unit{\kilogram\per\second}.
```

The generated commands are `\MAT` followed by the supplied name, preserving
its case: `'Force'` becomes `\MATForce`. Each command already contains
`\num{...}`, so use it directly and add units with `\unit`, as above;
do not put it inside another `\num` or the numeric argument of `\qty`.
The template loads the required `siunitx` package through its Math group.

Usage and limits:

- `export2latex(filename)` clears the file. Call it **once per script run**,
  before exporting any values, rather than before every export call.
- `export2latex(filename, 'Name', value, ...)` appends one or more values.
  Reusing a name produces a warning and a LaTeX redefinition; the last value
  takes effect. Resetting once per run avoids accumulating old definitions.
- Names may contain letters only: no digits, spaces, or underscores.
- Values must be finite, real numeric scalars. Arrays, `NaN`, and `Inf` are
  not accepted. Output uses 12 significant digits; MATLAB calculations
  retain their original precision.
- The destination folder must already exist. Paths are resolved by MATLAB;
  the example uses `fullfile` to avoid depending on the working directory.

### Export MATLAB tables with `table2latex`

```matlab
scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
tableFile = fullfile(projectDir, 'LaTeX', 'results_table.tex');

T = table(["A"; "B"], [24.525; 19.620], ...
    'VariableNames', {'Test', 'ForceN'});

table2latex(T, tableFile, 'tab:measurements', 'Measured forces.', ...
    {'Test', 'Force (\unit{\newton})'}, 3);
```

Include the complete generated table where it belongs in the report:

```latex
\input{results_table}
See Table~\ref{tab:measurements}.
```

The full call is
`table2latex(T, filename, label, caption, headers, decimals)`.
Only `T` is required. Defaults are `table.tex`, a label derived from the
filename (`tab:table` for `table.tex`), `Results.`, the table variable names
as headers, and four decimal places. Use `[]` to keep a default when supplying
a later argument, for example `table2latex(T, tableFile, [], [], [], 3)`.

Numeric columns use `siunitx`'s `S` alignment; text columns and optional MATLAB
row names are supported. Numeric variables must contain one value per row.
`NaN` is shown as a dash, and infinities as signed infinity symbols. The
function creates missing destination folders and overwrites the table on
each call, so rerunning MATLAB and recompiling LaTeX also updates the table.

The generated table requires `booktabs`, `siunitx`, and `float`, all supplied
by the template's Graphics and Math groups. With another template, load those
packages yourself. Custom headers, captions, and text cells are treated as
LaTeX: escape special characters where needed. Default variable-name headers
escape underscores; supply explicit headers for mathematical labels.
