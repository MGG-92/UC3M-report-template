% Export a table and generate a small document that includes it.
exampleDir = fileparts(mfilename('fullpath'));
matlabDir = fileparts(exampleDir);
repoDir = fileparts(matlabDir);
addpath(matlabDir);
outputDir = fullfile(repoDir, 'build', 'matlab-examples', 'table');
if ~isfolder(outputDir), mkdir(outputDir); end

T = table(["A"; "B"], [24.525; 19.620], ...
    'VariableNames', {'Test', 'ForceN'});
table2latex(T, filename=fullfile(outputDir, 'results_table.tex'), ...
    caption="Measured forces.", label="tab:measurements", decimals=3, ...
    headers={'Test', 'Force (\unit{\newton})'});

lines = [
    "\documentclass{article}"
    "\usepackage[T1]{fontenc}"
    "\makeatletter"
    "\def\input@path{{../../../template/}}"
    "\makeatother"
    "\usepackage{uc3m-report}"
    "\begin{document}"
    "\input{results_table}"
    "See Table~\ref{tab:measurements}."
    "\end{document}"
];
fid = fopen(fullfile(outputDir, 'main.tex'), 'w');
assert(fid ~= -1, 'Cannot open the example document for writing.');
fileCleanup = onCleanup(@() fclose(fid));
textLines = cellstr(lines);
fprintf(fid, '%s\n', textLines{:});
clear fileCleanup;
fprintf('Example written to %s\n', outputDir);
