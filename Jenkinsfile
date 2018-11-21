#!/usr/bin/groovy
@Library('jenkins-pipeline@v0.3.0')
import com.invoca.docker.*;

pipeline {
  agent { label 'docker' }
  stages {
    stage('Validations') {
      environment {
        GITHUB_TOKEN = credentials('github_token')
      }

      parallel {
        stage('Unit Tests') {
          agent { docker 'ruby:2.4.2' }
          steps {
            script {
              try {
                sh "bundle install"
                sh "TZ=America/Los_Angeles bundle exec rspec"
                updateGitHubStatus('jenkins-ci/unit-tests', 'success', 'Unit tests run against code.')
              } catch(err) {
                updateGitHubStatus('jenkins-ci/unit-tests', 'failure', 'Unit tests run against code.')
                throw(err)
              }
            }
          }
          post {
            always {
              junit 'spec/reports/rspec.xml'
              publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: 'coverage',
                reportFiles: 'index.html',
                reportName: 'Rcov Report',
                reportTitles: ''
              ])
            }
          }
        }

        stage('Version Bump Check') {
          agent { docker 'ruby:2.4.2' }
          steps {
            dir ('/tmp/parameter_substitution/master_repo') {
              git url: 'https://github.com/Invoca/parameter_substitution.git',
                  credentialsId: 'github_invocaops-ci'
            }
            script {
              try {
                sh "bundle install"
                sh "bin/verify_version_bump /tmp/parameter_substitution/master_repo"
                updateGitHubStatus('jenkins-ci/version-bumped', 'success', 'Verify version has been bumped.')
              } catch(err) {
                updateGitHubStatus('jenkins-ci/version-bumped', 'failure', 'Verify version has been bumped.')
                throw(err)
              }
            }
          }
        }
      }
    }
  }

  post { always { notifySlack(currentBuild.result) } }
}

void updateGitHubStatus(String context, String status, String description) {
  gitHubStatus([
    repoSlug:    'Invoca/parameter_substitution',
    sha:         env.GIT_COMMIT,
    description: description,
    context:     context,
    targetURL:   env.BUILD_URL,
    token:       env.GITHUB_TOKEN,
    status:      status
  ])
}
