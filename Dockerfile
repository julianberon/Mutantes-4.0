# Build stage using Maven and JDK 17
FROM maven:3.9-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copy pom.xml from nested project directory
COPY Mercado_Libre_Mutantes-main/Mercado_Libre_Mutantes-main/pom.xml ./pom.xml
RUN mvn dependency:go-offline -B

# Copy source code from nested path
COPY Mercado_Libre_Mutantes-main/Mercado_Libre_Mutantes-main/src ./src

# Package the application (skip tests for faster container build)
RUN mvn clean package -DskipTests -DskipITs

# Runtime stage with slim JRE
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
EXPOSE 8080

# Copy the built jar (artifact name pattern may vary)
COPY --from=build /app/target/*.jar ./app.jar

ENTRYPOINT ["java", "-jar", "./app.jar"]
