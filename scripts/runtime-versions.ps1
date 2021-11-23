#Requires -Version 5.0
$ErrorActionPreference = 'Stop'

# winkube-runtime variables to pass into the dockerfile

if ($env:REPO) {
    $REPO = $env:REPO
}
else {
    # set default
    $REPO = "winkube"
    $env:REPO = $REPO
}

$RUNTIME_PATH = $env:RUNTIME_PATH
if (-not $RUNTIME_PATH) {
    $RUNTIME_PATH = "winkube"
}
$env:RUNTIME_PATH = $RUNTIME_PATH

$CRICTL_VERSION = $env:CRICTL_VERSION
if (-not $CRICTL_VERSION) {
    $CRICTL_VERSION = "v1.22.0"
}
$env:CRICTL_VERSION = $CRICTL_VERSION

$CONTAINERD_VERSION = $env:CONTAINERD_VERSION
if (-not $CONTAINERD_VERSION) {
    $CONTAINERD_VERSION = "1.5.8"
}
$env:CONTAINERD_VERSION = $CONTAINERD_VERSION

$WINS_VERSION = $env:WINS_VERSION
if (-not $WINS_VERSION) {
    $WINS_VERSION = "v0.1.1"
}
$env:WINS_VERSION = $WINS_VERSION

$CALICO_VERSION = $env:CALICO_VERSION
if (-not $CALICO_VERSION) {
    $CALICO_VERSION = "v3.21.0"
}
$env:CALICO_VERSION = $CALICO_VERSION

$CNI_PLUGIN_VERSION = $env:CNI_PLUGIN_VERSION
if (-not $CNI_PLUGIN_VERSION) {
    $CNI_PLUGIN_VERSION = "v1.0.1"
}
$env:CNI_PLUGIN_VERSION = $CNI_PLUGIN_VERSION
