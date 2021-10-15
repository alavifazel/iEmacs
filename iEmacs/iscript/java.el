(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(defun sti ()
  "Convert String to Integer."
  (when (eq major-mode 'java-mode))
  (interactive)
  (insert "Integer.parseInt();")
  (backward-char 2))

(defun its ()
  "Convert Integer to String."
  (when (eq major-mode 'java-mode))
  (interactive)
  (insert "String.valueOf();")
  (backward-char 2))

(defun c (c-name)
  (interactive "sClass name ")
  (insert (concat "public class " c-name " {\n" ))
  (insert (concat "\tpublic " c-name "() {" ))
  (insert "\n")
  (setq p (line-number-at-pos))
  (insert "\n")
  (insert "\t}\n")
  (insert "};\n")
  (goto-line p)
  (insert "\t\t") )

(defun e (e-name)
  (interactive "sEnum name ")
  (insert (concat "enum " e-name " {\n" ))
  (setq p (line-number-at-pos))
  (insert "\n};\n")
  (goto-line p)
  (insert (concat "\tVALUE,")) )

(defun gs ()
  "Generate getters/setter."
  (when (eq major-mode 'java-mode))
  (interactive)
  (setq region-str (buffer-substring-no-properties (region-beginning) (region-end)))
  (save-match-data
    (and (string-match ".*\\([[:space:]].*[^[:space:]]\\)[[:space:]]*\\([[:space:]].*\\);$" region-str)
	 (setq gs-type-p (match-string 1 region-str)
	       gs-var-p (match-string 2 region-str))))
  (setq gs-type (substring-no-properties gs-type-p 1 nil))
  (setq gs-var (substring-no-properties gs-var-p 1 nil))
  (print gs-type)
  (goto-char (region-end))

  (insert "\n")
  (insert (concat "\tpublic " gs-type " " "get" (capitalize gs-var) "() { \n" ))
  (insert (concat "\t\t" "return this." gs-var ";\n"))
  (insert "\t}\n")

  (insert "\n")
  (insert (concat "\tpublic void set" (capitalize gs-var) "(" gs-type " " gs-var ") { \n" ))
  (insert (concat "\t\t" "this." gs-var " = " gs-var ";\n"))
  (insert "\t}\n") )

(defun intf (f-name) ;; To distinguish between 'if' syntax
  (interactive "sField name:")
  (insert (concat "private int " f-name ";"))
  (setq p (line-number-at-pos))
  (insert "\n")
  (goto-line p)
  (goto-char (line-end-position)) )

(defun bf (f-name)
  (interactive "sField name:")
  (insert (concat "private bool " f-name ";"))
  (setq p (line-number-at-pos))
  (insert "\n")
  (goto-line p)
  (goto-char (line-end-position)) )

(defun sf (f-name)
  (interactive "sField name:")
  (insert (concat "private String " f-name ";"))
  (setq p (line-number-at-pos))
  (insert "\n")
  (goto-line p)
  (goto-char (line-end-position)) )

(defun makefile ()
    (interactive)
  (if (file-exists-p "Makefile")
    (let ((choices '("Append" "Overwrite")))
      (let ((choice (ido-completing-read "Choose Action: " choices )))
	(if (string= choice "Append")
	(print "A"))
	(if (string= choice "Overwrite")
	    (progn
	        (write-region "" "" "Makefile")
		(write-makefile)
	      )
	)
	)
      )

    (progn
	(make-empty-file "Makefile")
	(print "Makefile created.")
	(write-makefile)
	)
    )
  )

(global-set-key [f8] 'makefile)

(defun write-makefile ()
    (with-temp-file "Makefile"
	(insert "CC = gcc\n")
	(insert "CFLAGS  = -g -Wall\n")
	)
    )

(call-interactively 'gen-makefile ())
(setq scroll-conservatively 10000)(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'evil)
  (package-install 'evil))

(require 'evil)
(evil-mode 1)
(custom-set-variables
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (company evil))))
(custom-set-faces)
(add-hook 'after-init-hook 'global-company-mode)

(electric-pair-mode t)
(load-theme 'wombat)
(show-paren-mode 1)

(defun load-scripts (file)
  (interactive)
  (load-file (expand-file-name file "~/.emacs.d/iscripts/")))

(defun add-ijava ()
    (load-scripts "ijava.el") )

(advice-add 'java-mode :before #'add-ijava)

(setq scroll-conservatively 1000)
