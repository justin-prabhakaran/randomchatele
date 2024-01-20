# Use the official Dart image as the base image
FROM google/dart:latest

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.yaml pubspec.lock /app/

# Install dependencies
RUN pub get

# Copy the entire project to the container
COPY . /app/

# Build the Dart application
RUN pub get --offline
RUN pub build

# Specify the command to run on container start
CMD ["dart", "build/bin/main.dart"]
