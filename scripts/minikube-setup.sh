#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

if [ "$(uname -m)" == "aarch64" ]
then
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/arm64/kubectl
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
  kubectl version --client
else
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
  kubectl version --client
fi


# conntrack is required for minikube 1.19 and higher for none driver
if ! conntrack --version &>/dev/null; then
  echo "WARNING: No contrack is not installed"
  sudo apt-get update -qq
  sudo apt-get -qq -y install conntrack
fi

if [ "$(uname -m)" == "aarch64" ]
then
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
  chmod +x minikube
  sudo mv minikube /usr/local/bin/
else
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  chmod +x minikube
  sudo mv minikube /usr/local/bin/
fi


sudo apt-get update
sudo apt-get install -y liblz4-tool

sudo minikube start --vm-driver=none
sudo minikube status
sudo chown -R $USER $HOME/.kube $HOME/.minikube
kubectl cluster-info
