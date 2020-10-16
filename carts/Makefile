build:
	docker build -t renadbk/carts .

run:
	docker run -it --name carts -p 8081:80 -d renadbk/carts

check:
	curl http://localhost:8081/health
