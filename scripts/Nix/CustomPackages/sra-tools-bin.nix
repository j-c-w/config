{ stdenv, fetchurl, tar }:

# This ONLY works in a FHS shell.
stdenv.mkDerivation {
	name = "sra-tools-bin";
	buildInputs = [ tar ];
	patches = [ ~/.scripts/Nix/CustomPackages/patches/fastq2fasta.patch ];

	# Most of this thing doesn't have to be built.  We just
	# want to add teh fastq2fasta script.
	buildPhase = ''
		# We also add the fastq2fasta tool, which is actually
		# a sed script taken from https://bioinformaticsworkbook.org/dataWrangling/fastaq-manipulations/converting-fastq-format-to-fasta.html#gsc.tab=0

		set -x
		cat bin/fastq2fasta
		chmod +x bin/fastq2fasta
	    '';
	installPhase = ''
		ls bin
		mkdir -p $out/bin
		mv bin/* $out/bin
		'';

	phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];

	src = fetchurl {
		url = https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.7/sratoolkit.2.10.7-centos_linux64.tar.gz;
		sha256 = "0h019r9d6myh7gyvd4ixad3x9xrhvl9klf6naj2k2yhc9ybikwxk";
	};
}
