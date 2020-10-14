FROM  maven:3-jdk-8-slim AS build
RUN mkdir -p /qm
COPY . /qm
WORKDIR /qm
RUN mvn clean package

FROM java:openjdk-8-alpine
COPY --from=build /qm/target/*.jar ./app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/urandom","-jar","./app.jar", "--port=80"]
