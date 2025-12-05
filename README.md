# Resilient SADAD Payment Network

A production-ready resilient payment processing service implementing the **EMAM Framework** for Saudi Arabia's critical infrastructure. Features chaos engineering, multi-AZ deployment, comprehensive monitoring, and disaster recovery procedures.



This project fulfills the **Design Resilient National System** assignment with complete implementation of:

- ✅ **Chaos Testing Scenarios** (Pod kill, Network partition, AZ outage, DDoS, Shamoon simulation)
- ✅ **Recovery Procedures** (Malware containment, DR failover, Key rotation)
- ✅ **Chaos Monkey** for application-level fault injection
- ✅ **Kubernetes** manifests with HPA, PDB, and multi-AZ resilience
- ✅ **Terraform** infrastructure as code for AWS EKS
- ✅ **Prometheus** monitoring with SLO-based alerting

## Architecture

Multi-AZ deployment on AWS:
- **VPC**: 3 Availability Zones with public/private subnets
- **EKS Cluster**: Managed Kubernetes with Auto Scaling
- **Application**: Spring Boot with Chaos Monkey, Prometheus metrics
- **Resilience**: Pod anti-affinity, topology spread, HPA, PDB

## Quick Start

### Prerequisites
- Java 17+
- Maven 3.9+
- Docker (optional)

### Run Locally
```bash
# Build and run
mvn spring-boot:run

# Healthcheck
curl -s http://localhost:8080/api/v1/healthz
```

### Run with Chaos Monkey
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=chaos
```

## Testing

### 1. Unit Tests

| Test Phase | Status | Details |
|------------|--------|---------||
| **Maven Build** | ✅ SUCCESS | Compiled 3 source files |
| **Resources** | ✅ SUCCESS | Copied 2 resources |
| **Unit Tests** | ✅ SUCCESS | All tests passed |
| **Build Time** | ⚡ 1.045s | Fast build cycle |

```bash
mvn clean test
```

### 2. Chaos Test Scenarios

| Scenario | File | Severity | Status | Description |
|----------|------|----------|--------|-------------|
| **AZ Outage** | `az-outage-simulation.yml` | 🔴 Critical | ✅ Ready | Complete Availability Zone failure |
| **DDoS (Eid)** | `ddos-eid-scenario.yml` | 🟠 High | ✅ Ready | High-traffic Eid period scenario |
| **Network Partition** | `network-partition-scenario.yml` | 🟠 High | ✅ Ready | Network split between zones |
| **Pod Kill** | `pod-kill-scenario.yml` | 🟡 Medium | ✅ Ready | Pod failure with health verification |
| **Shamoon Malware** | `shamoon-simulation.yml` | 🔴 Critical | ✅ Ready | Disk-wipe simulation + recovery |

```bash
bash chaos-tests/run-all-tests.sh
```

**Total**: 5 scenarios (2 Critical, 2 High, 1 Medium)

### 3. Infrastructure Validation
```bash
cd terraform
terraform init
terraform validate
terraform plan
```

### 4. Kubernetes Deployment (requires EKS cluster)
```bash
kubectl apply -f kubernetes/
kubectl get pods -w
```


## Security & Compliance

- **Data Residency**: Default region set to `me-central-1` (Bahrain)
- **Islamic Principles**: Amanah (stewardship), Adl (fairness), No harm
- **SAMA Compliance**: RTO ≤ 15 min, RPO ≤ 1 min
- **Threat Modeling**: STRIDE analysis with Saudi context (Shamoon, state actors)

## Monitoring

Prometheus metrics and alerts included:
- **Availability SLO**: 99.9% uptime
- **Latency SLO**: p95 < 500ms
- **Error Rate**: < 0.1%
- **Saturation**: CPU/Memory thresholds

## Recovery Procedures

1. Destructive Malware Containment (Shamoon-like)
2. Regional DR Failover (Warm Standby)
3. Key Rotation (KMS and App Secrets)
4. Runbook Drills Schedule



##  Vision 2030 Alignment

- Enable fintech ecosystem with high uptime
- Support cashless society goals
- Data sovereignty and transparency
- Ethical AI and automation

## Deployment

### Deploy to AWS
```bash
# 1. Provision infrastructure
cd terraform
terraform init
terraform apply

# 2. Configure kubectl
aws eks update-kubeconfig --region me-central-1 --name sadad-resilient-cluster

# 3. Deploy application
kubectl apply -f kubernetes/

# 4. Verify deployment
kubectl get pods -l app=resilient-sadad-network
kubectl get hpa
```




