+++
title = "Creating a blog using ox-hugo"
author = ["Prashant Tak"]
date = 2021-03-21T02:00:00+05:30
lastmod = 2022-06-20T09:19:10+05:30
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
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
10. Go to GitHub repository Settings &gt; GitHub pages. Select /docs in Source.
11. Voila!
