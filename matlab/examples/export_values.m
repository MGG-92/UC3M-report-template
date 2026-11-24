% Export scalar results and generate a small document that uses them.
exampleDir = fileparts(mfilename('fullpath'));
matlabDir = fileparts(exampleDir);
repoDir = fileparts(matlabDir);
addpath(matlabDir);
outputDir = fullfile(repoDir, 'build', 'matlab-examples', 'values');
if ~isfolder(outputDir), mkdir(outputDir); end

mass = 2.5;
acceleration = 9.81;
values = struct('Force', mass * acceleration, 'MassFlow', 0.25);
export2latex(values, filename=fullfile(outputDir, 'results.tex'), reset=true);

lines = [
    "\documentclass{article}"
    "\usepackage[T1]{fontenc}"
    "\makeatletter"
    "\def\input@path{{../../../template/}}"
    "\makeatother"
    "\usepackage{uc3m-report}"
    "\input{results}"
    "\begin{document}"
    "The force is \MATForce~\unit{\newton}."
    "The mass flow is \MATMassFlow~\unit{\kilogram\per\second}."
    "\end{document}"
];
fid = fopen(fullfile(outputDir, 'main.tex'), 'w');
assert(fid ~= -1, 'Cannot open the example document for writing.');
fileCleanup = onCleanup(@() fclose(fid));
textLines = cellstr(lines);
fprintf(fid, '%s\n', textLines{:});
clear fileCleanup;
fprintf('Example written to %s\n', outputDir);
