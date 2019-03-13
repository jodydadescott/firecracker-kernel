# firecracker-kernel
Build a Linux kernel and modules for AWS Firecracker
## Pre-built Binaries
### Version 4.16.0
- [kernel](https://github.com/jodydadescott/firecracker-kernel/releases/download/v4.16.0/vmlinuz-4.16)
- [modules](https://github.com/jodydadescott/firecracker-kernel/releases/download/v4.16.0/modules-4.16.tgz)
## Build Instructions
### Makefile
Edit the makefile and set the desired version. Then type make. This should build the kernel and the modules.
### Manual
```bash
BUILD_ARGS=-j 4
LINUX_VER=4.16
git clone https://github.com/jodydadescott/firecracker-kernel.git
cd firecracker-kernel
curl -o linux.tar.xz -L https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${LINUX_VER}.tar.gz
tar xfv linux.tar.xz
cp kernel.config linux-${LINUX_VER}/.config
cd linux-4.16

# Run the command 'make menu-config' for interactive configuration or
# the command './scripts/kconfig/merge_config.sh .config' for non-interactive configuration
./scripts/kconfig/merge_config.sh .config

# Build the kernel
make ${BUILD_ARGS} bzImage

# Build the modules and install in the present working directory (optional)
export INSTALL_MOD_PATH=$(PWD)
rm -rf lib
make ${BUILD_ARGS} modules
make modules_install
mv lib/modules modules
tar cvz modules > modules-${LINUX_VER}.tgz

# Extract the compressed kernel
cd ..
./extract-vmlinux linux-${LINUX_VER}/arch/x86/boot/bzImage > vmlinuz-${LINUX_VER}

```


