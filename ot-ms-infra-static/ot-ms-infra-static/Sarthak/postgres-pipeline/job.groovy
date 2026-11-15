// Jenkins Job DSL: creates the deploy pipeline job for postgres
folder('ot-microservices')
folder('ot-microservices/dev')

pipelineJob('ot-microservices/dev/deploy-postgres-infra') {
    description('Deploys postgres-infra (dev) with static Terraform in the central AWS account')

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
            scriptPath('Sarthak/postgres-pipeline/Jenkinsfile')
            lightweight(true)
        }
    }
}
