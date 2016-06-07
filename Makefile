default: build

build:
	docker build -t kevinjqiu/viper .

push:
	docker push kevinjqiu/viper
