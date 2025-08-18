# Use Maven with Eclipse Temurin JDK 17 as the build image
FROM maven:3.9.11-eclipse-temurin-17 AS build

# Set environment variable 'name' to 'PROD'
ENV name=PROD

# Clone the Spring Petclinic repository and build the project using Maven
RUN git clone https://github.com/spring-projects/spring-petclinic.git && \
    cd spring-petclinic && \
    mvn package


# Use a minimal Eclipse Temurin JRE 17 image for running the application
FROM eclipse-temurin:17.0.16_8-jre-ubi9-minimal AS runtime

# Define build arguments for user name and working directory
ARG user_name=testuser
ARG directory=/usr/share/demo

# Create a new user with the specified home directory
RUN adduser -m -d ${directory} -s /bin/bash ${user_name}

# Switch to the non-root user for better security
USER ${user_name}

# Set the working directory
WORKDIR ${directory}

# Copy the built JAR file from the build image
COPY --from=build /spring-petclinic/target/*.jar ck.jar

# Expose port 8080 for the application
EXPOSE 8080/tcp

# Set the default command to run the Spring Boot application
CMD ["java", "-jar", "ck.jar"]