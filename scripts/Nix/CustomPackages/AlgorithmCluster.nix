{ stdenv, buildPerlPackage, fetchurl, ... }:

buildPerlPackage {
	pname = "AlgorithmCluster";
	version = "1.59";

	src = fetchurl {
		url = https://cpan.metacpan.org/authors/id/M/MD/MDEHOON/Algorithm-Cluster-1.59.tar.gz;
		sha256 = "1pzw3pbhvnzkkssqgxj1h83qkyarghfi2lg1hn98vah2ylbxllyb";
	};
}
