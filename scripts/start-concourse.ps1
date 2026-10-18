# Downloads the official Concourse quickstart docker-compose.yml and starts Concourse.
# Requires Docker Desktop to be running.
$ErrorActionPreference = 'Stop'
$dir = Join-Path $PSScriptRoot '..\concourse-runtime'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Set-Location $dir
if (-not (Test-Path 'docker-compose.yml')) {
    Invoke-WebRequest 'https://concourse-ci.org/docker-compose.yml' -OutFile 'docker-compose.yml'
}
docker compose up -d
Write-Host ''
Write-Host 'Concourse UI : http://localhost:8080   (login: test / test)'
Write-Host 'Next         : download fly.exe from the links at the bottom of the UI and add it to your PATH.'
