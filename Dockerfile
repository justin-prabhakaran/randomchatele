# Use the official Dart image as the base image
FROM google/dart:latest

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.yaml pubspec.lock /app/

# Install dependencies
RUN dart pub get

# Copy the entire project to the container
COPY . /app/

# Build the Dart application
RUN dart pub get --offline
RUN dart pub run build_runner build --delete-conflicting-outputs

# Specify the command to run on container start
CMD ["dart", "bin/randomchatele.dart"]

