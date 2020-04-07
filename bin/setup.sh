#!/usr/bin/env bash

set -euo pipefail

KUBECONTEXT="${KUBECONTEXT:-sbx}"

testdata="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../testdata"

kubectl config set-context $KUBECONTEXT --namespace opa
kubectl create namespace opa || true

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 100000 -out ca.crt -subj "/CN=admission_ca"

cat >server.conf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
EOF

openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=opa.opa.svc" -config server.conf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 100000 -extensions v3_req -extfile server.conf

kubectl delete secret opa-server || true
kubectl create secret tls opa-server --cert=server.crt --key=server.key

kubectl apply -f $testdata/admission-controller.yaml

cat $testdata/webhook-configuration.yaml \
  | sed "s/CA_BUNDLE/$(cat ca.crt | base64 | tr -d '\n')/" \
  | kubectl apply -f -

kubectl delete configmap ingress-whitelist || true
kubectl create configmap ingress-whitelist --from-file=$testdata/ingress-whitelist.rego

kubectl create -f $testdata/qa-namespace.yaml >/dev/null 2>&1 || true
kubectl create -f $testdata/production-namespace.yaml >/dev/null 2>&1 || true



