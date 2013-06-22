$(foreach var,BUILDDEPS BUILDCONFLICTS,$(eval \
  $(if $(strip $($(var))),$(eval $(var) :=, $($(var))),$(eval $(var) :=))))

extra_packages:=libclang1 libclang-dev libclang-common-dev
packages := $(foreach build,$(builds),$($(build)_packages))
packages += $(extra_packages) 

debian/control:
	@echo Regenerating control file...
	sed -e "s/@PKGSOURCE@/$(PKGSOURCE)/g"			\
	    -e "s/ *@BUILDDEPS@/$(BUILDDEPS)/g"			\
	    -e "s/ *@BUILDCONFLICTS@/$(BUILDCONFLICTS)/g"	\
	    -e "s/@UVERSION@/$(UVERSION)/g"			\
	    -e "s/@GCC_VERSION@/$(GCC_VERSION)/g"		\
	    -e "s/@PKG_VERSION@/$(pkg_version)/g"		\
	    -e "s/ , /, /g"					\
	    $@.in/source $(addprefix $@.in/,$(packages)) > $@

control: debian/control

clean: control

.PHONY: clean control debian/control
