vm.down:; ([ -d $(BASEDIR)/.vagrant/ ] && vagrant destroy DeVM)

vm.install:; ([ ! -d $(BASEDIR)/.vagrant/ ] && vagrant up)

vm.ssh:; (vagrant ssh -c $(VMCMD) DeVM)

vm.uninstall: vm.down
	-rm -rf $(BASEDIR)/.vagrant/
	-rm -rf $(BASEDIR)/app/node_modules/
	-rm -rf $(BASEDIR)/node_modules/
