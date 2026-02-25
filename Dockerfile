FROM agent0ai/agent-zero-base:latest

ARG BRANCH=local
ENV BRANCH=$BRANCH

# Copy filesystem files to root
COPY ./docker/run/fs/ /

# Copy current development files
COPY ./ /git/agent-zero

# pre installation steps
RUN bash /ins/pre_install.sh $BRANCH

# install A0
RUN bash /ins/install_A0.sh $BRANCH

# install additional software
RUN bash /ins/install_additional.sh $BRANCH

# cleanup repo and install A0 without caching
ARG CACHE_DATE=none
RUN echo "cache buster $CACHE_DATE" && bash /ins/install_A02.sh $BRANCH

# post installation steps
RUN bash /ins/post_install.sh $BRANCH

# Fix scipy/numpy ufunc compatibility issue
RUN . /opt/venv-a0/bin/activate && pip install --force-reinstall scipy==1.13.1

# Port 80 (AgentZero default)
ENV PORT=80
ENV WEB_UI_PORT=80
EXPOSE 80

RUN chmod +x /exe/initialize.sh /exe/run_A0.sh /exe/run_searxng.sh /exe/run_tunnel_api.sh

CMD ["/exe/initialize.sh", "local"]
