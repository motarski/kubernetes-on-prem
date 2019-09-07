# The code for main project
---
Lifecycle of the project is going to be managed by maven end to end, from commit to deployment on the kubernetes cluster (provisioned with the vagrant scripts)

### Simple Nginx web server introduced to project_code

Directory project_code consists of current structure

* project_code
   * -- src
      * -- main
       * -- docker ``# -- Contains files for building docker images``
       * -- fabric8 ``# -- Contains kubernetes contracts``
* pom.xml ``# -- Project Object model``
* README.md ``# -- Documentation (This file)``


###### Kubernetes deployment strategy set to rollingUpdate


### To deploy init web app via maven
```
$ cd project_code
$ mvn clean install -Denv=edu
```

NOTE: Currently there are no other environments defined in the maven project and `edu` environment is set to be active by default there for running just `mvn clean install` will have the same result as above

It will deploy:
- Ingress rules
- Deployment
- Service

Accessible from browser host via url `http://barjaktarov.local`
