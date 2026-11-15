// Jenkins Job DSL: creates the deploy pipeline job for salary
folder('ot-microservices')
folder('ot-microservices/dev')

pipelineJob('ot-microservices/dev/deploy-salary-infra') {
    description('Deploys salary-infra (dev) with static Terraform in the central AWS account')

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
            scriptPath('Anurag/salary-pipeline/Jenkinsfile')
            lightweight(true)
        }
    }
}
