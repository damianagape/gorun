FROM node:24-bookworm
USER root:root
WORKDIR /
ENTRYPOINT []
CMD ["bash"]

ENV NODE_ENV="development"

COPY ./Dockerfile.bash /Dockerfile.bash
RUN /Dockerfile.bash && rm /Dockerfile.bash
