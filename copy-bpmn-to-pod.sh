#!/bin/bash
# Get pod names using kubectl
kubectl_pod_1=$(kubectl get pods --selector=app.kubernetes.io/name=zeebe-gateway --output=jsonpath='{range .items[0]}{.metadata.name}{"\n"}{end}' -n zeebe)
kubectl_pod_2=$(kubectl get pods --selector=app.kubernetes.io/name=zeebe-gateway --output=jsonpath='{range .items[1]}{.metadata.name}{"\n"}{end}' -n zeebe)
# Copy file to pod 1
kubectl cp /home/dev/united_frc_criteria.bpmn zeebe/"$kubectl_pod_1:/usr/local/zeebe"
# Copy file to pod 2
kubectl cp /home/dev/united_frc_criteria.bpmn zeebe/"$kubectl_pod_2:/usr/local/zeebe"
# Deploy bpmn on pod 1
kubectl exec -n zeebe -it "$kubectl_pod_1" -c zeebe-gateway -- /usr/local/zeebe/bin/zbctl --insecure deploy /usr/local/zeebe/united_frc_criteria.bpmn
# Deploy bpmn on pod 2
kubectl exec -n zeebe -it "$kubectl_pod_2" -c zeebe-gateway -- /usr/local/zeebe/bin/zbctl --insecure deploy /usr/local/zeebe/united_frc_criteria.bpmn

