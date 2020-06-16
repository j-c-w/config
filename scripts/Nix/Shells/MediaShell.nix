{ pkgs ? import<nixpkgs> {} }:

with pkgs;

mkShell {
	SHELL_NAME = "MediaTools";
	buildInputs = [ imagemagick sox scrot gimp pantheon.elementary-camera ];
}
