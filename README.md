# Postfix Gmail Relay Docker Setup
This repository contains a Dockerized Postfix service setup configured as a Gmail SMTP relay. The container runs Postfix with SASL authentication to send emails through Gmail's SMTP server.

## Features
- Relays emails through Gmail’s SMTP server (smtp.gmail.com).
- Supports authentication via Gmail’s SMTP with SASL credentials.
- Customizable via environment variables (hostname, networks, etc.).
- Secure connection using TLS.
- Automatic configuration of Postfix with Docker.

## Requirements
⚠️ **Important**: This solution only works with Gmail Workspace accounts that have SMTP relay configured. It will not work with regular Gmail accounts.

- Docker: Ensure Docker is installed on your machine.
- Gmail Workspace Account: This setup only works with Gmail accounts configured for relay via Google Workspace (formerly G Suite). It does not work with regular Gmail accounts. To set up Gmail as a relay, your Google Workspace admin needs to configure Gmail SMTP relay in your domain.
- SMTP Credentials: You will need to provide your Google Workspace email and app password in the .env file.
- Basic understanding of Postfix and email relaying.


## Getting Started
### 1. Clone the repository
```bash
git clone https://github.com/aganet/postfix-relay-docker.git
cd postfix-relay-docker
```

### 2. Create a `.env` file  and edit Variables in docker-compose.yaml (MYNETWORKS, etc... )

You need to create a `.env` file in the root of the repository with the following content:

```bash
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
```

- Replace `your-email@gmail.com` with your Gmail email.
- Replace `your-app-password` with your Gmail App Password.


### 3. Build the Docker image

```bash
docker build -t postfix-relay:latest ./build

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

Test the relay from another computer (replace xx with the IP of the host running this docker)
```bash
telnet xx.xx.xx.xx 25

```



Edit and paste the following: 
```bash
EHLO testclient.com
MAIL FROM:<name@gmail.com>
RCPT TO:<name@gmail.com>
DATA
Subject: Test Email

This is a test email sent through the Postfix relay.
     
.
QUIT


```

Check docker logs for error messages 



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

- **Authentication failed**: Check if your Gmail Workspace account is properly configured for SMTP relay.
- **Connection refused on port 25**: Ensure no other services are using port 25 on your host machine. (If postfix is already installed on the host machine could possible use port25 , disable postfix on main host machine `systemctl stop postfix && systemctl disable postfix` ) 
- **TLS/SSL errors**: Verify that your SMTP settings and certificates are correct and up to date.



