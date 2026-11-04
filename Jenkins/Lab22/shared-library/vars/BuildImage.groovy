#!/usr/bin/env groovy

/**
 * Shared Library Step: BuildImage
 * Builds Docker image, scans with Trivy, pushes to DockerHub, and cleans up locally.
 */
def call(Map config = [:]) {
    def imageName     = config.get('imageName', 'mohadevv/demoapp')
    def imageTag      = config.get('imageTag', "${env.BUILD_NUMBER}")
    def credentialsId = config.get('credentialsId', 'docker')
    def severity      = config.get('severity', 'HIGH,CRITICAL')

    echo "=========================================================="
    echo " [Shared Library] Build, Scan, Push & Cleanup Docker Image"
    echo " Image: ${imageName}:${imageTag}                          "
    echo "=========================================================="

    stage("Build Docker Image") {
        echo "Building container image..."
        sh "docker build -t ${imageName}:${imageTag} -t ${imageName}:latest ."
    }

    stage("Scan Docker Image") {
        echo "Scanning Docker image with Trivy for ${severity} vulnerabilities..."
        sh """
        trivy image --severity ${severity} --scanners vuln ${imageName}:${imageTag} || true
        """
    }

    stage("Push Image to DockerHub") {
        echo "Authenticating and pushing image to Docker Hub..."
        withCredentials([usernamePassword(
            credentialsId: credentialsId,
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
        )]) {
            sh """
            echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
            docker push ${imageName}:${imageTag}
            docker push ${imageName}:latest
            """
        }
    }

    stage("Delete Image Locally") {
        echo "Deleting local container image from runner storage..."
        sh """
        docker rmi ${imageName}:${imageTag} ${imageName}:latest || true
        """
    }
}
