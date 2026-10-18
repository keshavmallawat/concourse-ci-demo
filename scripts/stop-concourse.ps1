# Stops Concourse and removes its containers and volumes.
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..\concourse-runtime')
docker compose down -v
