PERL = perl
GENERATEPM = bin/generate-pm-package
GENERATEPM_ = $(PERL) $(GENERATEPM)

all: config/perl/modules.txt config/perl/libs.txt

config/perl/modules.txt: $(wildcard config/dist/*.pi)
	mkdir -p config/perl
	perl -e 'for (@ARGV) { my $$def = do $$_; print map { $$_ . "\n" } (keys %{$$def->{req_modules} || {}}, keys %{$$def->{t_req_modules} || {}}) }' config/dist/*.pi > $@

Makefile-setupenv: Makefile.setupenv
	$(MAKE) --makefile Makefile.setupenv setupenv-update \
	    SETUPENV_MIN_REVISION=20120313

Makefile.setupenv:
	wget -O $@ https://raw.github.com/wakaba/perl-setupenv/master/Makefile.setupenv

config/perl/libs.txt \
carton-install carton-update carton-install-module \
local-perl perl-version perl-exec: %: Makefile-setupenv config/perl/modules.txt
	$(MAKE) --makefile Makefile.setupenv $@

dist: dist-generate-pm-package

dist-generate-pm-package:: \
dist-%: config/dist/%.pi
	$(GENERATEPM_) $< dist

## License: Public Domain.
