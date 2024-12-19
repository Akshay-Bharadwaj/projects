- Configured the AWS infra using terraform
- Installed dependencies like kubectl, minikube and helm charts in the instance
- Added prometheus in helm, installed prometheus controller as helm chart
- Verified the prometheus pods and services
- The services are exposed to the cluster IPs. They are made exposed to the NodePort to access by users having access to each other node inside the cluster
- Added grafana in helm, installed grafana as helm chart
- Verified the grafana pods and services
- Exposed the services to the NodePort IPs
- Got the grafana password and minikube IP
- Using, minikubeIP:<grafanaExposedPort>
  grafana dashboard is accessed
- Added prometheus as data source in grafana i.e minikubeIP:<prometheusExposedPort>
  to get the node metrics from prometheus
- Created dashboard using the default dashboard template (3662) created by grafana
- Exposed kube-state metrics to NodePort IP. Prometheus shares the same data in json format
- To directly get the data from Prometheus server,
  go to Prometheus server config map -> add the kubestate metrics endpoint in the scrape_configs of the config map
