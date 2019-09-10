#!/bin/bash

tear_down=(wordpress wordpress-mysql)
pvcs=(mysql-pvc-claim www-pvc-claim)
k8s_objects=(secret.yaml service.yaml pvc.yaml ingress.yaml deployment.yaml)
k8s_location="src/main/fabric8"

tearDown() {
echo -e "\033[1;34mTear down all ...\033[0m"
for kube in "${tear_down[@]}"
 do kubectl delete svc ${kube}
         kubectl delete deployment ${kube}
 done

# Tear down Ingress secret and pvc
kubectl delete ingress wordpress
kubectl delete secret mysql-pass
for pvc in "${pvcs[@]}"
 do kubectl delete pvc ${pvc}
 done	 
}

deploy() {
echo -e "\033[1;34mDeploying all ...\033[0m"
for object in "${k8s_objects[@]}"
 do kubectl create -f ${k8s_location}/${object}
done
}

# Main bash flow
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

