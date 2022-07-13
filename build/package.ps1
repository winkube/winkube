#Requires -Version 5.0
$ErrorActionPreference = "Stop"

Invoke-Expression -Command "$PSScriptRoot\version.ps1"

$DIR_PATH = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SRC_PATH = (Resolve-Path "$DIR_PATH\..").Path

$ASSETS = @("kubelet", "kube-apiserver", "kube-scheduler", "kube-controller-manager", "kube-proxy", "etcd", "etcdctl", "etcdutl", "wins")
Write-Host -ForegroundColor Yellow "checking for build artifact [$ASSETS] in $SRC_PATH"
foreach ($item in $ASSETS) {
    if (-not ("$SRC_PATH\$item.exe")) {
        Write-Error "required build artifact is missing: $item.exe"
        throw
    }
}
Write-Host -ForegroundColor Green "all required build artifacts are present"

Write-Host -ForegroundColor Yellow "staging artifacts for image builds"
$null = New-Item -Type Directory -Path C:\package -ErrorAction Ignore
Copy-Item -Force -Path $SRC_PATH\*.exe -Destination C:\package
Write-Host -ForegroundColor Green "artifacts have been successfully staged"
Write-Host -ForegroundColor Green "package.ps1 has completed successfully."


