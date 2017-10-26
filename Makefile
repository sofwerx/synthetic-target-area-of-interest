TMPDIR := $(shell mktemp -d)

requirements.txt: */*.py */*/*.py */*/*/*.py
	pip install virtualenv pipreqs
	pipreqs . --force
	virtualenv $(TMPDIR)/staoi
	[ -n "$(TMPDIR)" -a -d $(TMPDIR) ]
	. $(TMPDIR)/staoi/bin/activate \
		&& pip install -r $@ \
		&& pip freeze > $@ \
		&& deactivate \
		&& rm -fr $(TMPDIR)/cybertick \
		&& rmdir $(TMPDIR)

