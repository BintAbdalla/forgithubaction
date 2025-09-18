pipeline {
    agent any

    tools {
        nodejs "node"  
    }

    environment {
        DOCKER_HUB_USER = "bintabdallah"   // 🔹 ton nom Docker Hub
        IMAGE_NAME = "bintabdallah/forgithubaction"                // 🔹 le nom de ton image
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                     url: 'https://github.com/BintAbdalla/forgithubaction.git',
                     credentialsId: 'github-credentials'
            }
        }

        stage('Install dependencies') {
            steps {
            //gkhgh
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                echo '⚠️ Aucun test défini, stage ignoré'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    def image = docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}:${env.BUILD_NUMBER}")

                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
                        image.push()
                        image.push("latest")
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo '🚀 Déploiement en cours...'

                    // 🔹 Exemple de déploiement local
                    sh """
                    docker stop ${IMAGE_NAME} || true
                    docker rm ${IMAGE_NAME} || true
                    docker run -d -p 80:80 --name ${IMAGE_NAME} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
                    """

                    echo "✅ Déploiement terminé avec succès"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo '✅ Pipeline réussi !'
        }
        failure {
            echo '❌ Pipeline échoué !'
        }
    }
}
