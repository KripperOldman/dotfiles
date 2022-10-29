org_files := $(shell find org/ -name "*.org")
config_files := config/$(patsubst org/%.org, config/%, $(org_files))

tangle: $(config_files)
config/%: org/%.org
	emacs --batch --eval "(require 'org)" --eval "(org-babel-tangle-file \"$<\")"
config/:
	mkdir config
clean:
	rm -rf ./config

.PHONY: clean tangle
