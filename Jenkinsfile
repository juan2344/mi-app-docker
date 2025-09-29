pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'registry.hub.docker.com'
        DOCKER_IMAGE = 'juanpa234/mi-app-docker'
        DOCKER_CREDS = credentials('docker-hub-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    def testImage = docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}")
                    testImage.inside {
                        sh '''
                            echo "Running container tests..."
                            ps aux | grep nginx
                        '''
                    }
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-hub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").push()
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").push('latest')
                    }
                }
            }
        }

        stage('Deploy to Test') {
            steps {
                script {
                    sh """
                    docker stop test-app || true
                    docker rm test-app || true
                    docker run -d -p 8081:80 --name test-app ${DOCKER_IMAGE}:${env.BUILD_ID}
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline ${currentBuild.result?:'SUCCESS'}"
        }
        success {
            echo ' ¡Despliegue exitoso!'
        }
        failure {
            echo ' Despliegue fallido'
        }
    }
}
