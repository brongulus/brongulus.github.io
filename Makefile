blog:
	emacs -Q --batch -l publish.el -f org-publish-all

serve:
	python3 -m http.server --directory ./docs/ 1313

force: clean
	emacs -Q --batch -l publish.el --eval '(org-publish "site" t)'

assets:
	emacs -Q --batch -l publish.el --eval '(org-publish "assets" t)'

clean:
	rm -rf ./docs/*
	rm -rf ~/.org-timestamps
