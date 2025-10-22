pipeline {
    agent any

    environment {
        SONAR_PROJECT_KEY = 'my-devops-hello'
        SONAR_HOST_URL = 'http://sonarqube:9000'
    }

    stages {
        stage('Checkout') {
            steps {
                sh '''
                rm -rf * .git
                git clone https://github.com/vladtheloka/my-devops-hello.git .
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Building project...'
                sh 'echo "Build stage placeholder"'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh '''
                        echo "Running SonarQube scan inside container..."
                        docker run --rm \
                          -e SONAR_HOST_URL=$SONAR_HOST_URL \
                          -e SONAR_LOGIN=$SONAR_AUTH_TOKEN \
                          -v $PWD:/usr/src \
                          sonarsource/sonar-scanner-cli:latest \
                          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                          -Dsonar.sources=/usr/src
                        '''
                    }
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
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
