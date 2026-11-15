// Jenkins Job DSL: creates the deploy pipeline job for employee
folder('ot-microservices')
folder('ot-microservices/dev')

pipelineJob('ot-microservices/dev/deploy-employee-infra') {
    description('Deploys employee-infra (dev) with static Terraform in the central AWS account')

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
            scriptPath('Vashishtha/employee-pipeline/Jenkinsfile')
            lightweight(true)
        }
    }
}
