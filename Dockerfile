# Use a Debian-based image
FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y wget

# Download and install Dart SDK
RUN wget https://dart.dev/get-dart/stable/latest/linux_debian -O dart.tar.gz && \
    tar xf dart.tar.gz && \
    mv dart /opt/dart && \
    rm dart.tar.gz

# Add Dart binaries to the PATH
ENV PATH "$PATH:/opt/dart/bin"

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

