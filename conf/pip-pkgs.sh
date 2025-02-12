# Install pip packages.
echo Installing pip packages at $(date)

python -m pip install cobaya --upgrade
pip install pixell --user

pip install git+https://github.com/msyriac/orphics.git

PYVERSION=$(python -c "import sys; print(str(sys.version_info[0])+'.'+str(sys.version_info[1]))")

dir=$CONDADIR/lib/python$PYVERSION/site-packages/tempura
git clone git@github.com:simonsobs/tempura.git $dir
cd $dir && python setup.py build_ext -i 
cp -r pytempura ../

dir=$CONDADIR/lib/python$PYVERSION/site-packages/falafel
git clone git@github.com:simonsobs/falafel.git $dir
cd $dir && cp input/config_template.yml input/config.yml && python setup.py develop

dir=$CONDADIR/lib/python$PYVERSION/site-packages/enlib
git clone https://github.com/amaurea/enlib $dir

dir=$CONDADIR/lib/python$PYVERSION/site-packages/so-lenspipe
git clone git@github.com:simonsobs/so-lenspipe.git $dir
cd $dir && cp input/config_template.yml input/config.yml && python setup.py build_ext -i && pip install -e . --user

#################### TBD ####################
#
# namaster and ccl without downgrading numpy
#
#############################################

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages
