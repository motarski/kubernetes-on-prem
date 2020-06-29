# Testing cluster functionality
## Deploy demo wordpress site

The application will deploy two kubernetes pods that are using NFS dynamic provisioner to claim volumes. It wil also deploy an ingress object to test the Loadbalancer component

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
