OINK_MODULE := github.com/pgsty/oink
OINK_LOCAL := $(HOME)/pgsty/oink

default: dev

d:dev
dev:
	HUGO_MODULE_REPLACEMENTS="$(OINK_MODULE) -> $(OINK_LOCAL)" hugo serve

serve:
	hugo serve --environment production --minify --disableFastRender --disableLiveReload

b:build
build:
	hugo build

check:
	GOWORK=off go mod verify
	GOWORK=off hugo --cleanDestinationDir \
		--printPathWarnings --printI18nWarnings --panicOnWarning

check-local:
	HUGO_MODULE_REPLACEMENTS="$(OINK_MODULE) -> $(OINK_LOCAL)" \
		hugo --cleanDestinationDir \
		--printPathWarnings --printI18nWarnings --panicOnWarning

.PHONY: default d dev serve b build check check-local

# generate zh-tw version
translate:
	bin/zh-tw.py

epub:
	bin/epub

.PHONY: default doc translate
