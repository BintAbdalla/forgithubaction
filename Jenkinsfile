pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'bintabdallah/forgithubaction:latest'
        DOCKER_REGISTRY = 'docker.io'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/BintAbdalla/forgithubaction.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Project') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build & Push') {
            steps {
                // Connecte-toi à Docker Hub (mettre les credentials dans Jenkins Credentials)
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker build -t $DOCKER_IMAGE ."
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }
    }

    post {
        success {
            echo 'Build et déploiement Docker réussis ✅'
        }
        failure {
            echo 'Le pipeline a échoué ❌'
        }
    }
}
