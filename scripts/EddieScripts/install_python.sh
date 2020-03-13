#!/bin/bash

source ~/.scripts/EddieScripts/tmpgen
source ~/.scripts/EddieScripts/paths

if [[ $# -ne 1 ]]; then
	echo "Expected Usage: $0 <installation directory>" > /dev/stderr
	exit 1
fi

module load igmm/compilers/gcc/5.5.0

install_dir="$1"
data_dir=$(eddie_mktmp)

(
set -eu
cd $data_dir
wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz
tar -xvf Python-3.7.6.tgz
cd Python-3.7.6
./configure --prefix=$install_dir
make && make install -j 4
cd ..)

export PATH=$install_dir/bin:$PATH
( pip3 install torch numpy dill matplotlib > /dev/null )

echo "export PATH=$install_dir/bin:\$PATH"
