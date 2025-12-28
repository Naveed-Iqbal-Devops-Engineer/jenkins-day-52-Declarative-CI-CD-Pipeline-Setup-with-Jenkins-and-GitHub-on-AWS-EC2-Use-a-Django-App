pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Naveed-Iqbal-Devops-Engineer/jenkins-day-52-Declarative-CI-CD-Pipeline-Setup-with-Jenkins-and-GitHub-on-AWS-EC2-Use-a-Django-App.git/'
            }
        }

        stage('Setup Virtual Environment') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    . venv/bin/activate
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Migrations') {
            steps {
                sh '''
                    . venv/bin/activate
                    python manage.py makemigrations
                    python manage.py migrate
                '''
            }
        }

        stage('Run Django App') {
            steps {
                sh '''
                    . venv/bin/activate
                     python manage.py runserver 0.0.0.0:8000
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful. Django app running on port 8000 (using runserver).'
        }
        failure {
            echo '❌ Deployment failed. Check logs.'
        }
    }
}
