help:
	@cat Makefile

DATA?="$(pwd)/data"
ROOT?="$(pwd)/tmp"
DOCKER=nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.6
SRC?=data

build:
	docker build -t keras --build-arg python_version=$(PYTHON_VERSION) .

bash: build
	$(DOCKER) run -it --rm -v $(SRC):/src/workspace -v $(DATA):/data -v $(ROOT):/root --env KERAS_BACKEND=$(BACKEND) keras bash

ipython: build
	$(DOCKER) run -it --rm -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras ipython

jupyter: build
	$(DOCKER) run -it --rm -v $(SRC):/src/workspace -v $(DATA):/data -v $(ROOT):/root --net=host --env KERAS_BACKEND=$(BACKEND) keras
