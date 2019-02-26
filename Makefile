LINUX_VER=4.16
BUILD_ARGS=-j 4

build:
	curl -o linux.tar.xz -L https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$(LINUX_VER).tar.gz
	tar xfv linux.tar.xz && $(RM) linux.tar.xz
	cp kernel.config linux-$(LINUX_VER)/.config
	cd linux-$(LINUX_VER) && ./scripts/kconfig/merge_config.sh .config
	cd linux-$(LINUX_VER) && $(MAKE) $(BUILD_ARGS) bzImage
	cd linux-$(LINUX_VER) && $(MAKE) $(BUILD_ARGS) modules
	export INSTALL_MOD_PATH=$(PWD)
	rm -rf lib
	cd linux-$(LINUX_VER) && $(MAKE) $(BUILD_ARGS) modules_install
	mv lib/modules modules && $(RM) -rf lib
	tar cvz modules > modules-$(LINUX_VER).tgz && $(RM) -rf modules
	./extract-vmlinux linux-${LINUX_VER}/arch/x86/boot/bzImage > vmlinuz-$(LINUX_VER)

clean:
	$(RM) -rf linux-$(LINUX_VER)
	$(RM) vmlinuz-$(LINUX_VER)
	$(RM) modules-$(LINUX_VER).tgz
