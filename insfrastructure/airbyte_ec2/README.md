### Install Docker, Docker Compose, and Airbyte

1. Use the following script to install docker and docker compose v2.

   ```bash
   #!/bin/bash

   # Install Docker
   # Reference: https://docs.airbyte.com/deploying-airbyte/on-aws-ec2
   sudo yum update -y;
   sudo yum install -y docker;

   # Start the docker service
   sudo service docker start;

   # Add the current user to the docker group
   sudo usermod -a -G docker $USER;

   # Manually install docker compose
   # Reference: https://docs.docker.com/compose/install/linux/#install-the-plugin-manually
   DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker};
   mkdir -p $DOCKER_CONFIG/cli-plugins;
   curl -SL https://github.com/docker/compose/releases/download/v2.24.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose;
   chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose;
   docker compose version;

   # logout of the instance
   exit
   ```

2. Log into the instance again and use the following script to install airbyte

   ```bash
   # Download and run airbyte
   mkdir airbyte && cd airbyte;
   wget https://raw.githubusercontent.com/airbytehq/airbyte/master/run-ab-platform.sh;
   chmod +x run-ab-platform.sh;
   ./run-ab-platform.sh -b;
   ```