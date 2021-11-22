# https://go-boringcrypto.storage.googleapis.com/go1.17.3b7.src.tar.gz
$GOARCH = "amd64"
$GOOS = "windows"
$CGO_ENABLED = 1
$GOROOT_BOOTSTRAP = "C:\Program Files\Go"
$GOROOT = "C:\Program Files\Go"
$GOPATH = "~\go"


mkdir ~/repos
Set-Location -Path ~/ repos
git clone https://go.googlesource.com/go goroot
Set-Location -Path ~/repos/goroot
git checkout dev.boringcrypto.go1.17
git fetch origin
git reset --hard origin/dev.boringcrypto.go1.17

# alt to: go build -o /cmd/dist/dist.exe ./cmd/dist
# >go build -o /cmd/dist/dist.exe ./cmd/dist
# main module (std) does not contain package std/cmd/dist
push-location ~/repos/goroot/src/cmd/dist  
go build 
Pop-Location

.\cmd\dist\dist.exe env -w -p >env.bat
call env.bat
