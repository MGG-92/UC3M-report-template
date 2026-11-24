#!/usr/bin/env python3
"""Build the report and reference without third-party Python dependencies."""

import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys
import zipfile

ROOT = Path(__file__).resolve().parents[1]
TARGETS = {
    'template': ROOT / 'template',
    'reference': ROOT / 'docs' / 'reference',
}
BAD_LOG = re.compile(
    r'^!|Overfull \\[hv]box|LaTeX Warning: (?:Reference .* undefined|'
    r'Citation .* undefined|There were undefined references|'
    r'Label\(s\) may have changed|Label .* multiply defined)',
    re.MULTILINE,
)
RERUN = re.compile(r'Label\(s\) may have changed|Rerun to get|Please (?:re)?run|'
                   r'rerunfilecheck Warning: File .* has changed')


def compile_document(target, engine):
    source = TARGETS[target]
    out = ROOT / 'build' / target
    out.mkdir(parents=True, exist_ok=True)
    log = out / 'main.log'
    # Remove only this target's old products so a failed build cannot appear fresh.
    for suffix in ('pdf', 'log', 'aux', 'toc', 'out'):
        (out / f'main.{suffix}').unlink(missing_ok=True)
    print(f'Building {target} with {engine}', flush=True)
    if engine == 'tectonic':
        command = [engine, '--untrusted', '--keep-logs', '--keep-intermediates',
                   '--reruns', '2', '--outdir', str(out), 'main.tex']
        subprocess.run(command, cwd=source, check=True)
    else:
        command = [engine, '-interaction=nonstopmode', '-halt-on-error',
                   '-no-shell-escape', f'-output-directory={out}', 'main.tex']
        # Always run twice; allow more passes when the contents or labels change.
        for count in range(5):
            result = subprocess.run(command, cwd=source, capture_output=True, text=True,
                                    errors='replace')
            if result.returncode:
                print(result.stdout, file=sys.stderr)
                print(result.stderr, file=sys.stderr)
                raise RuntimeError(f'{target} failed; see {log}')
            if count >= 1 and not RERUN.search(log.read_text(errors='replace')):
                break
    if not log.exists() or not (out / 'main.pdf').exists():
        raise RuntimeError(f'{target} did not produce a PDF and log')
    text = log.read_text(errors='replace')
    issues = BAD_LOG.findall(text)
    if issues or RERUN.search(text):
        raise RuntimeError(f'{target} has unresolved references, overflow, or rerun warnings; see {log}')
    print(f'Validated: {out / "main.pdf"}', flush=True)


def package_template():
    archive = ROOT / 'build' / 'uc3m-report-template.zip'
    excluded = {'.aux', '.log', '.pdf', '.toc', '.out', '.fls', '.fdb_latexmk', '.asv', '.gz'}
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as package:
        for path in sorted((ROOT / 'template').rglob('*')):
            if path.is_file() and path.suffix not in excluded and not any(
                part.startswith('.') for part in path.relative_to(ROOT / 'template').parts
            ):
                package.write(path, path.relative_to(ROOT / 'template'))
    print(f'Packaged: {archive}', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--target', choices=['all', *TARGETS], default='all')
    parser.add_argument('--engine', choices=['auto', 'pdflatex', 'tectonic'], default='auto')
    parser.add_argument('--publish-reference', action='store_true',
                        help='Replace the tracked root PDF after building and validating it')
    args = parser.parse_args()
    if args.publish_reference and args.target == 'template':
        parser.error('--publish-reference requires the reference target')
    engine = args.engine
    if engine == 'auto':
        engine = next((name for name in ('pdflatex', 'tectonic') if shutil.which(name)), None)
    if not engine or not shutil.which(engine):
        parser.error('Install pdfLaTeX or Tectonic and add it to PATH')
    targets = list(TARGETS) if args.target == 'all' else [args.target]
    try:
        for target in targets:
            compile_document(target, engine)
        if 'template' in targets:
            package_template()
        if args.publish_reference:
            shutil.copy2(ROOT / 'build/reference/main.pdf', ROOT / 'Package Reference.pdf')
            print('Updated Package Reference.pdf; visually review it before committing.')
    except (subprocess.CalledProcessError, RuntimeError, OSError) as error:
        print(f'Build failed: {error}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
