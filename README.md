# Postfix Gmail Relay Docker Setup
This repository contains a Dockerized Postfix service setup configured as a Gmail SMTP relay. The container runs Postfix with SASL authentication to send emails through Gmail's SMTP server.

## Features
- Relays emails through Gmail’s SMTP server (smtp.gmail.com).
- Supports authentication via Gmail’s SMTP with SASL credentials.
- Customizable via environment variables (hostname, networks, etc.).
- Secure connection using TLS.
- Automatic configuration of Postfix with Docker.

## Requirements
- Docker: Ensure Docker is installed on your machine.
- Gmail Workspace Account: This setup only works with Gmail accounts configured for relay via Google Workspace (formerly G Suite). It does not work with regular Gmail accounts. To set up Gmail as a relay, your Google Workspace admin needs to configure Gmail SMTP relay in your domain.
- SMTP Credentials: You will need to provide your Google Workspace email and app password in the .env file.
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
If you prefer using docker-compose for managing the container, use the existind docket-compose.yml

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
