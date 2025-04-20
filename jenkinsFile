pipeline
{
    agent none
	stages
	{
	    
		stage('Task 1 - Code Checkout')
		{
		    agent any
			steps
			{
				git 'https://github.com/Mujah16/ci_cd_pipeline.git'
			}
		}
		
		stage('Task 2 - Code Compile')
		{
		    agent any
			steps
			{
				sh 'mvn compile'
			}
		}

		stage('Task 2 - Code Test')
		{
		    agent any
			steps
			{
				sh 'mvn test'
			}
		}

		stage('Task 2 - Code Build')
		{
			agent any
			steps
			{
				sh 'mvn clean package'
				sh 'cp /var/lib/jenkins/workspace/$JOB_NAME/target/XYZtechnologies-1.0.war xyz_tech.war'
				stash name: 'build-artifacts', includes: 'xyz_tech.war,Dockerfile'
			}
		}

		// Task [Task 3 - Build Docker Image + Task 3 - Deploy on a container] has been enhanced in [Task 4  - Ansible Docker Build, Push and Deploy]

		// stage('Task 3 - Build Docker Image')
		// {
		// 	agent {
        //         label 'docker'  // Targets the slave with label 'docker'
        //     }
		// 	steps
		// 	{
		// 		unstash 'build-artifacts'  // Retrieve the WAR file from stash				
		// 		sh 'docker build -t xyz_tech:$BUILD_NUMBER .'
		// 		sh 'docker tag xyz_tech:$BUILD_NUMBER mujah92/xyz_tech:$BUILD_NUMBER'
				
		// 	}
		// }

		// stage('Task 3 - Deploy on a container')
		// {
		//     agent {
        //         label 'docker'  // Targets the slave with label 'docker'
        //     }
		// 	steps
		// 	{
		// 		sh 'docker run -itd -P xyz_tech:$BUILD_NUMBER'
		// 	}
		// }
		
		stage('Task 4 - Ansible Docker Build, Push and Deploy') {
			agent any
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker_hub_credentials',
                        usernameVariable: 'REGISTRY_USER',
                        passwordVariable: 'REGISTRY_PASS'
                    )
                ]) {
                    ansiblePlaybook(
                        playbook: "${WORKSPACE}/ansible/docker-deploy.yml",
                        inventory: "${WORKSPACE}/ansible/inventory.ini",
                        extras: """
                            -e 'registry_username=${REGISTRY_USER}'
                            -e 'registry_password=${REGISTRY_PASS}'
                            -e 'workspace=${WORKSPACE}'
                            -e 'build_number=${BUILD_NUMBER}'
                            -e 'push_to_registry=true' 
                            -e 'ansible_python_interpreter=/usr/bin/python3'
                        """.stripIndent(),
                        colorized: true
                    )
                }
            }
        }

		stage('Task 4 - Ansible K8s Deploy') {
			agent any
			steps {
				ansiblePlaybook(
					playbook: "${WORKSPACE}/ansible/k8s-deploy.yml",
					inventory: "${WORKSPACE}/ansible/inventory.ini",
					extras: """
						-e 'workspace=${WORKSPACE}'
						-e 'build_number=${BUILD_NUMBER}'
					"""
				)
			}
		}

   }
}
