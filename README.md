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
### 1. Clone the repository
```bash
git clone https://github.com/yourusername/postfix-gmail-relay.git
cd postfix-gmail-relay
```

### 2. Create a `.env` file

You need to create a `.env` file in the root of the repository with the following content:

```bash
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
```

- Replace `your-email@gmail.com` with your Gmail email.
- Replace `your-app-password` with your Gmail App Password.


### 3. Build the Docker image

```bash
docker build -t postfix-relay:latest .
```

### 4. Run the Docker container

You can start the container using Docker Compose. It will automatically configure Postfix based on the environment variables defined in the `.env` file.

```bash
docker-compose up -d
```


### 5. Configuration

The following environment variables are used to configure the container:

| Variable      | Description                                                    | Default Value           |
|---------------|----------------------------------------------------------------|-------------------------|
| `RELAY_HOST`  | The relay SMTP server host (usually Gmail SMTP)                | `smtp.gmail.com`        |
| `RELAY_PORT`  | The relay SMTP server port                                      | `587`                   |
| `MYHOSTNAME`  | The hostname to use for Postfix                                 | `example.com`           |
| `MYNETWORKS`  | Networks allowed to relay mail                                  | `127.0.0.0/8`           |
| `SASL_PASSWD` | SASL authentication (username:password)                        | **Required**            |

You can override these values by setting them in the `.env` file or directly in the `docker-compose.yml` file.

### 6. Test Email Sending

Once the container is up and running, you can test the email relay by using tools like `mail` or `sendmail`. Inside the running container:

```bash
docker exec -it postfix-gmail-relay bash
echo "Test email body" | mail -s "Test Subject" recipient@example.com
```

### 7. Logs

The container outputs Postfix logs to the console. You can view them with:
`docker logs postfix-relay` or `docker logs -f postfix-relay`


## Volumes

If you need persistent storage for Postfix queues, uncomment the `volumes` section in the `docker-compose.yml`:

```yaml
volumes:
  - ./postfix-spool:/var/spool/postfix
```

This will mount the host directory `./postfix-spool` to store the Postfix spool.

## Ports

The default port exposed is `25`. If you need to change it, modify the `ports` section in `docker-compose.yml`:

```yaml
ports:
  - "25:25"
```

## Troubleshooting

- **Error: SASL_PASSWD environment variable must be set**: Ensure that `SASL_PASSWD` is properly defined in the `.env` file as `user:password`.
- **TLS or authentication errors**: Ensure your Gmail account uses an App Password if you have 2FA enabled.




