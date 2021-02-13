#!/bin/bash

export AWS_PROFILE=kubia

echo "..... Create config maps and secrets"

kubectl create configmap mongodb-config \
    --from-env-file=config_files/mongodb/.env

kubectl create configmap mongodb-init \
    --from-file=config_files/mongodb/mongo-init.sh \
    --from-file=config_files/mongodb/restaurant.json

kubectl create secret generic mongodb-secrets \
    --from-literal=MONGO_INITDB_ROOT_PASSWORD='root' \
    --from-literal=MONGO_INITDB_PASSWORD='foodie'

kubectl create configmap restapi-config \
    --from-env-file=config_files/restapi/.env

kubectl create secret generic restapi-secrets \
    --from-literal=MONGO_URI='mongodb://foodie:foodie@mongodb-svc:27017/restaurantdb?authSource=admin'

echo "..... Create kubernetes resources"
kubectl apply -f kube-storageclass.yaml -f kube-mongodb.yaml -f kube-restapi.yaml
