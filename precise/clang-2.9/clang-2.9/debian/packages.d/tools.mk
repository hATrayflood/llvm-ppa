builds := $(PKGNAME)

ifeq (,$(filter $(PKGNAME),$(tools)))
  $(error unsupported tool)
endif

BUILDDEPS	:= \
	llvm-$(UVERSION)-dev (>= $(dev_version)), llvm-$(UVERSION)-source (>= $(dev_version))
BUILDCONFLICTS	:= ocaml

PF		:= /usr

patchdirs	:= /usr/src/llvm-$(UVERSION)/patches

export CCACHE_READONLY=1

$(PKGNAME)_packages := $(PKGNAME)

$(PKGNAME)_confargs := $(confargs) \
	--prefix=$(PF) --disable-assertions \
	--enable-shared \
	--enable-optimized --with-optimize-option=' $(opt_flags)' --enable-pic --enable-libffi

$(PKGNAME)_MAKEOPTS := $(MAKEOPTS) \
	VERBOSE=1 \
	DebianOpts="-DLLVM_DEBIAN_INFO='\" ($(OS) $(VERSION))\"'" \
	ONLY_TOOLS="$(PKGNAME)"

# FIXME: Should separe MAJOR/UVERSION.
tarpath		:= $(firstword $(wildcard $(D)/llvm-$(UVERSION)*.tar.* \
			/usr/src/llvm-$(UVERSION)/llvm-$(UVERSION)*.tar.*))
tarball		:= $(notdir $(tarpath))
srcdir		:= $(subst -dfsg,,$(subst .tar$(suffix $(tarball)),,$(tarball)))

define $(PKGNAME)_extra_unpack
	rm -rf $(D)/debian/ccache ; \
	if test -f $(PF)/lib/llvm-$(UVERSION)/build/ccache.$(DEB_HOST_ARCH).tar.lzma ; then \
		lzcat $(PF)/lib/llvm-$(UVERSION)/build/ccache.$(DEB_HOST_ARCH).tar.lzma | tar -C $(D)/debian -x -f - ; \
	fi ; \
	test ! "x$(srcdir)" = "x." || exit 1 ; \
	for tool in $(notdir $(wildcard $(D)/tools/*)) ; do \
	  rm -rf $(D)/$(srcdir)/tools/$$tool ; \
	  ln -sf $(D)/tools/$$tool $(D)/$(srcdir)/tools/$$tool ; \
	done
endef
