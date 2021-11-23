# Note this image doesn't really mater for hostprocess
# the files in the image are copied to $env:CONTAINER_SANDBOX_MOUNT_POINT on the host
# but the file system is the Host NOT the container
ARG BASE="mcr.microsoft.com/windows/nanoserver:1809"

FROM --platform=linux/amd64 curlimages/curl as bins
ARG KUBERNETES_VERSION="v1.22.3"

WORKDIR /kube-proxy
RUN curl -LO https://dl.k8s.io/release/${KUBERNETES_VERSION}/bin/windows/amd64/kube-proxy.exe
RUN curl -LO https://raw.githubusercontent.com/microsoft/SDN/master/Kubernetes/windows/hns.psm1

FROM $BASE

ENV PATH="C:\Program Files\PowerShell;C:\utils;C:\Windows\system32;C:\Windows;"

ADD ../hostprocess/kube-proxy/start.ps1 /bin/start.ps1
COPY --from=bins /kube-proxy/kube-proxy.exe /bin/kube-proxy.exe
COPY --from=bins /kube-proxy/hns.psm1 /bin/hns.psm1

ENTRYPOINT ["PowerShell"]
