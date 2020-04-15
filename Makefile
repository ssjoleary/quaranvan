SHELL=bash

.PHONY: compile
compile:
	./utils.sh -c

.PHONY: run
run:
	./utils.sh -r

.PHONY: cr
cr:
	./utils.sh -c -r

.PHONY: unzip
unzip:
	unzip -o game.lua.zip -d game.lua

.PHONY: deploy-staging
deploy-staging:
	make unzip
	netlify deploy --dir=game.lua

.PHONY: deploy-prod
deploy-prod:
	make unzip
	netlify deploy --dir=game.lua --prod

.PHONY: tic-watch
tic-watch:
	tic80 -code-watch build/game.lua
