{ pkgs ? import<nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
	targetPkgs = pkgs: with pkgs; [
		curl
		(callPackage ./sra-tools-bin.nix { tar = pkgs.gnutar; })
	];
	name = "simple-translator-env";
	profile = ''
		vdb-config --restore-defaults
		SHELL_NAME="NCBITools";
		'';
	runScript = "zsh";
}).env
