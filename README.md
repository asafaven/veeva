The task was done using terraform tool.
The cluster we create is single zone. The region and zone can be configured ont he terraform.tfvars file.

Prerequesites for installation:
-------------------------------
 - GCP Account with project api enabled for compute.googleapis.com,iam.googleapis.com,iamcredentials.googleapis.com
 - gcloud authorized to the relevant account (I.E. gcloud auth login)
 - Terraform installed on client machine


Terraform Providers
-------------------
 * google - to perform actions on gcp, authorized to the relevant account by the current gcloud connection.
 * kubernetes - used to create the relevant namespace for the web deployment. Authorized by the created kubernetes cluster data (takes token after cluster is created)
 * helm - used for helm deploying, authorized by the same way as the kubernetes

Terraform runs the following stages:
------------------------------------

A - Create VPC
--------------
The vpc is configured by tf/vpc.tf

We create a VPC network, and subnetwork that includes three /24 ranges:
    * Main (ip_cidr_range) - intended for the node ips
    * subnet-secondary-1 - intended for pod ips
    * subnet-secondary-2 - intended for service ips

B - Create Cluster, Nodepool and service account
------------------------------------------------
The cluster is configured on tf/gke_cluster.tf

    * Single zone cluster
    * Terrafrom deletes the default nodepool and creates a custom one ().
    * The subnets for the pod and service ips configured.
    * Customer service account is configured to the nodepool with editor permissions (I know it can have less permissions than editor,and of course it is not best practice to do that, but I did not want to waste too much time to figure out which is the specific ones I need to add to the role.)
    * The new nodepool is created with one e2-standard-2 node.
    
C - Apply nginx-ingress-controller
----------------------------------
Nginx ingress controller is applied using helm. The following configurations were added:
    * deletion_protection false -> in order to allow deleting it and creating it again.
    * rbac.create - create the relevant permissions required on the rbac cluster in order to collect the ingresses and expose them.
    * controller.service.type - Load balancer -> in order to verify that the nginx service account is created by load balanacer type with the relevant gcp loadbalaner.
    * controller.service.externalTrafficPolicy = Local  -> To provide the external ip address of the nginx controller service, and not the external ip of the node.
    * controller.publishService.enabled = true -> similar reason (maybe one of those two is deprecated, but anyway to make it work I added both of them)

D - Apply web test application
------------------------------
    * Creates "web" namespace terraform object
    * Runs the web chart located on helm/web

Web Chart:
----------
The web chart includes the following templates:
     * nginx-deployment.yaml - the nginx web server deployment, referenced to volume mount of the configmap includes the html page to load up.
     * nginx-html-config.yaml - The configmap includes the html page to load up.
     * nginx-service.yaml - The requests are done with ingress, so we can use ClusterIP service, that allows only internal cluster connections to the pod.
     * ingress.yaml - defines the ingress object. The nginx ingress controller looks for the ingress objects, attach to them the LoadBalancer external ip. When request is done to the ingress, the nginx ingress controller leads the request by the dns it is sent to. 



The ingress can be tested using:
--------------------------------
In order to test the ingresses without publishing the ips to a public domain we can do the following:
- NGINX_SVC_EXT_IP = $(kubectl get services --namespace default nginx-ingress-controller-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl $NGINX_SVC_EXT_IP -H "Host: test.test-veeva.com"

If we receive the html page, we are good :-)

