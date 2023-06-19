
## 3scale Random Blocker Policy

3scale API Gateway  Policy blocks/allows the request  based on random number generation, If the generated number is even it will allow the request, otherwise it will block the request.


## Policy Installation on OpenShift using 3scale APIcast self-managed

1. Deploy a self-managed  APIcast gateway
  
1. Install the APIcast operator as described in the [documentation](https://github.com/3scale/apicast-operator/blob/master/doc/quickstart-guide.md#Install-the-APIcast-operator)
2. Create a Kubernetes secret that contains a 3scale Porta admin portal endpoint information
```shell
oc create secret generic 3scaleportal --from-literal=AdminPortalURL=https://access-token@account-admin.3scale.net
```
3. create a secret containing the policy Lua files (the files exist in the  folder /policies/random_blocker/1.0.0)
```shell
oc create secret generic random-blocker-policy   --from-file=random_blocker.lua   --from-file=init.lua   
```
4.Create APIcast custom resource instance
```shell
apiVersion: apps.3scale.net/v1alpha1
kind: APIcast
metadata:
  name: apicast-random-blocker
spec: 
  adminPortalCredentialsRef:
    name: 3scaleportal
  replicas: 1  
  customPolicies:
    - name: random_blocker
      secretRef:
        name: random-blocker-policy
      version: 1.0.0
```
5. Create 3scale CustomPolicyDefinition Custom Resource 
 in order to view the policy configuration in the API Manager policy editor UI, the custom policy should be registered using customPolicyDefinition custom resource
```shell
apiVersion: capabilities.3scale.net/v1beta1
kind: CustomPolicyDefinition
metadata:
 name: custompolicydefinition-random-blocker
spec:
 name: "random_blocker"
 version: "1.0.0"
 schema:
   name: "random_blocker"
   version: "1.0.0"
   summary: "Block the request based if the generated random number is even, otherwise it allows the request"
   $schema: "http://json-schema.org/draft-07/schema#"
   configuration:
     type: object
     properties:
       error_message:
          title: Error message
          description: An error message to show to the user when traffic is blocked
          type: string
```
6. Add the policy to the policy chain to your API Product.
