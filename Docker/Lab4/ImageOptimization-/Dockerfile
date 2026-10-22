FROM maven:3.9-eclipse-temurin-17

WORKDIR /app

COPY . .

RUN if [ -d ".m2" ]; then cp -r .m2 /root/.m2; fi && \
    mvn package -DskipTests

EXPOSE 8080

CMD ["java", "-jar", "target/demo-0.0.1-SNAPSHOT.jar"]
