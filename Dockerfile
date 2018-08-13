FROM jenkins/jenkins:lts

# Install Docker
USER root

RUN apt-get update && \
	apt-get -y install apt-transport-https jq \
	ca-certificates \
	curl \
	gnupg2 \
	software-properties-common && \
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
	add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
	$(lsb_release -cs) \
	stable" && \
	apt-get update && \
	apt-get -y install docker-ce

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
	chmod +x ./kubectl && \
	mv ./kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Plugins
RUN install-plugins.sh \
    ant \
    blueocean \ 
    build-timeout \ 
    docker \
    email-ext \
    envinject \
    google-container-registry-auth \
    gradle \
    kubernetes \
    kubernetes-cli \
    kubernetes-cd \
    ldap \
    pam-auth \
    pipeline-github-lib \
    simple-theme-plugin \
    slack \
    ssh-agent \
    subversion \
    timestamper \
    build-user-vars-plugin \
    ws-cleanup 

USER ${user}
