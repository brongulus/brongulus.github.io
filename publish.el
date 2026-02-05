;;; publish.el --- generate and publish my blog -*- lexical-binding: t -*-

(require 'org)
(require 'ox-publish)

(setq debug-on-error t)

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

(defvar svg-toggle-button
  "<button id='dark-mode-button' aria-label='Toggle Dark Mode' type='button'>
    <svg id='moon-icon' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'>
      <path d='M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z'></path>
    </svg>
    <svg id='sun-icon' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor' style='display: none;'>
      <path d='M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z' fill-rule='evenodd' clip-rule='evenodd'></path>
    </svg>
  </button>")

(setq org-export-with-toc 1
      org-html-htmlize-output-type nil
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
      `(("en" ,(concat "<a href='/'>bacchanalian madness</a> / <a href='/rss'>rss</a>"
                       svg-toggle-button)))
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

;; Opus: htmlize alternative
(defun my/face-to-css-class (face)
  "Convert a font-lock face to a CSS class name."
  (cond
   ((null face) nil)
   ((symbolp face) (symbol-name face))
   ((listp face)
    ;; Handle composite faces - join them all
    (mapconcat (lambda (f)
                 (if (symbolp f) (symbol-name f) ""))
               (if (face-list-p face) face (list face))
               " "))
   (t nil)))

(defun my/fontify-code (code lang)
  "Fontify CODE string using LANG major mode and return HTML with CSS classes."
  (let ((lang-mode (org-src-get-lang-mode lang)))
    (if (fboundp lang-mode)
        (with-temp-buffer
          (insert code)
          (delay-mode-hooks (funcall lang-mode))
          (font-lock-ensure)
          (let ((pos (point-min))
                (result ""))
            (while (< pos (point-max))
              (let* ((next-pos (next-single-property-change pos 'face nil (point-max)))
                     (face (get-text-property pos 'face))
                     (text (buffer-substring-no-properties pos next-pos))
                     (escaped-text (org-html-encode-plain-text text))
                     (css-class (my/face-to-css-class face)))
                (setq result
                      (concat result
                              (if css-class
                                  (format "<span class=\"%s\">%s</span>"
                                          css-class escaped-text)
                                escaped-text)))
                (setq pos next-pos)))
            result))
      ;; Fallback if mode doesn't exist
      (org-html-encode-plain-text code))))

(defun my/org-html-src-block (src-block _contents info)
  "Export SRC-BLOCK with font-lock faces as CSS classes."
  (let* ((lang (org-element-property :language src-block))
         (code (org-element-property :value src-block))
         ;; Remove trailing newline if present
         (code (if (string-suffix-p "\n" code)
                   (substring code 0 -1)
                 code))
         (highlighted-code (my/fontify-code code lang)))
    (format "<pre class=\"src src-%s\"><code>%s</code></pre>\n"
            (or lang "none")
            highlighted-code)))

;; Override the default src-block export
(advice-add 'org-html-src-block :override #'my/org-html-src-block)

;; To remove: (advice-remove 'org-html-src-block #'my/org-html-src-block)
