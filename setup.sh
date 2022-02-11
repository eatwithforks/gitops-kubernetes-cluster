#!/bin/bash

kind delete cluster

kind create cluster

make install-argocd

make check-argocd-ready

kubectl patch deployment argocd-server --type json -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]' -n argocd

password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "$password"

sleep 120

make proxy-argocd-ui
