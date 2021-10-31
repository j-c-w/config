{ pkgs, fetchFromGitHub, buildPythonPackage, pythonPkgs }:

buildPythonPackage {
    pname = "gdown";
    version = "4.2.0";
    doCheck = false;
    src = fetchFromGitHub {
        owner = "wkentaro";
        repo = "gdown";
        rev = "12217e3";
        sha256 = "sha256:13vh6f51l33g83xz6mih2y9zb1mhi52viijrp3ycqizr4yqykl48";
    };

    propagatedBuildInputs = [
        pkgs.python38Packages.six
        pkgs.python38Packages.beautifulsoup4
        pkgs.python38Packages.tqdm
        pkgs.python38Packages.filelock
        pkgs.python38Packages.requests
        pkgs.python38Packages.setuptools
    ];
}
