DISTRIBUTION	:= $(shell dpkg-parsechangelog | grep ^Distribution | sed -e 's/^Distribution: //')
PKGSOURCE	:= $(shell dpkg-parsechangelog | grep ^Source | sed -e 's/^Source: //')
VERSION		:= $(shell dpkg-parsechangelog | grep ^Version | sed -e 's/^Version: //')
UXVERSION	:= $(shell echo $(VERSION) | cut -d'-' -f1)
PATCHSETVERSION	:= $(shell echo $(VERSION) | cut -d'-' -f2)
UVERSION	:= 3.0
SONAME_EXT      := 1
GCC_VERSION	:= 4.6
OS		:= $(shell lsb_release -is)
PF		:= /usr/lib/llvm-$(UVERSION)
D		:= $(CURDIR)
LLVM_PATH_SRC	:= llvm-$(UVERSION).src

# remove upstream version
PKGNAME		:= $(subst -$(UVERSION),,$(PKGSOURCE))
#PKGNAME_OTHERS := libclang

# for binaries
SUFFIX		:= $(subst $(PKGNAME),,$(PKGSOURCE))

# for the shared lib
pkg_version	:= $(UVERSION)
shlib_name	:= libLLVM-$(pkg_version)rc

# for llvm-gcc and tools
dev_version	:= $(UVERSION)

# for tools
export CCACHE_DIR=$(D)/debian/ccache
export PATH=/usr/lib/ccache:/usr/local/bin:/usr/bin:/bin

$(foreach var,$(shell dpkg-architecture | sed -e 's/=/?=/'),$(eval $(var)))

opt_flags = -g -O2
ifneq (,$(findstring $(DEB_HOST_ARCH),armel))
  opt_flags += -marm
endif

# testsuite
nocheck	:= no
ifneq (,$(findstring nocheck,$(DEB_BUILD_OPTIONS)))
  nocheck	:= yes
endif

stampdir	:= $(D)/debian/stamps
$(foreach target,control unpack configure build check install binary, \
  $(eval $(target)-stamp := $(stampdir)/$(target)-stamp))

packages_arch	:= $(strip $(shell dh_listpackages -a 2>/dev/null))
packages_indep	:= $(strip $(shell dh_listpackages -i 2>/dev/null))
packages_all	:= $(packages_arch) $(packages_indep)

NJOBS := 1
ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
  NJOBS := $(patsubst parallel=%,%,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
else
    NCPUS := $(shell getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)
    NJOBS := $(shell if test $(NCPUS) -gt 1; then echo `expr $(NCPUS) + 1`; \
               else echo $(NCPUS); fi)
endif

confargs := \
	CC=$(DEB_HOST_GNU_TYPE)-gcc-$(GCC_VERSION) CXX=$(DEB_HOST_GNU_TYPE)-g++-$(GCC_VERSION) \
	CPP=$(DEB_HOST_GNU_TYPE)-cpp-$(GCC_VERSION) \
	--with-c-include-dirs=/usr/include/$(DEB_HOST_GNU_TYPE):/usr/include \
    --with-cxx-include-root=/usr/include/c++/$(GCC_VERSION) \
    --with-cxx-include-arch=$(DEB_HOST_GNU_TYPE) \
    --host=$(DEB_HOST_GNU_TYPE) --build=$(DEB_BUILD_GNU_TYPE)

ifeq ($(shell dpkg-architecture -qDEB_HOST_ARCH_BITS),64)
  confargs += --with-cxx-include-32bit-dir=32
else
  confargs += --with-cxx-include-64bit-dir=64
endif



# build not yet prepared to take variables from the environment
define unsetenv
  unexport $(1)
  $(1) =
endef
$(foreach v, CPPFLAGS CFLAGS CXXFLAGS FFLAGS LDFLAGS, $(if $(filter environment,$(origin $(v))),$(eval $(call unsetenv, $(v)))))

