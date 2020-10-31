.PHONY: up down init cluster-up install uninstall logs repos namespaces cluster-down clean provision

up: cluster-up init docker-creds install-tekton deploy e2e-test

down: cluster-down

docker-creds:
	docker login
	kubectl create secret generic basic-user-pass-docker --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json --type=kubernetes.io/dockerconfigjson -n prod

install-tekton:
	chmod +x tekton-install.sh
	./tekton-install.sh
deploy:


cluster-down:
	k3d cluster delete labs

clean: logs
	
cluster-up:
	k3d cluster create labs \
	    -p 80:80@loadbalancer \
	    -p 443:443@loadbalancer \
	    -p 30000-32767:30000-32767@server[0] \
	    -v /etc/machine-id:/etc/machine-id:ro \
	    -v /var/log/journal:/var/log/journal:ro \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    --k3s-server-arg '--no-deploy=traefik' \
	    --agents 3

init: logs repos namespaces

logs:
	touch output.log
	rm -f output.log
	touch output.log

repos:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo add elastic https://helm.elastic.co
	helm repo add fluent https://fluent.github.io/helm-charts
	helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
	helm repo update

namespaces:
	kubectl apply -f platform/namespaces


install-ingress:
	echo "Ingress: install" | tee -a output.log
	kubectl apply -n ingress-nginx -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

delete-ingress:
	echo "Ingress: delete" | tee -a output.log
	kubectl delete -n ingress -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log 2>/dev/null | true


deploy: front-end carts-db carts catalogue-db catalogue payment orders-db orders user-db user rabbitmq shipping queue-master 

e2e-test:
	kubectl create -f tekton/e2e-js-test/sa.yaml -f tekton/e2e-js-test/task.yaml -f tekton/e2e-js-test/task-dep.yaml -f tekton/e2e-js-test/pipresource.yaml -f tekton/e2e-js-test/pipline.yaml -f tekton/e2e-js-test/piplinerun.yaml -n prod

front-end:
	kubectl create -f tekton/front-end/sa.yaml -f tekton/front-end/task.yaml -f tekton/front-end/task-dep.yaml -f tekton/front-end/pipresource.yaml -f tekton/front-end/pipline.yaml -f tekton/front-end/piplinerun.yaml -n prod

carts-db:
	kubectl create -f tekton/carts-db/sa.yaml -f tekton/carts-db/task-dep.yaml -f  tekton/carts-db/taskrun-dep.yaml -f tekton/carts-db/pipresource.yaml -n prod

carts:	
	kubectl create -f tekton/carts/sa.yaml -f tekton/carts/task.yaml -f tekton/carts/task-dep.yaml -f tekton/carts/pipresource.yaml -f tekton/carts/pipline.yaml -f tekton/carts/piplinerun.yaml -n prod

catalogue-db:
	kubectl create -f tekton/catalogue-db/sa.yaml -f tekton/catalogue-db/task.yaml -f tekton/catalogue-db/task-dep.yaml -f tekton/catalogue-db/pipresource.yaml -f tekton/catalogue-db/pipline.yaml -f tekton/catalogue-db/piplinerun.yaml -n prod

catalogue:
	kubectl create -f tekton/catalogue/sa.yaml -f tekton/catalogue/task.yaml -f tekton/catalogue/task-dep.yaml -f tekton/catalogue/pipresource.yaml -f tekton/catalogue/pipline.yaml -f tekton/catalogue/piplinerun.yaml -n prod

payment:
	kubectl create -f tekton/payment/sa.yaml -f tekton/payment/task.yaml -f tekton/payment/task-dep.yaml -f tekton/payment/pipresource.yaml -f tekton/payment/pipline.yaml -f tekton/payment/piplinerun.yaml -n prod

orders-db:
	k create -f tekton/orders-db/sa.yaml -f tekton/orders-db/task-dep.yaml -f  tekton/orders-db/taskrun-dep.yaml -f tekton/orders-db/pipresource.yaml -n prod

orders:
	kubectl create -f tekton/orders/sa.yaml -f tekton/orders/task.yaml -f tekton/orders/task-dep.yaml -f tekton/orders/pipresource.yaml -f tekton/orders/pipline.yaml -f tekton/orders/piplinerun.yaml -n prod

user-db:
	kubectl create -f tekton/user-db/sa.yaml -f tekton/user-db/task.yaml -f tekton/user-db/task-dep.yaml -f tekton/user-db/pipresource.yaml -f tekton/user-db/pipline.yaml -f tekton/user-db/piplinerun.yaml -n prod

user:
	kubectl create -f tekton/user/sa.yaml -f tekton/user/task.yaml -f tekton/user/task-dep.yaml -f tekton/user/pipresource.yaml -f tekton/user/pipline.yaml -f tekton/user/piplinerun.yaml -n prod

rabbitmq:
	k create -f tekton/rabbitmq/sa.yaml -f tekton/rabbitmq/task-dep.yaml -f  tekton/rabbitmq/taskrun-dep.yaml -f tekton/rabbitmq/pipresource.yaml -n prod

shipping:
	kubectl create -f tekton/shipping/sa.yaml -f tekton/shipping/task.yaml -f tekton/shipping/task-dep.yaml -f tekton/shipping/pipresource.yaml -f tekton/shipping/pipline.yaml -f tekton/shipping/piplinerun.yaml -n prod	

queue-master:
	kubectl create -f tekton/queue-master/sa.yaml -f tekton/queue-master/task.yaml -f tekton/queue-master/task-dep.yaml -f tekton/queue-master/pipresource.yaml -f tekton/queue-master/pipline.yaml -f tekton/queue-master/piplinerun.yaml -n prod

pro-graf:
	./pro-graf/pro-graf.sh 	

elf:
	./elf/elf.sh

complete-demo:
	 k apply -f complete-demo.yaml -n test
