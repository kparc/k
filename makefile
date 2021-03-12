all:
	@npm version patch --silent
	@npm publish

pack:
	./pack.sh
