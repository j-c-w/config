{ pkgs ? import<nixpkgs> {} }:

with pkgs;

mkShell {
	SHELL_NAME = "Games";
	buildInputs = [ openttd steam nethack ];
}
