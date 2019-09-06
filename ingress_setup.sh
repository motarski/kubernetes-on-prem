#!/bin/bash
# Setup ingress controller as daemonset 

k8_app="k8s_objects/hello-world-app"
k8_location="k8s_objects/ingress-controller"
k8_ingress_object=(ns-and-sa.yaml default-server-secret.yaml ingress-configmap.yaml ingress-rbac.yaml ingress-controller-daemonset.yaml)

for kube in "${k8_ingress_object[@]}"
 do kubectl create -f ${k8_location}/${kube}
done
