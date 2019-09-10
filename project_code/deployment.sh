#!/bin/bash

services=(wordpress wordpress-mysql)
pvcs=(mysql-pvc-claim www-pvc-claim)
volumes=(db-data www-data)
pv=(db-pv.yaml www-pv.yaml)
k8_pv_location="../k8s_objects/persistent-volumes"
k8s_objects=(secret.yaml service.yaml pvc.yaml ingress.yaml deployment.yaml)
k8s_location="src/main/fabric8"

tearDown() {
echo -e "\n\033[1;34mTear down everything ...\033[0m"
for kube in "${services[@]}"
 do kubectl delete svc ${kube}
         kubectl delete deployment ${kube}
	 kubectl delete endpoint ${kube}
done
# Tear down Ingress secret and pvc
kubectl delete ingress wordpress
kubectl delete secret mysql-pass
for pvc in "${pvcs[@]}"
 do kubectl delete pvc ${pvc}
done
for pv in "${volumes[@]}"
 do kubectl delete pv ${pv}
done
}

deploy() {
echo -e "\n\033[1;34mDeploying everything ...\033[0m"
# Provision persistent volumes
for volume in "${pv[@]}"
 do kubectl create -f ${k8_pv_location}/${volume}
done
for object in "${k8s_objects[@]}"
 do kubectl create -f ${k8s_location}/${object}
done
}

if [ $# -eq 0 ]; then
        echo -e "\nWhat do you want me to do, tearDown or deploy?\n"
	echo -e "USAGE: \033[1;33mdeployments --teardown\033[0m    # To tear down the whole thing (deployment, services and ingress)"
        echo -e "       \033[1;33mdeployments --deploy\033[0m      # To deploy application the whole thing\n"
        exit 0
fi

while [ $# -gt 0 ]; do
    case $1 in
        --teardown)     # Tear Down
            tearDown
            exit 0
            ;;
        --deploy)
	    deploy
	    exit 0
            ;;
    esac
        shift
done
