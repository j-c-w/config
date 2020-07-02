{ stdenv, fetchFromGitHub, gnumake, nasm }:

stdenv.mkDerivation {
	name = "MNRL";
	version = "1.1";
	src = fetchFromGitHub {
		owner = "kevinaangstadt";
		repo = "mnrl";
		fetchSubmodules = true;
		rev = "056d90b163ba0a7c61ec00aa076fe9e903a5e8e1";
		sha256 = "sha256:1k83xj3y0fapp289issci7hn4z3441pramq38bvqn7d3148zmpil";
	};

	patches = [ ./noinit.patch ];

	nativeBuildInputs = [ gnumake nasm ];

	outpts = [ "out" "lib" ];

	buildPhase = ''
		cd C++
		make
		cd ..
		'';

	installPhase = ''
		mkdir -p $out/src
		cp C++/libmnrl.{so,a} $lib

		cp -r . $out/src
		'';
}
