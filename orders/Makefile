build:
	docker build -t renadbkl/orders .

run:
	docker run -it --name orders -p 8083:80 renadbkl/orders

check:
	curl http://localhost:8083/health
