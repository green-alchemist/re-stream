
# DIY Live Streaming & Restreaming Server

This project provides a powerful, self-hosted, and open-source live streaming server using **NGINX** and **Docker**. It allows you to ingest a single live stream from software like OBS and simultaneously "restream" or "simulcast" it to multiple platforms like Twitch, YouTube, and Kick.

This setup is ideal for IRL streamers who need a robust cloud endpoint for a mobile bonding router, or for any streamer who wants full control over their broadcast pipeline.

-----

## \#\# Features

  * **Self-Hosted:** Full control over your streaming infrastructure.
  * **Multi-Platform Restreaming:** Stream to Twitch, YouTube, Kick, and any other RTMP-compatible service simultaneously.
  * **Secure:** Uses environment variables to handle secret stream keys, keeping them out of your configuration files.
  * **Containerized:** Uses **Docker Compose** for easy, one-command setup and deployment.
  * **Optimized:** Built with a multi-stage `Dockerfile` for a small, secure, and efficient final image.

-----

## \#\# Prerequisites

Before you begin, ensure you have the following installed on your local machine or cloud server:

  * [Docker](https://www.docker.com/products/docker-desktop/)
  * [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)

-----

## \#\# 🚀 Quick Start

1.  **Clone the Repository (or create the files):**
    Ensure you have the project files in a single directory.

2.  **Create your `.env` File:**
    Create a file named `.env` and add your secret stream keys. This file should **never** be committed to version control.

    ```env
    # .env - Store your secret stream keys here
    TWITCH_KEY=live_0000000_xxxxxxxxxxxxxxxxxxxxxxxx
    YOUTUBE_KEY=xxxx-xxxx-xxxx-xxxx-xxxx
    KICK_KEY=sk_us-east-1_xxxxxxxxxxxxxxxxxxxxxxxx?pass=p_xxxxxxxxxx
    ```

3.  **Build and Run the Server:**
    Open a terminal in the project directory and run the following command:

    ```bash
    docker-compose up --build -d
    ```

      * `--build` builds the Docker image the first time you run it.
      * `-d` runs the server in detached (background) mode.

4.  **Configure Your Streaming Software (OBS):**

      * **Service:** `Custom...`
      * **Server:** `rtmp://<YOUR_SERVER_IP>:1935/live` (Use `localhost` if running on your local machine).
      * **Stream Key:** You can put anything here (e.g., `test`), as the server doesn't validate it.

5.  **Go Live\!**
    Start streaming from OBS. Your broadcast will now be automatically sent to all platforms defined in your configuration.

-----

## \#\# Configuration

The server's behavior is controlled by the **`nginx.conf.template`** file. You can add or remove `push` directives to change your streaming destinations. The variables like `${TWITCH_KEY}` are automatically replaced by the values in your `.env` file when the server starts.

```nginx
# nginx.conf.template

rtmp {
    server {
        # ...
        application live {
            live on;

            # Add or remove push destinations here
            push rtmp://live.twitch.tv/app/${TWITCH_KEY};
            push rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_KEY};
            push rtmps://fa7a127ee0.global-contribute.live-video.net/app/${KICK_KEY};
        }
    }
}
```

-----

## \#\# Managing the Server

  * **Start the server:** `docker-compose up -d`
  * **Stop the server:** `docker-compose down`
  * **View live logs:** `docker-compose logs -f`
  * **Check status:** `docker-compose ps`

-----

## \#\# 🛠️ Project Structure

```
.
├── .env                  # Your secret stream keys (IGNORED BY GIT)
├── .dockerignore         # Specifies files to exclude from Docker build context
├── .gitignore            # Specifies files for Git to ignore
├── docker-compose.yml    # Defines the Docker service and configuration
├── Dockerfile            # Instructions for building the Docker image
├── nginx.conf.template   # NGINX configuration template
├── README.md             # This file
└── start.sh              # Startup script to generate config and start NGINX
```