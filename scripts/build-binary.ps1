#Requires -Version 5.0

$ErrorActionPreference = 'Stop'
Import-Module -WarningAction Ignore -Name "$PSScriptRoot\utils.psm1"

function Build-Binary () {
    if ($null -ne $GODEBUG -or $env:GODEBUG) { 
        $env:EXTRA_LDFLAGS="$env:EXTRA_LDFLAGS -s -w"
        $env:DEBUG_GO_GCFLAGS=""
        $env:DEBUG_TAGS=""
        else {
        $env:DEBUG_GO_GCFLAGS='-gcflags=all=-N -l'
        }
    }

    $env:REVISION="$env:COMMIT$env:DIRTY"
    $env:RELEASE="$env:PROG-$env:OS.$ARCH"

    $env:BUILDTAGS="netgo osusergo no_stage static_build"
    $env:GO_BUILDTAGS="$env:GO_BUILDTAGS $env:BUILDTAGS $env:DEBUG_TAGS"

    $VERSION_FLAGS="
    -X github.com/$env:REPO/$env:PROG/pkg/version.GitCommit=$env:REVISION 
    -X github.com/$env:REPO/$env:PROG/pkg/version.Program=$env:PROG
    -X github.com/$env:REPO/$env:PROG/pkg/version.Version=$env:VERSION
    -X github.com/$env:REPO/$env:PROG/pkg/images.DefaultRegistry=$env:REGISTRY
    -X github.com/$env:REPO/$env:PROG/pkg/images.DefaultEtcdImage=rancher/hardened-etcd:$env:ETCD_VERSION-$env:IMAGE_BUILD_VERSION
    -X github.com/$env:REPO/$env:PROG/pkg/images.DefaultKubernetesImage=rancher/hardened-kubernetes:$env:KUBERNETES_IMAGE_TAG
    -X github.com/$env:REPO/$env:PROG/pkg/images.DefaultPauseImage=rancher/pause:$env:PAUSE_VERSION
    -X github.com/$env:REPO/$env:PROG/pkg/images.DefaultRuntimeImage=$env:REPO/$env:PROG-runtime:$env:DOCKERIZED_VERSION
    "

    $GO_LDFLAGS="$STATIC_FLAGS $EXTRA_LDFLAGS"
    Write-Output "$env:DEBUG_GO_GCFLAGS"
    # $CGO_ENABLED=1 $CXX="x86_64-w64-mingw32-g++" $CC="x86_64-w64-mingw32-gcc" 
    $env:GOOS="windows"; $env:GOARCH="amd64"; go build `
    -tags "$env:GO_BUILDTAGS $env:GO_GCFLAGS $env:GO_BUILD_FLAGS" `
    -o "bin/$env:PROG.exe" `
    -ldflags "$GO_LDFLAGS $VERSION_FLAGS" `
    $env:GO_TAGS
    if (-not $?) {
        Log-Fatal "go build failed!"
    }
}

Invoke-Script -File "$PSScriptRoot\version.ps1"
if ($LASTEXITCODE -ne 0) {
    Log-Fatal "Build failed while running version.ps1"
    exit $LASTEXITCODE
}

$SRC_PATH = (Resolve-Path "$PSScriptRoot\..\..").Path
Push-Location $SRC_PATH

Remove-Item -Path "$SRC_PATH\bin\*" -Force -ErrorAction Ignore
$null = New-Item -Type Directory -Path bin -ErrorAction Ignore
Build-Binary
Pop-Location
