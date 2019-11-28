def gitCommit
def gitBranch
def shortGitCommit
def shortBranch
def previousGitCommit
def imageName = "eportal"
def frontProjectName = "eportal"
def frontProjectPath = "ui"
def apiProjectPath = "api"
def mockApiContexPath = "mock-luxoft"
def mockApiLuxoftProjectPath = "mock-api-luxoft"
def imageVersion = "java8-node12-nginx16-mvn362"
def namespace
def commitMessage
def logSend
def credID = "1226203a-998c-4c9a-ba7a-881b70f75b4b"

pipeline {
    agent {
    kubernetes {
      label 'autobuild-eportal'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: java-node-nginx
    podRetention: Always
    image: taxaz-docker.luxoft.com/tools/apps:${imageVersion}
    command: ["cat"]
    tty: true
    volumeMounts:
#    - name: mynpmrc
#      mountPath: "/root"
#      readOnly: false
    - name: npm
      mountPath: "/root/.npm"
      readOnly: false
  - name: docker
    image: docker:stable-dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: dind-storage
      mountPath: /var/lib/docker
  - name: helm-cli
    image: "alpine/helm"
    command: ["cat"]
    tty: true
  imagePullSecrets:
  - name: regcred
  volumes:
  - name: dind-storage
    emptyDir: {}
  - name: npm
    emptyDir: {}
  - name: mynpmrc
    secret:
      secretName: npmrc
"""
        }
    }
    stages {
        stage('Git checkout') {
            steps {
                script {
                def myRepo = checkout scm
                gitCommit = myRepo.GIT_COMMIT
                gitBranch = myRepo.GIT_BRANCH
                shortGitCommit = "${gitCommit[0..10]}"
				commitMessage = sh(script: "git log -1 --pretty=short", returnStdout: true).trim()
                localBranch = sh(script: "git symbolic-ref --short HEAD", returnStdout: true).trim()
                shortBranch = sh(script: "echo ${localBranch} | sed 's/\\//-/'", returnStdout: true).trim()
				shortBranch = shortBranch.toLowerCase()
                namespace = localBranch.replaceFirst("/(.*)", "")
                sh "echo namespace: ${namespace}"
                sh "echo shortBranch: ${shortBranch}"
                previousGitCommit = sh(script: "git rev-parse ${gitCommit}~", returnStdout: true)
                }
            }
        }
		stage ('NPM install') {
			parallel {
				stage('Install Dependencies UI') {
					steps {
						container('java-node-nginx') {
							sh "cd ${frontProjectPath} && npm install"
						}
					}
				}
				stage('Install Dependencies MOCK API LUXOFT') {
					steps {
						container('java-node-nginx') {
							sh "cd ${mockApiLuxoftProjectPath} && npm install"
						}
					}
				}
			}
		}
		stage('SonarQube UI') {
			steps {
				container('java-node-nginx') {
//					sh "cd ${frontProjectPath} && npm run test -- --ci --coverage"
					sh "cd ${frontProjectPath} && npm run sonar-scanner -- -Dsonar.host.url=${sonarUrl} -Dsonar.login=${sonarLogin} -Dsonar.projectKey=${frontProjectPath}-${shortBranch} -Dsonar.projectVersion=${gitCommit}"
				}
			}
		}
		stage('Build UI') {
			steps {
				container('java-node-nginx') {
					sh "cd ${frontProjectPath} && npm run build"
				}
			}
		}
		stage('Create Docker images') {
			steps {
				container('docker') {
					withCredentials([[$class: 'UsernamePasswordMultiBinding',
					credentialsId: "${credID}",
					usernameVariable: 'DOCKER_HUB_USER',
					passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
					sh """
					#!/bin/bash -x
					docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD} ${DOCKER_REGISTRY}
					docker build -t ${DOCKER_REGISTRY}/${imageName}:${shortGitCommit} --build-arg BASE_IMAGE=${DOCKER_REGISTRY}/tools/apps:${imageVersion} .
					docker tag ${DOCKER_REGISTRY}/${imageName}:${shortGitCommit} ${DOCKER_REGISTRY}/${imageName}:${shortBranch}
					docker push ${DOCKER_REGISTRY}/${imageName}
					"""
					}
				}
			}	
		}
		stage('Helm') {
		    when {
                expression {
                    namespace == 'feature' || namespace == 'develop' || namespace == 'luxoft' || namespace == 'hotfix' || namespace == 'bugfix' || namespace == 'release' 
                }
            }
            steps {
                container('helm-cli') {
					withCredentials([[$class: 'UsernamePasswordMultiBinding',
					credentialsId: "${credID}",
					usernameVariable: 'HELM_USER',
					passwordVariable: 'HELM_PASSWORD']]) {
					sh 'helm init --client-only'
					sh 'helm repo add chartmuseum ${CHART_REPOSITORY}'
					sh "helm upgrade --install --force --recreate-pods --set web.host='${shortBranch}.${CLUSTER_URL}' --set serviceImage.tag='${shortBranch}' '${shortBranch}-${frontProjectPath}' chartmuseum/'${frontProjectPath}' --namespace='${namespace}' --wait"
                    sh "helm upgrade --install --force --recreate-pods --set web.host='${shortBranch}.${CLUSTER_URL}' --set serviceImage.tag='${shortBranch}' --set serviceInfo.name='${mockApiLuxoftProjectPath}' --set serviceImage.workingDir='/opt/${mockApiLuxoftProjectPath}' --set 'url.path=/mock-luxoft' '${shortBranch}-${mockApiLuxoftProjectPath}' chartmuseum/'${apiProjectPath}' --namespace='${namespace}' --wait"
					}
                }
			}
		}
	}
	post {
        always {
			script {
				if (currentBuild.result == "FAILURE") {
					logSend = true
				} else {
					logSend = false 
				}
			emailext attachLog: "${logSend}", body:
			"""<style type="text/css">
				.tg  {border-collapse:collapse;border-spacing:0;}
				.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
				.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
				.tg .tg-7u53{font-weight:bold;font-family:"Lucida Console", Monaco, monospace !important;;background-color:#efefef;text-align:center;vertical-align:top}
				.tg .tg-m2jw{font-family:"Lucida Console", Monaco, monospace !important;;text-align:center;vertical-align:top}
			</style>
			<table class="tg">
			<tr>
				<th class="tg-7u53">STATUS</th>
				<th class="tg-m2jw">${currentBuild.result?:'SUCCESS'}</th>
			</tr>
			<tr>
				<th class="tg-7u53">COMMITMESSAGE</th>
				<th class="tg-m2jw">${commitMessage}}</th>
			</tr>
			<tr>
				<td class="tg-7u53">GIT BRANCH</td>
				<td class="tg-m2jw">${gitBranch}</td>
			</tr>
			<tr>
				<td class="tg-7u53">SHORT COMMIT</td>
				<td class="tg-m2jw">${shortGitCommit}</td>
			</tr>
			<tr>
				<td class="tg-7u53">FRONTEND URL</td>
				<td class="tg-m2jw">https://${shortBranch}.${CLUSTER_URL}/${frontProjectName}</td>
			</tr>
			<tr>
				<td class="tg-7u53">MOCK API URL</td>
				<td class="tg-m2jw">https://${shortBranch}.${CLUSTER_URL}/${mockApiContexPath}</td>
			</tr>
			<tr>
				<td class="tg-7u53">SONAR QUBE</td>
				<td class="tg-m2jw">${sonarUrl}</td>
			</tr>
			</table>""", 
			compressLog: true,
			recipientProviders: [[$class: 'DevelopersRecipientProvider'], 
			[$class: 'RequesterRecipientProvider']],
			replyTo: 'do-not-reply@company.com', 
			subject: "Status: ${currentBuild.result?:'SUCCESS'} '${env.JOB_NAME}:${env.BUILD_NUMBER}\'", 
			to: 'ikalinichev@luxoft.com, AGerman@luxoft.com, KMukhov@luxoft.com, vdulkeyt@luxoft.com, ASemenchukova@luxoft.com'
			}
            script {
                currentBuild.result = currentBuild.result ?: 'SUCCESS'
                notifyBitbucket( 
                        commitSha1: '', 
                        considerUnstableAsSuccess: false, 
                        credentialsId: "${credID}", 
                        disableInprogressNotification: false, 
                        ignoreUnverifiedSSLPeer: true, 
                        includeBuildNumberInKey: true, 
                        prependParentProjectKey: false, 
                        projectKey: '', 
                        stashServerBaseUrl: 'https://luxproject.luxoft.com/stash')
            }
        }
    }
}
