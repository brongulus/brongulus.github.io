+++
title = "Creating a blog using ox-hugo, org mode and github pages"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 27.2 (Org mode 9.5 + ox-hugo)"
+++

I was going to make a post explaining how I made this blog but it was rendered pretty useless by [this.](https://dev.to/usamasubhani/setup-a-blog-with-hugo-and-github-pages-562n) So yeah, I might archive this later.

1.  Install hugo from your package manager.
2.  Create a new site:

    ```sh
       hugo new site blog
    ```
3.  Add a theme:

    ```sh
       cd blog
       git init
       git submodule add <theme_url> themes/<name>
    ```
4.  Install ox-hugo in emacs

    ```emacs-lisp
       ;; goes in packages.el
       (package! ox-hugo)

       ;; goes in config.el
       (use-package ox-hugo
         :after ox)
    ```
5.  TODO Explain the process of content and properties, tags etc.
6.  Export
7.  Config.toml (theme, title, url, publishdir, etc)
8.  Run server, check localhost.
9.  Push
10. Go to GitHub repository Settings > GitHub pages. Select /docs in Source.
11. Voila!
