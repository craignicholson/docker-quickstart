# Kubernetes Quick Start

Update: For users experiencing the hang on the initialization, we've tracked down the issue and updated the instructions accordingly.

These instructions will help you deploy a fully working Kubernetes Cluster on Linux Academy Cloud Servers.

First, create a master server using the "Cloudnative Kubernetes" engine.  Once this machine has booted, log in to it, change the password, and then start the deployment.

Make sure that the instance has the latest packages installed.

sudo apt-get update
The kubeadm tool attempts to simultaneously download all the images for the control pods, which overwhelms our lab server. We will pull the images first, so kubeadm can build the containers more efficiently:

sudo docker pull k8s.gcr.io/kube-scheduler-amd64:v1.10.1
sudo docker pull k8s.gcr.io/etcd-amd64:3.1.12
sudo docker pull  k8s.gcr.io/kube-apiserver-amd64:v1.10.1
sudo docker pull k8s.gcr.io/kube-controller-manager-amd64:v1.10.1
Note that the version numbers might change and the "latest" tag won't work. We'll update this document as soon as we notice a change.

K8s requires a pod network to function. We are going to use Flannel, so we need to pass in a flag to the deployment script so K8s knows how to configure itself:

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
This command might take a fair amount of time to complete, possibly as much as ten minutes. Once it's complete, make note of the join command output by kubeadm init that looks like this:

kubeadm join --token --discovery-token-ca-cert-hash sha256:
You will run that command on the other nodes to allow them to join the cluster -- but not quite yet.  We'll get to that soon.

Create a directory:

mkdir -p $HOME/.kube
Next, you'll move the configuration files to a location usable by your local user. if you copy and paste these commands, do so one at a time, or your sudo password prompt might cause things to go slightly wrong and you might have to redo it.

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 

sudo chown $(id -u):$(id -g) $HOME/.kube/config
In order for your pods to communicate with one another, you'll need to install pod networking.  We are going to use Flannel for our Container Network Interface (CNI) because it's easy to install and reliable.  Enter this command:

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
Author's Note: This link has changed since the course's original release. The old link no longer works. Please use this one to install the Flannel CNI.

Next, you'll check to make sure everything is coming up properly.

kubectl get pods --all-namespaces
Once the kube-dns-xxxx containers are up, your cluster is ready to accept worker nodes.  Create three or so worker nodes the same way you created your master nodes -- by bringing up the "Cloudnative Kubernetes" image on your Cloud Servers tab above.

ssh to each of the other nodes in the cluster, and execute the kubeadm join command you noted earlier.  You will need execute this command with root privileges, so be sure to add "sudo" to the beginning of the command in order for it to complete correctly.  Once this command is issued, you may log out of the node.  Kubernetes will configure it for you from this point on.

See the video "Setting Up Your Cluster" in this course for details and a full walkthrough of the process.

On the master, you can watch the node come up by repeatedly running:

kubectl get nodes