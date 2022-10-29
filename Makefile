user_config_dir := ${HOME}/.config
backup_dir := backup
org_files = $(shell find org/ -name "*.org")
config_files = $(patsubst org/%.org, config/%, $(org_files))
user_config_files = $(patsubst config/%, $(user_config_dir)/%, $(config_files))
backup_config_files = $(patsubst config/%, $(backup_dir)/%, $(config_files))

link: tangle backup
	$(MAKE) $(user_config_files)
$(user_config_dir)/%: config/%
	mkdir -p `dirname $@` && ln -s $(abspath $^) $(abspath $@)

tangle: $(config_files)
config/%: org/%.org
	emacs --batch --eval "(require 'org)" --eval "(org-babel-tangle-file \"$<\")"
config/:
	mkdir config

backup: $(backup_config_files)
$(backup_dir)/%: $(user_config_dir)/%
	- mkdir -p $@ && mv -b $^ $@

clean:
	rm -rf config $(backup_dir)

.PHONY: clean tangle link backup
