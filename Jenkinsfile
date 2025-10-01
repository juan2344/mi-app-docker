pipeline {
  agent any
  environment {
    IMAGE_NAME = "juanpa234/mi-app-docker"   // <-- nombre de repo en DockerHub
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:latest .'
      }
    }
    stage('Login to DockerHub') {
      steps {
        // debe existir credencial con ID 'dockerhub-cred'
        withCredentials([usernamePassword(credentialsId: 'dockerhub-cred',
                                         usernameVariable: 'DOCKER_USER',
                                         passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        }
      }
    }
    stage('Push to DockerHub') {
      steps {
        sh 'docker push $IMAGE_NAME:latest'
      }
    }
    stage('Deploy (host local)') {
      steps {
        // Este bloque ejecuta el contenedor en el host Docker.
        // Reemplaza puerto si quieres otro (8090 es ejemplo).
        sh '''
          docker rm -f mi-app || true
          docker run -d --name mi-app -p 8090:80 $IMAGE_NAME:latest
        '''
      }
    }
  }
  post {
    always {
      sh 'docker system prune -f || true'
    }
    success {
      echo "Pipeline completado con éxito"
    }
    failure {
      echo "Pipeline falló"
    }
  }
}
