# conda packages
echo Current time $(date) Installing conda packages
echo condadir is $CONDADIR

conda create --yes --name cmbxlss -c conda-forge python=3.11 healpy
conda activate cmbxlss

conda config --set solver classic
conda install --yes -n base conda-libmamba-solver
conda config --set solver libmamba

conda install --yes -c conda-forge \
    camb \
    mpi4py \
 && rm -rf $CONDADIR/pkgs/*

if [ $? != 0 ]; then
    echo "ERROR installing conda packages; exiting"
    exit 1
fi

conda list --export | grep -v conda > "$CONDADIR/pkg_list.txt"
#conda config --set solver classic

echo Current time $(date) Done installing conda packages
