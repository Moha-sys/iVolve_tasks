# Part 2: Build Locally
FROM eclipse-temurin:17-jre

# Set working directory
WORKDIR /app

# Create a non-root user to control the container
RUN useradd -m -u 1001 appuser

# Copy the pre-built JAR file from local build
COPY target/calculator.jar app.jar

# Give non-root user ownership of the application directory
RUN chown -R appuser:appuser /app

# Expose port 8080
EXPOSE 8080

# Switch to non-root user
USER appuser

# Run the application
CMD ["java", "-jar", "app.jar"]
