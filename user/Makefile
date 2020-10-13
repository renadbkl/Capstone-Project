build:

	docker build -t renadbkl/user .

run:

	docker run -it --name user -p 80:80 -d renadbkl/user

check:

	curl http://localhost:8080/health

stop:

	docker stop user

clean:
	
	docker rm -f user
