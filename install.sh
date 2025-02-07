#!/bin/bash

while getopts "v" opt; do
    case $opt in
	v) set -x # print commands as they are run so we know where we are if something fails
	   ;;
    esac
done
echo Starting cmbxlss installation at $(date)
SECONDS=0

# Defaults
if [ -z $CONF ] ; then CONF=s3df;    fi
if [ -z $PKGS ] ; then PKGS=default; fi

# Script directory
pushd $(dirname $0) > /dev/null
topdir=$(pwd)
popd > /dev/null

scriptname=$(basename $0)
fullscript="${topdir}/${scriptname}"

CONFDIR=$topdir/conf

CONFIGUREENV=$CONFDIR/$CONF-env.sh
INSTALLPKGS=$CONFDIR/$PKGS-pkgs.sh

export PATH=$CONDADIR/bin:$PATH

# Initialize environment
source $CONFIGUREENV

# Set installation directories
CMBXLSS=$PREFIX/$CMBXLSSVERSION
CONDABASEDIR=$CMBXLSS/conda
CONDADIR=$CMBXLSS/conda/envs/cmbxlss
MODULEDIR=$CMBXLSS/modulefiles/cmbxlss

# Install conda root environment
echo Installing conda root environment at $(date)

curl -SL $MINICONDA \
  -o miniconda.sh \
    && /bin/bash miniconda.sh -b -p $CONDABASEDIR

source $CONDABASEDIR/bin/activate

# Install packages
source $INSTALLPKGS

echo Using Python version $PYVERSION

# Compile python modules
echo Pre-compiling python modules at $(date)

python$PYVERSION -m compileall -f "$CONDADIR/lib/python$PYVERSION/site-packages"

# Set permissions
echo Setting permissions at $(date)

chgrp -R $GRP $CONDABASEDIR
chmod -R u=rwX,g=rX,o-rwx $CONDABASEDIR

# Install modulefile
echo Installing the cmbxlss modulefile to $MODULEDIR at $(date)

mkdir -p $MODULEDIR

cp $topdir/modulefile.gen cmbxlss.module

sed -i 's@_CONDADIR_@'"$CONDADIR"'@g' cmbxlss.module
sed -i 's@_CMBXLSSVERSION_@'"$CMBXLSSVERSION"'@g' cmbxlss.module
sed -i 's@_PYVERSION_@'"$PYVERSION"'@g' cmbxlss.module
sed -i 's@_CONDAPRGENV_@'"$CONDAPRGENV"'@g' cmbxlss.module

cp cmbxlss.module $MODULEDIR/$CMBXLSSVERSION
cp $topdir/cmbxlss.modversion $MODULEDIR/.version_$CMBXLSSVERSION

chgrp -R $GRP $MODULEDIR
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR

# All done
echo Done at $(date)
duration=$SECONDS
echo "Installation took $(($duration / 60)) minutes and $(($duration % 60)) seconds."
