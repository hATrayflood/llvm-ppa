
DISTRIBUTION	:= $(shell dpkg-parsechangelog | grep ^Distribution | sed -e 's/^Distribution: //')
PKGSOURCE	:= $(shell dpkg-parsechangelog | grep ^Source | sed -e 's/^Source: //')
VERSION		:= $(shell dpkg-parsechangelog | grep ^Version | sed -e 's/^Version: //')
UXVERSION	:= $(shell echo $(VERSION) | cut -d'-' -f1)
MAJOR_VERSION := 3
MINOR_VERSION := 0
UVERSION	:= $(MAJOR_VERSION).$(MINOR_VERSION)
EXTVERSION  := .src
OS		:= $(shell lsb_release -is)
PF		:= /usr/lib/llvm-$(UVERSION)
D		:= $(CURDIR)

DEB_HOST_MULTIARCH ?= $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)

# remove upstream version
PKGNAME		:= $(subst -$(UVERSION),,$(PKGSOURCE))

# for binaries
SUFFIX		:= $(subst $(PKGNAME),,$(PKGSOURCE))

# for the shared lib
ifeq ($(PKGNAME),llvm)
  pkg_version	:= $(shell sed -n "/^PACKAGE_VERSION=/s/.*'\(.*\)'$$/\1/p" configure)
  pkg_version	:= $(subst rc,,$(pkg_version))
else
  pkg_version	:= $(UVERSION)
endif
shlib_name	:= libLLVM-$(pkg_version)

# for llvm-gcc and tools
dev_version	:= $(UVERSION)-4

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
	CC=$(DEB_HOST_GNU_TYPE)-gcc CXX=$(DEB_HOST_GNU_TYPE)-g++ \
	CPP=$(DEB_HOST_GNU_TYPE)-cpp \
	--host=$(DEB_HOST_GNU_TYPE) --build=$(DEB_BUILD_GNU_TYPE)

# build not yet prepared to take variables from the environment
define unsetenv
  unexport $(1)
  $(1) =
endef
$(foreach v, CPPFLAGS CFLAGS CXXFLAGS FFLAGS LDFLAGS, $(if $(filter environment,$(origin $(v))),$(eval $(call unsetenv, $(v)))))

