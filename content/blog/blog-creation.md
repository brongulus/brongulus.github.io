+++
title = "Creating a blog using ox-hugo, org mode and github pages"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 28.0.50 (Org mode 9.5 + ox-hugo)"
+++

1.  Install hugo from your package manager.
2.  Create a new site:

<!--listend-->

```sh
hugo new site blog
```

1.  Add a theme:

<!--listend-->

```sh
cd blog
git init
git submodule add <theme_url> themes/<name>
```

1.  Install ox-hugo in emacs

<!--listend-->

```emacs-lisp
;; goes in packages.el
(package! ox-hugo)

;; goes in config.el
(use-package ox-hugo
  :after ox)
```

1.  TODO Explain the process of content and properties, tags etc.
2.  Export
3.  Config.toml (theme, title, url, etc)
4.  Run server, check localhost.
