FROM jupyter/minimal-notebook

# Inspired from https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile
MAINTAINER Théo Segonds <theo.segonds@inria.fr>

USER jovyan

ADD notebooks/ /home/jovyan/work

# Install Python 3 packages
RUN conda install --yes \
    'ipywidgets=4.0*' \
    'pandas=0.17*' \
    'matplotlib=1.4*' \
    'scipy=0.16*' \
    'seaborn=0.6*' \
    'scikit-learn=0.16*' \
    'scikit-image=0.11*' \
    'sympy=0.7*' \
    'cython=0.22*' \
    'patsy=0.4*' \
    'statsmodels=0.6*' \
    'cloudpickle=0.1*' \
    'dill=0.2*' \
    'numba=0.22*' \
    'bokeh=0.10*' \
    && conda clean -yt

RUN pip install poppy-ergo-jr poppy-torso poppy-humanoid

# Install Python 2 packages
RUN conda create -p $CONDA_DIR/envs/python2 python=2.7 \
    'ipython=4.0*' \
    'ipywidgets=4.0*' \
    'pandas=0.17*' \
    'matplotlib=1.4*' \
    'scipy=0.16*' \
    'seaborn=0.6*' \
    'scikit-learn=0.16*' \
    'scikit-image=0.11*' \
    'sympy=0.7*' \
    'cython=0.22*' \
    'patsy=0.4*' \
    'statsmodels=0.6*' \
    'cloudpickle=0.1*' \
    'dill=0.2*' \
    'numba=0.22*' \
    'bokeh=0.10*' \
    pyzmq \
    && conda clean -yt

RUN source activate python2 
RUN pip install poppy-ergo-jr poppy-torso poppy-humanoid

USER root

# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime.
RUN $CONDA_DIR/envs/python2/bin/python \
    $CONDA_DIR/envs/python2/bin/ipython \
    kernelspec install-self

USER jovyan