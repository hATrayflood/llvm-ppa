unpack: $(unpack-stamp)
$(unpack-stamp): $(addprefix $(unpack-stamp)-,$(tarball))
	mkdir -p $(@D)
	$(call $(PKGNAME)_extra_unpack)
	touch $@

$(unpack-stamp)-%:
	test -d $(stampdir) || mkdir $(stampdir)
	if ! test -z "$(tarball)" ; then \
	  $(RM) -r $(srcdir) ; \
	  case $(tarball) in \
	    *.bz2) tar -x --bzip2 -f $(tarpath);; \
	    *.gz)  tar -x --gzip  -f $(tarpath);; \
	    *.lzma) lzcat $(tarpath) | tar -x -f -;; \
	    *.xz) xzcat $(tarpath) | tar -x -f -;; \
	    *)     false;; \
	  esac ; \
	fi
	touch $@

patches := $(foreach patchdir,$(patchdirs),$(wildcard $(patchdir)/*.patch))

patches_rev := # nothing
$(foreach patch,$(patches),$(eval patches_rev := $(patch) $(patches_rev)))

patch: $(patch-stamp)
$(patch-stamp): $(unpack-stamp)
	test -d $(stampdir)/patches || mkdir -p $(stampdir)/patches
	cd $(srcdir) && for patch in $(patches) ; do \
	  test -f "$$patch" || continue; \
	  if ! test -f $(stampdir)/patches/$$(echo $$patch | tr "/" "_") ; \
	    then echo "Applying patch: $$patch" && patch -p1 < $$patch ; \
	      test $$? = 0 || exit 1 ; \
	    touch $(stampdir)/patches/$$(echo $$patch | tr "/" "_") ; \
	    echo ; \
	  fi ; \
	done
	touch $@

unpatch:
	test -d $(stampdir)/patches || mkdir -p $(stampdir)/patches
	test -z "$(tarball)" || (test -d $(srcdir) || mkdir $(srcdir))
	cd $(srcdir) && for patch in $(patches_rev) ; do \
	  test -f "$$patch" || continue; \
	  if test -f $(stampdir)/patches/$$(echo $$patch | tr "/" "_") ; \
	    then echo "Reverting patch: $$patch" && patch -p1 -R < $$patch ; \
	      test $$? = 0 || exit 1 ; \
	    $(RM) $(stampdir)/patches/$$(echo $$patch | tr "/" "_") ; \
	    echo ; \
	  fi ; \
	done
	$(RM) -r $(stampdir)/patches
	$(RM) $(patch-stamp)

clean: unpatch

.PHONY: clean unpack patch unpatch
