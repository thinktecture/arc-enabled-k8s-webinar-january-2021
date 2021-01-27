#!/bin/bash

echo "Targeting Tenant " $ARC_TENANT_ID

echo "Verify Service Principal Permissions:"
az role assignment list --assignee $ARC_CLIENT_ID --all -o table --query "[].roleDefinitionName"
echo ""

echo "Hit return if SP has role Log Analytics Contributor"
read ShouldContinue


echo "Please provide the resource ID of your Arc enabled Kubernetes cluster:"
read ARC_RESOURCE_ID

echo "Please provide the resource ID of your Log Analytics Workspace:"
read LAW_RESOURCE_ID

kubectl config get-contexts

echo "Please provide the name of the desired kubernetes context: "
read KUBE_CTX
kubectl config use-context $KUBE_CTX

echo "Will login with Service Princial now (HIT RETURN to continue)"
read ShouldContinue
az login --service-principal -u $ARC_CLIENT_ID -p $ARC_CLIENT_SECRET --tenant $ARC_TENANT_ID
echo ""

./msft-enable-monitoring.sh --resource-id $ARC_RESOURCE_ID --client-id $ARC_CLIENT_ID --client-secret $ARC_CLIENT_SECRET  --tenant-id $ARC_TENANT_ID --kube-context $KUBE_CTX  --workspace-id $LAW_RESOURCE_ID
