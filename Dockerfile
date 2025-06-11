# ---- Stage 1: Build the application ----
FROM maven:3.9.3-eclipse-temurin-17 AS build

WORKDIR /app

# Copy only the pom.xml first and download dependencies (for better caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application code
COPY . .

# Package the application
RUN mvn clean package -DskipTests


# ---- Stage 2: Run the application ----
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the packaged jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
