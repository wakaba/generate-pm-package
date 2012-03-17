PERL = perl
GENERATEPM = bin/generate-pm-package
GENERATEPM_ = $(PERL) $(GENERATEPM)

all: config/perl/modules.txt

config/perl/modules.txt:
	mkdir -p config/perl
	perl -e 'for (@ARGV) { my $$def = do $$_; print map { $$_ . "\n" } (keys %{$$def->{req_modules} || {}}, keys %{$$def->{t_req_modules} || {}}) }' config/dist/*.pi > $@

dist: dist-generate-pm-package

dist-generate-pm-package:: \
dist-%: config/dist/%.pi
	$(GENERATEPM_) $< dist

## License: Public Domain.
