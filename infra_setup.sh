#!/bin/bash
# Kubernetes Cluster Infrastructure prerequisities
# Setup ingress controller as daemonset
# Setup Persistant volumes on a cluster level
 
k8_pv_location="k8s_objects/persistent-volumes"
k8_location="k8s_objects/ingress-controller"
k8_ingress_object=(ns-and-sa.yaml default-server-secret.yaml ingress-configmap.yaml ingress-rbac.yaml ingress-controller-daemonset.yaml)
k8_pv_object=(db-pv.yaml www-pv.yaml db-pvc.yaml www-pvc.yaml) 

for kube in "${k8_ingress_object[@]}"
 do kubectl create -f ${k8_location}/${kube}
done

for pv in "${k8_pv_object[@]}"
 do kubectl create -f ${k8_pv_location}/${pv}
done
