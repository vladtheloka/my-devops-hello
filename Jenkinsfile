pipeline {
    agent any

    environment {
        SONAR_PROJECT_KEY = 'my-devops-hello'
        SONAR_HOST_URL = 'http://sonarqube:9000'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                sh '''
                # Если репозиторий уже есть, делаем pull, иначе клонируем
                if [ -d ".git" ]; then
                    echo "Git repository exists, pulling latest changes..."
                    git pull origin main
                else
                    echo "Git repository not found, cloning..."
                    git clone https://github.com/vladtheloka/my-devops-hello.git .
                fi

                # Проверяем, что находимся в git репозитории
                git rev-parse --is-inside-work-tree
                ls -la
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
