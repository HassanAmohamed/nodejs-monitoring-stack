# Node.js Application Monitoring Stack on Kubernetes

![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?logo=grafana&logoColor=white)

A complete solution for deploying and monitoring Node.js applications in Kubernetes with built-in observability through Prometheus metrics and Grafana dashboards.

## 🚀 Quick Deployment

### Prerequisites
- Kubernetes cluster (v1.19+)
- `kubectl` configured with cluster access
- PersistentVolume provisioner

```bash
# 1. Deploy the monitoring stack
kubectl apply -f nodejs-monitor.yaml

# 2. Deploy the sample application
kubectl apply -f nodejs-app.yaml

# 3. Access the services (local port-forward)
kubectl port-forward svc/grafana-service 3000:3000 &  # Grafana
kubectl port-forward svc/prometheus-service 9090:9090 &  # Prometheus
kubectl port-forward svc/nodejs-service 8080:8080 &  # Node.js App

📊 Monitoring Architecture
![image](https://github.com/user-attachments/assets/92571181-ed16-4d1c-8114-788f8f36153e)

graph LR
    A[Node.js App] -->|/metrics| B(Prometheus)
    B -->|Scrape| A
    B -->|Alert Rules| C(AlertManager)
    B -->|Dashboard Data| D(Grafana)
    C -->|Notifications| E[Email/Slack]

🛠️ Configuration
Custom Metrics (in index.js)

// Example HTTP request counter
const httpRequests = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'endpoint', 'status']
});

// Example response time histogram
const httpDuration = new promClient.Histogram({
  name: 'http_response_time_seconds',
  help: 'Duration of HTTP requests',
  buckets: [0.1, 0.5, 1, 2.5, 5]
});

Kubernetes Manifests
nodejs-app.yaml: Deployment and Service for Node.js application

nodejs-monitor.yaml: Prometheus + Grafana stack

nodejs-rule.yaml: Alerting rules

nodejs-svc.yaml: Service monitors

🔍 Access Endpoints
Service	Cluster URL	Local Access
Grafana	http://grafana-service:3000	localhost:3000 (admin/prom-operator)
Prometheus	http://prometheus-service:9090	localhost:9090
Node.js App	http://nodejs-service:8080	localhost:8080
🛡️ Alert Management
Edit nodejs-rule.yaml to customize alerts:

- alert: HighErrorRate
  expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
  for: 10m
  labels:
    severity: critical
  annotations:
    summary: "High error rate on {{ $labels.instance }}"

🧹 Cleanup
kubectl delete -f nodejs-app.yaml -f nodejs-monitor.yaml

📚 Documentation
Prometheus Querying

Grafana Dashboard Docs

Kubernetes Monitoring


