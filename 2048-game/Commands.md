1. Create K8s cluster using eksctl and fargate profile

eksctl create cluster --name <clustername> --region <regionname> --fargate

2. Update kubeconfig

aws eks update-kubeconfig --name <clustername> --region <regionname>

3. Create fargate profile

eksctl create fargateprofile --cluster <clustername> --region <regionname> --name <profilename> --namespace <namespace>

4. Create deployment, service, ingress

kubectl apply -f <yaml-manifest-path>

5. Configure OIDC connector

export cluster_name=demo-cluster

oidc_id=$(aws eks describe-cluster --name <clustername> --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

eksctl utils associate-iam-oidc-provider --cluster <clustername> --approve

6. Create IAM policy

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
              --cluster=<clustername> \
              --namespace=kube-system \
              --name=aws-load-balancer-controller \
              --role-name AmazonEKSLoadBalancerControllerRole \
              --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
              --approve

7. Deploy ALB controller

helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \            
  -n kube-system \
  --set clusterName=<clustername> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<regionname> \
  --set vpcId=<your-vpc-id>

kubectl get deployment -n kube-system aws-load-balancer-controller
















    
