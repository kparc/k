all:
	@npm version patch --silent
	@npm publish
