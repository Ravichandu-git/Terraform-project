pipeline {
    agent any

    environment {
        AWS_REGION         = 'ap-south-1'
        REPO_URL            = 'https://github.com/Ravichandu-git/Terraform-project.git'
    }

    stages {

        stage('Git Clone') {
            steps {
                git(
                    url: "${REPO_URL}",
                    branch: 'main',
                    credentialsId: 'git-creds'
                )
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
                sh '''
                    terraform init
                '''
            }
        }

        stage('Terraform Format') {
    steps {
        sh '''
            terraform fmt -recursive
        '''
    }
}

        stage('Terraform Validate') {
            steps {
                sh '''
                    terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan -out=tfplan
                '''
            }
        }

        stage('Manual Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        message: 'Approve Terraform Apply?',
                        ok: 'Deploy',
                        submitter: 'ravi'
                    )
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform apply -auto-approve tfplan
                '''
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

        always {
            echo 'Terraform pipeline execution completed.'
        }
    }
}
