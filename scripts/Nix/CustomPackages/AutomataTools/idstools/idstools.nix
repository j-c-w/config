{ buildPythonPackage, fetchFromGitHub, pytest, setuptools, dateutil, ordereddict }:

buildPythonPackage {
	pname = "idstools";
	version = "0.6.4";

	src = fetchFromGitHub {
		owner = "jasonish";
		repo = "py-idstools";
		rev = "a97393d";
		sha256 = "sha256:1nsk48d3zczjw35ynk2gx3gr9x2icagd6b7471l58dcavww96lh1";
	};

	propagatedBuildInputs = [ setuptools dateutil ordereddict ];
	doCheck = false;
}
