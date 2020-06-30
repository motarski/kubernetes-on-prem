# Testing cluster functionality
## WordPress demo site deployment

This script will deploy two kubernetes pods that use NFS dynamic provisioner functionality. It will also deploy an ingress object to test the Loadbalancer functionality

```
$ cd website
$ ./deployment --deploy
```
## Accessing the site

```
Accessible from host browser (Chrome, Firefox) via url `http://barjaktarov.local`
```
## Tear it down

```
$ cd website
$ ./deployment --teardown
```

To display info on usage of the deployment script type `./deployment`
