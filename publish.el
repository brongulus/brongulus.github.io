;;; publish.el --- generate and publish my blog -*- lexical-binding: t -*-

(require 'org)
(require 'ox-publish)

(defvar blog-base-dir
  (file-name-directory (or load-file-name (buffer-file-name)))
  "The `:base-directory' for blog source.")

;; src: https://orgmode.org/worg/org-tutorials/org-publish-html-tutorial.html
;; https://taingram.org/blog/org-mode-blog.html
;; https://zwpdbh.github.io/emacs/org-to-blog-using-org-publish.html
;; https://git.sr.ht/~taingram/org-publish-rss
;; python3 -m http.server --directory ~/brongulus.github.io/docs/ 1313

(defvar blog-katex-template "
<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/katex@0.16.0/dist/katex.min.css' integrity='sha384-Xi8rHCmBmhbuyyhbI88391ZKP2dmfnOl4rT9ZfRI7mLTdk1wblIUnrIq35nqwEvC' crossorigin='anonymous'>
<script defer src='https://cdn.jsdelivr.net/npm/katex@0.16.0/dist/katex.min.js' integrity='sha384-X/XCfMm41VSsqRNQgDerQczD69XqmjOOOwYQvr/uuC+j4OPoNhVgjdGFwhvN02Ja' crossorigin='anonymous'></script>
<script defer src='https://cdn.jsdelivr.net/npm/katex@0.16.0/dist/contrib/auto-render.min.js' integrity='sha384-+XBljXPPiv+OzfbB3cVmLHf4hdUFHlWNZN5spNQ7rmHTXpd7WvJum6fIACpNNfIR' crossorigin='anonymous'></script>
<script defer>
document.addEventListener('DOMContentLoaded', function() {
    renderMathInElement(document.body, {
        delimiters: [
            {left: '$$', right: '$$', display: true},
            {left: '$', right: '$', display: false},
            {left: '\\\\(', right: '\\\\)', display: false},
            {left: '\\\\[', right: '\\\\]', display: true}
        ],
        throwOnError: false
    });
});
</script>")

(setq org-export-with-toc 1
      org-html-htmlize-output-type nil ;'css
      org-html-doctype "html5"
      org-html-html5-fancy t
      ;; org-html-link-use-abs-url t
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-mathjax-options nil
      org-html-mathjax-template blog-katex-template
      org-html-metadata-timestamp-format "%Y"
      org-html-divs '((preamble "div" "nav")
                      (content "div" "content")
                      (postamble "footer" "postamble"))
      org-html-preamble-format
      '(("en" "<a href='/'>bacchanalian madness</a> / <a href='/rss'>rss</a> / <label id='dark-mode-button'> <input type='checkbox'> </label>"))
      org-html-postamble t
      org-html-postamble-format
      '(("en" "&copy; %T . Made with %c."))
      ;; " <script defer src='/css/main.js'></script>"
      org-html-head
      "<script src='/css/head.js'></script> <link rel='stylesheet' type='text/css' href='/css/stylesheet.css'>"
      org-publish-project-alist
      `(("site" :components ("meta" "blog" "notes" "root" "assets"))
        ("root"
         :base-directory ,(concat blog-base-dir "org/")
         :base-extension "org"
         :publishing-directory ,(concat blog-base-dir "docs/")
         :recursive nil
         :section-numbers nil
         :html-htmlize-output-type "css"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :publishing-function org-html-publish-to-html
         :headline-levels 5 ; change?
         :auto-preamble t)
        ("blog"
         :base-directory ,(concat blog-base-dir "/org/blog/")
         :base-extension "org"
         :publishing-directory ,(concat blog-base-dir "/docs/blog/")
         :recursive t
         :section-numbers nil
         :html-htmlize-output-type "css"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :publishing-function org-html-publish-to-html
         :headline-levels 5
         :auto-preamble t
         :auto-sitemap t
         :sitemap-function my-sitemap-function
         :sitemap-title "Blog Posts"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically)
        ("notes"
         :base-directory ,(concat blog-base-dir "/org/notes/")
         :base-extension "org"
         :publishing-directory ,(concat blog-base-dir "/docs/notes/")
         :recursive t
         :section-numbers nil
         :html-htmlize-output-type "css"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :publishing-function org-html-publish-to-html
         :headline-levels 5
         :auto-preamble t
         :auto-sitemap t
         :sitemap-function my-sitemap-function
         :sitemap-title "Notes"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically)
        ("meta"
         :base-directory ,(concat blog-base-dir "/org/meta/")
         :base-extension "org"
         :publishing-directory ,(concat blog-base-dir "/docs/meta/")
         :recursive t
         :section-numbers nil
         :html-htmlize-output-type "css"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :publishing-function org-html-publish-to-html
         :headline-levels 5
         :auto-preamble t
         :auto-sitemap t
         :sitemap-function my-sitemap-function
         :sitemap-title "Notes"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically)
        ("assets"
         :base-directory ,(concat blog-base-dir "org/")
         :base-extension "css\\|ttf\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ico"
         :publishing-directory ,(concat blog-base-dir "docs/")
         :recursive t
         :publishing-function org-publish-attachment)))

(defun my-sitemap-function (title list)
  (concat "#+OPTIONS: toc:nil\n#+HTML: <div class=\"entries\">\n\n* "
          title "\n\n"
          (org-list-to-org list) "\n\n"
          "#+HTML: </div>"))

(defun my-org-html-example-filter (text backend _info)
  "Wrap example blocks in details tags."
  (when (org-export-derived-backend-p backend 'html)
    (format "<details>\n<summary>Output</summary>\n%s</details>" text)))

(add-to-list 'org-export-filter-example-block-functions
             #'my-org-html-example-filter)

(defun my/remove-paragraph-newlines (orig-fun paragraph contents info)
  (let ((result (funcall orig-fun paragraph contents info)))
    (replace-regexp-in-string "<p\\(.*?\\)>\n" "<p\\1>" result)))

(advice-add 'org-html-paragraph :around #'my/remove-paragraph-newlines)

(defun my/fix-image-src (orig-fun link desc info)
  (let ((result (funcall orig-fun link desc info)))
    (replace-regexp-in-string
     "src=\"file://\\(/[^\"]+\\)\""
     "src=\"\\1\""
     result)))

(advice-add 'org-html-link :around #'my/fix-image-src)
