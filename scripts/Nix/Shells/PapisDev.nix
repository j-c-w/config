{ pkgs ? import<nixpkgs> { overlays = [ (import ~/.scripts/Nix/CustomPackages/JCWPapis.nix) ]; }}:

with pkgs;
mkShell {
	name = "PapisDev";
	SHELL_NAME = "PapisDev";
	buildInputs = [ papis ];
}
