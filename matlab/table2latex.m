function table2latex(T, options)
% TABLE2LATEX Export a MATLAB table using optional named settings.
%   table2latex(T)
%   table2latex(T, filename="results.tex", decimals=3)
%   table2latex(T, settings=struct('caption','Results.','decimals',3))
%   table2latex(T, settings=s, decimals=5)
% Explicit options override settings; omitted fields use defaults.
% Options: filename, label, caption, headers, decimals, settings.
% Requirements: booktabs, siunitx, float. See README for examples.

arguments
    T table
    options.settings (1,1) struct = struct()
    options.filename
    options.label
    options.caption
    options.headers
    options.decimals
end

% Merge first, then validate so settings fields receive the same checks.
combined = options.settings;
names = fieldnames(rmfield(options,'settings'));
for k = 1:numel(names)
    combined.(names{k}) = options.(names{k});
end
args = namedargs2cell(combined);
config = validate_options(args{:});
filename = char(config.filename);
if ~endsWith(filename,'.tex'), filename = [filename '.tex']; end
label = char(config.label);
if isempty(label)
    [~,name] = fileparts(filename);
    label = ['tab:' name];
end
caption = char(config.caption);
decimals = config.decimals;
if isempty(config.headers)
    headers = cellfun(@(s) strrep(s,'_','\_'), ...
        T.Properties.VariableNames,'UniformOutput',false);
else
    mustBeText(config.headers);
    headers = cellstr(config.headers);
end
if ~isvector(headers) || numel(headers)~=width(T)
    error('table2latex:Headers','Provide one text header per table variable.');
end
headers = reshape(headers,1,[]);
output_dir = fileparts(filename);
if ~isempty(output_dir) && ~isfolder(output_dir), mkdir(output_dir); end

%% Column specifications
n_col = width(T);
n_row = height(T);

col_spec = cell(1, n_col);
numeric_col = false(1, n_col);

fmt = sprintf('%%.%df', decimals);

for c = 1:n_col

    values = T{:,c};

    if isnumeric(values)

        numeric_col(c) = true;

        if size(values,2) ~= 1
            error('Numeric table variables must be scalar per row.');
        end

        finite_values = values(isfinite(values));

        if isempty(finite_values)
            int_digits = 1;
            has_negative = false;
        else
            max_value = max(abs(finite_values));

            % Account for rounding to the chosen precision
            max_value = max_value + 0.5*10^(-decimals);

            int_digits = max(1, floor(log10(max(1,max_value)))+1);
            has_negative = any(finite_values < 0);
        end

        sign_spec = '';
        if has_negative
            sign_spec = '-';
        end

        col_spec{c} = sprintf('S[table-format=%s%d.%d]', ...
            sign_spec, int_digits, decimals);

    else
        col_spec{c} = 'l';
    end
end

%% Optional row names
row_names = T.Properties.RowNames;
has_row_names = ~isempty(row_names);

if has_row_names
    col_spec = [{'l'}, col_spec];
end

%% Open output file
fileID = fopen(filename, 'w');

if fileID == -1
    error('Unable to create output file: %s', filename);
end

%% Table environment
fprintf(fileID, '\\begin{table}[H]\n');
fprintf(fileID, '    \\centering\n');
fprintf(fileID, '    \\caption{%s}\n', caption);

if ~isempty(label)
    fprintf(fileID, '    \\label{%s}\n', label);
end

fprintf(fileID, '    \\begin{tabular}{%s}\n', ...
    strjoin(col_spec, ' '));

fprintf(fileID, '        \\toprule\n');

%% Column headers
header_cells = cell(1,n_col);

for c = 1:n_col
    if numeric_col(c)
        header_cells{c} = ['{' headers{c} '}'];
    else
        header_cells{c} = headers{c};
    end
end

if has_row_names
    header_cells = [{''}, header_cells];
end

fprintf(fileID, '        %s %s\n', ...
    strjoin(header_cells, ' & '), '\\');

fprintf(fileID, '        \\midrule\n');

%% Table data
for r = 1:n_row

    row_cells = cell(1,n_col);

    for c = 1:n_col

        value = T{r,c};

        % Unwrap cell contents
        while iscell(value)
            if isempty(value)
                value = '';
                break
            end
            value = value{1};
        end

        if isnumeric(value)

            if isnan(value)
                row_cells{c} = '{---}';

            elseif isinf(value)
                if value > 0
                    row_cells{c} = '{$\infty$}';
                else
                    row_cells{c} = '{$-\infty$}';
                end

            else
                row_cells{c} = sprintf(fmt, value);
            end

        elseif islogical(value)

            row_cells{c} = mat2str(value);

        else

            row_cells{c} = char(string(value));

        end
    end

    if has_row_names
        row_cells = [{row_names{r}}, row_cells];
    end

    fprintf(fileID, '        %s %s\n', ...
        strjoin(row_cells, ' & '), '\\');
end

%% Close table
fprintf(fileID, '        \\bottomrule\n');
fprintf(fileID, '    \\end{tabular}\n');
fprintf(fileID, '\\end{table}\n');

fclose(fileID);

fprintf('LaTeX table saved to: %s\n', filename);

end

function config = validate_options(config)
arguments
    config.filename (1,1) string {mustBeNonzeroLengthText} = "table.tex"
    config.label (1,1) string = ""
    config.caption (1,1) string = "Results."
    config.headers = []
    config.decimals (1,1) double {mustBeReal,mustBeFinite, ...
        mustBeInteger,mustBeNonnegative} = 4
end
end
