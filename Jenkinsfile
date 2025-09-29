pipeline {
  agent any
  environment {
    IMAGE_NAME = "juanpa234/mi-app-docker"    // <- cambia por tu usuario/repo
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/juan2344/mi-app-docker.git'
      }
    }

    stage('Build Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:latest .'
      }
    }

    stage('Login to DockerHub & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-cred',
                                          usernameVariable: 'DOCKER_USER',
                                          passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh 'docker push $IMAGE_NAME:latest'
        }
      }
    }

    stage('Deploy (run container)') {
      steps {
        sh '''
          docker rm -f mi_app || true
          docker run -d --name mi_app -p 8090:80 $IMAGE_NAME:latest
        '''
      }
    }
  }
  post {
    always {
      sh 'docker system prune -af || true'
    }
  }
}
