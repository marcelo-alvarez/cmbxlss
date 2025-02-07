CMBxLSS
=======

Introduction
------------

This package contains scripts for installing cmbxlss, an environment for
running cmbxlss analysis at S3DF.

Quick start
-----------

Install::

    # set target
    prefix=/sdf/group/kipac/.../cmbxlss # <-- where this version will be installed
    mkdir -p ${prefix}

    tmp_build_dir=/path-to-temporary-build-directory
    git clone https://github.com/marcelo-alvarez/cmbxlss ${tmp_build_dir}
    cd ${tmp_build_dir}

    unset PYTHONPATH
    export VERSION=$(date '+%Y%m%d')-0.0.0 # <-- name of this version
    CONF=s3df PKGS=default PREFIX=${prefix} ./install.sh |& tee install.log

Load the environment installed above::

    module use ${prefix}/${VERSION}/modulefiles
    module load cmbxlss
