# Recovery Procedures (Runbooks)

Applies to: SADAD Payment Service (`resilient-sadad-network`)
Owners: Platform + Payments SRE
RTO target: ≤ 15 minutes (Tier-1 APIs)
RPO target: ≤ 1 minute for ledger/settlement

---

## 1) Destructive Malware Containment (Shamoon-like)

Prereqs: SIEM detects anomaly, or hash/IOC received; Prometheus alerts abnormal restarts/latency; Evidence ticket opened.

1. Declare Incident (SEV-1) and assemble responders (SRE, SecOps, App lead). Start incident doc.
2. Quarantine blast radius:
   - Isolate namespace: apply `deny-egress` NetworkPolicy except to observability and KMS.
   - Cordon and drain suspicious nodes.
   - Scale suspect workloads to zero if needed.
3. Credential rotation:
   - Invalidate CI tokens, rotate KMS data keys and DB passwords.
   - Revoke affected service accounts; re-issue with new secrets.
4. Forensics and rehydration:
   - Snapshot volumes for evidence; do not mount in prod cluster.
   - Rebuild nodes from golden images; re-deploy workloads from signed images (verify attestations/SBOM).
5. Data validation and restore:
   - Verify database integrity (checksums). If corrupted, perform PITR from latest snapshot; reprocess pending transactions from outbox / message queue.
6. Verification gates:
   - Synthetic checks pass; Prometheus SLOs stable for 30 minutes.
   - Business validation on sample transactions.
7. Communications:
   - Internal: status channel q15m. External per regulator playbook (SAMA) if thresholds crossed.
8. Post-incident:
   - Root cause analysis, corrective actions, update detection rules and chaos drills.

---

## 2) Regional DR Failover (Warm Standby)

1. Criteria: Region A instability > 10m impacting SLO, or regulator-directed.
2. Actions:
   - Freeze deploys in Region A, snapshot DB.
   - Promote replica in Region B to primary; update DNS / global load balancer to Region B.
   - Scale Region B to full capacity; run smoke tests.
3. Data:
   - Ensure replication catch-up completed; reconcile outbox/ledger differences.
4. Rollback:
   - When Region A healthy, failback with controlled switchover and dual-write reconciliation window.

---

## 3) Key Rotation (KMS and App Secrets)

1. Schedule rotation window, notify dependent teams.
2. Generate new data keys; re-encrypt secrets and configs.
3. Roll workloads with new secrets; validate decrypts.
4. Revoke old keys after grace period; audit logs for usage.

---

## 4) Runbook Checks and Drills

- Monthly: malware containment tabletop + partial tech drill (namespace isolation and node rebuild on staging).
- Quarterly: DR failover rehearsal; capture RTO/RPO achieved.
- After any incident: update this runbook and chaos scenarios.
