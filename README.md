##### build the project

    ./gradlew build

##### build Docker image called java-app. Execute from root

    docker build -t java-app .
    
##### push image to repo 

    docker tag java-app demo-app:java-1.0
    
##### trigger cicd

opa eval --data  tests/terraform.rego --input  terraform/tfplan.json "data.terraform.analysis.total_changes"