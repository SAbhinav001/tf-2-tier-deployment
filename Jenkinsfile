pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
        image = "my-todo-app-django"

    }

    stages {
        stage('checkou SCM') {
            steps {
               script{
                   checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/SAbhinav001/tf-2-tier-deployment.git']])
               }
            }
        }
        
        stage('build') {
            steps {
                echo 'build'
                sh 'docker build -t ${image} .'
            }
        }
        
        stage('push') {
            steps {
                echo 'push'
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                    sh 'docker login -u $USERNAME -p $PASSWORD'
                    sh 'docker tag ${image} $USERNAME/${image}'
                    sh 'docker push $USERNAME/${image}'
                }
            }
        }


        stage('Initializing Terraform') {
            steps {
                script{
                    dir('terraform/eks'){
                        sh 'terraform init'
                    }
                }
            }
        } 
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('terraform/eks'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('terraform/eks'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra'){
            steps{
                script{
                    dir('terraform/eks'){
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Create/Destroy an EKS Cluster'){
            steps{
                script{
                    dir('terraform/eks') {
                        sh 'terraform $action --auto-approve'
                    }
                }
            }
        }
        
        stage('Deploying Nginx Application') {
            steps{
                script{
                    dir('k8s') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl apply -f deploymentService.yaml'
                    }
                }
            }
        }
        
    }
    
}
