all: .foo

.foo: Dockerfile
	docker build -t senax/sysbench:latest .
	touch .foo
