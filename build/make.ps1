#Requires -Version 5.0

$ErrorActionPreference = 'Stop'

Import-Module -WarningAction Ignore -Name "$PSScriptRoot\scripts\utils.psm1"

$Components = @("kubelet", "kube-apiserver", "kube-scheduler", "kube-controller-manager", "kube-proxy", "etcd")

# TODO
# function BinaryBuilder
# param (
#     [parameter(Mandatory = $true, ValueFromPipeline = $true)] [array]$Components,
#     [parameter(Mandatory = $true, ValueFromPipeline = $true)] [array]$OutDir
# )
#  function Package
# param (
#     [parameter(Mandatory = $true, ValueFromPipeline = $true)] [array]$Components,
#     [parameter(Mandatory = $true, ValueFromPipeline = $true)] [array]$OutDir
# )
function ImageBuilder() {
    param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)] [array]$Components,
        [parameter(Mandatory = $false, ValueFromPipeline = $true)] [string]$InputDir
    )
    Invoke-Expression -Command "$PSScriptRoot\version.ps1"
    Write-Host "Components: $Components"
    Write-Host "VERSION: $env:TAG"

    foreach ($COMPONENT in $Components) {
        try {
            $IMAGE = ('{0}/{1}:{2}-windows-{3}' -f $env:REPO, $COMPONENT, $env:TAG, $env:SERVERCORE_VERSION)
            Write-Host -ForegroundColor Yellow "Starting docker build of $IMAGE`n"

            if ($COMPONENT == "etcd") {
                $etcd = "etcd."
            }
                docker build `
                --build-arg SERVERCORE_VERSION=$env:SERVERCORE_VERSION `
                --build-arg VERSION=$env:VERSION `
                --build-arg MAINTAINERS=$env:MAINTAINERS `
                --build-arg REPO=$env:REPO `
                --build-arg REPO=$env:REGISTRY `
                -t $IMAGE `
                -f ('{0}Dockerfile' -f $etcd) .
            } catch {    
            Write-Host -NoNewline -ForegroundColor Red "[Error while building $IMAGE]: "
            Write-Host -ForegroundColor Red "$_`n"
            $env:TAG=""
            $env:VERSION=""
            $env:SERVERCORE_VERSION=""
            $COMPONENT=""
            $IMAGE=""
            $etcd=""
            exit 1
        }
        Write-Host -ForegroundColor Green "Successfully built $IMAGE`n"
    }
}

if ($args[0] -eq "build") {
    Write-Host "build is not yet implemented"
    # BinaryBuilder -Components $Components
    exit 1
}

if ($args[0] -eq "package") {
    Write-Host "package is not yet implemented"
    # BinaryBuilder -Components $Components -OutDir C:/winkube/bin
    # PackageBuilder -Components $Components -OutDir C:/winkube/images
    exit 1
}

if ($args[0] -eq "all" -or $args.Count -eq 0) {
    Write-Host "Building all images"
    ImageBuilder -Components $Components -InputDir "C:/winkube/bin"
    exit
}

if ($args[0] -eq "clean") {
    $confirm = Read-Host -Prompt "Are you sure you want to prune Docker images and volumes?: y/n"
    if ($confirm -eq "Y" -or $confirm -eq "y") {
        docker image prune --force 
        docker volume prune --force
        Write-Host -ForegroundColor Blue "Successfully pruned Docker images and volumes"
        exit 0
    } else {
        Write-Host -ForegroundColor Red "Will not prune Docker images and volumes, exiting now."
        exit 1
    }
}

if ($Components.Contains($($args[0]))) {
    ImageBuilder -Components $args[0] -InputDir "C:/winkube/bin"
    exit
}

