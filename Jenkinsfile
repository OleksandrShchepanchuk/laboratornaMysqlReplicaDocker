pipeline {
    agent any
    
    stages {
        stage('Build and Deploy') {
            steps {
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
            }
        }
    }

    post {
        success {
            cleanUp()
        }
        failure {
            cleanUp()
        }
    }
}

def cleanUp() {
    stage('Cleanup') {
        steps {
            // Clean up any remaining resources or perform additional cleanup steps here
            // For example:
            sh 'docker network prune -f'
        }
    }
}
