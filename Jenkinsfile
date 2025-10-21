pipeline {
    agent any

    environment {
        // имя сервера SonarQube, как указано в Manage Jenkins → System
        SONARQUBE_ENV = credentials('jenkins-token')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building project...'
                // пример: docker build или просто echo
                sh 'echo "Build complete"'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                // имя сервера SonarQube (как в Jenkins → System)
                SONARQUBE_SERVER = 'SonarQube'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        sonar-scanner \
                          -Dsonar.projectKey=my-devops-hello \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://sonarqube:9000 \
                          -Dsonar.login=$SONARQUBE_ENV
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy stage...'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
