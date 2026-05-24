echo "=========monitoring script============="
# Test 1: Cluster Connectivity
echo "Test 1: Cluster Connectivity"
echo "AWS Cluster nodes:"
kubectl --context kind-aws-cluster get nodes
echo ""
echo "GCP Cluster nodes:"
kubectl --context kind-gcp-cluster get nodes
echo ""
# Test 2: Service Discovery
echo "Test 2: Service Discovery"
echo "AWS Cluster services:"
kubectl --context kind-aws-cluster get services -n multicloud
echo ""
echo "GCP Cluster services:"
kubectl --context kind-gcp-cluster get services -n multicloud
echo ""
# Test 3: Cross-cluster communication test
echo "Test 3: Cross-cluster Communication"
AWS_POD=$(kubectl --context kind-aws-cluster get pods -n multicloud -l app=web-app -o jsonpath='{.items[0].metadata.name}')
GCP_POD=$(kubectl --context kind-gcp-cluster get pods -n multicloud -l app=database -o jsonpath='{.items[0].metadata.name}')
echo "Testing from AWS pod to GCP service..."
kubectl --context kind-aws-cluster exec -n multicloud $AWS_POD -- wget -qO- --timeout=5 http://gcp-database-direct/ || echo "Cross-cluster communication test failed"
echo "Testing from GCP pod to AWS service..."
kubectl --context kind-gcp-cluster exec -n multicloud $GCP_POD -- wget -qO- --timeout=5 http://aws-app-direct/ || echo "Cross-cluster communication test failed"
# Test 4: Load Balancer Status
echo ""
echo "Test 4: Load Balancer Status"
echo "AWS LoadBalancer services:"
kubectl --context kind-aws-cluster get services -n multicloud -o wide | grep LoadBalancer
echo ""
echo "GCP LoadBalancer services:"
kubectl --context kind-gcp-cluster get services -n multicloud -o wide | grep LoadBalancer
echo ""
echo "=== Test Suite Complete ==="
