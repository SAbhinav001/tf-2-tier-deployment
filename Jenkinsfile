pipeline {
    agent {
        label 'prod'
    }
    
    environment {
        image= "my-todo-app-django:${env.BUILD_NUMBER}"
    }

    stages {
        stage('code') {
            steps {
                echo 'code'
                git branch: 'develop', credentialsId: 'github', url: 'https://github.com/SAbhinav001/todo-app-django.git'
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
        // stage('run') {
        //     steps {
        //         echo 'run'
        //         sh 'docker-compose up -d'
        //     }
        // }
         stage('deploy to k8s') {
            steps {
                withKubeConfig([credentialsId: 'textfile', serverUrl: 'https://172.31.1.216:6443']) {
                        sh 'kubectl apply -f deploymentService.yml'
                 }
            }
        }
    }
}
