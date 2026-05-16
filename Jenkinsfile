pipeline {
    agent any
    
    environment {
        // 1. Define your Docker Hub registry credentials ID configured in Jenkins
        DOCKER_REGISTRY_CREDENTIALS_ID = 'dockerhub-credentials' 
        
        // 2. Define your Docker Hub username and repository name
        REGISTRY_USER = 'merontedros' // <-- Replace with your Docker Hub username
        IMAGE_NAME    = 'angular-service'
        IMAGE_TAG     = "${BUILD_NUMBER}"      // <-- Uses the unique Jenkins build number (e.g., 1, 2, 3)
    }
    
    stages {
        stage('Pull Code from GitHub') {
            steps {
                // This step pulls the specific branch that triggered the build
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Starting build process for image: ${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
                    
                    // Builds the image using the local Dockerfile and tags it uniquely
                    dockerImage = docker.build("${REGISTRY_USER}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        
        stage('Push Image to Docker Hub') {
            steps {
                script {
                    echo "Logging into Docker Hub and pushing image..."
                    
                    // Securely authenticates against DockerHub using credentials stored inside Jenkins
                    docker.withRegistry('', DOCKER_REGISTRY_CREDENTIALS_ID) {
                        
                        // Push the uniquely numbered version (great for Kubernetes rollbacks)
                        dockerImage.push()
                        
                        // Also update the 'latest' tag so your cluster can always fetch the newest version
                        dockerImage.push('latest') 
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline complete. Cleaning up workspace build artifacts..."
            cleanWs() // Wipes the temporary build files from the Jenkins agent to save disk space
        }
    }
}