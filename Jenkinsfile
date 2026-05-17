pipeline {
    agent any

    environment {
        // Define your Docker Hub registry settings
        REGISTRY_USER = 'merontedros'
        IMAGE_NAME    = 'angular-service'
        IMAGE_TAG     = "${BUILD_NUMBER}" // Dynamically increments with each Jenkins build run
        DOCKER_REGISTRY_CREDENTIALS_ID = 'dockerhub-credentials'

    }

    stages {
        stage('Pull Code from GitHub') {
            steps {
                // Pulls the clean checkout branch code directly via SCM
                checkout scm
            }
        }

        stage('Build Docker Image') {
            tools {
                dockerTool 'default'
            }
            steps {
                script {
                    echo "Starting build process for image: ${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    
                    // Uses the native plugin engine instead of raw shell commands
                    dockerImage = docker.build("${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Image to Docker Hub') {
            tools {
                dockerTool 'default'
            }
            steps {
                script {
                    echo "Authenticating and pushing image to registry..."
                    
                    // Securely wraps authentication using your saved credentials ID
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_REGISTRY_CREDENTIALS_ID}") {
                        dockerImage.push()
                    }
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