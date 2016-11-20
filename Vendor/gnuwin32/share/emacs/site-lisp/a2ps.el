;;; a2ps.el --- Major mode for a2ps style sheets

;; Author: Akim Demaille (demaille@inf.enst.fr)
;; Maintainer: Akim Demaille (demaille@inf.enst.fr)
;; Keywords: languages, faces, a2ps

;;; Copyright (c) 1988, 89, 90, 91, 92, 93 Miguel Santana
;;; Copyright (c) 1995, 96, 97, 98 Akim Demaille, Miguel Santana

;;;
;;; This file is part of a2ps.
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 59 Temple Place - Suite 330,
;;; Boston, MA 02111-1307, USA.
;;;

;; This file is (not yet) part of GNU Emacs.

;; $Id: a2ps.el,v 1.1.1.1.2.2 2007/12/29 01:58:11 mhatta Exp $

;; to autoload a2ps lisp code:
;; (autoload 'a2ps-mode "a2ps-mode" nil t)
;;
;; or can use (load "a2ps-mode") or (require 'a2ps-mode) to just load it
;;
;; to try to "auto-detect" a2ps files:
;; (setq auto-mode-alist
;;	 (cons '(".*\\.a2ps$" . a2ps-mode)
;;	       auto-mode-alist))

;; Thanks to Didier Verna <verna@inf.enst.fr> for
;; a2ps-compile-regexp

;;path to the a2ps program
(defvar a2ps-program "/usr/local/bin/a2ps")

;;thank god for make-regexp.el!
(defvar a2ps-font-lock-keywords
  `(
    ("^\\\#.*" . font-lock-comment-face)
;    ("\\\$\\\*" . font-lock-variable-name-face)
;    ("\\\$[0-9]" . font-lock-variable-name-face)
;    ("\\\$\\\#" . font-lock-variable-name-face)
    ;; Keywords related to the LaTeX symbols
    ("\\b\\(---\\|\\\\\\(Alpha\\|Beta\\|Chi\\|D\\(elta\\|ownarrow\\)\\|E\\(psilon\\|ta\\)\\|Gamma\\|I\\(m\\|ota\\)\\|Kappa\\|L\\(ambda\\|eft\\(arrow\\|rightarrow\\)\\)\\|Mu\\|Nu\\|Om\\(ega\\|icron\\)\\|P\\(hi\\|i\\|si\\)\\|R\\(e\\|ho\\|ightarrow\\)\\|Sigma\\|T\\(au\\|heta\\)\\|Up\\(arrow\\|silon\\)\\|Xi\\|Zeta\\|a\\(l\\(eph\\|pha\\)\\|ngle\\|pp\\(le\\|rox\\)\\)\\|b\\(eta\\|ullet\\)\\|c\\(a\\(p\\|rriagereturn\\)\\|dot\\|hi\\|irc\\|lubsuit\\|o\\(ng\\|pyright\\)\\|up\\)\\|d\\(elta\\|i\\(amondsuit\\|v\\)\\|ownarrow\\)\\|e\\(mptyset\\|psilon\\|quiv\\|ta\\|xists\\)\\|f\\(lorin\\|orall\\)\\|g\\(amma\\|eq\\)\\|heartsuit\\|i\\(n\\(\\|fty\\|t\\)\\|ota\\)\\|kappa\\|l\\(a\\(mbda\\|ngle\\)\\|ceil\\|dots\\|e\\(ft\\(arrow\\|rightarrow\\)\\|q\\)\\|floor\\)\\|mu\\|n\\(abla\\|eq\\|ot\\(\\|\\\\\\(in\\|subset\\)\\)\\|u\\)\\|o\\(m\\(ega\\|icron\\)\\|plus\\|times\\)\\|p\\([im]\\|artial\\|erp\\|hi\\|r\\(ime\\|o\\(d\\|pto\\)\\)\\|si\\)\\|r\\(a\\(dicalex\\|ngle\\)\\|ceil\\|egister\\|floor\\|ho\\|ightarrow\\)\\|s\\(i\\(gma\\|m\\)\\|padesuit\\|u\\(bset\\(\\|eq\\)\\|chthat\\|m\\|pset\\(\\|eq\\)\\|rd\\)\\)\\|t\\(au\\|he\\(refore\\|ta\\)\\|imes\\|rademark\\)\\|up\\(arrow\\|silon\\)\\|v\\(ar\\(Upsilon\\|copyright\\|diamondsuit\\|p\\(hi\\|i\\)\\|register\\|sigma\\|t\\(heta\\|rademark\\)\\)\\|ee\\)\\|w\\(edge\\|p\\)\\|xi\\|zeta\\)\\)\\b" . font-lock-type-face)
    ;; Keywords related to the struture
    ("\\b\\(a\\(2ps\\|lphabets?\\|ncestors\\|re\\)\\|by\\|c\\(ase\\|losers\\)\\|documentation\\|e\\(nd\\|xceptions\\)\\|first\\|i\\([ns]\\|nsensitive\\)\\|keywords\\|op\\(erators\\|tional\\)\\|requires\\|s\\(e\\(cond\\|nsitive\\|quences\\)\\|tyle\\)\\|version\\|written\\)\\b" . font-lock-keyword-face)
    ;; Keywords related to the faces or special sequences
    ("\\b\\(C\\(-\\(char\\|string\\)\\|omment\\(\\|_strong\\)\\)\\|E\\(ncoding\\|rror\\)\\|In\\(dex[1234]\\|visible\\)\\|Keyword\\(\\|_strong\\)\\|Label\\(\\|_strong\\)\\|Plain\\|S\\(tring\\|ymbol\\)\\|Tag[1234]\\)\\b" . font-lock-type-face)
    "default font-lock-keywords")
)

;; this may still need some work
(defvar a2ps-mode-syntax-table nil
  "syntax table used in a2ps mode")
(setq a2ps-mode-syntax-table (make-syntax-table))
;(modify-syntax-entry ?` "('" a2ps-mode-syntax-table)
;(modify-syntax-entry ?' ")`" a2ps-mode-syntax-table)
(modify-syntax-entry ?# "<\n" a2ps-mode-syntax-table)
(modify-syntax-entry ?\n ">#" a2ps-mode-syntax-table)
(modify-syntax-entry ?/  "\"" a2ps-mode-syntax-table)
;(modify-syntax-entry ?{  "_" a2ps-mode-syntax-table)
;(modify-syntax-entry ?}  "_" a2ps-mode-syntax-table)
(modify-syntax-entry ?\\  "_" a2ps-mode-syntax-table)
(modify-syntax-entry ?@  "w" a2ps-mode-syntax-table)
(modify-syntax-entry ?_  "w" a2ps-mode-syntax-table)
(modify-syntax-entry ?*  "w" a2ps-mode-syntax-table)

;;; a2ps-compile-regexp

;;; Author:        Didier Verna on metheny <verna@inf.enst.fr>
;;; Maintainer:    Verna@inf.enst.fr
;;; Created:       Wed Aug  6 08:54:37 1997 under emacs
;;; Last revision: Wed Aug  6 10:32:40 1997
;;;
;;; Removed this now the syntax is completely different.
;;; (defun a2ps-compile-regexp (start end)
;;;   "Compile a list of keywords or operators to the optimized regexp.
;;; - Select the region of keywords and type M-x a2ps-compile-regexp."
;;;   (interactive "r")
;;;   (let (thelist lines)
;;; 	(setq lines (count-lines start end))
;;; 	(goto-char start)
;;; 	(save-excursion
;;; 	  (while (< (point) end)
;;; 	    (re-search-forward "[^ #,\"\t\n]+")
;;; 	    (setq thelist (cons (match-string 0) thelist))
;;; 	    (goto-char (+ (match-end 0) 1))))
;;; 	(let ((i 1))
;;; 	  (beginning-of-line)
;;; 	  (while (<= i lines)
;;; 	    (if (not (string= (char-to-string (following-char)) "#"))
;;; 		(insert "#"))
;;; 	    (forward-line)
;;; 	    (setq i (+ i 1))))
;;; 	(insert "/")
;;; 	(save-excursion
;;; 	  (insert (prin1-to-string (make-regexp thelist)))
;;; 	  (delete-char -1)
;;; 	  (insert "/\n"))
;;; 	(delete-char 1)))

(defvar a2ps-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-c\C-b" 'a2ps-a2ps-buffer)
;;;    (define-key map "\C-c\C-r" 'a2ps-a2ps-region)
    (define-key map "\C-c\C-c" 'comment-region)
    map))

(defun a2ps-check-buffer ()
  "Check that the current style sheet is correct"
  (interactive)
  ;; This `let' is for protecting the previous value of compile-command.
  (let ((compile-command (concat a2ps-program
				 " -q < /dev/null -o - > /dev/null -E"
				 buffer-file-name)))
    (compile compile-command))
)

(defun a2ps-a2ps-region ()
  "send contents of the current region to a2ps"
  (interactive)
  (start-process "a2psprocess" "*a2ps output*" a2ps-program "-e")
  (process-send-region "a2psprocess" (point) (mark))
  (process-send-eof "a2psprocess")
  (switch-to-buffer "*a2ps output*")
)

(easy-menu-define a2ps-mode-menu
    a2ps-mode-map
    "Menu used in a2ps mode."
  (list "a2ps"
	["Compile region" a2ps-compile-regexp t]
	["Documentation" a2ps-goto-info-page t]
;	["Complete" TeX-complete-symbol t]
;	["Save Document" TeX-save-document t]
;	["Next Error" TeX-next-error t]
;	["Kill Job" TeX-kill-job t]
;	["Debug Bad Boxes" TeX-toggle-debug-boxes
;	 :style toggle :selected TeX-debug-bad-boxes ]
;	["Switch to Original File" TeX-home-buffer t]
;	["Recenter Output Buffer" TeX-recenter-output-buffer t]
;	;; ["Uncomment" TeX-un-comment t]
;	["Uncomment Region" TeX-un-comment-region t]
;	;; ["Comment Paragraph" TeX-comment-paragraph t]
;	["Comment Region" TeX-comment-region t]
;	["Switch to Master file" TeX-home-buffer t]
;	["Submit bug report" TeX-submit-bug-report t]
;	["Reset Buffer" TeX-normal-mode t]
;	["Reset AUC TeX" (TeX-normal-mode t) :keys "C-u C-c C-n"]
	))

;; Open info on the page on How to write a style sheet
(defun a2ps-goto-info-page ()
  "Read documentation for a2ps style sheets in the info system."
  (interactive)
  (require 'info)
  (Info-goto-node "(a2ps)Style sheets implementation"))

(defun a2ps-mode ()
  "A major-mode to edit a2ps style sheet files
\\{a2ps-mode-map}
"
  (interactive)
  (kill-all-local-variables)
  (use-local-map a2ps-mode-map)

  (make-local-variable 'comment-start)
  (setq comment-start "#")
  (make-local-variable 'parse-sexp-ignore-comments)
  (setq parse-sexp-ignore-comments t)

  ; Used to have a cooler environment
  (require 'filladapt)
  (filladapt-mode)

  ; Used to compile regexps
;  (load "make-regexp")

  ; Used for the menus
  (require 'easymenu)

  ; Install the menus
  (easy-menu-add a2ps-mode-menu a2ps-mode-map)

  ; The \ is used both as an escape in strings, and
  ; as a symbol constituent in LaTeX like symbols
  (setq words-include-escapes t)

  (make-local-variable	'font-lock-defaults)
  (setq major-mode 'a2ps-mode
	mode-name "a2ps"
	font-lock-defaults `(a2ps-font-lock-keywords nil)
	)
  (set-syntax-table a2ps-mode-syntax-table)
  (run-hooks 'a2ps-mode-hook))

(provide 'a2ps-mode)

;;stuff to play with for debugging
;(char-to-string (char-syntax ?`))

;;; (setq foo (make-regexp '("a2ps" "alphabet" "alphabets" "ancestors" "are" "by" "case" "closers" "documentation" "end" "exceptions" "first" "in" "insensitive" "is" "keywords" "requires" "second" "sensitive" "operators" "optional" "sequences" "style" "version" "written") t))

;;; (setq bar (make-regexp '("\\\\forall" "\\\\exists" "\\\\suchthat" "\\\\cong" "\\\\Alpha" "\\\\Beta" "\\\\Chi" "\\\\Delta" "\\\\Epsilon" "\\\\Phi" "\\\\Gamma" "\\\\Eta" "\\\\Iota" "\\\\vartheta" "\\\\Kappa" "\\\\Lambda" "\\\\Mu" "\\\\Nu" "\\\\Omicron" "\\\\Pi" "\\\\Theta" "\\\\Rho" "\\\\Sigma" "\\\\Tau" "\\\\Upsilon" "\\\\varsigma" "\\\\Omega" "\\\\Xi" "\\\\Psi" "\\\\Zeta" "\\\\therefore" "\\\\perp" "\\\\radicalex" "\\\\alpha" "\\\\beta" "\\\\chi" "\\\\delta" "\\\\epsilon" "\\\\phi" "\\\\gamma" "\\\\eta" "\\\\iota" "\\\\varphi" "\\\\kappa" "\\\\lambda" "\\\\mu" "\\\\nu" "\\\\omicron" "\\\\pi" "\\\\theta" "\\\\rho" "\\\\sigma" "\\\\tau" "\\\\upsilon" "\\\\varpi" "\\\\omega" "\\\\xi" "\\\\psi" "\\\\zeta" "\\\\sim" "\\\\varUpsilon" "\\\\prime" "\\\\leq" "\\\\infty" "\\\\florin" "\\\\clubsuit" "\\\\diamondsuit" "\\\\heartsuit" "\\\\spadesuit" "\\\\leftrightarrow" "\\\\leftarrow" "\\\\uparrow" "\\\\rightarrow" "\\\\downarrow" "\\\\circ" "\\\\pm" "\\\\geq" "\\\\times" "\\\\propto" "\\\\partial" "\\\\bullet" "\\\\div" "\\\\neq" "\\\\equiv" "\\\\approx" "\\\\ldots" "---" "\\\\carriagereturn" "\\\\aleph" "\\\\Im" "\\\\Re" "\\\\wp" "\\\\otimes" "\\\\oplus" "\\\\emptyset" "\\\\cap" "\\\\cup" "\\\\supset" "\\\\supseteq" "\\\\not\\\\subset" "\\\\subset" "\\\\subseteq" "\\\\in" "\\\\not\\\\in" "\\\\angle" "\\\\nabla" "\\\\varregister" "\\\\varcopyright" "\\\\vartrademark" "\\\\prod" "\\\\surd" "\\\\cdot" "\\\\not" "\\\\wedge" "\\\\vee" "\\\\Leftrightarrow" "\\\\Leftarrow" "\\\\Uparrow" "\\\\Rightarrow" "\\\\Downarrow" "\\\\vardiamondsuit" "\\\\langle" "\\\\register" "\\\\copyright" "\\\\trademark" "\\\\sum" "\\\\lceil" "\\\\lfloor" "\\\\apple" "\\\\rangle" "\\\\int" "\\\\rceil" "\\\\rfloor")))


;;; (defvar foobar (make-regexp '("Plain" "Keyword" "Keyword_strong" "Comment" "Comment_strong" "Label" "Label_strong" "String" "Symbol" "Tag1" "Tag2" "Tag3" "Tag4" "Index1" "Index2" "Index3" "Index4" "Error" "Encoding" "Invisible" "C-string" "C-char")))


;;; (setq forall (make-regexp '("\\\\forall" "\\\\bullet")))

;;; a2ps.el ends here
