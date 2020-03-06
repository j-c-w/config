{ pkgs, ...}:
{
	  nixpkgs.config.packageOverrides = pkgs: {
		  papis = pkgs.papis.overrideAttrs (old: {
			  src = pkgs.fetchFromGitHub {
				  owner = "papis";
				  repo = "papis";
				  rev = "b2de2520bfb57447d6f5343a95ab7aec37505dab";
				  sha256 = "sha256:0aspz0izpbnw8hc991lj442p807p1w32mwslfy4n4nr31b7bx09v";
			  };
			  propagatedBuildInputs = old.propagatedBuildInputs ++ [
				  pkgs.python37Packages.typing-extensions
			  ];

			  # Upstream papis fails these checks...
			  doCheck = false;
			  doInstallCheck = false;
		  });
	  };
}
