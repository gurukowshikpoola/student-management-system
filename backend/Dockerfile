# ==========================================================
# Build stage
# ==========================================================
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven configuration
COPY pom.xml .

# Copy source code
COPY src ./src

# Build WAR file
RUN mvn clean package -DskipTests


# ==========================================================
# Runtime stage
# ==========================================================
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the generated WAR
COPY --from=build /app/target/*.war app.war

# Start the Spring Boot WAR application
CMD ["java", "-jar", "app.war"]