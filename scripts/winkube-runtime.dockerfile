FROM --platform=linux/amd64 curlimages/curl as winkube-runtime-collect
ARG RUNTIME_PATH
ARG CRICTL_VERSION
ARG CONTAINERD_VERSION
ARG WINS_VERSION
ARG CALICO_VERSION
ARG CNI_PLUGIN_VERSION
ARG ARCH=amd64
ARG KUBERNETES_VERSION=dev

RUN set -x \
    && apk --no-cache add \
    bash \
    curl \
    file 
    
RUN mkdir -p winkube
RUN curl -sLO https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-windows-amd64.tar.gz
RUN curl -sLO https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-windows-amd64.tar.gz.sha256sum
RUN sha256sum -c containerd-${CONTAINERD_VERSION}-windows-amd64.tar.gz.sha256sum

RUN curl -sLO https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-windows-amd64.tar.gz
RUN curl -SLO https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-windows-amd64.tar.gz.sha256
RUN sha256sum -c ./crictl-${CRICTL_VERSION}-windows-amd64.tar.gz.sha256

RUN curl -sLO https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGIN_VERSION}/cni-plugins-windows-amd64-${CNI_PLUGIN_VERSION}.tgz
RUN curl -sLO https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGIN_VERSION}/cni-plugins-windows-amd64-${CNI_PLUGIN_VERSION}.tgz.sha256
RUN sha256sum -c cni-plugins-windows-amd64-${CNI_PLUGIN_VERSION}.tgz.sha256

RUN curl -sLO https://github.com/winkube/wins/releases/download/v${WINS_VERSION}/wins.exe
RUN curl -sLO https://github.com/winkube/wins/releases/download/v${WINS_VERSION}/sha256sum.txt
RUN cat sha256sum.txt | head -n1 | awk '{print $1"  wins.exe"}' >> wins.exe.sha256
RUN sha256sum -c wins.exe.sha256
RUN mv wins.exe winkube/

RUN curl -sLO https://dl.k8s.io/release/${KUBERNETES_VERSION}/bin/windows/amd64/kubectl.exe
RUN curl -sLO https://dl.k8s.io/${KUBERNETES_VERSION}/bin/windows/amd64/kubectl.exe.sha256
RUN echo "  kubectl.exe" >> kubectl.exe.sha256
RUN sha256sum -c kubectl.exe.sha256
RUN mv kubectl.exe winkube/

RUN curl -sLO https://dl.k8s.io/release/${KUBERNETES_VERSION}/bin/windows/amd64/kubelet.exe
RUN curl -sLO https://dl.k8s.io/${KUBERNETES_VERSION}/bin/windows/amd64/kubelet.exe.sha256
RUN echo "  kubelet.exe" >> kubelet.exe.sha256
RUN sha256sum -c kubelet.exe.sha256
RUN mv kubelet.exe winkube/

RUN curl -sLO https://dl.k8s.io/release/${KUBERNETES_VERSION}/bin/windows/amd64/kube-proxy.exe
RUN curl -sLO https://dl.k8s.io/${KUBERNETES_VERSION}/bin/windows/amd64/kube-proxy.exe.sha256
RUN echo "  kube-proxy.exe" >> kube-proxy.exe.sha256
RUN sha256sum -c kube-proxy.exe.sha256
RUN mv kube-proxy.exe winkube/

RUN curl -sLO https://github.com/projectcalico/calico/releases/download/${CALICO_VERSION}/calico-windows-${CALICO_VERSION}.zip
RUN curl -sL https://github.com/Microsoft/SDN/raw/master/Kubernetes/windows/hns.psm1 -o winkube/hns.psm1

RUN tar xzvf crictl-${CRICTL_VERSION}-windows-amd64.tar.gz crictl.exe -C winkube/
RUN tar xvzf containerd-${CONTAINERD_VERSION}-windows-amd64.tar.gz -C winkube/
RUN tar xzvf cni-plugins-windows-amd64-${CNI_PLUGIN_VERSION}.tgz ./win-overlay.exe ./host-local.exe -C winkube/

RUN unzip calico-windows-${CALICO_VERSION}.zip
RUN mv CalicoWindows/calico-node.exe winkube/
RUN mv CalicoWindows/cni/calico.exe winkube/
RUN mv CalicoWindows/cni/calico-ipam.exe winkube/


# FROM mcr.microsoft.com/windows/nanoserver:ltsc2022 AS winkube-runtime
# ARG RUNTIME_PATH
# ARG CRICTL_VERSION
# ARG CONTAINERD_VERSION
# ARG WINS_VERSION
# ARG CALICO_VERSION
# ARG CNI_PLUGIN_VERSION
# ARG ARCH=amd64
# ARG KUBERNETES_VERSION=dev

# SHELL ["pwsh", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# RUN Write-Host "Using Kubernetes version:" $env:KUBERNETES_VERSION
# RUN Write-Host "Using Runtime Path:" $env:RUNTIME_PATH

# RUN New-Item -ItemType Directory -Path ${env:RUNTIME_PATH}
# WORKDIR /tmp/

# RUN curl.exe -sfL -R https://dl.k8s.io/release/$env:KUBERNETES_VERSION/bin/windows/amd64/kubectl.exe -o /winkube/kubectl.exe ; \ 
#     curl.exe -sfL -R https://dl.k8s.io/release/$env:KUBERNETES_VERSION/bin/windows/amd64/kubelet.exe -o /winkube/kubelet.exe ; \
#     curl.exe -sfL -R https://dl.k8s.io/release/$env:KUBERNETES_VERSION/bin/windows/amd64/kube-proxy.exe -o /winkube/kube-proxy.exe

# RUN curl.exe -sfL -O -R https://github.com/containernetworking/plugins/releases/download/${env:CNI_PLUGIN_VERSION}/cni-plugins-windows-amd64-$env:CNI_PLUGIN_VERSION.tgz; \
#     tar.exe xzvf cni-plugins-windows-amd64-$env:CNI_PLUGIN_VERSION.tgz --strip=1 win-overlay.exe host-local.exe ; \
#     Move-Item -Path win-overlay.exe -Destination /winkube/win-overlay.exe  ; \
#     Move-Item -Path host-local.exe -Destination /winkube/host-local.exe

# RUN curl.exe -sfL -O -R https://github.com/containerd/containerd/releases/download/v${env:CONTAINERD_VERSION}/containerd-${env:CONTAINERD_VERSION}-windows-amd64.tar.gz; \ 
#     tar xvzf containerd-${env:CONTAINERD_VERSION}-windows-amd64.tar.gz --strip=1 -C /winkube/

# RUN curl.exe -sfL -O -R https://github.com/projectcalico/calico/releases/download/${env:CALICO_VERSION}/calico-windows-${env:CALICO_VERSION}.zip; \
#     Expand-Archive -Path calico-windows-${env:CALICO_VERSION}.zip; \
#     Move-Item -Path calico-windows-v3.19.2/CalicoWindows/calico-node.exe -Destination /winkube/calico-node.exe ; \
#     Move-Item -Path calico-windows-v3.19.2/CalicoWindows/cni/calico.exe -Destination /winkube/calico.exe ; \
#     Move-Item -Path calico-windows-v3.19.2/CalicoWindows/cni/calico-ipam.exe -Destination /winkube/calico-ipam.exe

# RUN curl.exe -sfL -O -R https://github.com/kubernetes-sigs/cri-tools/releases/download/${env:CRICTL_VERSION}/crictl-${env:CRICTL_VERSION}-windows-amd64.tar.gz ; \ 
#     tar xzvf crictl-$env:CRICTL_VERSION-windows-amd64.tar.gz -C /winkube/

# RUN curl.exe -sfL -R https://github.com/winkube/wins/releases/download/$env:WINS_VERSION/wins.exe -o /winkube/wins.exe


# FROM mcr.microsoft.com/windows/nanoserver:ltsc2022 AS winkube-runtime
FROM mcr.microsoft.com/windows/nanoserver:ltsc2022 AS winkube-runtime
# COPY --from=winkube-runtime /winkube/. /bin/
COPY --from=windows-runtime-collect ./winkube/* /bin/

SHELL ["pwsh", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV PATH="C:\Program Files\PowerShell;C:\utils;C:\Windows\system32;C:\Windows;"

ENTRYPOINT ["pwsh"]
