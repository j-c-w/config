{ pkgs, fetchFromGitHub, buildPythonPackage, pythonPkgs }:

buildPythonPackage {
    pname = "guppy";
    version = "0.1.11";
    doCheck = false;
    src = fetchFromGitHub {
        owner = "svenil";
        repo = "guppy-pe";
        rev = "0.1.11";
        sha256 = "sha256:1riz24hgc5k19mygmqf6rxgi1iwxwzajh77fbknkaci99sxf7vaj";
    };

    propagatedBuildInputs = [
        pythonPkgs.dateutil
    ];
}
