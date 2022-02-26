{ pkgs, fetchFromGitHub, buildPythonPackage, pythonPkgs, python }:

buildPythonPackage {
    pname = "deap";
    version = "1.3.0";
    doCheck = false;
    src = fetchFromGitHub {
        owner = "DEAP";
        repo = "deap";
        rev = "1.3.0";
        sha256 = "sha256:0blcq10xm7vm4khikq5zfcr98ss3xaaz2i557mr9ax39gfahyj87";
    };

    nativeBuildInputs = [python];
    propagatedBuildInputs = [
        pythonPkgs.numpy python
    ];
}
