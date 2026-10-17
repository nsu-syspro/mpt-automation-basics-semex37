name := $(shell jq -r .name config.json)
version := $(shell jq -r .version config.json)

src := src/wordcount.c
obj := build/wordcount.o
target := build/$(name)

flags := -Wall -g -DNAME="\"$(name)\"" -DVERSION="\"$(version)\""
CC := cc

all: $(target)

$(target): $(obj) config.json
		@mkdir -p build
		$(CC) $(flags) $(obj) -o $(target)

$(obj): $(src) config.json
		@mkdir -p build
		$(CC) $(flags) -c $(src) -o $(obj)

clean:
		rm -rf build

input = $(wildcard test/*.txt)
output = $(patsubst test/%.txt, build/%.out, $(input))

check: $(target) $(output)

build/%.out: test/%.txt $(target)
	@mkdir -p build
	@./$(target) $< > $@
	@if ! diff -u test/$*.expected $@; then \
		echo "Test $* failed!"; \
		rm -f $@; \
		exit 1; \
	fi
	@rm -f $@
