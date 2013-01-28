$(foreach var,BUILDDEPS BUILDCONFLICTS,$(eval \
  $(if $(strip $($(var))),$(eval $(var) :=, $($(var))),$(eval $(var) :=))))

packages := $(foreach build,$(builds),$($(build)_packages))
packages += $(extra_packages)

debian/control:
	@echo Regenerating control file...
	sed -e "s/@PKGSOURCE@/$(PKGSOURCE)/g"			\
	    -e "s/ *@BUILDDEPS@/$(BUILDDEPS)/g"			\
	    -e "s/ *@BUILDCONFLICTS@/$(BUILDCONFLICTS)/g"	\
	    -e "s/@UVERSION@/$(UVERSION)/g"			\
	    -e "s/@GCC_VERSION@/$(gcc_version)/g"		\
	    -e "s/@PKG_VERSION@/$(pkg_version)/g"		\
	    -e "s/ , /, /g"					\
	    $@.in/source $(addprefix $@.in/,$(packages)) > $@

control: debian/control

diffstats:
	@echo Updating diffstats...
	for patch in $(D)/debian/patches/*.patch ; do \
	  test -f "$$patch" || continue; \
	  (echo '---' ; \
	   diffstat $${patch} ; \
	   echo ; \
	   cat $${patch} | awk '/^---$$/ {put=0} /^[a-zA-Z0-9]/ {put=1} /^--- / {put=1} put==1' ; \
	  ) > $${patch}T && \
	  sed -r '/^Index: /d;/^={67}$$/d' -i $${patch}T ; \
	  diff -U 0 $${patch} $${patch}T ; \
	  mv -f $${patch}T $${patch} ; \
	done

clean: control diffstats

.PHONY: clean control debian/control diffstats
