pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        DEV_IMAGE = 'deepesh79/dev:latest'
        PROD_IMAGE = 'deepesh79/prod:latest'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push DEV Image') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh 'docker build -t $DEV_IMAGE .'
                        sh 'docker push $DEV_IMAGE'
                    }
                }
            }
        }

        stage('Build & Push PROD Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh 'docker build -t $PROD_IMAGE .'
                        sh 'docker push $PROD_IMAGE'
                    }
                }
            }
        }
    }
}

