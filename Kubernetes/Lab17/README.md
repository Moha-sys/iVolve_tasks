# Lab 17: Control Pod-to-Pod Traffic via NetworkPolicy

Comprehensive guide, policy definitions, commands, and security verification for **Lab 17 (Control Pod-to-Pod Traffic via NetworkPolicy)** in Kubernetes.

---

## Lab Objectives

1. **NetworkPolicy Definition**:
   - Define a NetworkPolicy named `ivolvenp` (and `allow-app-to-mysql`) in namespace `ivolve`.
2. **Pod Selector**:
   - Target MySQL pods (`app: mysql` / `app: ivolvedb`).
3. **Policy Types**:
   - Set exclusively to `Ingress`.
   - *Security Note:* Do not specify `Egress`, so MySQL egress traffic (DNS, Calico, cluster networking) remains unimpeded while all non-whitelisted ingress traffic is blocked by default.
4. **Ingress Rule**:
   - Restrict incoming traffic strictly to application pods (`app: ivolveApp` / `app: myapp`).
   - Restrict port strictly to TCP `3306` (MySQL default port).
5. **Verification**:
   - Confirm application pods can query MySQL successfully.
   - Verify that test pods without application labels are blocked from connecting to MySQL port 3306.

---

## Architecture Diagram

```
+-----------------------------------------------------------------------------+
|                               NAMESPACE: ivolve                             |
|                                                                             |
|      +------------------------+                                             |
|      |  Pod: ivolveapp        |                                             |
|      |  (Label: app=ivolveApp)|                                             |
|      +-----------+------------+                                             |
|                  |                                                          |
|                  | ALLOWED (Port 3306 TCP)                                  |
|                  v                                                          |
|      +---------------------------------------------------------------+      |
|      |                  NetworkPolicy: ivolvenp                      |      |
|      |                  Targets: app=mysql / app=ivolvedb            |      |
|      +-------------------------------+-------------------------------+      |
|                                      |                                      |
|                                      v                                      |
|                        +---------------------------+                        |
|                        |   Pod: ivolvedb-0         |                        |
|                        |   (MySQL listening: 3306) |                        |
|                        +---------------------------+                        |
|                                      ^                                      |
|                                      |                                      |
|                                      x BLOCKED (Connection Timed Out)       |
|                                      |                                      |
|                        +-------------+-------------+                        |
|                        |  Test Pod (app!=ivolveApp)|                        |
|                        +---------------------------+                        |
+-----------------------------------------------------------------------------+
```

---

## 1. Step 1: NetworkPolicy Manifest (`network-policy.yaml`)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ivolvenp
  namespace: ivolve
spec:
  podSelector:
    matchExpressions:
      - key: app
        operator: In
        values: ["mysql", "ivolvedb"]
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchExpressions:
              - key: app
                operator: In
                values: ["ivolveApp", "myapp"]
      ports:
        - protocol: TCP
          port: 3306
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-app-to-mysql
  namespace: ivolve
spec:
  podSelector:
    matchExpressions:
      - key: app
        operator: In
        values: ["mysql", "ivolvedb"]
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchExpressions:
              - key: app
                operator: In
                values: ["ivolveApp", "myapp"]
      ports:
        - protocol: TCP
          port: 3306
```

---

## 2. Step 2: Verification Commands

1. **Apply & Describe NetworkPolicy**:
   ```bash
   kubectl apply -f network-policy.yaml
   kubectl describe networkpolicy ivolvenp -n ivolve
   ```

2. **Verify Allowed Ingress (From Application Pods)**:
   ```bash
   kubectl exec -it deployment/ivolveapp -n ivolve -c ivolveapp -- nc -zv -w 3 mysql-service 3306
   ```

3. **Verify Blocked Ingress (From Non-Whitelisted Pod)**:
   ```bash
   kubectl run test-blocked --image=busybox:1.28 --rm -it --restart=Never -n ivolve \
     --overrides='{"spec":{"tolerations":[{"key":"workload","operator":"Exists","effect":"NoSchedule"}]}}' \
     -- nc -zv -w 3 mysql-service 3306
   ```
   *Expected Result:* Connection times out, confirming traffic is filtered by the NetworkPolicy.

