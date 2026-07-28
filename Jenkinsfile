pipeline {

    agent any

    environment {
        AWS_REGION         = 'ap-south-1'
        REPO_URL           = 'https://github.com/Ravichandu-git/Terraform-project.git'
    }

    stages {

        stage('Checkout') {
            steps {
                script {

                    def githubSecret = sh(
                        script: '''
                        aws secretsmanager get-secret-value \
                          --secret-id jenkins/github/token \
                          --query SecretString \
                          --output text
                        ''',
                        returnStdout: true
                    ).trim()

                    def githubToken = new groovy.json.JsonSlurper()
                        .parseText(githubSecret)["github-user"]

                    sh '''
                    rm -rf terraform-project
                    '''

                    sh """
                    git clone https://${githubToken}@github.com/Ravichandu-git/Terraform-project.git terraform-project
                    """
                }
            }
        }

        stage('Read AWS Credentials') {
            steps {
                script {

                    def awsSecret = sh(
                        script: '''
                        aws secretsmanager get-secret-value \
                          --secret-id jenkins/aws/credentials \
                          --query SecretString \
                          --output text
                        ''',
                        returnStdout: true
                    ).trim()

                    def creds = new groovy.json.JsonSlurper().parseText(awsSecret)

                    env.AWS_ACCESS_KEY_ID = creds.access_key
                    env.AWS_SECRET_ACCESS_KEY = creds.secret_key
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform-project') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform-project') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform-project') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Deploy Infrastructure?'

                dir('terraform-project') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'Infrastructure created successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
