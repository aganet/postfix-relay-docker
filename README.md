# Postfix Gmail Relay Docker Setup
This repository contains a Dockerized setup for a Postfix relay server using Gmail as the SMTP relay host. This setup is useful for relaying emails from your internal applications or systems through Gmail, with environment variables to customize your configuration.

## Features
- Relays emails through Gmail’s SMTP server (smtp.gmail.com).
- Supports authentication via Gmail’s SMTP with SASL credentials.
- Customizable via environment variables (hostname, networks, etc.).
- Secure connection using TLS.
- Automatic configuration of Postfix with Docker.

## Requirements
- **Gmail account that has been configured to use SMTP relay through Google Workspace**
- Docker installed on your system.
- A Gmail account with App Passwords enabled (if using 2-factor authentication).
- Basic understanding of Postfix and email relaying.

## Getting Started
Clone the repository
```bash
git clone https://github.com/aganet/postfix-relay-docker.git
cd postfix-relay-docker
```

## Environment Variables
You can customize the Postfix setup by providing the following environment variables:

- `RELAY_HOST`: The SMTP relay host (default: smtp.gmail.com).
- `RELAY_PORT`: The SMTP port for relay (default: 587).
- `MYHOSTNAME`: The hostname for the Postfix server (default: example.com).
- `MYNETWORKS`: Networks allowed to relay mail through the server (default: 127.0.0.0/8).
- `SASL_PASSWD`: Gmail SMTP username and password in defined in `.env` file.

# Usage
Build the Docker Image:
```bash
docker build -t postfix-relay .
```

## Run the Postfix Relay Server:

You can start the relay server by running the Docker container:

```bash
docker run -d --name postfix-relay \
  -e RELAY_HOST=smtp.gmail.com \
  -e RELAY_PORT=587 \
  -e MYHOSTNAME=mydomain.com \
  -e MYNETWORKS="127.0.0.0/8 192.168.0.0/16" \
  -e SASL_PASSWD="your-email@gmail.com:your-app-password" \
  -p 25:25 \
  postfix-relay
```


Replace your-email@gmail.com and your-app-password with your Gmail credentials. If you're using Gmail 2-factor authentication, you'll need to create an App Password.


## To run via Docker Compose
If you prefer using docker-compose for managing the container, you can create a docker-compose.yml file like this:

```yaml
services:
  postfix:
    image: postfix-relay
    container_name: postfix-relay
    environment:
      RELAY_HOST: smtp.gmail.com
      RELAY_PORT: 587
      MYHOSTNAME: mydomain.com
      MYNETWORKS: "127.0.0.0/8 192.168.0.0/16"
      SASL_PASSWD: "your-email@gmail.com:your-app-password"
    ports:
      - "25:25"
    restart: always

```
Run the service using:

```bash
docker-compose up -d
```
Debugging
If you encounter issues, check the logs for the Postfix container using:

`docker logs postfix-relay` or `docker logs -f postfit-relay`

You may need to ensure that:

- Gmail App Passwords are correctly set up (if using 2FA).
- Your Docker container can connect to the internet.
- You’ve properly configured the `MYNETWORKS` and `SASL_PASSWD` environment variables.

## Security Notes
- App Passwords: If you use Gmail 2-factor authentication, you must use an App Password for authentication instead of your regular Gmail password.
- Environment Variables: It is recommended to securely manage your credentials by using Docker secrets or environment files.
