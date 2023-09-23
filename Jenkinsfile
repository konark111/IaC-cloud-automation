pipeline {
    agent any

    stages {
        stage('scm checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/konark111/IaC-cloud-automation.git']])
            }
        }
    stage('Terraform Apply') {
    steps {
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-credentials', // Use the ID you configured in Jenkins
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
        ]]) {
            sh 'terraform init'
            sh 'terraform plan'
            sh 'terraform apply -auto-approve'
        }
    }
}
        stage('ansible automation') {
            steps {
            ansiblePlaybook credentialsId: 'private_key', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/terra/inventory', playbook: '/var/lib/jenkins/workspace/terra/playbook.yml'            
                
            }
        }
        
    }
}

