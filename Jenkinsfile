pipeline {
    agent {
        kubernetes {
            label 'kaniko'
        }
    }

    environment {
        GitBranch       = "production"
        GitRepo         = "https://git.greenapex.in/mineramax/frontend/mineramax-fe.git"
        GitCreds        = "cicd"

        DockerRegistry  = "docker.io"
        DockerImage     = "greenapex/devops"
        DockerTag       = "mineramax-fe-prod"
        Dockerfile      = "$WORKSPACE/Dockerfile-Prod"

        Cluster         = "GP-ManagedEKS"
        Namespace       = "prod-mineramax"
        Deployment      = "mineramax-frontend"
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo "Starting the build process..."
                git branch: "${GitBranch}", credentialsId: "${GitCreds}", url: "${GitRepo}"
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                container('kaniko') {
                    sh """
                        /kaniko/executor \
                          --dockerfile=${Dockerfile} \
                          --context=dir://${WORKSPACE} \
                          --destination=${DockerRegistry}/${DockerImage}:${DockerTag}-${BUILD_ID} \
                          --destination=${DockerRegistry}/${DockerImage}:${DockerTag}-latest
                    """
                }
            }
        }

        stage('Kubernetes Deployment Rollout') {
            agent { label "master" }
            steps {
                sh "kubectl --kubeconfig=/var/jenkins_home/.kube/${Cluster} rollout restart deployment ${Deployment} -n ${Namespace}"
                sh "kubectl --kubeconfig=/var/jenkins_home/.kube/${Cluster} rollout status deployment ${Deployment} -n ${Namespace}"
            }
        }
    }

    post {
        always {
            emailext(
                from: 'devops@green-apex.com',
                to: 'devops@green-apex.com',
                subject: '${PROJECT_NAME} - Build #${BUILD_NUMBER} - ${BUILD_STATUS}!',
                body: '''BUILD FINISHED - ${PROJECT_NAME} - Build #${BUILD_NUMBER} - ${BUILD_STATUS}
Check console output at ${BUILD_URL} to view the results.'''
            )
        }
    }
}
