{ pkgs ? import<nixpkgx> {} }:

with pkgs;
mkShell { 
	SHELL_NAME = "Name";
	buildInputs = [ ];
	shellHook = '' '';
}
