(TeX-add-style-hook
 "blog"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "11pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("ulem" "normalem")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art11"
    "inputenc"
    "fontenc"
    "graphicx"
    "grffile"
    "longtable"
    "wrapfig"
    "rotating"
    "ulem"
    "amsmath"
    "textcomp"
    "amssymb"
    "capt-of"
    "hyperref")
   (LaTeX-add-labels
    "sec:orgcf93b46"
    "sec:orgbc6e925"
    "sec:orgfd8a66e"
    "sec:orgfe385c1"
    "sec:org8e83e52"
    "sec:orgb9d8018"
    "sec:orga4c1ed4"
    "sec:org431ae12"
    "sec:org70347a8"
    "sec:orgbfac308"
    "sec:orgd97e5ac"
    "sec:orgc419b80"
    "sec:orgbe02c5e"
    "sec:org97f2103"
    "sec:org027f809"
    "sec:org4c4f925"
    "sec:org3c62c8f"
    "sec:org4513984"
    "sec:org9c28bbd"
    "sec:org08d246d"
    "sec:org0b4cb2f"
    "sec:org9cb11b8"
    "sec:org7d57775"
    "sec:orgd3e6d75"
    "sec:org25f3a0e"
    "sec:org3d42cee"
    "sec:org6e51ca1"
    "sec:orgdb2b000"
    "sec:orge72901b"
    "sec:org9621718"
    "sec:org99b5d9d"
    "sec:orgf721c7f"
    "sec:org499fde9"
    "sec:orgb754e90"
    "sec:org5be9237"
    "sec:orgb99d73e"
    "sec:org6d2ce51"))
 :latex)

