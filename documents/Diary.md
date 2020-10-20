Day 1:
i spent the day searching and oberving the sockshop project, and i created the github repo for the project and added the microservices,
 and i made the trello boerd. then i started running the microservices locally.


Day 2:
more services to run locally and it took me more than i thought, and i created makefiles and fixed dockerfiles and some other files.

Day 3:
I had a problem with some of the microservises because the version is not updated, so i had to go to almost everyfile and fix that,
and also i had a problem runnig load-test and i had to specify the host number aka the pivate ip in the docker run command to make it work.
 and finally all the microservices worked locally. and i pushed all the images

Day 4,5:
i fixed user-db dockerfile and i created docker secrets installed tekton and i made sa, pipline resource, task, taskrunner files and i had this error " Error running git [submodule init]" because there is
another reposetory inside mine and it has .git folder so i deleted it then finally the taskrun succeed for front-end microservice
