#!/bin/bash

source ~/.scripts/EddieScripts/tmpgen
source ~/.scripts/EddieScripts/paths

if [[ $# -ne 1 ]]; then
	echo "Expected Usage: $0 <installation directory>" > /dev/stderr
	exit 1
fi

module load igmm/compilesr/gcc/5.5.9
install_dir=$1
data_dir=$(eddie_mktmp)

(
set -eu
cd $data_dir
wget https://github.com/ocaml/ocaml/archive/4.10.0.tar.gz
tar -xvf 4.10.0.tar.gz
cd ocaml-4.10.0
./configure --prefix=/$install_dir/ocaml
make -j 20
make install -j 10
)

echo "export PATH=$install_dir/ocaml/bin:\$PATH"
