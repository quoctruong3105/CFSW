pipeline {
    agent {
        label 'Build Node'
    }
    stage {
        stage('Checkout') {
            steps {
                
            }
        }
        stage('Code analysis') {

        }
        stage('Docker build and tag') {

        }
        stage('Docker push') {

        }
        stage('Deploy to test enviroment') {

        }
        stage('Auto test') {
            
        }
        stage('Deploy to production environment') {

        }
    }
}
