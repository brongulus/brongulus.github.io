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
    "sec:org0cc4585"
    "sec:org56d9ae2"
    "sec:org872d5c7"
    "sec:org9940d7a"
    "sec:org44dbf12"
    "sec:orgd64333f"
    "sec:org3afccf1"
    "sec:org0e6bb42"
    "sec:org6318b85"
    "sec:org70ac094"
    "sec:org3f034a5"
    "sec:org7842070"
    "sec:orga0615e3"
    "sec:org20c5528"
    "org631a0bd"
    "org5aeba47"
    "orga215ed2"
    "sec:orgdf38cc3"
    "sec:org8c9b355"
    "sec:org7c75adf"
    "sec:orgf269536"
    "sec:org6d063a4"
    "sec:orgabde472"
    "sec:org83e89f4"
    "sec:orgf78b039"
    "sec:orgfbe1c38"
    "Architecture"
    "sec:org78e1783"
    "sec:org40f21d0"
    "sec:org8018b89"
    "sec:orga971ce1"
    "sec:org16750c4"
    "sec:orgc52981e"
    "sec:org9e8719c"
    "sec:org28d1a31"
    "sec:org9638a9c"
    "sec:orgb99acd8"
    "sec:org35f98ca"
    "sec:org62bb8da"
    "sec:org1add51b"
    "sec:orgb0cc969"
    "sec:orge27f023"
    "sec:org62d7e26"
    "sec:org9f4bb6f"
    "sec:org105fdef"
    "sec:org6b529cd"
    "sec:org31d27a3"
    "sec:org6bb063d"
    "sec:org36547a3"
    "sec:org15fda41"
    "sec:org29b498f"
    "sec:org7ad2fc0"
    "sec:org59b10d4"
    "sec:org9374f1d"
    "sec:org85f63b3"
    "sec:org5146791"
    "sec:orgacdc178"
    "sec:org290f64c"
    "sec:orged47883"
    "sec:orga8787e3"
    "sec:orgc79e0b8"
    "sec:org6785d2f"))
 :latex)

