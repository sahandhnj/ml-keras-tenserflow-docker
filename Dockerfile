FROM nvidia/cuda:9.0-cudnn7-devel

RUN apt-get update && apt-get install -y --no-install-recommends bzip2 g++ \
    git graphviz libgl1-mesa-glx libhdf5-dev openmpi-bin wget unzip && \
    rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh

ENV USER sahand

RUN useradd -m -s /bin/bash -N -u 1000 $USER && \
    chown $USER $CONDA_DIR -R && \
    mkdir -p /ml && \
    chown $USER /ml

USER $USER

ARG python_version=3.6

RUN conda install -y python=${python_version}
RUN pip install --upgrade pip

RUN pip install sklearn_pandas tensorflow-gpu \
    theano keras pandas matplotlib h5py sklearn pillow jupyter pydot nltk && \
    conda clean -yt

ENV PYTHONPATH='/ml/:$PYTHONPATH'

WORKDIR /ml

EXPOSE 8888

CMD jupyter notebook --port=8888 --ip=0.0.0.0
