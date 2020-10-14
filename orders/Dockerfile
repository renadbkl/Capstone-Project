FROM maven:3-jdk-8-slim AS base
RUN mkdir -p /orders
COPY . /orders
WORKDIR  /orders
RUN mvn clean package


FROM weaveworksdemos/msd-java:jre-latest

COPY --from=base /orders/target/*.jar ./app.jar

RUN	chown -R ${SERVICE_USER}:${SERVICE_GROUP} ./app.jar

USER ${SERVICE_USER}

ENTRYPOINT ["/usr/local/bin/java.sh","-jar","./app.jar", "--port=80"]
