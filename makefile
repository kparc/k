all:
	rm -rf bin/k
	@npm version patch --silent
	@npm publish

pack:
	./pack.sh
