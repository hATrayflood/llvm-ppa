$(foreach var,BUILDDEPS BUILDCONFLICTS,$(eval \
  $(if $(strip $($(var))),$(eval $(var) :=, $($(var))),$(eval $(var) :=))))

extra_packages:=libclang1 libclang-dev
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

clean: control

.PHONY: clean control debian/control
