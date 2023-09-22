user_config_dir := $(abspath ${HOME}/.config)
backup_dir := $(abspath ./backup)
org_files = $(shell find org/ -name "*.org")
created_config_files = $(patsubst org/%.org, config/%, $(org_files))
existing_config_files = $(shell find config/ -mindepth 1 -maxdepth 1)
user_config_files = $(patsubst config/%, $(user_config_dir)/%, $(existing_config_files))
backup_config_files = $(patsubst config/%, $(backup_dir)/%, $(existing_config_files))


backup: $(backup_config_files)
$(backup_dir)/%:
	- mkdir -p `dirname $@` && mv $(patsubst $(backup_dir)/%, $(user_config_dir)/%, $(abspath $@)) $@

tangle: $(created_config_files)

config/%: org/%.org
	emacs --batch --eval "(require 'org)" --eval "(org-babel-tangle-file \"$<\")"
config/:
	mkdir config

link: tangle 
	$(MAKE) backup
	$(MAKE) $(user_config_files)
$(user_config_dir)/%: config/%
	mkdir -p `dirname $@` && ln -s $(abspath $^) $(abspath $@)

clean:
	rm -rf $(created_config_files) $(backup_dir)

.PHONY: clean tangle link backup
