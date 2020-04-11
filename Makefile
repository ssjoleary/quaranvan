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

.PHONY: deploy-staging
deploy-staging:
	netlify deploy --dir=game.lua

.PHONY: deploy-prod
deploy-prod:
	netlify deploy --dir=game.lua --prod
