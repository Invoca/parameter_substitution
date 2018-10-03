@Library('github.com/invoca/jenkins-pipeline@v0.1.0')
import com.invoca.docker.*;

pipeline {
  agent { label 'docker' }

  stages {
    stage('Test') {
      agent { docker 'ruby:2.4.2' }
      steps {
        sh "bundle install"
        sh "bundle exec rake test"
      }
    post {
      always {
        publishHTML([
          allowMissing: false,
          alwaysLinkToLastBuild: false,
          keepAll: true,
          reportDir: 'coverage',
          reportFiles: 'index.html',
          reportName: 'Coverage Report',
          reportTitles: ''
        ])
      }
      }
    }
  }

  post { always { notifySlack(currentBuild.result) } }
}
