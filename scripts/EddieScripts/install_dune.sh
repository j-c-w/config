#!/bin/bash
set -eu

source ~/.scripts/EddieScripts/tmpgen
source ~/.scripts/EddieScripts/paths

if [[ $# -ne 1 ]]; then
	echo "Expected Usage: $0 <installation directory>" > /dev/stderr
	exit 1
fi

module load igmm/compilesr/gcc/5.5.9
install_dir=$1
data_dir=$(eddie_mktmp)
mkdir -p $install_dir/dune/bin

(
set -eu
cd $data_dir
git clone https://github.com/ocaml/dune dune_repo
cd dune_repo
make release
cp dune.exe $install_dir/dune/bin
ln -s $install_dir/dune/bin/dune.exe $install_dir/dune/bin/dune
)

echo "export PATH=$install_dir/dune/bin:\$PATH"
echo "export XDG_CACHE_HOME=$TMPDIR/cache"
