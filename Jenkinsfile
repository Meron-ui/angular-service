pipeline {
    agent any

    environment {
        REGISTRY_USER = 'merontedros'
        IMAGE_NAME    = 'angular-service'
        IMAGE_TAG     = "${BUILD_NUMBER}"
        DOCKER_REGISTRY_CREDENTIALS_ID = 'dockerhub-credentials'
    }

    // Force the tool path globally across all shell stages. This ensures that the correct Docker binary is used regardless of the agent's default PATH settings.
    tools {
        dockerTool 'default'
    }

    stages {
        stage('Pull Code from GitHub') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Starting build process for image: ${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                // Direct shell execution utilizes the tool binary perfectly
                sh "docker build -t ${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo "Authenticating and pushing image to registry..."
                // Securely grab your username and password from the credentials vault
                withCredentials([usernamePassword(credentialsId: "${DOCKER_REGISTRY_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    // Standard Docker login and push via shell
                    sh "docker login -u \$DOCKER_USER -p \$DOCKER_PASS"
                    sh "docker push ${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline complete. Cleaning up workspace build artifacts..."
            cleanWs()
        }
        success {
            echo "🎉 Successfully built and pushed ${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG} to Docker Hub!"
        }
        failure {
            echo "❌ Build failed. Check the stage logs above for details."
        }
    }
}