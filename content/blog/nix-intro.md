+++
title = "Another nix post in the wall"
author = ["Prashant Tak"]
date = 2022-06-02T00:00:00+05:30
lastmod = 2022-06-23T10:48:35+05:30
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
+++

## Starting {#starting}

Are you using Nixos? This is not for you.
Do you want multi-user installation? This is not for you.
This is only useful if you want to use both flakes and home-manager.

-   Single-user installation (no sudo needed, easier to remove, good for testing purposes)
    ```sh
      sh <(curl -L https://nixos.org/nix/install) --no-daemon
    ```
-   Source the new profile or login.
    `. ~/.nix-profile/etc/profile.d/nix.sh`
-   Since most of the nix "guides" are outdated, check what your current version supports `nix --help`, ~~at the time of writing this, there's no need to enable experimental features for flakes :)~~ spoke too soon.
-   Upgrading nix:
    ```sh
      nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert
    ```
-   Check if `nixpkgs-unstable` channel (package sources basically) is installed or not by `nix-channel --list`
-   You can look at user-installed packages by `nix-env --query`


## Home manager {#home-manager}

Allows declarative configuration of user-specific (non global) packages and dotfiles.


### Installation {#installation}

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

In `.bash_profile`. (might not be needed for single-user systems, check back later)

```sh
export NIX_PATH=${NIX_PATH:+:$NIX_PATH}$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
```

In your `.bash_profile`, add below and source the profile for your current session.

```sh
source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```


### Configuration {#configuration}

Now check `~/.config/nixpkgs/home.nix`, if it exists then for the most part you've successfully installed (not sure about configuration) home-manager. Building a configuration produces a directory in the Nix store that contains all files and programs that should be available in your home directory and Nix user profile, respectively. Run `home-manager build` to successfully verify. Also periodically check `home-manager news` for updates regarding new changes to packages that are referred in your config. After [adding some packages](https://nix-community.github.io/home-manager/index.html#sec-install-standalone) (section 2.1), run `home-manger switch`.


## Fleyks (_sorry_) {#fleyks--sorry}

Flakes allow us to define inputs (you can think of them as dependencies) and outputs of packages in a declarative way and allow for dependency pinning using locks. As of writing this (June 2022) flakes are still experimental, so they must be enabled explicitly.

```sh
nix-env -iA nixpkgs.nixFlakes
```

This replaces nix 2.9.0 with 2.8.1? Look into why that's happening. For now we enable experimental features.

```sh
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

The documentation is so stinky for flakes, like there are _n_ variants sayings \\(n^2\\) different things, so for now I'm just winging it. Comment out the stateVersion from `home.nix` and in the same directory create a `flake.nix`. Replace jdoe with your username. Also the stateVersion can be changed accordingly to upgrade your `home-manager`.

```nix
{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "jdoe";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home.nix;

        inherit system username;
        homeDirectory = "/home/${username}";
        # Update the state version as needed.
        # See the changelog here:
        # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
        stateVersion = "22.05"; # TODO add current unstable home-manager version

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
```

Now it's time to flake-ify your `hm`. Here &lt;flake-uri&gt; would be `path:.config/nixpkgs` assuming your pwd is `~`.

```sh
  home-manager switch --flake '<flake-uri>#jdoe'
```

The flake inputs are not upgraded automatically when switching. The analogy to the command `home-manager --update` ... is `nix flake update`. If updating more than one input is undesirable, the command `nix flake lock --update-input <input-name>` can be used.
