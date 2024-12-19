1. Start the cluster

   minikube start

2. Add prometheus repo in helm

   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

3. Update helm repo

   helm repo update

4. Install prometheus controller as helm chart

   helm install prometheus prometheus-community/prometheus

5. To get pods and services

   kubectl get pods
   
   kubectl get svc

5. Expose prometheus to node port

   kubectl expose service prometheus-server –type=NodePort –target-port=9090 –name=prometheus-server-ext

6. Open the minikube service for the prometheus

   minikube service prometheus-server-ext

7. Add grafana repo in helm

   helm repo add grafana https://grafana.github.io/helm-charts

8. Install grafana as helm chart

   helm install grafana grafana/grafana

9. Expose grafana to node port
   
   kubectl expose service grafana –type=NodePort –target-port=3000 –name=grafana-ext

10. Open the minikube service for the grafana

    minikube service grafana-ext

11. Expose kube-state metrics to node port

    kubectl expose service prometheus-kube-state-metrics –type=NodePort –target-port=8080 –name= prometheus-kube-state-metrics-ext
