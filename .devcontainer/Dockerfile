FROM ubuntu:22.04


ENV UBUNTU_FRONTEND=noninteractive

RUN apt update

RUN apt-get install -y curl && \
    apt-get install -y sudo && \
    apt-get install -y wget && \
    apt-get install -y vim && \
    apt-get clean

COPY ./docker-in-docker-ubuntu.sh /usr/local/share/docker-in-docker-ubuntu.sh
RUN chmod +x /usr/local/share/docker-in-docker-ubuntu.sh
RUN /usr/local/share/docker-in-docker-ubuntu.sh

RUN curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash -

COPY copy-kube-config.sh /usr/local/share/
RUN echo "source /usr/local/share/copy-kube-config.sh" | tee -a /root/.bashrc >> /root/.zshrc

ENTRYPOINT /usr/local/share/docker-init.sh && /bin/bash
