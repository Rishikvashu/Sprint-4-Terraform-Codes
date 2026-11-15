# OT-Microservices - Dev Infra (100% static Terraform + Jenkins DSL)

Beginner friendly: **no variables, no tfvars, no modules, no loops** - every value is written directly in `main.tf`.
Each ticket folder has just `provider.tf` (region + remote state) and `main.tf`. Pipeline tickets have `Jenkinsfile` + `job.groovy`.

## Who has what
- **Anshul** -> `network-ssh-key`, `notification-instance`, `attendance-target-group`, `salary-listener-rule`, `redis-security-group`
- **Anurag** -> `network-route53`, `notification-security-group`, `attendance-auto-scaling-group`, `salary-pipeline`, `scylladb-ec2`
- **Maqbool** -> `network-pipeline`, `frontend-instance`, `notification-target-group`, `attendance-listener-rule`, `employee-security-group`, `scylladb-security-group`
- **Palak** -> `network-vpc`, `frontend-security-group`, `notification-auto-scaling-group`, `attendance-auto-scaling-policies`, `attendance-pipeline`, `employee-launch-template`, `scylladb-pipeline`
- **Priyanshu** -> `network-subnets`, `frontend-launch-template`, `notification-auto-scaling-policies`, `salary-instance`, `employee-target-group`, `redis-pipeline`
- **Rani** -> `network-nat-gateway`, `frontend-target-group`, `notification-listener-rule`, `salary-security-group`, `employee-auto-scaling-group`, `postgres-security-group`
- **Sarthak** -> `network-igw`, `frontend-auto-scaling-group`, `notification-pipeline`, `salary-launch-template`, `employee-auto-scaling-policies`, `postgres-pipeline`
- **Shivam** -> `network-route-tables`, `frontend-auto-scaling-policies`, `attendance-instance`, `salary-target-group`, `employee-listener-rule`
- **Vashishtha** -> `network-nacl`, `frontend-listener-rule`, `notification-launch-template`, `attendance-security-group`, `salary-auto-scaling-group`, `employee-pipeline`, `postgres-ec2`
- **Vineet** -> `network-load-balancer`, `frontend-pipeline`, `attendance-launch-template`, `salary-auto-scaling-policies`, `employee-instance`, `redis-ec2`

> `Arjun->X` tickets are reassigned: folder is under the new owner **X**.

## Ticket -> folder
| Group | Ticket | Owner | Path |
|---|---|---|---|
| Network | vpc | Palak | `Palak/network-vpc/` |
| Network | subnets | Priyanshu | `Priyanshu/network-subnets/` |
| Network | nat-gateway | Rani | `Rani/network-nat-gateway/` |
| Network | igw | Sarthak | `Sarthak/network-igw/` |
| Network | route-tables | Shivam | `Shivam/network-route-tables/` |
| Network | nacl | Vashishtha | `Vashishtha/network-nacl/` |
| Network | load-balancer | Vineet | `Vineet/network-load-balancer/` |
| Network | ssh-key | Anshul | `Anshul/network-ssh-key/` |
| Network | route53 | Anurag | `Anurag/network-route53/` |
| Network | pipeline | Maqbool | `Maqbool/network-pipeline/` |
| Frontend | instance | Maqbool | `Maqbool/frontend-instance/` |
| Frontend | security-group | Palak | `Palak/frontend-security-group/` |
| Frontend | launch-template | Priyanshu | `Priyanshu/frontend-launch-template/` |
| Frontend | target-group | Rani | `Rani/frontend-target-group/` |
| Frontend | auto-scaling-group | Sarthak | `Sarthak/frontend-auto-scaling-group/` |
| Frontend | auto-scaling-policies | Shivam | `Shivam/frontend-auto-scaling-policies/` |
| Frontend | listener-rule | Vashishtha | `Vashishtha/frontend-listener-rule/` |
| Frontend | pipeline | Vineet | `Vineet/frontend-pipeline/` |
| Notification | instance | Anshul | `Anshul/notification-instance/` |
| Notification | security-group | Anurag | `Anurag/notification-security-group/` |
| Notification | launch-template | Vashishtha | `Vashishtha/notification-launch-template/` |
| Notification | target-group | Maqbool | `Maqbool/notification-target-group/` |
| Notification | auto-scaling-group | Palak | `Palak/notification-auto-scaling-group/` |
| Notification | auto-scaling-policies | Priyanshu | `Priyanshu/notification-auto-scaling-policies/` |
| Notification | listener-rule | Rani | `Rani/notification-listener-rule/` |
| Notification | pipeline | Sarthak | `Sarthak/notification-pipeline/` |
| Attendance | instance | Shivam | `Shivam/attendance-instance/` |
| Attendance | security-group | Vashishtha | `Vashishtha/attendance-security-group/` |
| Attendance | launch-template | Vineet | `Vineet/attendance-launch-template/` |
| Attendance | target-group | Anshul | `Anshul/attendance-target-group/` |
| Attendance | auto-scaling-group | Anurag | `Anurag/attendance-auto-scaling-group/` |
| Attendance | auto-scaling-policies | Palak | `Palak/attendance-auto-scaling-policies/` |
| Attendance | listener-rule | Maqbool | `Maqbool/attendance-listener-rule/` |
| Attendance | pipeline | Palak | `Palak/attendance-pipeline/` |
| Salary | instance | Priyanshu | `Priyanshu/salary-instance/` |
| Salary | security-group | Rani | `Rani/salary-security-group/` |
| Salary | launch-template | Sarthak | `Sarthak/salary-launch-template/` |
| Salary | target-group | Shivam | `Shivam/salary-target-group/` |
| Salary | auto-scaling-group | Vashishtha | `Vashishtha/salary-auto-scaling-group/` |
| Salary | auto-scaling-policies | Vineet | `Vineet/salary-auto-scaling-policies/` |
| Salary | listener-rule | Anshul | `Anshul/salary-listener-rule/` |
| Salary | pipeline | Anurag | `Anurag/salary-pipeline/` |
| Employee | instance | Vineet | `Vineet/employee-instance/` |
| Employee | security-group | Maqbool | `Maqbool/employee-security-group/` |
| Employee | launch-template | Palak | `Palak/employee-launch-template/` |
| Employee | target-group | Priyanshu | `Priyanshu/employee-target-group/` |
| Employee | auto-scaling-group | Rani | `Rani/employee-auto-scaling-group/` |
| Employee | auto-scaling-policies | Sarthak | `Sarthak/employee-auto-scaling-policies/` |
| Employee | listener-rule | Shivam | `Shivam/employee-listener-rule/` |
| Employee | pipeline | Vashishtha | `Vashishtha/employee-pipeline/` |
| Redis | ec2 | Vineet | `Vineet/redis-ec2/` |
| Redis | security-group | Anshul | `Anshul/redis-security-group/` |
| Redis | pipeline | Priyanshu | `Priyanshu/redis-pipeline/` |
| Syclla DB | ec2 | Anurag | `Anurag/scylladb-ec2/` |
| Syclla DB | security-group | Maqbool | `Maqbool/scylladb-security-group/` |
| Syclla DB | pipeline | Palak | `Palak/scylladb-pipeline/` |
| Postgres | ec2 | Vashishtha | `Vashishtha/postgres-ec2/` |
| Postgres | security-group | Rani | `Rani/postgres-security-group/` |
| Postgres | pipeline | Sarthak | `Sarthak/postgres-pipeline/` |

## How to run one stack (beginner steps)
```
cd Palak/network-vpc
terraform init
terraform plan
terraform apply
```

## Deploy order (stacks find each other by Name tag, so ORDER MATTERS)
1. Network: vpc -> igw -> subnets -> nat-gateway -> route-tables -> nacl -> ssh-key -> load-balancer -> route53
2. Apps (each): security-group -> instance -> launch-template -> target-group -> auto-scaling-group -> auto-scaling-policies -> listener-rule
3. Data stores: security-group -> ec2 (after the app security groups exist)

## Static values used (search & replace if your diagram differs)
- Region `ap-south-1`, names `ot-ms-dev-<resource>`, VPC `10.0.0.0/16`, subnets 10.0.1/2 (public), 10.0.11/12 (app), 10.0.21/22 (db)
- Tags on every resource: Application, Owner, Environment=dev, CostCenter=`CC-OT-DEV-1001` (placeholder)
- State bucket `ot-ms-dev-tfstate` + lock table `ot-ms-dev-tflock` must exist first
- `Anshul/network-ssh-key/main.tf`: replace the placeholder public key
- DB dev password is `password` (matches the app configs) - dev only
- `job.groovy`: replace `https://github.com/<YOUR_ORG>/ot-microservices-infra.git`
- Jenkins credentials: `aws-central-account`, `github-credentials`
- Demo only in the CENTRAL account, not a personal one
