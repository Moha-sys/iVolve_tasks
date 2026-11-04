#!/usr/bin/env groovy

/**
 * Shared Library Step: DeployOnK8s
 * Updates deployment manifest with the newly built image tag and rolls out to Kubernetes.
 */
def call(Map config = [:]) {
    def imageName     = config.get('imageName', 'mohadevv/demoapp')
    def imageTag      = config.get('imageTag', "${env.BUILD_NUMBER}")
    def manifestPath  = config.get('manifestPath', 'k8s/deployment.yaml')
    def servicePath   = config.get('servicePath', 'k8s/service.yaml')
    def namespace     = config.get('namespace', 'ivolve')
    def deploymentName = config.get('deploymentName', 'demoapp-deployment')
    def timeoutSec    = config.get('timeout', '300s')

    echo "=========================================================="
    echo " [Shared Library] Deploy Application to Kubernetes        "
    echo " Target: ${deploymentName} in namespace ${namespace}      "
    echo "=========================================================="

    stage("Update Deployment File") {
        echo "Updating container image tag in ${manifestPath}..."
        sh """
        sed -i 's|image: .*|image: ${imageName}:${imageTag}|g' ${manifestPath}
        grep -n "image:" ${manifestPath}
        """
    }

    stage("Deploy to Kubernetes Cluster") {
        echo "Applying Kubernetes manifests..."
        sh """
        kubectl apply -f ${manifestPath}
        if [ -f "${servicePath}" ]; then
            kubectl apply -f ${servicePath}
        fi
        kubectl rollout status deployment/${deploymentName} -n ${namespace} --timeout=${timeoutSec}
        kubectl get deployment,pods,svc -l app=demoapp -n ${namespace} -o wide
        """
    }
}
