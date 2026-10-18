# Logs in to the local Concourse, loads pipeline.yml, unpauses it and triggers the first run.
param([Parameter(Mandatory = $true)][string]$GithubUser)
$ErrorActionPreference = 'Stop'
fly -t local login -c http://localhost:8080 -u test -p test
fly -t local set-pipeline -p demo -c (Join-Path $PSScriptRoot '..\pipeline.yml') -v github_user=$GithubUser -n
fly -t local unpause-pipeline -p demo
fly -t local trigger-job -j demo/test -w
