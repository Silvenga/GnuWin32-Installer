;;a2ps-print.el: Postscript printing hook for a2ps.
;;This file is available at ftp://ftp.cppsig.org/pub/tools/emacs/a2ps-print.el
;;This requires a2ps to be installed in your PATH
;;a2ps is available at ftp://ftp.enst.fr/pub/unix/a2ps/ and others

;; Keywords: languages, faces, a2ps
;;Modified for enscript from lpr.el by Jim Robinson robinson@wdg.mot.com
;;Modified for a2ps by phanes@icon.com and docs by bingalls@panix.com
;;Tested on a2ps v4.10 on emacs & xemacs 20.2 on solaris

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
;; $Id: a2ps-print.el,v 1.1.1.1.2.1 2007/12/29 01:58:11 mhatta Exp $

;;Put the following into your .emacs:
;(load "a2ps-print")
;(global-set-key 'f22 'a2ps-buffer)			;f22 is Print Screen
;(global-set-key '(shift f22) 'a2ps-region-1)		;print selected text
;(add-menu-button '("File") ["a2ps-print" a2ps-buffer "--"]) ;on file menu
		;;Someday I'll get menu to show PrtScr instead of f22...

;you can pass up to 4 command line switches to a2ps.
;Here's a recommended sample for your .emacs:
;(setq a2ps-switches `("-C" "--line-numbers=1"))

(defvar a2ps-switches nil
;You can replace nil above with up to 4 hard coded switches:
;`("-C" "--line-numbers=1")
  "*List of strings to pass as extra switch args to a2ps when it is invo\
ked.")

(defvar a2ps-command "a2ps"
  "Shell command for printing a file")

(defun a2ps-buffer (argp)
  "Print buffer contents as with Unix command `a2ps'.
`a2ps-switches' is a list of extra switches (strings) to pass to a2ps."
  (interactive "P")
  (a2ps-region (point-min) (point-max) argp))

(defun a2ps-region (start end argp)
  "Print region contents as with Unix command `a2ps'.
`a2ps-switches' is a list of extra switches (strings) to pass to a2ps."
  (interactive "r\nP")
  (let ((switches a2ps-switches)
        (lpr-command a2ps-command))
    (if argp
        (setq switches (append switches (list (read-string "switches: ")))))
    (a2ps-region-1 start end switches)))

(defun a2ps-region-1 (start end switches)
  (let (
	(name (buffer-name))
	(filetype (substring (buffer-name)
			     (string-match "[^.]*$" (buffer-name))))
        (width tab-width))
; this line doesn't work if switches actually contains anything
;    (message (concat "Sending '" name "' to " lpr-command " switches: "
;    switches " filetype: " filetype))
    (save-excursion
      (message "Spooling...")
      (if (/= tab-width 8)
	  (let ((oldbuf (current-buffer)))
	    (set-buffer (get-buffer-create " *spool temp*"))
	    (widen) (erase-buffer)
	    (insert-buffer-substring oldbuf)
	    (setq tab-width width)
	    (untabify (point-min) (point-max))
	    (setq start (point-min) end (point-max))))
      (apply 'call-process-region
	     (nconc (list start end lpr-command
			  nil nil nil
;above can be replaced with this debug line:
;                        nil '(nil "/tmp/EEE") nil
;			  (concat "--header=" name)
			  (concat "--center-title=" name)
			  (concat "--footer=" (concat name " Emacs buffer"))
			  (concat "--pretty-print=" filetype)
;Uncommenting the following gives a print preview (only):
;			  (concat "--output=/tmp/foo.ps")
			  )
		    switches))
      (message "Spooling...done")
      )))

