configure: $(configure-stamp)
$(configure-stamp): $(addprefix $(configure-stamp)-,$(builds))
	touch $@

build: $(build-stamp)
$(build-stamp): $(addprefix $(build-stamp)-,$(builds))
	touch $@

check: $(check-stamp)
$(check-stamp): $(addprefix $(check-stamp)-,$(builds))
	touch $@

install: $(install-stamp)
$(install-stamp): $(addprefix $(install-stamp)-,$(builds))
	touch $@

clean: clean-common
clean-common:
	dh_testdir
	dh_testroot
	dh_clean
	find $(srcdir)/test/Bindings/Ocaml -type f \
	  -name "*.o" -or -name "*.cmx" | xargs $(RM)
	$(RM) -r $(D)/debian/tmp-*
	$(RM) $(D)/test/Bindings/Ocaml/*.cm[io]
	$(RM) $(D)/debian/log-check-* $(D)/debian/logwatch-*.pid
	$(RM) $(D)/log-* $(D)/missing

.PHONY: configure build install check clean clean-common

# GENERIC -------------------
$(configure-stamp)-%: $(unpack-stamp)
	mkdir -p tools/clang/include/clang/Debian
	sed -e "s|@DEB_HOST_MULTIARCH@|$$(dpkg-architecture -qDEB_HOST_MULTIARCH)|" \
		-e "s|@DEB_HOST_GNU_TYPE@|$$(dpkg-architecture -qDEB_HOST_GNU_TYPE)|" \
		-e "s|@DEB_PATCHSETVERSION@|$(PATCHSETVERSION)|" \
		debian/debian_path.h > tools/clang/include/clang/Debian/debian_path.h
	# Make sure that the built libs have the extension into the name
	sed -i -e "s|^LLVMLibsPaths +=\(.*SHLIBEXT)$$\)|LLVMLibsPaths +=\1.$(SONAME_EXT)|g" \
	-i	-e "s|^BaseLibName.SO \(.*SHLIBEXT)$$\)|BaseLibName.SO \1.$(SONAME_EXT)|g" \
	$(LLVM_PATH_SRC)/Makefile.rules
	-mkdir -p $($*_builddir) 2>/dev/null
	cd $($*_builddir) && \
	  ../$(srcdir)/configure $($*_confargs) CLANG_VENDOR=Debian
	$(call $*_extra_configure)
	touch $@

$(build-stamp)-%: $(configure-stamp)-%
	$(MAKE) -j$(NJOBS) -C $($*_builddir) $($*_MAKEOPTS) CLANG_VENDOR=Debian	
	$(call $*_extra_build)
	touch $@

$(check-stamp)-%: $(build-stamp)-%
	# TODO: fix logwatch script
#	  chmod +x $(D)/debian/logwatch.sh && \
#	  (debian/logwatch.sh -t 900 -p $(D)/debian/logwatch-$*.pid \
#	     -m '\ntestsuite still running ...\n' \
#	     $($*_builddir)/test/testrun.log \
#	     &)
	if test "x$(nocheck)-$($(strip $(call buildof,$*))_check)" = "xno-yes" ; then \
	  if test "x$($*_check)" = "xyes" ; then \
	    $(MAKE) -C $($*_builddir) $($*_MAKECHECKOPTS) check || true ; \
	  fi ; \
	fi
	$(call $*_extra_check)
	touch $@

$(install-stamp)-%: $(build-stamp)-% $(check-stamp)-%
	$(MAKE) -C $($*_builddir) $($*_MAKEOPTS) install DESTDIR=$(D)/debian/tmp-$*
	# Fix links that point to install directory
	find $(D)/debian/tmp-$* -type l | while read i ; \
	  do \
	    L=$$(readlink $$i) ; \
	    L=$${L##$(D)/debian/tmp-$*} ; \
	    ln -sf $$L $$i ; \
	  done
	(cd $(D)/debian/tmp-clang/usr/lib/; \
		if test ! -h libclang.so; then \
			ln -s libclang.so.$(SONAME_EXT) libclang.so; \
	fi)
	chrpath -d $(D)/debian/tmp-clang/usr/bin/clang
	$(call $*_extra_install)
	touch $@

