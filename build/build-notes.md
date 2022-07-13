```powershell
# run controlplane on windows

New-Item -Type Directory -Path "C:\winkube\package" -Force


## get etcd binaries for windows

curl.exe -LO https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-windows-amd64.zip
Expand-Archive etcd-v3.5.4-windows-amd64.zip
Copy-Item etcd*.exe C:\winkube\package\

## build etcd image



## get coredns binaries for windows

curl.exe -LO https://github.com/coredns/coredns/releases/download/v1.9.3/coredns_1.9.3_windows_amd64.tgz
tar xz coredns_1.9.3_windows_amd64.tgz
Copy-Item coredns.exe C:\winkube\package\

## build k8s server binaries for windows

## build k8s server images

## kubeadm kube-proxy add-on manifest

https://github.com/kubernetes/kubernetes/blob/master/cmd/kubeadm/app/phases/addons/proxy/manifests.go

> the manifest currently supports linux only due to node selectors

## kubeadm coredns add-on manifest 

https://github.com/kubernetes/kubernetes/blob/master/cmd/kubeadm/app/phases/addons/dns/manifests.go
```
