;;; publish.el --- generate and publish my blog -*- lexical-binding: t -*-

(require 'org)
(require 'ox-publish)
(require 'easy-mmode)

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

(defvar rss-svg
  "<a href='/rss.xml'>
    <button id='rss-button' aria-label='Get RSS feed' type='button'>
      <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 448 512' fill='currentColor'>
        <path d='M128.081 415.959c0 35.369-28.672 64.041-64.041 64.041S0 451.328 0 415.959s28.672-64.041 64.041-64.041 64.04 28.673 64.04 64.041zm175.66 47.25c-8.354-154.6-132.185-278.587-286.95-286.95C7.656 175.765 0 183.105 0 192.253v48.069c0 8.415 6.49 15.472 14.887 16.018 111.832 7.284 201.473 96.702 208.772 208.772.547 8.397 7.604 14.887 16.018 14.887h48.069c9.149.001 16.489-7.655 15.995-16.79zm144.249.288C439.596 229.677 251.465 40.445 16.503 32.01 7.473 31.686 0 38.981 0 48.016v48.068c0 8.625 6.835 15.645 15.453 15.999 191.179 7.839 344.627 161.316 352.465 352.465.353 8.618 7.373 15.453 15.999 15.453h48.068c9.034-.001 16.329-7.474 16.005-16.504z'></path>
      </svg>
    </button>
  </a>")

(setq org-export-with-toc 1
      org-html-htmlize-output-type nil
      org-html-doctype "html5"
      org-html-html5-fancy t
      ;; org-html-link-use-abs-url t
      org-export-with-smart-quotes t
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-mathjax-options nil
      org-html-mathjax-template blog-katex-template
      org-html-metadata-timestamp-format "%Y"
      org-html-divs '((preamble "div" "nav")
                      (content "div" "content")
                      (postamble "footer" "postamble"))
      org-html-preamble-format
      `(("en" ,(concat "<a href='/'>bacchanalian madness</a>"
                       rss-svg svg-toggle-button)))
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

(advice-add 'org-html-src-block :override #'my/org-html-src-block)

;;; RSS: Sonnet
(defun my/generate-rss-feed ()
  "Generate RSS feed from all blog and notes posts."
  (let* ((posts '())
         (blog-dir (concat blog-base-dir "org/blog/"))
         (notes-dir (concat blog-base-dir "org/notes/"))
         (output-file (concat blog-base-dir "docs/rss.xml")))
    
    ;; Collect posts from blog and notes
    (dolist (dir (list blog-dir notes-dir))
      (when (file-directory-p dir)
        (dolist (file (directory-files-recursively dir "\\.org$"))
          (unless (string-match-p "index\\.org$" file)
            (push (list :file file
                        :date (nth 5 (file-attributes file))
                        :rel-path (file-relative-name file (concat blog-base-dir "org/")))
                  posts)))))
    
    ;; Sort by date
    (setq posts (sort posts (lambda (a b)
                              (time-less-p (plist-get b :date)
                                           (plist-get a :date)))))
    
    ;; Generate RSS XML
    (with-temp-file output-file
      (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
      (insert "<rss version=\"2.0\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n")
      (insert "  <channel>\n")
      (insert "    <title>Bacchanalian Madness</title>\n")
      (insert "    <link>https://brongulus.github.io/</link>\n")
      (insert "    <description>Webpresence of Prashant Tak</description>\n")
      (insert "    <atom:link href=\"https://brongulus.github.io/rss.xml\" rel=\"self\" type=\"application/rss+xml\" />\n")
      
      (dolist (post posts)
        (let* ((file (plist-get post :file))
               (date (plist-get post :date))
               (rel-path (plist-get post :rel-path))
               (html-path (concat "/" (file-name-sans-extension rel-path) ".html"))
               (title (my/extract-title file)))
          (insert "    <item>\n")
          (insert (format "      <title>%s</title>\n" (my/xml-escape title)))
          (insert (format "      <link>https://brongulus.github.io%s</link>\n" html-path))
          (insert (format "      <guid>https://brongulus.github.io%s</guid>\n" html-path))
          (insert (format "      <pubDate>%s</pubDate>\n" 
                          (format-time-string "%a, %d %b %Y %H:%M:%S %z" date)))
          (insert "    </item>\n")))
      
      (insert "  </channel>\n")
      (insert "</rss>\n"))))

(defun my/extract-title (file)
  "Extract title from org FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (if (re-search-forward "^#\\+TITLE: *\\(.+\\)$" nil t)
        (match-string 1)
      (file-name-base file))))

(defun my/xml-escape (str)
  "Escape special XML characters in STR."
  (setq str (replace-regexp-in-string "&" "&amp;" str))
  (setq str (replace-regexp-in-string "<" "&lt;" str))
  (setq str (replace-regexp-in-string ">" "&gt;" str))
  (setq str (replace-regexp-in-string "\"" "&quot;" str))
  (setq str (replace-regexp-in-string "'" "&apos;" str))
  str)

;; Call this after publishing
;; (my/generate-rss-feed)

;; -------------------------------------------------------------------------------
;; src: https://github.com/alphapapa/unpackaged.el#export-to-html-with-useful-anchors

(advice-add #'org-export-get-reference :override #'unpackaged/org-export-get-reference)

(defun org-reference-contraction (reference-string)
  "Contract REFERENCE-STRING to alphanumeric form, max 3 words/35 chars."
  (let* ((str (downcase reference-string))
         (str (replace-regexp-in-string "\\[\\[[^]]+\\]\\[\\([^]]+\\)\\]\\]" "\\1" str))
         (str (replace-regexp-in-string "[-/ ]+" " " str))
         (str (puny-encode-string str))
         (str (replace-regexp-in-string "^xn--\\(.*?\\) ?-?\\([a-z0-9]+\\)$" "\\2 \\1" str))
         (str (replace-regexp-in-string "[^A-Za-z0-9 ]" "" str))
         (words (cl-remove-if (lambda (w) (member w '("the" "on" "in" "off" "a" "for" "by" "of" "and" "is" "to" "as")))
                              (split-string str " +")))
         (words (cl-subseq words 0 (min 3 (length words))))
         (budget (- 35 (1- (length words))))
         (avg (/ budget 3))
         (num-long (cl-count-if (lambda (w) (> (length w) avg)) words))
         (short-len (apply #'+ (mapcar (lambda (w) (if (<= (length w) avg) (length w) 0)) words)))
         (max-len (if (zerop num-long) avg (/ (- budget short-len) num-long)))
         (words (mapcar (lambda (w) (if (<= (length w) max-len) w (substring w 0 max-len))) words)))
    (string-join words "-")))

(defun unpackaged/org-export-get-reference (datum info)
  "Use heading titles instead of random numbers for references."
  (let ((cache (plist-get info :internal-references)))
    (or (car (rassq datum cache))
        (let* ((crossrefs (plist-get info :crossrefs))
               (cells (org-export-search-cells datum))
               (new (or (cl-some (lambda (cell)
                                   (let ((stored (cdr (assoc cell crossrefs))))
                                     (when stored
                                       (let ((old (org-export-format-reference stored)))
                                         (and (not (assoc old cache)) stored)))))
                                 cells)
                        (when (or (org-element-property :raw-value datum)
                                  (member (car datum) '(src-block table example fixed-width property-drawer)))
                          (unpackaged/org-export-new-named-reference datum cache))))
               (reference-string new))
          (when new
            (dolist (cell cells) (push (cons cell new) cache))
            (push (cons reference-string datum) cache)
            (plist-put info :internal-references cache))
          reference-string))))

(defun unpackaged/org-export-new-named-reference (datum cache)
  "Return new unique reference for DATUM."
  (cl-macrolet ((inc-suffixf (place)
                  `(progn
                     (string-match (rx bos (minimal-match (group (1+ anything)))
                                       (optional "--" (group (1+ digit))) eos)
                                   ,place)
                     (let* ((base (match-string 1 ,place))
                            (suffix (match-string 2 ,place))
                            (num (if suffix (string-to-number suffix) 0)))
                       (setf ,place (format "%s--%s" base (1+ num)))))))
    (let* ((headline-p (eq (car datum) 'headline))
           (title (if headline-p
                      (org-element-property :raw-value datum)
                    (or (org-element-property :name datum)
                        (org-element-property :raw-value
                                              (org-element-property :parent
                                                                    (org-element-property :parent datum)))))))
      (when title
        (let ((ref (concat (org-reference-contraction (substring-no-properties title))
                           (unless (or headline-p (org-element-property :name datum))
                             (concat "," (pcase (car datum)
                                           ('src-block "code")
                                           ('example "example")
                                           ('fixed-width "mono")
                                           ('property-drawer "properties")
                                           (_ (symbol-name (car datum)))) "--1"))))
              (parent (when headline-p (org-element-property :parent datum))))
          (while (member ref (mapcar #'car cache))
            (if parent
                (setf title (concat (org-element-property :raw-value parent) "--" title)
                      ref (org-reference-contraction (substring-no-properties title))
                      parent (when headline-p (org-element-property :parent parent)))
              (inc-suffixf ref)))
          ref)))))
