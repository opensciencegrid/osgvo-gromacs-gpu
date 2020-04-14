# based on Dockerfile from Mario David <mariojmdavid@gmail.com> (https://github.com/mariojmdavid/docker-gromacs-cuda/)

FROM nvidia/cuda:10.1-devel
MAINTAINER Mats Rynge <rynge@isi.edu>

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        cmake \
        g++ \
        wget \
        tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp \
    && wget http://ftp.gromacs.org/pub/gromacs/gromacs-2020.1.tar.gz \
    && tar zxvf gromacs-2020.1.tar.gz \
    && cd gromacs-2020.1 \
    && mkdir -p /tmp/gromacs-2020.1/build \
    && cd /tmp/gromacs-2020.1/build \
    && cmake .. -DGMX_BUILD_OWN_FFTW=ON -DGMX_GPU=on \
    && make \
    && make install \
    && rm -rf /tmp/gromacs-*

# required directories
RUN for MNTPOINT in \
        /cvmfs \
        /hadoop \
        /hdfs \
        /lizard \
        /mnt/hadoop \
        /mnt/hdfs \
        /xenon \
        /spt \
        /stash2 \
    ; do \
        mkdir -p $MNTPOINT ; \
    done


# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs /etc/OpenCL/vendors

# some extra singularity stuff
COPY .singularity.d /.singularity.d

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

