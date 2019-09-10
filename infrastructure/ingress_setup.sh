#!/bin/bash
# Kubernetes Cluster Infrastructure prerequisities

k8_location="../k8s_objects/ingress-controller"
k8_ingress_object=(ns-and-sa.yaml default-server-secret.yaml ingress-configmap.yaml ingress-rbac.yaml ingress-controller-daemonset.yaml)
k8_pv_object=(db-pv.yaml www-pv.yaml)

# Deploy Ingress Controller as daemonset
echo -e "\033[1;34mDeploying Ingress Controller ...\033[0m"
for kube in "${k8_ingress_object[@]}"
 do kubectl create -f ${k8_location}/${kube}
done

# Rename context to kubernetes
echo -e "\n\033[1;34mRename and switch context ...\033[0m"
kubectl config rename-context kubernetes-admin@kubernetes kubernetes
kubectl config use-context kubernetes
