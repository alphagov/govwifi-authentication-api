#!/bin/bash

set -v -e -u -o pipefail

source deploy-tools/aws-helpers.sh

function deploy() {
  local cluster_name service_name deploy_stage

  deploy_stage="$(stage_name)"
  cluster_name="${deploy_stage}-${CLUSTER_NAME}"

	if [[ deploy_stage == "staging" ]]
	then
		service_name="authentication-api-service-${deploy_stage}"
	else
		service_name="${SERVICE_NAME}-${deploy_stage}"
	fi

  ecs_deploy_region \
    "${cluster_name}" \
    "${service_name}" \
    "eu-west-1"

  ecs_deploy_region \
    "${cluster_name}" \
    "${service_name}" \
    "eu-west-2"
}

deploy
