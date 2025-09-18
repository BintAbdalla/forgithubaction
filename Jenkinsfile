pipeline {
    agent any

    tools {
        nodejs "node"
    }

    environment {
        DOCKER_HUB_USER = "bintabdallah"
        IMAGE_NAME = "forgithubaction"
        DEPLOY_PORT = "8080"   // Port par défaut
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

                    sh """
                    # Arrêter et supprimer le container existant
                    if [ \$(docker ps -aq -f name=${IMAGE_NAME}) ]; then
                        docker stop ${IMAGE_NAME} || true
                        docker rm ${IMAGE_NAME} || true
                    fi

                    # Détection d'un port libre
                    if lsof -i:${DEPLOY_PORT} ; then
                        echo "Port ${DEPLOY_PORT} occupé, utilisation de 8081"
                        DEPLOY_PORT=8081
                    fi

                    # Lancer le container
                    docker run -d -p ${DEPLOY_PORT}:80 --name ${IMAGE_NAME} ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest

                    # Afficher les logs récents pour vérification
                    docker logs ${IMAGE_NAME} --tail 20
                    """

                    echo "✅ Déploiement terminé sur le port ${DEPLOY_PORT}"
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
