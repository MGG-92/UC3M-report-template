# Windows convenience wrapper. Python and a TeX engine must be on PATH.
& python (Join-Path $PSScriptRoot 'build.py') @args
exit $LASTEXITCODE
