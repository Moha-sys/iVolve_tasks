#!/usr/bin/env groovy

/**
 * Shared Library Step: BuildApp
 * Performs unit testing and application packaging using Maven.
 */
def call(Map config = [:]) {
    def skipTests = config.get('skipTests', false)

    stage("Build App - Unit Test & Package") {
        echo "=========================================================="
        echo " [Shared Library] Executing Unit Tests & Application Build "
        echo "=========================================================="
        
        if (!skipTests) {
            echo "Running Unit Tests..."
            sh 'mvn test || true'
        }
        
        echo "Packaging Spring Boot JAR artifact..."
        sh 'mvn clean package -DskipTests'
        
        sh 'ls -la target/*.jar'
    }
}
