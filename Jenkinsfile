pipeline{
    agent any

    stages{
        stage("virtual-environment"){
            input{
                message "Virtual Environment"
                ok "Yes"
                parameters{
                    choice(
                        choices: ['ONE', 'TWO'],
                        name: 'PARAMETER_01'
                        )
                    }
            }

            steps {
                echo "${PARAMETER_01}"
            }

        }

    }
}
