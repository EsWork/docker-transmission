all: build

build:
	@docker build --tag=eswork/transmission .

release: build
	@docker build --tag=eswork/transmission .
