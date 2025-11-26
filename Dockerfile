# Use a multi-stage build to keep the image size small
FROM maven:3.9-eclipse-temurin-17 as build
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests -Dmaven.compiler.source=17 -Dmaven.compiler.target=17

# Create the runtime image
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Set the default command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
