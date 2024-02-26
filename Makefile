##
## —————————————— MAKEFILE ————————————————————————————————————————————————————————
##
SHELL=/bin/bash

.DEFAULT_GOAL = help

.PHONY: help
help: ## Display help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | sed -e 's/Makefile://' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-22s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


.PHONY: header
header:
	@		echo "*********************************** MAKEFILE ***********************************"
	@		echo "HOSTNAME	`uname -n`"
	@		echo "KERNEL RELEASE 	`uname -r`"
	@		echo "KERNEL VERSION 	`uname -v`"
	@		echo "PROCESSOR	`uname -m`"
	@		echo "********************************************************************************"


##
## —————————————————————————— ENVIRONMENTS CONFIGURATION ——————————————————————————
##

.PHONY: env
env: header ## Prepare environment
	@[ -d "${PWD}/.direnv" ] || (echo "Venv not found: ${PWD}/.direnv" && exit 1)
	@pip3 install -U pip --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} pip3" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} pip3"

	@pip3 install -U wheel --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} wheel" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} wheel"

	@pip3 install -U setuptools --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} setuptools" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} setuptools"

	@pip install -U --no-cache-dir -q -r requirements.txt &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS"

.PHONY: prepare
prepare: header ## Install ansible-galaxy requirements
	@echo "***************************** ANSIBLE REQUIREMENTS *****************************"
	@ansible-galaxy install -fr ${PWD}/requirements.yml

##
## —————————————— TESTS ———————————————————————————————————————————————————————————
##
.PHONY: test-docker
test-docker: ## Test ansible-role-certbot in docker-vagrant environment with DNS-01
	@echo -e "${Blue}==> Testing ansible-role-certbot in docker-vagrant environment with DNS-01${Color_Off}"
	@source .env.vagrant
	@cd ${TEST_DOCKER_DIRECTORY} && vagrant up && vagrant provision

.PHONY: test-vbox
test-vbox: ## Test ansible-role-certbot in vbox-vagrant environment with DNS-01
	@echo -e "${Blue}==> Testing ansible-role-certbot in vbox-vagrant environment with DNS-01${Color_Off}"
	@cd ${TEST_DOCKER_DIRECTORY} && vagrant up && vagrant provision

.PHONY: test-aws
test-aws: ## Test ansible-role-certbot in aws environment with HTTP-01
	@echo -e "${Blue}==> Testing ansible-role-certbot in aws environment with HTTP-01${Color_Off}"
	@cd ${TEST_AWS_DIRECTORY} && ansible-playbook tests.yml

##
## —————————————— CLEAN ———————————————————————————————————————————————————————————
##

.PHONY: clean
clean: ## Easy way to clea-up local environment
	@echo -e "${Green}Clean up environment${Color_Off}"

	@if test -d $(TEST_DOCKER_DIRECTORY)/.vagrant; \
		then cd $(TEST_DOCKER_DIRECTORY) && vagrant destroy -f && vagrant global-status --prune; \
		rm -rf $(TEST_DOCKER_DIRECTORY)/.vagrant; \
	fi
	@if test -d $(TEST_DOCKER_DIRECTORY)/secrets; \
		then rm -rf $(TEST_DOCKER_DIRECTORY)/secrets; \
	fi

	@rm -rf .direnv
