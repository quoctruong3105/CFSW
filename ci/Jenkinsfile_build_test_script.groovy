pipeline {
    agent {
        label 'Test Node'
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
    }
}
