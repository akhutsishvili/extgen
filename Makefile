all: install

current_dir = $(shell pwd)

install:
	echo alias extgen=\"ruby $(current_dir)/main.rb\" >> ~/.bashrc
