pipeline{
    agent any

    stages{
        stage("virtual-environment"){
            input{
                message "Add changes?"
                ok "Yes"
                parameters{
                    choice(
                        choices: ['fetch'],
                        name: 'REPO_NAME'
                        )
                    }

            }

            steps {
                sh './scripts/restart_services.sh ${REPO_NAME}'
            }

        }

    }
}
