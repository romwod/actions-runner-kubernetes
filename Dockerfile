# GitHub's Linux runners default to the latest Ubunutu
# https://help.github.com/en/actions/automating-your-workflow-with-github-actions/virtual-environments-for-github-hosted-runners#supported-runners-and-hardware-resources
# Ubuntu uses the latest tag to represent the latest stable release
# https://hub.docker.com/_/ubuntu/
FROM ubuntu:latest

# Add our installation script
COPY install.sh /root/

# Install and update the system in one tidy layer
ARG ACTIONS_RUNNER_VERSION="2.165.2"
ENV ACTIONS_RUNNER_VERSION=$ACTIONS_RUNNER_VERSION
RUN /bin/bash /root/install.sh

# Run as the runner user instead of root
WORKDIR /home/runner
USER runner
ENV COMPOSE_DOCKER_CLI_BUILD=1
ENV DOCKER_CLI_EXPERIMENTAL=enabled
ENV DOCKER_BUILDKIT=1
ENV PATH="/opt/dc:${PATH}"
COPY *.sh ./
RUN /bin/bash ./test.sh
ENTRYPOINT ["/bin/bash", "./entrypoint.sh"]
