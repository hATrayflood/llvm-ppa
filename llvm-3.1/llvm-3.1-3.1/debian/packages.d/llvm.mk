builds := llvm

# packages which don't need the builds
extra_packages := llvm-source

ifneq (,$(findstring $(DEB_HOST_GNU_CPU),ia64))
  $(error unsupported processor)
endif

BUILDDEPS := \
	ocaml-nox (>= 3.11.2), ocaml-best-compilers | ocaml-nox, \
	dh-ocaml (>= 0.9.1)


#ifeq (yes,$(shell dpkg --compare-versions $(VERSION) gt $(UVERSION)-1 && echo yes))
#  llvm-priv-dev_version := $(UVERSION)-$(shell expr $(subst $(UVERSION)-,,$(VERSION)) - 1)
#  BUILDDEPS := llvm-$(UVERSION)-priv-dev (>= $(llvm-priv-dev_version)), $(BUILDDEPS)
#endif

# build with RTTI
export REQUIRES_RTTI=1

include /usr/share/ocaml/ocamlvars.mk

llvm_packages	:= \
	llvm llvm-runtime llvm-dev \
	libllvm-ocaml-dev \
	llvm-doc llvm-examples

llvm_confargs	:= $(confargs) \
	--prefix=$(PF) --disable-assertions \
	--enable-optimized --with-optimize-option=' $(opt_flags)' --enable-pic --enable-libffi \
	--with-ocaml-libdir=$(OCAML_STDLIB_DIR)/llvm-$(UVERSION) \
	--libdir=\$${prefix}/lib/$(DEB_HOST_MULTIARCH) \
    --with-binutils-include=/usr/include

llvm_packages := libllvm$(pkg_version) $(llvm_packages)
llvm_confargs += --enable-shared

llvm_MAKEOPTS := $(MAKEOPTS) \
	VERBOSE=1 \
	DebianOpts="-DLLVM_DEBIAN_INFO='\" ($(OS) $(VERSION))\"'"

# run testsuite
llvm_check := yes

llvm_MAKECHECKOPTS := $(MAKEOPTS) \
	VERBOSE=1 \
	PATH="$(D)/build-llvm/Release-Asserts/bin:$(srcdir)/test/Scripts:/usr/bin:/bin"

ifeq (0,1)
define llvm_extra_unpack
	rm -rf $(D)/debian/ccache ; \
	if test -f $(PF)/build/ccache.$(DEB_HOST_ARCH).tar.lzma ; then \
		lzcat $(PF)/build/ccache.$(DEB_HOST_ARCH).tar.lzma | tar -C $(D)/debian -x -f - ; \
	fi ; \
	if ! test "x$$($(DEB_HOST_GNU_TYPE)-g++ --version | head -n 1)" = "x$$(cat $(D)/debian/ccache/version 2>/dev/null)" ; then \
		echo "Clearing the cache." && \
		$(RM) -r $(D)/debian/ccache && \
		mkdir $(D)/debian/ccache && \
		$(DEB_HOST_GNU_TYPE)-g++ --version | head -n 1 > $(D)/debian/ccache/version ; \
	fi ; \
	ccache -c
endef
endif

define llvm_extra_install
	mkdir -p $(D)/debian/tmp-llvm/usr/lib/$(DEB_HOST_MULTIARCH)
	mv $(D)/debian/tmp-llvm/$(PF)/lib/$(shlib_name).so \
	  $(D)/debian/tmp-llvm/usr/lib/$(DEB_HOST_MULTIARCH)/$(shlib_name).so.1
	cp -f $(D)/utils/vim/llvm.vim $(D)/utils/vim/llvm-$(UVERSION).vim
	cp -f $(D)/utils/vim/tablegen.vim $(D)/utils/vim/tablegen-$(UVERSION).vim
endef

define llvm-runtime_extra_binary
	if test "x$*" = "xllvm-runtime" ; then \
		mv $(D)/debian/$(strip $(call pkgname,$*))/usr/share/binfmts/llvm.binfmt \
		   $(D)/debian/$(strip $(call pkgname,$*))/usr/share/binfmts/llvm-$(UVERSION).binfmt ; \
		sed -i -e "s/@UVERSION@/$(UVERSION)/g" $(D)/debian/$(strip $(call pkgname,$*))/usr/share/binfmts/llvm-$(UVERSION).binfmt ; \
	fi
endef

define llvm_extra_binary
	if test "x$*" = "xllvm" ; then \
		find $(D)/debian/$(strip $(call pkgname,$*)) ! -type d -name "lli*" ; \
		find $(D)/debian/$(strip $(call pkgname,$*)) ! -type d -name "lli*" | xargs $(RM) ; \
		sed -r 's/^(my\s+\$$LLVM_SRC_ROOT\s+=\s+q)\{(.*)\}\;$$/\1\{$(subst /,\/,$(PF))\/build\}\;/' \
			-i $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/bin/llvm-config ; \
		sed -r 's/^(my\s+\$$LLVM_OBJ_ROOT\s+=\s+q)\{(.*)\}\;$$/\1\{$(subst /,\/,$(PF))\/build\}\;/' \
			-i $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/bin/llvm-config ; \
		if test "x$(llvm_check)" = "xyes" ; then \
			install -m 0644 $(D)/build-llvm/test/testrun.sum \
			$(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/ ; \
			echo >> $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/testrun.sum ; \
			echo "Compiler version: $(shell $(DEB_HOST_GNU_TYPE)-gcc -dumpversion) (GCC)" \
			  >> $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/testrun.sum ; \
			echo "Platform: $(DEB_HOST_GNU_TYPE)" \
			  >> $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/testrun.sum ; \
			echo "configure flags: $(llvm_confargs)" \
			  >> $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/testrun.sum ; \
			gzip -9nf $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/testrun.sum ; \
		fi ; \
	fi
endef

define llvm-dev_extra_binary
	if test "x$*" = "xllvm-dev" ; then\
		find $(D)/debian/$(strip $(call pkgname,$*)) ! -type d -name "libLLVM-$(UVERSION)*.so.*" | xargs $(RM) ; \
		for i in llvm llvm-c ; do \
			mv $(D)/debian/$(strip $(call pkgname,$*))/usr/include/$$i \
				$(D)/debian/$(strip $(call pkgname,$*))/$(PF)/include/$$i ; \
		done ; rm -rf $(D)/debian/$(strip $(call pkgname,$*))/usr/include ; \
		for i in $$(ls $(D)/debian/$(strip $(call pkgname,$*))/usr/share/vim/addons/plugin/*.vim 2>/dev/null || echo -n) ; do \
			mv $$i $$(echo $$i | sed -r 's/(\.vim)$$/-$(MAJOR_VERSION)\.$(MINOR_VERSION)\1/g') ; \
		done ; \
		sed -r 's/^(LLVM_SRC_ROOT\s+\:\=\s+\$$\(shell cd).*\; \$$\(PWD\)\)$$/\1 $(subst /,\/,$(PF))\/build \; \$$\(PWD\)\)/' \
			-i $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/build/Makefile.config ; \
		sed -r 's/^(LLVM_OBJ_ROOT\s+\:\=\s+\$$\(shell cd).*\; \$$\(PWD\)\)$$/\1 $(subst /,\/,$(PF))\/build \; \$$\(PWD\)\)/' \
			-i $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/build/Makefile.config ; \
		sed -r "s/^(ac_pwd\=)'.*'$$/\1'$(subst /,\/,$(PF))\/build'/" \
			-i $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/build/config.status ; \
		chmod 644 $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/build/Makefile* ; \
		find $(D)/debian/$(strip $(call pkgname,$*)) -type f -name "LICENSE.TXT" | xargs $(RM) ; \
		cp $(D)/utils/vim/README $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/README.vim ; \
		cp $(D)/utils/emacs/README $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/README.emacs ; \
		sed -r 's/path-to-llvm\/utils\/emacs/\/usr\/share\/emacs\/site-lisp\/llvm-$(UVERSION)/' \
			-i $(D)/debian/$(strip $(call pkgname,$*))/usr/share/doc/$(strip $(call pkgname,$*))/README.emacs ; \
	fi
endef

define llvm-priv-dev_extra_binary
	if test "x$*" = "xllvm-priv-dev" ; then \
		ccache -c ; \
		cp -r $(D)/debian/ccache $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/build/ ; \
		cd $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/build/ && \
			tar cf ccache.$(DEB_HOST_ARCH).tar ccache && \
			lzma --best ccache.$(DEB_HOST_ARCH).tar ; \
			cd $(D) ; \
		$(RM) -r $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/build/ccache ; \
	fi
endef

# FIXME: Should separe MAJOR/UVERSION.
define llvm-source_extra_binary
	if test "x$*" = "xllvm-source" ; then \
		$(RM) -r $(D)/debian/$(strip $(call pkgname,$*))/usr/src/llvm-$(UVERSION) ; \
		mkdir -p $(D)/debian/$(strip $(call pkgname,$*))/usr/src/llvm-$(UVERSION) ; \
		cp -f ../$(PKGNAME)-$(UVERSION)_$(UXVERSION).orig.tar.bz2 \
			$(D)/debian/$(strip $(call pkgname,$*))/usr/src/llvm-$(UVERSION)/$(PKGNAME)-$(UVERSION).tar.bz2 ; \
		cd $(D)/debian/$(strip $(call pkgname,$*))/usr/src/llvm-$(UVERSION)/; \
		tar jxf $(PKGNAME)-$(UVERSION).tar.bz2 ; \
		mv $$(find . -maxdepth 1 -type d -iname 'llvm-$(UVERSION)$(EXTVERSION)*') llvm-$(UVERSION); \
		cd llvm-$(UVERSION); \
		echo "Apply patches in the llvm-source package from $(D)/debian/patches/"; \
		quilt setup  --sourcedir $(D)/debian/patches/ $(D)/debian/patches/series; \
		quilt push -a | exit 1; \
		rm patches series ../$(PKGNAME)-$(UVERSION).tar.bz2; \
		cd ..; \
		tar Jcf $(PKGNAME)-$(UVERSION).tar.xz $(PKGNAME)-$(UVERSION)$(EXTVERSION) ; \
		rm -rf $(PKGNAME)-$(UVERSION)$(EXTVERSION); \
	fi; \
	FILESIZE=$(stat --printf="%s" $(PKGNAME)-$(UVERSION).tar.xz); \
	if test $$FILESIZE -lt 100000; then \
		echo "$(PKGNAME)-$(UVERSION).tar.xz file size is too small. Found: "; echo $$FILESIZE; \
		exit 42; \
	fi
endef

define libllvm-ocaml-dev_extra_binary
	if test "x$*" = "xlibllvm-ocaml-dev" ; then \
		dh_ocaml -p$(call pkgname,$*) ; \
		cp $(D)/debian/$(strip $(call pkgname,$*)).META \
		   $(D)/debian/$(strip $(call pkgname,$*))/$(OCAML_STDLIB_DIR)/METAS/META.llvm-$(subst .,_,$(UVERSION)); \
	fi
endef

