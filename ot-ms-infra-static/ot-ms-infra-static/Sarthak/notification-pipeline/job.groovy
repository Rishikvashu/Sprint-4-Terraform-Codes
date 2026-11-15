// Jenkins Job DSL: creates the deploy pipeline job for notification
folder('ot-microservices')
folder('ot-microservices/dev')

pipelineJob('ot-microservices/dev/deploy-notification-infra') {
    description('Deploys notification-infra (dev) with static Terraform in the central AWS account')

    logRotator {
        numToKeep(20)
    }

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/<YOUR_ORG>/ot-microservices-infra.git')
                        credentials('github-credentials')
                    }
                    branch('*/main')
                }
            }
            scriptPath('Sarthak/notification-pipeline/Jenkinsfile')
            lightweight(true)
        }
    }
}
