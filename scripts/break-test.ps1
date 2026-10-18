# Makes a unit test fail on purpose, commits and pushes (demo: red pipeline, build-image blocked).
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
(Get-Content app.test.js -Raw).Replace('add(2, 3), 5', 'add(2, 3), 6') | Set-Content app.test.js -NoNewline
git add app.test.js
git commit -m "Demo: break unit test on purpose"
git push
fly -t local check-resource -r demo/repo
