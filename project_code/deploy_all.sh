#!/bin/bash

k8s_objects=(secret.yaml service.yaml pvc.yaml ingress.yaml deployment.yaml)
k8s_location="src/main/fabric8"

echo -e "\033[1;34mDeploying all ...\033[0m"
for object in "${k8s_objects[@]}"
 do kubectl create -f ${k8s_location}/${object}
done
