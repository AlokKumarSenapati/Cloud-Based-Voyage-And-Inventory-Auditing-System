# =====================================================================
# Stage 1: Build the React Frontend
# =====================================================================
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# =====================================================================
# Stage 2: Build the Spring Boot Application
# =====================================================================
FROM maven:3.9.9-eclipse-temurin-21-alpine AS backend-builder
WORKDIR /app/backend

# Copy backend dependencies first for layer caching
COPY backend/pom.xml ./
RUN mvn dependency:go-offline -B

# Copy backend sources
COPY backend/src ./src

# Copy built frontend assets into Spring Boot static resources
COPY --from=frontend-builder /app/frontend/dist/ ./src/main/resources/static/

# Package the production JAR
RUN mvn clean package -DskipTests

# =====================================================================
# Stage 3: Lightweight Production JRE Runtime
# =====================================================================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Create non-root system user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy JAR from backend-builder stage
COPY --from=backend-builder /app/backend/target/*.jar app.jar

# Expose Spring Boot port
EXPOSE 8080

# Production JVM configurations
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC"
ENV SPRING_PROFILES_ACTIVE="prod"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

