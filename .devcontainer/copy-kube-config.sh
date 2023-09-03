#!/bin/bash -i
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Copyright (c) trukhinyuri <yuri@trukhin.com>. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Maintainer: trukhinyuri <yuri@trukhin.com>
#

# Copies localhost's ~/.kube/config file into the container and swap out localhost
# for host.docker.internal whenever a new shell starts to keep them in sync.
if [ -d "/usr/local/share/kube-localhost" ]; then
    mkdir -p $HOME/.kube
    sudo cp -r /usr/local/share/kube-localhost/* $HOME/.kube
    sudo chown -R $(id -u) $HOME/.kube
    sed -i -e "s/localhost/host.docker.internal/g" $HOME/.kube/config
    sed -i -e "s/127.0.0.1/host.docker.internal/g" $HOME/.kube/config
    sed -i '/\ \ \ \ server: https:\/\/host.docker.internal:6443/a \ \ \ \ insecure-skip-tls-verify: true' $HOME/.kube/config
    sed -i '/certificate-authority-data:/d' $HOME/.kube/config


    # If .minikube was mounted, set up client cert/key
    if [ -d "/usr/local/share/minikube-localhost" ]; then
        mkdir -p $HOME/.minikube
        sudo cp -r /usr/local/share/minikube-localhost/ca.crt $HOME/.minikube
        # Location varies between versions of minikube
        if [ -f "/usr/local/share/minikube-localhost/client.crt" ]; then
            sudo cp -r /usr/local/share/minikube-localhost/client.crt $HOME/.minikube
            sudo cp -r /usr/local/share/minikube-localhost/client.key $HOME/.minikube
        elif [ -f "/usr/local/share/minikube-localhost/profiles/minikube/client.crt" ]; then
            sudo cp -r /usr/local/share/minikube-localhost/profiles/minikube/client.crt $HOME/.minikube
            sudo cp -r /usr/local/share/minikube-localhost/profiles/minikube/client.key $HOME/.minikube
        fi
        sudo chown -R $(id -u) $HOME/.minikube

        # Point .kube/config to the correct locaiton of the certs
        sed -i -r "s|(\s*certificate-authority:\s).*|\\1$HOME\/.minikube\/ca.crt|g" $HOME/.kube/config
        sed -i -r "s|(\s*client-certificate:\s).*|\\1$HOME\/.minikube\/client.crt|g" $HOME/.kube/config
        sed -i -r "s|(\s*client-key:\s).*|\\1$HOME\/.minikube\/client.key|g" $HOME/.kube/config
    fi
fi