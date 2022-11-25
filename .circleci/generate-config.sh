#!/bin/bash

RUN_TYPE=$1
NODE_SUB='nodejs'
# config_content=`cat ./default_config.yml`
if [[ $RUN_TYPE == "initial_run" ]]
then
cat << EOF > ./circleci/generated-config.yml

version: 2.1
jobs:
  initial_workflow_job:
    docker:
      - image: cimg/node:17.4.0
    steps:
      - checkout
      - run: echo "Initial Workflow is Created & Run"
workflows:
  initial_workflow:
    jobs:
      - initial_workflow_job

EOF
curl --request POST \
--url https://circleci.com/api/v2/project/gh/jasurbek-khanjarov/cci-new-pipelines-api/pipeline \
--header "Circle-Token: $CIRCLE_TOKEN" \
--header 'content-type: application/json' \
--data '{"branch":"main", "parameters":{"run-setup": true, "run-type": "secondary_run"}}'
elif [[ $RUN_TYPE == "secondary_run" ]]
then
cat << EOF > ./circleci/generated-config.yml

version: 2.1
jobs:
  secondary_workflow_job:
    docker:
      - image: cimg/base:2022.01
    steps:
      - checkout
      - run: echo "New Pipeline Workflow is Created & Run"
workflows:
  secondary_workflow:
    jobs:
      - secondary_workflow_job

EOF
fi