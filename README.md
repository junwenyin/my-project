##### build the project

    ./gradlew build

##### build Docker image called java-app. Execute from root

    docker build -t java-app .
    
##### push image to repo 

    docker tag java-app demo-app:java-1.0
    
##### trigger cicd
curl -L -o opa https://openpolicyagent.org/downloads/v0.69.0/opa_linux_amd64_static
chmod 755 ./opa
sudo mv ./opa /usr/local/bin/


terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
opa eval --data  tests/terraform.rego --input  terraform/tfplan.json "data.terraform.policy.resource_change_limits.resource_change_summary" -f raw


opa eval --data  tests/terraform.rego --input  terraform/tfplan.json "data.terraform.policy.resource_change_limits.authz" -f raw
opa exec --decision "terraform/policy/resource_change_limits/authz" -b tests/ terraform/tfplan.json