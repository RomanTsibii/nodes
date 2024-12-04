FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl
COPY infera /app/infera
RUN chmod +x /app/infera
WORKDIR /app
CMD ["./infera"]
