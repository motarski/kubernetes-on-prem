# Deployment and Tear down
###### Deploying wordpress with Mysql Application stack to test the functionality of cluster and persistent volumes
---

Deploy the website

```
$ cd website
$ ./deployment --deploy
```

Tear it down

```
$ cd website
$ ./deployment --teardown
```

For Usage of the deployment script type `./deployment`

### Accessing the Wordpress website

Accessible from browser host via url `http://barjaktarov.local`

The test of functionality web application is configured with the default DNS record for ingress host rule. If you changed the default `FQDN` in `vars.sh` when provisioning the cluster then you need to update the ingress object manually as well.

Enjoy your On-Prem Kubernetes cluster

##### Found bugs or have any comments? Feedback is appreciated. Send me an e-mail: ivan.thegreat@gmail.com
