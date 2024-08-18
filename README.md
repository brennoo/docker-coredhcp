# CoreDHCP Docker Image

This repository provides an automated build and push process for the CoreDHCP Docker image based on the latest commits from the `coredhcp/coredhcp` GitHub repository. The Docker image is automatically tagged with the short commit hash from the upstream repository, ensuring that each image reflects the specific snapshot of the upstream codebase.

## Table of Contents

- [Usage](#usage)
- [Configuration](#configuration)
- [Build Process](#build-process)
- [Contributing](#contributing)
- [License](#license)


## Usage

To use the CoreDHCP Docker image:

```sh
docker run -d --name coredhcp-server -p 67:67/udp brennoo/coredhcp:bd8c808
```

## Configuration

To run the CoreDHCP server using Docker Compose:

 1. Create the config.yaml file:
```yaml
# config.yaml
server4:
  listen:
    - "0.0.0.0%eth0"
  plugins:
    - lease_time: 3600s
    - server_id: 192.168.177.1
    - dns: 1.1.1.1 8.8.8.8
    - router: 192.168.177.1
    - netmask: 255.255.255.0
    - range: leases.txt 192.168.177.100 192.168.177.200 600s
```

 2. Create the docker-compose.yml file:

```yaml
version: '3.8'

services:
  coredhcp:
    image: brennoo/coredhcp:bd8c808
    container_name: coredhcp-server
    network_mode: "host"
    volumes:
      - ./config.yaml:/app/config.yaml
      - ./leases.txt:/app/leases.txt
    environment:
      - COREDHCP_PLUGIN_CONFIG_FILE=/app/config.yaml
    command: ["-config", "/app/config.yaml"]
    cap_add:
      - NET_ADMIN
      - NET_BIND_SERVICE
    expose:
      - "67/udp"
```
3. Run the Docker Compose setup:
```sh
docker-compose up -d
```

For a complete config example please refer to the [config.yaml.example](https://github.com/coredhcp/coredhcp/blob/master/cmds/coredhcp/config.yml.example) file

## Build Process

This repository is configured to automatically build and push Docker images to Docker Hub whenever there are new commits in the `coredhcp/coredhcp` master branch. The images are tagged using the short commit hash from the upstream repository - while their release process is not in place.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss your ideas or improvements.

## License

This project is licensed under the MIT License.
