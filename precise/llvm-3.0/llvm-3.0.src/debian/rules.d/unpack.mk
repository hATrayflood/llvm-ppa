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

clean: 

.PHONY: clean unpack 