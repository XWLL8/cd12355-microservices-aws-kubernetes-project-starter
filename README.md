
# 🧠 Coworking Analytics Microservice on EKS

This project deploys a Flask-based analytics microservice to an AWS EKS cluster. It connects to a PostgreSQL database and emits periodic metrics to CloudWatch.

## 🚀 Deployment Steps

1. **Build & Push Image to ECR**
   ```bash
   docker build -t coworking-analytics -f analytics/Dockerfile .
   docker tag coworking-analytics:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/coworking-analytics:latest
   docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/coworking-analytics:latest
   ```

2. **Create ConfigMap & Secret**
   ```bash
   kubectl create configmap coworking-config \
     --from-literal=DB_HOST=postgresql-service \
     --from-literal=DB_PORT=5432 \
     --from-literal=DB_NAME=mydatabase \
     --from-literal=DB_USERNAME=myuser

   kubectl create secret generic coworking-secret \
     --from-literal=DB_PASSWORD=<your-password>
   ```

3. **Apply Kubernetes Manifests**
   ```bash
   kubectl apply -f deployment/
   ```

4. **Install Fluent Bit for CloudWatch Logs**
   ```bash
   helm repo add eks https://aws.github.io/eks-charts
   helm repo update
   helm upgrade --install aws-for-fluent-bit eks/aws-for-fluent-bit \
     --namespace amazon-cloudwatch \
     --create-namespace \
     --set cloudWatch.region=us-east-1 \
     --set cloudWatch.logGroupName=/aws/containerinsights/coworking-space/application \
     --set cloudWatch.logStreamPrefix=application \
     --set serviceAccount.create=true \
     --set serviceAccount.name=aws-for-fluent-bit
   ```

## 📊 Log Verification

- Go to CloudWatch → `/aws/containerinsights/coworking-space/application`
- Look for log stream: `coworking-<pod-name>_default_coworking-<container>.log`
- Confirm periodic database output like:
  ```
  INFO in app: {'2023-02-12': 176, '2023-02-13': 196, ...}
  ```

