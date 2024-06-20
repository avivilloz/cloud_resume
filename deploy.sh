#!/bin/bash

mkdir -p temp

terraform -chdir="infra/provision" init
terraform -chdir="infra/provision" apply -auto-approve