build:
	DOCKER_BUILDKIT=1 docker build --progress=plain --tag renadbkl/shipping .

run:
	docker run -it --name shipping -p 8080:80 -d renadbkl/shipping
check: 
	curl http://localhost:8080/health
