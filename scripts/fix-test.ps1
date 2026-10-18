# Restores the unit test, commits and pushes (demo: pipeline turns green again).
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
(Get-Content app.test.js -Raw).Replace('add(2, 3), 6', 'add(2, 3), 5') | Set-Content app.test.js -NoNewline
git add app.test.js
git commit -m "Demo: fix unit test"
git push
fly -t local check-resource -r demo/repo
