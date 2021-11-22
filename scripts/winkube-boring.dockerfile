# ARG SERVERCORE_VERSION
FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS winkube-goboring
# FROM rancher/golang:1.17-windowsservercore AS winkube-goboring
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# WORKDIR C:/
# RUN $URL = 'https://github.com/git-for-windows/git/releases/download/v2.33.0.windows.2/MinGit-2.33.0.2-64-bit.zip' \
#     $ProgressPreference = 'SilentlyContinue'; \
#     [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
#         Invoke-WebRequest -UseBasicParsing -OutFile c:\git.zip -Uri $URL ; \
#         Expand-Archive -Force -Path c:\git.zip -DestinationPath c:\git\. ; \
#         Remove-Item -Force -Recurse -Path c:\git.zip 

# go get github.com/golang/go@dev.boringcrypto.go1.17
# https://go-boringcrypto.storage.googleapis.com/go1.17.2b7.src.tar.gz

RUN     if ($null -ne $GODEBUG -or $env:GODEBUG) { \
        $env:EXTRA_LDFLAGS="$env:EXTRA_LDFLAGS -s -w" \
        $env:DEBUG_GO_GCFLAGS="" \
        $env:DEBUG_TAGS="" \
        else { \
        $env:DEBUG_GO_GCFLAGS='-gcflags=all=-N -l' \
        } \
        } 

ARG RUNTIME_PATH
ARG CRICTL_VERSION
ARG CONTAINERD_VERSION
ARG WINS_VERSION
ARG CALICO_VERSION
ARG CNI_PLUGIN_VERSION
ARG ARCH=amd64
ARG KUBERNETES_VERSION=dev

ADD https://go-boringcrypto.storage.googleapis.com/go1.17.2b7.src.tar.gz /usr/local/boring.tgz
WORKDIR C:/usr/local/boring
RUN tar xzf ../boring.tgz
WORKDIR C:/usr/local/boring/go/src
RUN ./make.bat
COPY scripts/ /usr/local/boring/go/bin/



FROM mcr.microsoft.com/windows/nanoserver:1809 AS winkube-build
COPY --from=winkube-goboring /usr/local/boring/go/ /usr/local/go/
