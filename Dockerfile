FROM ubuntu:focal
ARG RUNNER_URL
ARG RUNNER_TOKEN
ARG RUNNER_NAME
ARG RUNNER_WORK_DIRECTORY

ENV RUNNER_VER "2.277.1"
ENV USER "runner"
ENV DEBIAN_FRONTEND=noninteractive
ENV RANCHER_VER "2.4.6"
##Install packages as root
USER root

#add the service user
RUN useradd -ms /bin/bash $USER


RUN apt-get update && \
	apt-get install apt-transport-https \
			ca-certificates \
			curl \
			git-all \
			gnupg-agent \
			gnupg2 \
			software-properties-common \
		-y && \
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
	apt-add-repository universe && \
	apt-get update && \
	apt-get install docker-ce \
			docker-ce-cli \
			containerd.io \
			python3-pip \
			kubectl \
		-y && \
	#groupadd docker && \
	usermod -aG docker $USER && \
	pip3 install --no-cache docker-compose  && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean
	
RUN curl -O -L https://releases.rancher.com/cli2/v${RANCHER_VER}/rancher-linux-amd64-v${RANCHER_VER}.tar.gz && \
	tar xzf ./rancher-linux-amd64-v${RANCHER_VER}.tar.gz && \
	mv ./rancher-v${RANCHER_VER}/rancher /usr/local/bin/ && \
	rm -rf ./rancher-linux-amd64-v${RANCHER_VER}*
	

WORKDIR /actions-runner

RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VER}/actions-runner-linux-x64-${RUNNER_VER}.tar.gz && \
	tar xzf ./actions-runner-linux-x64-${RUNNER_VER}.tar.gz && \
	rm ./actions-runner-linux-x64-${RUNNER_VER}.tar.gz

RUN ./bin/installdependencies.sh

USER $USER

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
