self: super:

let pkgs = import<nixpkgs>{};
in {
	papis = super.papis.overrideAttrs (old: rec {
		src = super.fetchFromGitHub {
			owner = "j-c-w";
			repo = "papis";
			rev = "ff0ed8f300c";
			sha256 = "sha256:06b1m99gy768w503zi13ia5gla30wb2s7yg12y8ddyawf5xa1myn";
		};

		propagatedBuildInputs = old.propagatedBuildInputs ++ [
			super.python37Packages.typing-extensions
		];

		doCheck = false;
		doInstallCheck = false;
	});
}
