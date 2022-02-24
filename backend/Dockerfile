FROM maven:3.8.4-eclipse-temurin-17 AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:17.0.2-oraclelinux7
COPY --from=build /usr/src/app/target/fileshare-0.1.0.jar /usr/app/fileshare-0.$
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/app/fileshare-0.1.0.jar"]