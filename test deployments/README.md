# Test_deployment
kubectl describe CertificateRequest -n myweb-2
Order

kubectl describe Order -n myweb-2

Challenge

kubectl describe Challenge -n myweb-2

watch -t kubectl get certificate -n myweb-2

myapp-2-tls

watch -t kubectl get certificate -n myweb-2

kubectl get secret myapp-2-tls -n myweb-2
kubectl describe secret myapp-2-tls -n myweb-2
app2-nginx-argo.yaml


helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f custom-values.yaml --namespace monitoring --create-namespace

kubeseal --controller-name sealed-secrets -o yaml \
-n kube-system <1-example/repo-secret.yaml > 6-example/sealed-repo-secret.yaml
