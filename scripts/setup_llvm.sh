#!/bin/echo "Should be sourced"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <LLVM Dir>"
else

  pushd $1
  if [[ ! -d bin ]]; then
    echo "Are you sure this is an LLVM installation?  Expecting a bin"
  else
    fulldir=$PWD
    popd

    export PATH=$fulldir/bin:$PATH
    export LLVM_DIR=$fulldir
    export LD_LIBRARY_PATH=$fulldir/lib:$LD_LIBRARY_PATH
    export CMAKE_PREFIX_PATH=$fulldir:$CMAKE_PREFIX_PATH

    echo "Set everything: new version is:"
    llvm-config --version
  fi
fi
