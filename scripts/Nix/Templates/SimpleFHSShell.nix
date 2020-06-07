{ pkgs ? import<nixpkgs> {} }:

# Creates a shell with normal ubuntu-like locations.
(pkgs.buildFHSUserEnv {
	targetPkgs = pkgs: with pkgs; [
		git
	];
	name = "simple-translator-env";
	runScript = "zsh";
}).env
