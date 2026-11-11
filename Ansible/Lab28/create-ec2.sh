#!/usr/bin/env bash
# ==============================================================================
# Lab 28: Automated Provisioning of AWS EC2 with Tag server:ivolve
# ==============================================================================
set -euo pipefail

REGION="${AWS_DEFAULT_REGION:-us-east-1}"
KEY_NAME="ivolve-key"
KEY_FILE="${HOME}/.ssh/${KEY_NAME}.pem"
SG_NAME="ivolve-ec2-sg"
INSTANCE_TYPE="t3.micro"
TAG_KEY="server"
TAG_VAL="ivolve"

echo "===================================================================="
echo " 1. Validating AWS Credentials and Region (${REGION})"
echo "===================================================================="
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    echo "[ERROR] AWS credentials not configured. Please run 'aws configure' first."
    exit 1
fi
echo "[SUCCESS] Authenticated to AWS as: $(aws sts get-caller-identity --query 'Arn' --output text)"

echo ""
echo "===================================================================="
echo " 2. Ensuring SSH Key Pair Exists (${KEY_NAME})"
echo "===================================================================="
if ! aws ec2 describe-key-pairs --key-names "${KEY_NAME}" --region "${REGION}" >/dev/null 2>&1; then
    echo "[INFO] Creating new key pair: ${KEY_NAME}..."
    aws ec2 create-key-pair \
        --key-name "${KEY_NAME}" \
        --region "${REGION}" \
        --query 'KeyMaterial' \
        --output text > "${KEY_FILE}"
    chmod 400 "${KEY_FILE}"
    echo "[SUCCESS] Key saved to: ${KEY_FILE}"
else
    echo "[INFO] Key pair '${KEY_NAME}' already exists in AWS."
fi

echo ""
echo "===================================================================="
echo " 3. Ensuring Security Group Exists (${SG_NAME})"
echo "===================================================================="
SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${SG_NAME}" --region "${REGION}" --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null || true)
if [[ "${SG_ID}" == "None" || -z "${SG_ID}" ]]; then
    VPC_ID=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --region "${REGION}" --query 'Vpcs[0].VpcId' --output text)
    echo "[INFO] Creating security group ${SG_NAME} in VPC ${VPC_ID}..."
    SG_ID=$(aws ec2 create-security-group \
        --group-name "${SG_NAME}" \
        --description "Security group for iVolve Ansible dynamic inventory lab" \
        --vpc-id "${VPC_ID}" \
        --region "${REGION}" \
        --query 'GroupId' --output text)

    aws ec2 authorize-security-group-ingress \
        --group-id "${SG_ID}" \
        --protocol tcp --port 22 --cidr 0.0.0.0/0 \
        --region "${REGION}"
    aws ec2 authorize-security-group-ingress \
        --group-id "${SG_ID}" \
        --protocol tcp --port 80 --cidr 0.0.0.0/0 \
        --region "${REGION}"
    echo "[SUCCESS] Security group created: ${SG_ID} (SSH:22 & HTTP:80 allowed)"
else
    echo "[INFO] Security group already exists: ${SG_ID}"
fi

echo ""
echo "===================================================================="
echo " 4. Locating Latest Amazon Linux 2023 AMI"
echo "===================================================================="
AMI_ID=$(aws ssm get-parameters \
    --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
    --region "${REGION}" \
    --query 'Parameters[0].Value' --output text)
echo "[INFO] Target AMI: ${AMI_ID}"

echo ""
echo "===================================================================="
echo " 5. Launching EC2 Instance with Tag '${TAG_KEY}:${TAG_VAL}'"
echo "===================================================================="
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "${AMI_ID}" \
    --instance-type "${INSTANCE_TYPE}" \
    --key-name "${KEY_NAME}" \
    --security-group-ids "${SG_ID}" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ivolve-ec2},{Key=${TAG_KEY},Value=${TAG_VAL}}]" \
    --region "${REGION}" \
    --query 'Instances[0].InstanceId' --output text)

echo "[INFO] Launched instance: ${INSTANCE_ID}. Waiting for 'running' state..."
aws ec2 wait instance-running --instance-ids "${INSTANCE_ID}" --region "${REGION}"

PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "${INSTANCE_ID}" \
    --region "${REGION}" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo ""
echo "===================================================================="
echo " [SUCCESS] EC2 Instance Provisioned Successfully!"
echo " Instance ID : ${INSTANCE_ID}"
echo " Public IP   : ${PUBLIC_IP}"
echo " Tag         : ${TAG_KEY}=${TAG_VAL}"
echo "===================================================================="
echo ""
echo "Now run dynamic inventory discovery:"
echo "  ansible-inventory -i aws_ec2.yaml --graph"
