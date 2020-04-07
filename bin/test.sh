#!/usr/bin/env bash

testdata="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../testdata"
echo "This should be ok ..."
kubectl create -f $testdata/ingress-ok.yaml -n opa-production

echo "This should fail ..."
kubectl create -f $testdata/ingress-bad.yaml -n opa-qa
