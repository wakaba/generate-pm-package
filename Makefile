PERL = perl
WGET = wget
GIT = git
GENERATEPM = bin/generate-pm-package
GENERATEPM_ = $(PERL) $(GENERATEPM)

all: config/perl/modules.txt pmb-install

config/perl/modules.txt: $(wildcard config/dist/*.pi)
	mkdir -p config/perl
	$(PERL) -e 'for (@ARGV) { my $$def = do $$_; print map { $$_ . "\n" } (keys %{$$def->{req_modules} || {}}, keys %{$$def->{t_req_modules} || {}}) }' config/dist/*.pi > $@

Makefile-setupenv: Makefile.setupenv
	$(MAKE) --makefile Makefile.setupenv setupenv-update \
	    SETUPENV_MIN_REVISION=20120313

Makefile.setupenv:
	$(WGET) -O $@ https://raw.github.com/wakaba/perl-setupenv/master/Makefile.setupenv

pmb-update pmb-install \
lperl local-perl perl-version perl-exec \
: %: Makefile-setupenv config/perl/modules.txt
	$(MAKE) --makefile Makefile.setupenv $@

dist: dist-generate-pm-package

dist-generate-pm-package:: \
dist-%: config/dist/%.pi
	$(GENERATEPM_) $< dist --generate-json

dist-wakaba-packages: local/wakaba-packages dist
	cp dist/*.json local/wakaba-packages/data/perl/
	cp dist/*.tar.gz local/wakaba-packages/perl/
	cd local/wakaba-packages && $(MAKE) all

local/wakaba-packages: always
	$(GIT) clone "git@github.com:wakaba/packages.git" $@ || (cd $@ && git pull)
	cd $@ && git submodule update --init

always:

## License: Public Domain.
