pipeline {
    agent any
    
    stages {
        stage('Build and Deploy') {
            steps {
                sh "docker build -t image ."
                sh './build.sh'
            }
        }
    }
    
    post {
        always {
            script {
                sh 'docker-compose down -v'
                sh 'rm -rf ./master/data/*'
                sh 'rm -rf ./slave/data/*'
                sh 'docker network prune -f'
            }
        }
    }
}
