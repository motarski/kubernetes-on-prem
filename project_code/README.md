# The code for main project
---
Lifecycle of the project is going to be managed by maven end to end, from commit to deployment on the kubernetes cluster (provisioned with the vagrant scripts)

### Simple Nginx web server introduced to project_code

Directory project_code consists of current structure

- pom.xml ``Main project object model``
- src `Directory where source code and kubernetes deployment will be stored`

###### Kubernetes deployment strategy set to rollingUpdate


### To setup init web app via maven
```
# mvn clean install -Denv=edu
```

NOTE: Currently there are no other environments defined in the maven project and `edu` environment is set to be active by default there for running just `mvn clean install` will have the same result as above

It will deploy:
- Ingress rules
- Deployment
- Service

Accesible from browser host via url `http://barjaktarov.local`
