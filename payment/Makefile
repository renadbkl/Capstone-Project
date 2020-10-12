up: build run

build:

	docker build -t payment .

run:

	docker run -it --name payment -p 8082:80 -d payment

check:

	curl http://localhost:8082/health

exec:

	docker exec -it payment sh

stop:

	docker stop payment

clean:
	
	docker rm -f payment 
