export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all

.PHONY:all bin bitcoin build check chmod clean init rm sh venv vm

.SUBLIME_TARGETS:all

include .deosrc

all: chmod
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@(if [[ -z "$(x)" ]]; then ($(MAKE) install); fi)
	@(if [[ -n "$(x)" ]]; then ($(PRINTM) cyan $@ start); fi)
	if [ "$(x)" = "all" ]; then ($(MAKE) build)\
	else [ "$(x)" = "run" ] && ($(MAKE) wallet) || ($(MAKE) x=all); fi
	@(if [[ -n "$(x)" ]]; then ($(PRINTM) cyan $@ stop); fi)
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

install:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	# brew install tree
	@-mkdir $(BASEDIR)/.swap/
	sh $(BASEDIR)/src/install.sh
endif
	@$(LAGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1" #!BIN

chmod:
	@$(LAGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0" #!BIN
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	cp src/logger.py bin/darwin/logger
	@-chmod +x $(PRINTM) $(DEOS)
	@-chmod +x bin/darwin/logger
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

build: venv check
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(PRINTM) cyan $@ start
	-mkdir $(BASEDIR)/config/nginx/
	-$(MAKE) vm
	@$(PRINTM) cyan $@ stop
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

clean:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(PRINTM) magenta $@ start
	@-$(MAKE) rm
	@-rm -rf $(BASEDIR)/.blockstack/
	@-rm -rf $(BASEDIR)/.vagrant/
	@-rm -rf $(BASEDIR)/.zerotier/
	@-rm -rf $(BASEDIR)/.swap/
	@-rm -rf $(VENV)/darwin/*
	@-cp $(BASEDIR)/tao/static/gitignore.txt $(VENV)/darwin/.gitignore
	@-rm -rf $(VENV)/linux/*
	@-cp $(BASEDIR)/tao/static/gitignore.txt $(VENV)/linux/.gitignore
	@$(PRINTM) magenta $@ stop
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

check:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(PRINTM) cyan $@ start
	@-$(MAKE) deos.check
	@$(PRINTM) cyan $@ stop
else
	@-$(MAKE) deos.check
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

venv:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(PRINTM) cyan $@ start
	[ "$(x)" = "blockstack" ]\
	&& (cd $(VENV)/darwin/\
		&& virtualenv blockstack --no-site-packages)\
	|| (cd $(VENV)/darwin/\
		&& virtualenv default --no-site-packages)
	@$(PRINTM) cyan $@ stop
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

rm:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(PRINTM) yellow $@ start
	-rm -rf $(BASEDIR)/.deos/
	#[ -d $(BASEDIR)/.vagrant/ ] && rm -rf $(BASEDIR)/.deos/
	-$(MAKE) vm.uninstall
	@$(PRINTM) yellow $@ stop
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

sh:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(PRINTM) cyan $@ start
	-$(MAKE) vm.ssh
	@$(PRINTM) cyan $@ stop
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

vm:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(PRINTM) cyan $@ start
	-$(MAKE) vm.install
	@$(PRINTM) cyan $@ stop
endif
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

yubikey:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
	@$(PRINTM) cyan $@ start
	$(DeOS_YUBIKEY_PATH_SRC)/yubiserve.py --db $(DeOS_YUBIKEY_PATH_DB)
	@$(PRINTM) cyan $@ stop
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"

wallet:
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 0"
	@-$(PRINTM) cyan $@ start
	#brew install libusb-1.0-0
	# clean
	-rm -rf $(VENV)/darwin/wallet/
	# init
	cd $(VENV)/darwin/ && virtualenv wallet --no-site-packages
	# install
	source .deos/venv/darwin/wallet/bin/activate\
	&& pip install pyusb --pre\
	&& pip install pypreprocessor
	# build
	source .deos/venv/darwin/wallet/bin/activate\
	&& cd src\
	&& python wallet.py prod
	# run
	source .deos/venv/darwin/wallet/bin/activate\
	&& chmod +x bin/wallet\
	&& ./bin/wallet
	@-$(PRINTM) cyan $@ stop
	@$(LOGGER) "DEBUG" "$(DeOS_HOST_OS) : make : $@ : 1"
