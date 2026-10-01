# Failure Mode Matrix

**Status:** N2/N3 REFERENCE

| Failure mode | First signals | Immediate checks | Typical mitigation | Evidence |
|---|---|---|---|---|
| API latency/unavailable | kubectl timeout, alert | API readyz, control-plane health, etcd | reduce load/escalate control-plane issue | readyz, events, metrics |
| Node NotReady | node alert | conditions, kubelet, pressure, network | isolate/drain if safe, recover node | node yaml, kubelet logs |
| DNS failure | service lookup failures | CoreDNS pods/logs, Service/Endpoints | recover DNS pods/network path | DNS test, logs |
| Ingress failure | Routes/Ingress errors | controller pods, LB/DNS, endpoints | restore controller/LB path | controller status/events |
| Storage attach/mount | Pending pods, mount errors | PVC/PV/CSI events | fix CSI/storage path, reschedule carefully | PVC/PV/events |
| ImagePullBackOff | pod blocked | image ref, registry auth/network | restore auth/connectivity or image | pod describe/events |
| Policy rejection | admission denied | Kyverno/Gatekeeper policy | correct workload or approved exception | admission message/policy |
| Capacity saturation | pressure/eviction | requests, allocatable, top nodes | scale/redistribute/reduce pressure | capacity report/events |
| Upgrade stalled | operators/nodes not converged | version/operator/MCP state | stop promotion, use supported recovery path | before/after status |

## Rule

This matrix supports triage. It does not replace distribution/vendor support procedures for control-plane recovery.
