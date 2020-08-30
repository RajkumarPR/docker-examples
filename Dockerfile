FROM node:alpine AS storefront

WORKDIR /opt/app/my-app

COPY my-app .

RUN npm install

RUN npm run build



FROM maven:alpine AS appserver

WORKDIR /opt/app/spring-boot

COPY spring-boot-react-docker .

COPY --from=storefront /opt/app/my-app/build src/main/resources/static

RUN mvn clean package -DskipTests




FROM java:8-jdk-alpine

RUN adduser -Dh /home/ubuntu rajkumar

WORKDIR /opt/app

COPY --from=appserver /opt/app/spring-boot/target/spring-boot-react-docker-0.0.1-SNAPSHOT.jar .

ENTRYPOINT ["java", "-jar", "/opt/app/spring-boot-react-docker-0.0.1-SNAPSHOT.jar"]

CMD ["--spring.profiles.active=default"]



 
