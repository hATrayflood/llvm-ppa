binary-indep binary-arch: $(build-stamp) $(install-stamp)
binary-arch: $(addprefix $(binary-stamp)-,$(subst -$(UVERSION),,$(packages_arch)))
binary-indep: $(addprefix $(binary-stamp)-,$(subst -$(UVERSION),,$(packages_indep)))
binary: binary-arch binary-indep
	# TODO: list installed nowhere files

debhelper-%:
	(cd debian/tmp-clang/usr/lib/; if test ! -h libclang.so.0; then ln -s libclang.so libclang.so.0; fi)
	$(foreach f,$(notdir $(wildcard $(D)/debian/debhelper.in/$*.*)),\
	echo $(pkgname); \
	    sed -e "s;@PF@;$(PF);g" \
		-e "s;@TMP@;tmp-clang;g" \
		-e "s;@BUILD@;build-$(strip $(call buildof,$*));g" \
		-e "s;@UVERSION@;$(UVERSION);g" \
		-e "s;@GCC_VERSION@;$(GCC_VERSION);g" \
		-e "s;@LLVM_VERSION@;$(LLVM_VERSION);g" \
		-e "s/@PKG_VERSION@/$(pkg_version)/g" \
		-e "s/@SHLIB_NAME@/$(shlib_name)/g" \
		-e "s;@OCAML_STDLIB_DIR@;$(OCAML_STDLIB_DIR);g" \
		-e "s;@DEB_HOST_MULTIARCH@;$(DEB_HOST_MULTIARCH);g" \
		$(D)/debian/debhelper.in/$f > \
		$(D)/debian/$(strip $(call pkgname,$*))$(strip $(suffix $(f))) \
	&&) :

clean: clean-debhelper
clean-debhelper: clean-common
	$(RM) $(strip $(foreach f,$(notdir $(wildcard $(D)/debian/debhelper.in/*.*)),\
	  $(D)/debian/$(strip $(call pkgname,$(shell echo $(basename $(f)) | sed -e 's/\.$$//')))$(strip $(suffix $(f))) \
	))

.PHONY: clean clean-debhelper

$(foreach build,$(builds),$(foreach package,$($(build)_packages),$(eval \
dependency-$(package): $(install-stamp)-$(build))))

$(foreach package,$(extra_packages),$(eval \
dependency-$(package): $(unpack-stamp)))

$(binary-stamp)-%: dependency-% debhelper-%
	@echo Building package: $(call pkgname,$*)
	dh_testdir
	dh_testroot
	dh_installchangelogs -p$(call pkgname,$*)
	dh_installdocs -p$(call pkgname,$*)
	dh_installexamples -p$(call pkgname,$*)
	dh_installman -p$(call pkgname,$*)
	dh_installmime -p$(call pkgname,$*)
	dh_installdirs -p$(call pkgname,$*)
	dh_install -p$(call pkgname,$*)
	$(call $*_extra_binary)
	for dir in usr/lib $(PF)/lib usr/bin $(PF)/bin ; \
		do for i in $$(find $(D)/debian/$(strip $(call pkgname,$*))/$$dir 2>/dev/null || echo -n) ; \
			do if objdump -p $$i 2>/dev/null | grep RPATH 2>&1 >/dev/null ; \
				then echo "Removing hardcoded path library from $$i" ; \
				chrpath -d $$i || true ; \
			fi ; \
		done ; \
	done
	if ! test "x$(PF)" = "x/usr" ; then \
		for i in $$(ls $(D)/debian/$(strip $(call pkgname,$*))/$(PF)/bin 2>/dev/null || echo -n); do \
			echo "Adding versioned symlink for binary $(D)/debian/$(PF)/bin/$$i" ; \
			echo "$(PF)/bin/$$i usr/bin/$$i$(SUFFIX)" >> $(D)/debian/$(strip $(call pkgname,$*)).links ; \
		done ; \
	fi
	for man in $$(seq 1 8) ; do \
		for i in $$(ls $(D)/debian/$(strip $(call pkgname,$*))/usr/share/man/man$$man/*.$$man 2>/dev/null || echo -n) ; do \
			echo "Adding upstream version to manpage $$i" ; \
			mv $$i $$(echo $$i | sed -r "s/(\.$$man)$$/$(subst .,\.,$(SUFFIX))\1/g") ; \
		done ; \
	done
	dh_link -p$(call pkgname,$*)
	dh_strip -p$(call pkgname,$*)
	dh_compress -p$(call pkgname,$*)
	dh_fixperms -p$(call pkgname,$*)
	DH_VERBOSE=1 dh_makeshlibs -p$(call pkgname,$*)
	DH_VERBOSE=1 dh_shlibdeps -p$(call pkgname,$*)
	if test $(call pkgname,$*) = python-clang-$(UVERSION) ; then \
		find $(D)/debian/python-clang-$(UVERSION)/usr/share/doc/python-clang-$(UVERSION)/examples -name "*.gz" -exec gzip -d {} \; ; \
		find $(D)/debian/python-clang-$(UVERSION)/usr/share/doc/python-clang-$(UVERSION)/tests    -name "*.gz" -exec gzip -d {} \; ; \
	fi
	dh_installdeb -p$(call pkgname,$*)
	dh_gencontrol -p$(call pkgname,$*)
	dh_md5sums -p$(call pkgname,$*)
	dh_builddeb -p$(call pkgname,$*)
	touch $@

.PHONY: binary binary-arch binary-indep dependency-% debhelper-%
