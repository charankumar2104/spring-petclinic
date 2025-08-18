    cd spring-petclinic && \
    mvn package

# Use Maven with Eclipse Temurin JDK 17 as the build image
FROM maven:3.9.11-eclipse-temurin-17 AS build

# Clone the Spring Petclinic repository and build the project using Maven
RUN git clone https://github.com/spring-projects/spring-petclinic.git && \
    cd spring-petclinic && \
    mvn package



# Use a minimal Eclipse Temurin JRE 17 image for running the application
FROM eclipse-temurin:17.0.16_8-jre-ubi9-minimal AS runtime

# Create a new user 'testuser' with home directory /usr/share/demo
RUN adduser -m -d /usr/share/demo -s /bin/bash testuser

# Switch to the non-root user for better security
USER testuser

# Set the working directory
WORKDIR /usr/share/demo

# Copy the built JAR file from the build image
COPY --from=build /spring-petclinic/target/*.jar ck.jar

# Expose port 8080 for the application
EXPOSE 8080/tcp

# Set the default command to run the Spring Boot application
CMD ["java", "-jar", "ck.jar"]
