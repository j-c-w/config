self: super:

let pkgs = import<nixpkgs>{};
in {
	papis = super.papis.overrideAttrs (old: rec {
		src = super.fetchFromGitHub {
			owner = "j-c-w";
			repo = "papis";
			rev = "b597029c";
			sha256 = "sha256:0w9hd41q2r817wa61bj4b916g4pg7b52g5nxd4l2agsw2k0gmcng";
		};

		propagatedBuildInputs = old.propagatedBuildInputs ++ [
			super.python37Packages.typing-extensions
		];

		doCheck = false;
		doInstallCheck = false;
	});
}
