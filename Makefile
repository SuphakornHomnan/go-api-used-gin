.PHONY: build maria

build:
	go build -ldflags "-X main.buildcommit=`git rev-parse --short HEAD` -X main.buildtime=`date "+%Y-%m-%dT%H:%M:%S%Z:00"`" -o app

maria:
	docker run -d \
    --name my-mariadb \
    -p 3306:3306 \
    -v ~/apps/mariadb/data:/var/lib/mysql \
    --user 1000:1000 \
    -e MYSQL_ROOT_PASSWORD=S3cret \
    -e MYSQL_PASSWORD=An0thrS3crt \
    -e MYSQL_USER=citizix_user \
    -e MYSQL_DATABASE=myapp \
    mariadb:10.7

image:
	docker build -t todo:test -f Dockerfile .

container:
	docker run -p 8081:8081 --env-file ./local.env  --link my-mariadb  --name myapp todo:test