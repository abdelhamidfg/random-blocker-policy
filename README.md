
## 3scale Random Blocker Policy

scale API Gateway  Policy blocks/allows the request  based on random number generation ,If the generated number is even it will allow the request,othereise it will block the request.


## Policy Installation on OpenShift

1. Update the following lines in openshift.yml with your own envrironment.
	
    - GIT_REPO openshift.yml:L113
    - APICAST_CUSTOM_NAMESPACE openshift.yml:L117

2. Access the current 3scale namespace for your API casts.

   ```shell
   oc project <<3SCALE_NAMESPACE>>
   ```


3. To install the build configs on OpenShift you can use provided template:

   ```shell
   oc -n <<3SCALE_NAMESPACE>> new-app -f openshift.yml -o yaml | oc apply -f -
   ```

## Starting the build

1. To start the first build run the following command:

   ```shell
   oc -n <<3SCALE_NAMESPACE>> start-build apicast-new-policy --wait --follow
   ```

2. To start the second build run the following command:

   ```shell
   oc -n <<3SCALE_NAMESPACE>> start-build apicast-custom --wait --follow
   ```

If you didn't change the output image of the second build, you should see the API Casts (stage and production) being redeployed.

Once the redeploys finish the new policy appearing in the list of policies to add.

