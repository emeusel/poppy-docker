FROM alpine:latest
MAINTAINER Théo Segonds <theo.segonds@inria.fr>

# Inspired from :
# * https://github.com/jupyter/docker-stacks
# * https://github.com/CognitiveScale/alpine-miniconda


# Install glibc and usefull packeges
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \ 
    && apk --update add \
    bash \
    git \
    curl \
    ca-certificates \
    bzip2 \
    unzip \
    sudo \
    libstdc++ \
    glib \
    libxext \
    libxrender \
    tini@testing \
    && curl "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" -o glibc.apk \
    && apk add --allow-untrusted glibc.apk \
    && curl "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" -o glibc-bin.apk \
    && apk add --allow-untrusted glibc-bin.apk \
    && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
    && rm -rf glibc*apk /var/cache/apk/*


# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV NB_USER jovyan
ENV NB_UID 1000
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create jovyan user with UID=1000 and in the 'users' group
RUN adduser -s /bin/bash -u $NB_UID -D $NB_USER && \
    mkdir -p /opt/conda && \
    chown jovyan /opt/conda

USER jovyan

# Setup jovyan home directory
RUN mkdir /home/$NB_USER/work && \
    mkdir /home/$NB_USER/.jupyter && \
    mkdir /home/$NB_USER/.local

# Install conda as jovyan
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    curl https://repo.continuum.io/miniconda/Miniconda3-3.18.3-Linux-x86_64.sh  -o miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    $CONDA_DIR/bin/conda install --yes conda==3.18.3


USER root


# Configure container startup as root
WORKDIR /home/$NB_USER/work
ENTRYPOINT ["tini", "--"]
CMD [ "/bin/bash" ]

# Switch back to jovyan to avoid accidental container runs as root
USER jovyan
