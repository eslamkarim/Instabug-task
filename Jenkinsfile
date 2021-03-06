def TEST_STATUS = false
def BUILD_STATUS = false
def LINT_STATUS = false
def E2E_TEST_STATUS = false
pipeline {
   agent any
   stages {
       stage('pull app from SC'){
           steps{
               dir('todo') {
                   git url: 'https://github.com/dobromir-hristov/todo-app.git'
                   sh 'mv ../Dockerfile .'
                   sh 'docker build --no-cache -t todo-main .'
               }
           }
       }
        stage('app build stage and archive build-output') {
            steps{
                dir("${env.WORKSPACE}/todo"){
                    script{
                        BUILD_STATUS = sh (
                            script: "docker run --tty --name todo-build todo-main build",
                            returnStatus: true
                        ) == 0
                    }
                }
            }
            post { 
                always { 
                    sh 'docker logs todo-build > build-output_${BUILD_NUMBER}.log'
                    archiveArtifacts artifacts: 'build-output_${BUILD_NUMBER}.log'
                }
            }
        }
        stage('app lint stage') {
            when{
                expression { BUILD_STATUS }
            }
            steps{
                dir("${env.WORKSPACE}/todo"){
                    script{
                        LINT_STATUS = sh (
                            script: "docker run --rm --tty --name todo-lint todo-main lint",
                            returnStatus: true
                        ) == 0
                    }
                }
            }
        }
        stage('app unit testing stage') {
            when{
                expression { LINT_STATUS }
            }
            steps {
                dir("${env.WORKSPACE}/todo"){
                    script{
                        TEST_STATUS = sh (
                            script: "docker run --rm  --tty --name todo-test todo-main test:unit",
                            returnStatus: true
                        ) == 0
                    }
                }
            }
        }
        stage('app e2e testing stage') {
            when{
                expression { TEST_STATUS }
            }
            steps {
                dir("${env.WORKSPACE}/todo"){
                    ansiColor('xterm') {
                        script{
                        E2E_TEST_STATUS = sh (
                            script: "docker run --rm --tty --name todo-e2e-test todo-main test:e2e --headless",
                            returnStatus: true
                        ) == 0
                    }}
                }
            }
        }
        stage('app running stage') {
            when{
                expression { E2E_TEST_STATUS }
            }
            steps {
                dir("${env.WORKSPACE}/todo"){
                    script{
                        sh (
                            script: "docker run --tty -d --name todo-dev -p 8000:8080 todo-main"
                        )
                    }
                }
            }
            
        }
    }
}
