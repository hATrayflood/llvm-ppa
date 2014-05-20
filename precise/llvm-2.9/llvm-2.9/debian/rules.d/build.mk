
ifeq ($(DEB_HOST_ARCH),kfreebsd-amd64)
  check_args="-j 1 -v"
endif

ifeq ($(DEB_HOST_ARCH),kfreebsd-i386)
  check_args="-j 1 -v"
endif

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
$(configure-stamp)-%: $(unpack-stamp) $(patch-stamp)
	-mkdir -p $($*_builddir) 2>/dev/null
	cd $($*_builddir) && \
	  ../$(srcdir)/configure $($*_confargs)
	$(call $*_extra_configure)
	touch $@
$(build-stamp)-%: $(configure-stamp)-%
	$(MAKE) -j$(NJOBS) -C $($*_builddir) $($*_MAKEOPTS)
	$(call $*_extra_build)
	touch $@
$(check-stamp)-%: $(build-stamp)-%
	# TODO: fix logwatch script
#	  chmod +x $(D)/debian/logwatch.sh && \
#	  (debian/logwatch.sh -t 900 -p $(D)/debian/logwatch-$*.pid \
#	     -m '\ntestsuite still running ...\n' \
#	     $($*_builddir)/test/testrun.log \
#	     &)
	echo "ici"
	if test "x$(nocheck)-$($(strip $(call buildof,$*))_check)" = "xno-yes" ; then \
	  if test "x$($*_check)" = "xyes" ; then \
	    $(MAKE) -C $($*_builddir) $($*_MAKECHECKOPTS) LIT_ARGS=$(check_args) check || true ; \
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
	$(call $*_extra_install)
	touch $@

