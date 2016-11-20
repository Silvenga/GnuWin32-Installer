;; gri-mode.el - major mode for Gri, a scientific graphics programming language

;; Copyright (C) 1994-2005 Peter S. Galbraith
 
;; Author:    Peter S. Galbraith <psg@debian.org>
;; Created:   14 Jan 1994
;; Version:   2.68 (01 Mar 2005)
;; Keywords:  gri, emacs, XEmacs, graphics.

;;; This file is not part of GNU Emacs.

;; This package is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License version 2 as 
;; published by the Free Software Foundation.

;; This package is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;; ----------------------------------------------------------------------------
;;; Commentary:

;; This major mode for GNU emacs provides support for editing Gri files.
;; Gri is a graphics plotting language that produces beautiful postscript
;; output suitable for publications.  Gri is written by Dan Kelley,
;; Dalhousie University.  General info about Gri is available at
;;
;;       http://gri.sourceforge.net

;; Full documentation on the installation and use of gri-mode.el is
;; provided in the Gri manual, included in source form in gri's source tar
;; file, in Info and HTML form in binary packages, and on-line at
;;
;;       http://gri.sourceforge.net/gridoc/html/Emacs.html

;; Features of gri-mode include:
;;
;;   Automatic indentation for block structures, line continuations, 
;;     and comments.  
;;   Parenthesis matching support.  
;;   Gri command completion (using abbreviations in your gri buffer)
;;   Displays help and info-manual about the gri command on the current line.  
;;   Hide user commands at the beginning of gri buffers (similar to Outline 
;;     mode)
;;   Run gri from within emacs.
;;   Display (possibly compressed) postscript file associated with gri file.
 
;;; Installation  -- Follow these 3 steps:
;;
;; 0- Configuring Emacs to load your extra .el files
;;    (Debian package and Red Hat Powertools package users can skip this, 
;;     as it's done for them.)
;;
;;  Extra .el files like gri-mode.el that are not part of Emacs should be
;;  stored in a directory where Emacs will find them when you ask it to
;;  load them.  The files should therefore be found in Emacs' `load-path'.
;;  To see the directory list currently in the load-path, do
;;
;;    C-h v load-path
;;
;;  If you have access to system directories, put gri-mode.el in a
;;  `site-lisp' directory, such as `/usr/local/share/emacs/site-lisp/'
;;  That way all users will have access to the files.
;;
;;  If you don't have access to a site-lisp directory (e.g. you have only a
;;  user account), then create a directory where your extra .el files will
;;  be stored and add it to Emacs' load-path.  For example, say you created
;;  the directory ~/emacs and stored gri-mode.el there, you would then put
;;  this near the top of your ~/.emacs file:
;;
;;    (setq load-path (cons "~/emacs" load-path))
;;
;; 1- Configuring gri-mode to where gri lives on your system:
;;    (Debian package and Red Hat Powertools package users can skip this, 
;;     as it's done for them.)
;;
;;  If gri is installed as /usr/local/bin/gri and /usr/local/share/gri/gri.cmd 
;;  on your system, go to step 2.  If not, then you need to set the variable
;;  gri*directory-tree.
;;
;;  The Emacs variable `gri*directory-tree' is used to configure gri-mode
;;  to where Gri is installed on your system.  If you have only one version
;;  of gri installed on your system, gri-mode expects to find gri.cmd and
;;  the gri executable like so:
;;
;;     `gri*directory-tree`/gri.cmd 
;;      and the gri executable in the PATH
;;  or
;;     `gri*directory-tree`/lib/gri.cmd 
;;      and the gri executable in the PATH
;;  or
;;     `gri*directory-tree`/bin/gri
;;     `gri*directory-tree`/lib/gri.cmd
;;
;;  However, gri-mode was designed to support, and ease the use of, multiple
;;  installed versions of gri.  To use this feature, you must use the gri
;;  version number as a directory name under the `gri*directory-tree` path,
;;  like this:
;;
;;     `gri*directory-tree`/VERSION/bin/gri
;;     `gri*directory-tree`/VERSION/lib/gri.cmd
;;
;;      (e.g. /opt/gri/2.040/bin/gri and /opt/gri/2.040/lib/gri.cmd with 
;;       gri*directory-tree set to "/opt/gri")
;;
;;  or without the `lib' and `bin' subdirectories if the executable is
;;  found in the PATH named like `gri-VERSION'
;;
;;     `gri*directory-tree`/VERSION/gri.cmd
;;     gri-VERSION executable in the PATH
;;
;;      (e.g. /usr/share/gri/2.1.17/gri.cmd and /usr/bin/gri-2.1.17 with
;;       gri*directory-tree set to "/usr/share/gri")
;;
;;  Example 1:
;;   If you had multiple versions of Gri installed like so:
;;    /opt/gri/2.040/bin/gri
;;    /opt/gri/2.040/lib/gri.cmd
;;    /opt/gri/2.041/bin/gri
;;    /opt/gri/2.041/lib/gri.cmd
;;   then you'd use:
;;    (setq gri*directory-tree "/opt/gri/")
;;
;;  Example 2:
;;   If you use a Debian GNU/Linux installation like:
;;    /usr/bin/gri -> /usr/bin/gri-2.1.17
;;    /usr/share/gri/2.1.17/gri.cmd
;;   then you'd use:
;;    (setq gri*directory-tree "/usr/share/gri/")
;;   Note that since there is no /usr/share/gri/bin/ directory (a similar 
;;   structure to /opt/gri above), all gri binaries with version number 
;;   suffixes must exist in the path (e.g. gri-2.1.17)
;;
;;  Example 3:
;;   If you use a RedHat Powertool installation like:
;;    /usr/bin/gri
;;    /usr/share/gri/gri.cmd
;;   then you'd also use:
;;    (setq gri*directory-tree "/usr/share/gri/")
;;   but gri-mode would know of only one installed version of gri.
;;
;;   You may have more than one tree and make a list of them:
;;    (setq gri*directory-tree '("/opt/gri/" "/usr/share/gri/"))
;;
;; 2- Telling emacs to load gri-mode:
;;    (Debian package users can skip this, as it's done for them.)
;;
;;  To tell emacs to use this mode with .gri files, you can load gri-mode 
;;  whenever a new emacs session is starting by adding the following line 
;;  to your ~/.emacs file:
;;
;;   (require 'gri-mode)
;;
;;  This is a good thing specially when you only start emacs once a week and
;;  use it for every file you edit (as you should).  
;;  If you startup a fresh emacs every time you edit (bad scientist!)
;;  then you probably only want to load gri-mode into emacs when you need it.
;;  In that case, instead of the `require' statement above, add the following 
;;  lines to your ~/.emacs file:
;;
;;   (autoload 'gri-mode "gri-mode" "Enter Gri-mode." t)
;;   (setq auto-mode-alist (cons '("\\.gri$" . gri-mode) auto-mode-alist))
;;
;; 3- Extra user configuration of gri-mode
;;    (all users should do this at some point)
;;
;;  At this point, gri-mode should start up when you edit a gri file.  You
;;  may optionally customize gri-mode by using the Custom interface (see
;;  the Help or Gri-Help menu).
;;
;; ----------------------------------------------------------------------------
;;; Change log:
;;
;; V1.03 14jan94 by Peter Galbraith, rhogee@bathybius.meteo.mcgill.ca
;;      Created (based on version 1.02 from Dan Kelley. See later in file.)
;; V1.03a 18jan94 - fixed bug in gri-hide-all
;;                  improved gri-hide-function to detect beginning of program
;; V1.04 19jan94 - gri-perform renamed gri-run
;;               - gri-run is now error-smart (puts cursor on proper line)
;;               - add gri-view (C-c v)
;;               - move gri-version to C-c C-v
;;               - don't indent comment after system line (e.g. used in sed)
;;       26jan94 - bug fix: `Unbalanced Parenthese' on gri-info and gri-help
;;               - remove C-C c binding for gri-complete
;;               - gri-apropos renamed gri-help-apropos
;;               - bound M-q to gri-indent-region
;;               - prefixed gri-indent-region indents entire buffer.
;;       31jan94 - Added menus
;;               - Added C-C ?
;;               - gri-function-skeleton
;;       08feb94 - Added support for hilit19.el
;;       09feb94 - Added gri*hilit-declarations variable
;;       10feb94 - Added gri*view-command and gri*view-landscape-arg variables
;; V1.05 15feb94 - gri-view checks that postscript file exists. 
;;               - Added gri-narrow-to-function, added to menu as well.
;;       22feb94 - debugged gri-isolate-this-command for lines with comments
;;               - Added ERROR message to gri-run.
;;                 Don't show the shell-output-buffer window if only showing 
;;                 the error message (no set trace on).
;;                 ** still can't it shell-output-buffer to display ending **
;;               - Added gri-comment-out-region (in menu)
;;               - Added gri-uncomment-out-region (in menu)
;;               - Added `Info Special Topics' menu
;;       28feb94 - Changed key defs from `C-c letter' to `C-c C-letter'
;;       07Mar94 - Added gri-help and gri-info w/ minibuffer completion.
;; V1.06 23Mar94 - hilit19 for /* comments new for gri V1.069 */
;;                 hilit19 enhanced highlighting for hidden commands 
;; V1.07 28Mar94 - hilit optionally after carriage return
;;       05Apr94 - Removed gri-system-syntax-file variable
;;               - Replaced variable gri-cmd-file by gri*path
;;       07Apr94 - hilit for system <<"EOF" 
;;                 hilit further enhanced on hidden commands
;;                 Added vars gri*hilit-variables and gri*hilit-rpn-contents
;; V1.08 08Apr94 - Added gri-insert-file-as-comment.
;;       13Apr94 - gri-indentation skips over foreign system code. 
;;       14Apr94 - Fixed gri-help, extracting text fell short with numerics.
;;       18Apr94 - Added gri-mosaic-manual
;;       25Apr94 - expand-file-name instead of concat usage.
;;       03May94 - gri*view-after-run added
;;               - Improved hilit pattern for `\synonym = system'
;; V1.09 15Jun94 - Deleted key-defs in menus (standard in emacs-19.24)
;; V1.10 07Jul94 - Fixed indentation on continued system lines (else, //)
;;               - gri-hide-all would hide second line if no program existed.
;; V1.11 06Sep94 - Added gri-view for gzip'ed files.
;; V1.12 05Oct94 - C-c C-k kills contents of string or variable under cursor 
;;                 if not within an option.
;;                 (still kills option, when within an option).
;;               - Enhanced gri-next-option now bound to C-c C-n
;;               - Moved gri-narrow-to-function to C-c M-n
;;               - Bound gri-indent-buffer to M-C-v
;; V1.13 03Nov94 - Better gri-view
;;       20Dec94 - Changed WWW gri manual URL
;;               - Changed gri-mosaic-manual to gri-WWW-manual
;;                         gri*mosaic-program to gri*WWW-program
;;                         -  default is now Mosaic.
;; V1.14 17Feb95 - gri-close-statement added.
;; V1.15 17Feb95 - gri-close-statement fixed.
;; V1.16 23May95 - detect gri segmentation fault.
;; V1.17 09Jun95 - new way of calling gri. See gri*directory-tree variable. 
;; V1.18 21Jun95 - Added gri-print
;; V1.19 28Jun95 - Added major artificial intelligence to detect bad 
;;                 installation.  I had an evening to spare!
;; V1.20 09Nov95 - emacs-19.29 bug on completion fixed.
;; V1.21 01dec95 - gri-version more flexible about gri directory names
;; V1.22 27dec95 - `M-;' still not generic emacs, but `kill-comment' and
;;                 `M-x comment-region' work correctly.
;;                 New syntax table -> font-lock won't crash!
;;                 New functions gri-option-select-mouse gri-kill-option-mouse
;; V1.23 22jan96 - Added gri-command-arguments and auto-mode-alist setup.
;; V1.24 11jun96 - Added new gri-insertion-filter for set-process-filter
;;                 Added shell-command-switch for Windows (uses "/c").
;; V1.25 11jul96 RCS 1.1 
;; - Added *single* menu for XEmacs. Now loads under XEmacs.
;; V1.26 24jul96 RCS 1.2 
;; - Fixed XEmacs special-topics info menu. 
;; - set-buffer-menubar in XEmacs so that menu disappears after.
;; V1.27 24Aug96 RCS 1.10
;; - font-lock support.
;; - Added gri*use-hilit19.
;; - Adding gri-local-version (not finished yet).
;; V1.28 25Oct96 RCS 1.11 - Bug in gri-kill-option
;; V1.29 11Nov96 RCS 1.12 
;; - gri-set-local-version added.
;; - gri-version renamed to gri-set-version.
;; V1.30 31Dec96 RCS 1.13 - Repeat single-line output from gri-run after view
;; V1.31 11Feb97 RCS 1.14 - Better fontification of multi-line system commands.
;; V1.32 03Jun97 RCS 1.15 - `Running gri done' message.
;; V1.33 20Oct97 RCS 1.16 - Fixed font-lock for Emacs-20
;; V1.34 21Oct97 RCS 1.17 - Fixed menu definition conditional for Emacs-20
;; V1.35 01Dec97 RCS 1.18 - Emacs-20 outline-minor-mode invisibility.
;; V2.00 10Jul98 RCS 1.21 - gri*path removed. Allow list in gri*directory-tree.
;; V2.01 27Jul98 RCS 1.23 - skipped over a version in gri*directory-tree
;; V2.02 21Aug98 RCS 1.24 - changed gri*WWW-manual 
;; V2.03 15Oct98 RCS 1.27 - added # comments; better gri-local-version control.
;; V2.04 10Jan98 RCS 1.29 - only # comments!
;;                        - added gri-convert-comments 
;;                        - added gri-convert-comments-with-prompt
;; V2.05 27Jan98 RCS 1.30 - Fixed completion when case-different matches exist
;; V2.06 14May99 RCS 1.31 - Fixed `\.var. = system' detected as system line 
;; V2.07 30Nov99 RCS 1.32 - Fixed gri info special topics that have changed
;; V2.08 30Nov99 RCS 1.33 - Default gri*view-command is now gv.
;; V2.09 19Dec99 RCS 1.34 - Fixed gri-info-function for xemacs20
;;                        - Switch to easy-menu and added gv scale selection
;;                        - add gri-fontify-buffer
;; V2.10 20Dec99 RCS 1.35 - Added first XEmacs toolbar button.
;; V2.11 21Dec99          - XEmacs gv scale selection uses radio buttons
;; V2.12 19Jan00 RCS 1.36 - XEmacs-21 doesn't have variable lpr-command
;; V2.13 19Jan00 RCS 1.37 - XEmacs-21 fixes: no toolbar in -nw; no show-all
;; V2.14 29Mar00 RCS 1.38 
;; - Made gri*directory-tree default to new /usr/local/share/gri location
;; - Made RedHat setup work (/usr/bin/gri & /usr/share/gri/gri.cmd)
;; V2.15 09Apr00 RCS 1.39 - add `www' prefix to gri*WWW-page URL.
;; V2.16 13Apr00 RCS 1.40 - gri-do-run won't move to gri.cmd on error.
;; V2.17 18Apr00 RCS 1.41 - Made gri-expand-versions use -directory_default
;;                          in case gri*directory-tree is not set correctly.
;; V2.18 19Apr00 RCS 1.42 - 
;;  Removed underlines from ~/.gri-syntax file, using semicolon as separator.
;;  Fixed all functions such that completions buffer now shows real names and
;;  you can click on one to ener it.
;; V2.19 14May00 RCS 1.43
;; - Use customize; update install docs; use radio buttons for gv-scale in
;;   Emacs too;
;; - Fix gri-build-command-alist broken since whitespace removed in gri-syntax
;; V2.20 14May00 RCS 1.44 
;; - gri-help accepts argument (in prep for command list menu)
;; V2.21 16May00 RCS 1.45
;; - buggy gri-match-list-to-string caused wrong completions string
;; V2.22 17May00 RCS 1.46
;; - Added the Gri command list menubar.
;; - gri-apropos alias and bug fix for new syntax file format.
;; V2.23 18May00 RCS 1.47
;; - eval Gri command list menubar only when gri-cmd-file is set correctly
;; - Gri info file can have .info extension now.
;; V2.24 18May00 RCS 1.48
;; - tweaks for XEmacs (easymenu entries need `t' at end; 
;;   call add-submenu in gri-mode)
;; V2.25 19May00 RCS 1.49 - Removed RCS Id line to avoid confusion.
;; V2.26 19May00 RCS 1.50 
;; - gri-info-function changed to lookup `Index of Commands' instead of raw
;;   list of nodes.
;; V2.27 30May00 RCS 1.51 - default web page changed to:
;;    http://www.phys.ocean.dal.ca/~kelley/gri/index.html 
;; V2.28 21Jun00 RCS 1.53 - Added gri*run-settings
;;                        - Bettered some customize entries.
;; V2.29 18Jul00 RCS 1.54 - default web page changed to:
;;    http://gri.sourceforge.net/gridoc/html/index.html
;; V2.30 03Aug00 RCS 1.55 - default web page changed to:
;;    "http://gri.sourceforge.net/gridoc/html/index.html" (fixes bug)
;; V2.31 03Aug00 RCS 1.56 - `gri-help pwd' was broken (improper regexp)
;; V2.32 28Aug00 RCS 1.57 
;;  - Added buffer-local variable gri-command-postarguments
;;    and functions gri-set-command-postarguments and
;;    gri-unset-command-postarguments.
;; V2.33 29Aug00 RCS 1.58 - gri-hide-all skips over initial commands 
;; V2.34 25Sep00 RCS 1.59 - allows spaces after new command brackets
;;    Closes SF Bug #115307
;; V2.35 09Jan01 RCS 1.60 - gri-mode-is-Emacs20 -> gri-mode-is-Emacs2X
;;                          for Emacs-21 now out in beta.
;; V2.36 07Feb01 RCS 1.61 - add ~.grirc to auto-mode-alist
;; V2.37 15Feb01 RCS 1.62 - modify syntax table for strings with embedded "
;; V2.38 20Feb01 RCS 1.63 - add display of defaults after completion (>= 2.6.0)
;; V2.39 20Feb01 RCS 1.64 - add imenu support.
;; V2.40 20Feb01 RCS 1.65 - add gri-idle-display-defaults.
;; V2.41 20Feb01 RCS 1.66 - gri-idle-display-defaults set outside of X too.
;; V2.42 21Feb01 RCS 1.67 - move idle timer startup into gri-mode proper.
;; V2.43 11Apr01 RCS 1.68 - gri-common-in-list: fix bug introduced in
;;   completion of "set color" when compared to "set colorname"
;; V2.44 01May01 RCS 1.69 - XEmacs has IMenu after all.
;; V2.45 03May01 RCS 1.70 - Fix byte-compiled gri-mode's imenu from
;;   imenu-progress-message macro definition (can't rely on variable
;;   defined here for loading of imenu during byte-compilation).
;;   (Closes SF Bug #421076)
;; V2.46 10May01 RCS 1.71 - gri-initialize-version: wrong scope for version var
;;   imenu--create-gri-index: fix for few variables and synonym cases.
;; V2.47 10May01 RCS 1.72 - locally set resize-mini-windows to nil when
;;   running shell--command to run gri.
;; V2.48 01Jun01 RCS 1.73 - Add emacs21 icons for gri-info and gri-view
;; V2.49 06Jun01 RCS 1.74 - "Error at FILE:LINE" now instead of "detected at"
;; V2.50 13Jul01 RCS 1.75 - Add support for completion of builtin variables.
;;   gri-build-expansion-regex: detects if at end of ..var[point]
;;   gri-add-variables: new function.
;;   gri-perform-completion: tweak fo delete only to gri-complete-begin-point
;; V2.51 14Jul01 RCS 1.76 - Fix support for completion of builtin variables.
;;   gri-lookat-syntax-file: add ARG = 3 to skip over variables.
;;   gri-build-command-alist: skip over variables in syntax buffer.
;;   gri-menubar-cmds-build: (gri-lookat-syntax-file 3)
;;   gri-build-expansion-regex: stop at \.synonym.
;;   gri-perform-completion: needed to regexp-quote the search string
;; V2.52 15Jul01 RCS 1.77 - Add set/unset-command-postarguments to Perf menubar
;; V2.53 17Jul01 RCS 1.78 - Tweak Perform menubar order.
;; V2.54 18Jul01 RCS 1.79 - Change toolbar icons to look nicer.
;; V2.55 18Jul01 RCS 1.80 - Add gri-syntax-default-this-builtin used by idle
;;   timer.
;; V2.56 18Jul01 RCS 1.81 - Fontify defined builtins distinctively
;; V2.57 18Jul01 RCS 1.82 - Tweak the new local .variable. regexp for font-lock
;; V2.58 24Jul01 RCS 1.83 - Typo fix.
;; V2.59 24Jan02 RCS 1.85 - Support gv -watch option.  When using gri-run,
;;   an existing gv process will be stopped during figure regeneration, and
;;   therafter continued.  gv will then redisplay automatically.
;; V2.60 25Jan02 RCS 1.87 - Fix support for gv -watch option in Emacs20.
;;   Sending (signal-process ID 'SIGCONT) doesn't change the process status
;;   from 'stop, even though the process did start up again.  I need to do:
;;   (continue-process PROCESS) to change the status.  Bug in emacs20?
;; V2.61 09May02 RCS 1.88 - Add support for 'gv -noantialias' option.
;; V2.62 21Jun02 RCS 1.89 - Make gri*view-command more customizible, with menu.
;; V2.63 31Jul02 RCS 1.90 -
;;  gri-validate-version: new function, see if specified version is available.
;;  gri-validate-cmd-file: new function, see if gri-cmd-file as set ik okay.
;;  gri-what-version: REMOVED function.  Not very useful anyway.
;; V2.64 02Apr2003 - Remove old hilit19 code.  Obsolete.
;; V2.65 09Jun2003 - Added Help menu entry to gri History.
;; V2.66 17Aug2004 - Eric Nodwell <nodwell@physics.ubc.ca>
;;  keybindings similar to phyton-mode to (un)comment regions.
;; V2.67 16Dec2004
;;  Adapt to new texinfo's "Index of Commands" which includes a line offset
;;   number.
;; V2.68 01mar2005
;;  gri-view: Adapt to new gv options. (Closes: #296692)
;; ----------------------------------------------------------------------------
;;; Code:
;; The following variable may be edited to suit your site: 

(defgroup gri nil 
  "Gri - Scientific graphics language" :group 'languages)

(defcustom gri*directory-tree "/usr/local/share/gri"
  "Root of the gri directory tree.

Root of the gri directory tree holding versions of gri library files.
This is either a string, or a list of strings.

In the following file layout, gri*directory-tree should be set to 
\"/usr/share/gri\"

 /usr/bin/gri-2.10.1
 /usr/share/gri/2.10.1/gri.cmd

In the following file layout, gri*directory-tree should be set to \"/opt/gri\"

 /opt/gri/2.1.17/bin/gri
 /opt/gri/2.1.17/lib/gri.cmd

If you had both layouts, you'd use:

 (setq gri*directory-tree '(\"/opt/gri/\" \"/usr/lib/gri\"))

Notes:
 1 - The lib/ directory is optional.
 2 - The bin/ directory may exist to hold the gri binary.  If it doesn't
     exist, gri-mode will assume that the gri command suffixed with the 
     version number exists in the path (e.g. /usr/bin/gri-2.1.17).

This variable must be set correctly for gri-mode to function properly, and
for the `gri-set-version' command to switch between gri versions.

See the gri-mode.el file itself for more information."
    :group 'gri
    :type '(choice (directory) (repeat directory)))

(defcustom gri-idle-display-defaults
  (fboundp 'run-with-idle-timer)
  "*t means to display function defaults under point when Emacs is idle."
  :group 'gri
  :type 'boolean)

(defcustom gri-menubar-cmds-action 'Info
  "Default action to do on listed Gri command in Cmds menu-bar menu.
This can be set to one of Info, Help or Insert."
  :group 'gri
;;; :type '(restricted-sexp :match-alternatives ('Info 'Help 'Insert)
  :type '(choice (const :tag "Info" Info)
                 (const :tag "Help" Help)
                 (const :tag "Insert" Insert)))

(defcustom gri*run-settings nil
  "List of optional parameters to pass to gri when running it.
This list makes the startup values used in the menubar pull-down menu."
  :group 'gri
  :type '(set (const "-debug")
              (const "-nowarn_offpage")
              (const "-no_bounding_box")
              (const "-publication")
              (const "-trace")))

(defcustom gri*use-imenu (fboundp 'imenu-add-to-menubar)
  "*Use imenu package for gri-mode?
If you do not wish this behaviour, reset it in your .emacs file like so:

  (setq gri*use-imenu nil)"
  :group 'gri
  :type 'boolean)

(defcustom gri*view-after-run t
  "When true, the graph will be displayed after compilation.
See also variable gri*view-command to set what viewer to use.
If you do not wish this behaviour, reset it in your .emacs file like so:

  (setq gri*view-after-run nil)"
  :group 'gri
  :type 'boolean)

(defcustom gri*view-command 'gv
  "Command used by gri-view to display postscript file.
Reset this in your .emacs file (but not in your gri-mode-hook) like so:

  (setq gri*view-command \"ghostview -magstep -1\") ;for small screens
or
  (setq gri*view-command \"gv -media letter\")

Note: If you use gv as a viewer, use the gri*view-scale variable to set 
the default scale; don't use the gv -scale option in this variable."
  :group 'gri
  :type '(choice (const :tag "gv" gv)
                 (const :tag "gv (old version)" gv-old)
                 (const :tag "gnome-gv" gnome-gv)
                 (const :tag "ggv" ggv)
                 (const :tag "ghostview" ghostview)
                 (const :tag "kghostview" kghostview)
                 (string :tag "User specified command")))

(defcustom gri*view-landscape-arg "-landscape" 
  "Argument used to obtain landscape orientation in gri-view.
This argument is passed to the shell along with the command stored 
in the variable gri*view-command.
Reset this in your .emacs file (but not in your gri-mode-hook) like so:

  (setq gri*view-landscape-arg \"\")

  where the empty string is used here (as an example) if no landscape
  argument exists for the command used in gri*view-command.

This is only used when gri*view-command is set to a user-specified string.
ghostview or gv-old use -landscape, gv uses --orientation=landscape and
kghostview and gnome-gv don't support the option."
  :group 'gri
  :type 'string)

(defcustom gri*view-scale 0
  "Default scale argument to use when using gv as gri-view command.
You may change this via the menu-bar during an editing session."
  :group 'gri
  ;;  :type 'integer)
  :type '(choice (const :tag "0.1" -5)
                 (const :tag "0.125" -4)
                 (const :tag "0.25" -3)
                 (const :tag "0.5" -2)
                 (const :tag "0.707" -1)
                 (const :tag "1" 0)
                 (const :tag "1.414" 1)
                 (const :tag "2" 2)
                 (const :tag "4" 3)
                 (const :tag "8" 4)
                 (const :tag "10" 5)))
(make-variable-buffer-local 'gri*view-scale)

(defcustom gri*view-watch t
  "When true, use -watch option with gv to check the document periodically.
If changes are detected gv will automatically display the newer version of
the file."
  :group 'gri
  :type 'boolean)
(make-variable-buffer-local 'gri*view-watch)

(defcustom gri*view-noantialias nil
  "When true, use -noantialias option with gv.
The current version of 'gv' has known rendering bugs using -antialias,
so try setting this if parts of a figure don't show up on the screen."
  :group 'gri
  :type 'boolean)
(make-variable-buffer-local 'gri*view-noantialias)

(defcustom gri*WWW-program nil
  "Program name for World-Wide-Web browser, used by command gri-WWW-manual.
If set to nil, gri-mode will use the Emacs' browse-url package to deal with
the browser request.  If set to a string, gri-mode will start it as a
sub-process.

On your system, this could be `netscape'.  If so, set this variable in your
.emacs file like so:

  (setq gri*WWW-program \"netscape\")"
  :group 'gri
;;; :type '(restricted-sexp :match-alternatives (stringp 'nil))
  :type '(choice (const :tag "Use browse-url package" nil)
                 (string :tag "Specify a program")))


(defcustom gri*WWW-page "http://gri.sourceforge.net/gridoc/html/index.html"
  "*Web page or local html index file for the gri manual.
This is used by the gri-WWW-manual command.
If the sourceforge site is down, try:
 http://www.phys.ocean.dal.ca/~kelley/gri/index.html
On your system, this could be reset to a local html file, e.g.
 (setq gri*WWW-page \"file:/usr/share/doc/gri-html-doc/html/index.html\")
but it defaults to the online gri manual at sourceforge.net:
 http://gri.sourceforge.net/gridoc/html/index.html

See also:  variable gri*WWW-program."
  :group 'gri
  :type 'string)

(defcustom gri-indent-before-return nil
  "Set to true to indent current line when pressing carriage return.
Reset this in your .emacs file like so:

  (setq gri-indent-before-return t)"
  :group 'gri
  :type 'boolean)

(defcustom gri*lpr-command (if (boundp 'lpr-command) 
                               lpr-command
                             "lpr")
  "Command used by gri-mode to print PostScript files produced by gri.
Set only the command name here.  Options are set in gri*print-switches"
  :group 'gri
  :type 'string)

(defcustom gri*lpr-switches (if (boundp 'lpr-switches) lpr-switches)
  "Options used to print PostScript files produced by gri.
This is usually entered as a list of strings:
   (setq gri*lpr-switches '(\"-P las_imlsta\" \"-ps\"))
but can also be entered simply as a single string:
   (setq gri*lpr-switches \"-P las_imlsta -ps\")"
  :group 'gri
  :type '(repeat string))

(defvar gri-view-process nil
  "Buffer local variable holding the process object for gri-view, if any.")
(make-variable-buffer-local 'gri-view-process)

;; ----------------------------------------------------------------------------
;; The syntax file looks like:     Used by:
;; -------------------
;; Syntax for gri version 1.063
;; -                               gri-complete works from here (all commands)
;; ?set_axes   (fragments)
;; --                              gri-help-apropos
;; Draw_Ctd    (user commands)
;; ---                             gri-help (backward to see if user command) 
;; cd cd [\pathname]
;; close close [\filename]
;; -------------------
;;                                (gri-info doesn't look at this file)
;;
;;  System gri commands and fragments are inserted when .gri-syntax is created.
;;  User commands and fragments are added when *gri-syntax* buffer is created
;;   and when gri-mode is invoked (on a new gri buffer) if *gri-syntax* exists.
;;   That way, we won't create *gri-syntax* for users who never use it.
;;  User commands and fragments can overwrite older user commands AND any
;;   fragments (whether gri or not).  This provides a mean for users to modify
;;   official gri fragments. 

(if (not (fboundp 'when))
    (eval-when-compile
      (require 'cl)))

(defvar gri-mode-is-XEmacs
  (not (null (save-match-data (string-match "XEmacs\\|Lucid" emacs-version)))))

(defvar gri-mode-is-Emacs2X
  (and (not gri-mode-is-XEmacs) (<= 20 emacs-major-version)))

(defvar gri-bin-file "" "Command used to call gri binary.") 
(defvar gri-cmd-file "" 
  "gri.cmd file used when calling gri command (if gri-bin-cmd not \"gri\")
and used for gri-mode syntax.") 

(defvar gri-sys-command-alist nil
  "Alist of gri system commands.
This list is filled automatically when needed.")

(defvar gri-user-command-alist nil
  "Alist of gri user commands
This list is filled automatically when needed.")

(defvar gri-version-list nil
  "Internal list of gri versions available from variable gri*directory-tree")

(defvar gri-local-version nil
  "Local variable for gri version to use on this file.
To use this, you insert strings like this at the end of the file:

# Local Variables:
# gri-local-version: \"2.053\"
# End:")
(make-variable-buffer-local 'gri-local-version)

(defvar gri-command-arguments ""
  "command arguments to pass to gri when using gri-run, excluding -b -y
which are always sent.")
(make-variable-buffer-local 'gri-command-arguments) 

(defvar gri-command-postarguments ""
  "command arguments to pass to gri after the script file, i.e. file names.
Used, for example, to run a gri script that requires data filenames as 
argument:

 $ gri script.gri datafile1.dat datafile2.dat

In the above example, you'd set gri-command-postarguments to 
\"datafile1.dat datafile2.dat\".

Use `M-x gri-set-command-postarguments' to set this locally for one gri file.
This variable is only locally set for a particular file.")
(make-variable-buffer-local 'gri-command-postarguments)

(defvar gri-idle-timer nil
  "Holds gri's idle timer when set.")

(defvar gri-commands-menu nil)
(defvar gri-menubar nil)

(defun gri-set-local-version ()
  "Set the version of gri to use on this file only.
This adds an emacs local-variable at the end of your file as a gri comment,
such that gri-mode will use the proper version of gri the next time you
edit the gri file."
  (interactive)
  (let* ((table (gri-expand-versions))
         (version (and table            ;Choose if we have possiblities (table)
                       (completing-read "Gri version number to use: "
                                        table nil t nil))))
    (cond 
     ((string-equal version "")
      (error "No version specified.  Exiting."))
     ((string-equal version "default")
      (message 
       "Unsetting local-buffer version and using default version of gri")
      (gri-unset-local-version))
     (t
      (setq gri-local-version version)
      (save-excursion
        (goto-char (point-max))
        (if (re-search-backward "\\(//\\|#\\) Local Variables:" nil t)
            (if (re-search-forward "gri-local-version: \"\\(.*\\)\"" nil t)
                (progn
                  (goto-char (match-beginning 1))
                  (delete-region (match-beginning 1)(match-end 1))
                  (insert version))
              (end-of-line)
              (insert "\n# gri-local-version: \"" version "\""))
          (goto-char (point-max))
          (insert "# Local Variables:\n"
                  "# gri-local-version: \"" version "\"\n"
                  "# End:\n")))))
      (gri-initialize-version t)))

(defun gri-unset-local-version ()
  "Unset this buffer's local version of gri and use default value instead"
  (interactive)
  (setq gri-local-version nil)
  (save-excursion 
    (save-restriction
      (widen)
      (goto-char (point-max))
      (when (and (re-search-backward "# Local Variables:" nil t)
                 (re-search-forward  "# gri-local-version:" nil t))
        (delete-region (progn (beginning-of-line)(point))
                       (progn (forward-line 1) (point)))
        (forward-line -1)
        (if (and (looking-at "# Local Variables:\n")
                 (progn (forward-line 1)(looking-at "# End:")))
            (delete-region (progn (end-of-line)(point))
                           (progn (forward-line -1) (point))))))))

(defun gri-menu-set-command-postarguments ()
  "Set filename arguments to use for this script when running gri

This adds an emacs local-variable at the end of your file as a gri comment,
locally setting the gri-mode variable `gri-command-postarguments'."
  (interactive)
  (let ((args (read-string "Arguments: ")))
    (gri-set-command-postarguments args)))

(defun gri-set-command-postarguments (args)
  "Set filename arguments to use for this script when running gri

This adds an emacs local-variable at the end of your file as a gri comment,
locally setting the gri-mode variable `gri-command-postarguments'."
  (interactive (list (read-string "Arguments: ")))
  (cond 
   ((string-equal args "")
    ;; Unset here? Or error?
    ;;(error "No arguments specified.  Exiting."))
    (message "Unsetting local-buffer variable.")
    (gri-unset-command-postarguments))
   (t
    (setq gri-command-postarguments args)
    (save-excursion
      (goto-char (point-max))
      (if (re-search-backward "\\(//\\|#\\) Local Variables:" nil t)
          (if (re-search-forward 
               "gri-command-postarguments: \"\\(.*\\)\"" nil t)
              (progn
                (goto-char (match-beginning 1))
                (delete-region (match-beginning 1)(match-end 1))
                (insert args))
            (end-of-line)
            (insert "\n# gri-command-postarguments: \"" args "\""))
        (goto-char (point-max))
        (insert "# Local Variables:\n"
                "# gri-command-postarguments: \"" args "\"\n"
                "# End:\n"))))))

(defun gri-unset-command-postarguments ()
  "Unset this buffer's use of post arguments."
  (interactive)
  (setq gri-command-postarguments nil)
  (save-excursion 
    (save-restriction
      (widen)
      (goto-char (point-max))
      (when (and (re-search-backward "# Local Variables:" nil t)
                 (re-search-forward  "# gri-command-postarguments:" nil t))
        (delete-region (progn (beginning-of-line)(point))
                       (progn (forward-line 1) (point)))
        (forward-line -1)
        (if (and (looking-at "# Local Variables:\n")
                 (progn (forward-line 1)(looking-at "# End:")))
            (delete-region (progn (end-of-line)(point))
                           (progn (forward-line -1) (point))))))))

(defun gri-initialize-version (tryhard)
  "Decide which version of gri to use based on ~/.gri-using-version
unless local-variable gri-local-version is set, then use that version,
and also use the variable gri*directory-tree.
Sets variables gri-bin-file and gri-cmd-file.
If TRYHARD is set, then try hard if first guess is not valid."
  (cond
   (gri-local-version
    ;; make gri-bin-file and gri-cmd-file local variables (for gri-run)
    (cond
     ((gri-validate-version gri-local-version)
      (make-local-variable 'gri-cmd-file)
      (make-local-variable 'gri-bin-file)
      (setq gri-cmd-file (gri-cmd-file-for-version gri-local-version))
      (setq gri-bin-file (gri-bin-file-for-version gri-local-version))
      (message "Using gri version %s for this file." gri-local-version))
     (tryhard
      (goto-char (point-max))
      (or (re-search-backward "^# gri-local-version" nil t)
          (re-search-backward "^# Local Variables:" nil t))
      (read-string 
       (format 
        "Gri version %s was not on the system. Press ENTER to continue. "
        gri-local-version))
      (setq gri-local-version nil)
      (gri-initialize-version t))))
   ((file-readable-p "~/.gri-using-version")
    (let ((the-buffer (create-file-buffer "~/.gri-using-version"))
          (version))
      (save-excursion
        (set-buffer the-buffer)
        (insert-file-contents "~/.gri-using-version")
        (goto-char (point-min))
        (setq version
              (buffer-substring (point) (progn (end-of-line)(point)))))
      (kill-buffer the-buffer)
      (cond
       ((gri-validate-version version)
        (setq gri-cmd-file (gri-cmd-file-for-version version))
        (setq gri-bin-file (gri-bin-file-for-version version))
        (message "Using gri version %s." version))
       (tryhard
        ;; Version from ~/.gri-using-version doesn't exist.
        (read-string 
         (format 
          "Gri %s requested in ~/.gri-using-version is not on the system. Press ENTER "
          version))
        (if (file-exists-p "~/.gri-using-version")
            (delete-file "~/.gri-using-version"))
        (gri-initialize-version t)))))
   (t
    ;; Default setting, (~/.gri-using-version file not used)
    (setq gri-cmd-file (gri-cmd-file-for-version "default"))
    (setq gri-bin-file (gri-bin-file-for-version "default"))
    (if (not (and gri-cmd-file
                  (not (string-equal "" gri-cmd-file))
                  (file-readable-p gri-cmd-file)))
        (setq gri-cmd-file ""
              gri-bin-file "")))))

(defun gri-inquire-default ()
  "Ask gri which -default_directory to use to find gri.cmd. Sets gri-cmd-file."
  (save-excursion
    (let ((gri-tmp-buffer (get-buffer-create "*gri-tmp-buffer*")))
      (set-buffer gri-tmp-buffer)
;;    (message "Inquiring to gri about location of gri.cmd file...") 
      (shell-command-on-region 1 1 "gri -directory_default" t)
    ;;(shell-command-on-region 1 1 "echo ERROR" t)
    ;;(shell-command-on-region 1 1 "echo /opt/gri/2.017/lib/" t)
;;    (message "Inquiring to gri about location of gri.cmd file... Done.") 
      (setq gri-cmd-file 
            (and (not (search-backward "ERROR" nil t))
                 (expand-file-name 
                  "gri.cmd" 
                  (buffer-substring 
                   1 (progn (goto-char 1)(end-of-line)(point))))))
      (kill-buffer gri-tmp-buffer))
    gri-cmd-file))

(defun gri-inquire-default-version ()
  "Ask gri -v to find version number"
  (save-excursion
    (let ((gri-tmp-buffer (get-buffer-create "*gri-tmp-buffer*"))
          answer)
      (set-buffer gri-tmp-buffer)
      (shell-command-on-region 1 1 "gri -v" t)
      (goto-char (point-min))
      (if (re-search-forward "gri version \\(.*\\)$" nil t)
          (setq answer (match-string 1)))
      (kill-buffer gri-tmp-buffer)
      answer)))

(defun gri-expand-versions-this-directory (directory-tree)
  "Do gri-expand-versions on a single directory"
;;; This is what needs to be supported:
;;
;;    Old style local install:
;;    
;;     /opt/gri/VERSION/bin/gri
;;     /opt/gri/VERSION/lib/gri.cmd
;;    
;;    New style local install:
;;    
;;     /usr/local/bin/gri
;;     /usr/local/share/gri/gri.cmd
;;    
;;    Red Hat:
;;    
;;     /usr/bin/gri
;;     /usr/share/gri/gri.cmd
;;    
;;    Debian:
;;    
;;     /usr/bin/gri-VERSION
;;     /usr/share/gri/VERSION/gri.cmd
;;    
;;    gri-mode will only let the user pick and switch gri versions for
;;    a given buffer with `Old style local install' and `Debian'.
;;
  (if (or (not (file-readable-p directory-tree))
          (not (file-directory-p directory-tree)))
      nil
    (let ((file-list (cdr (cdr (directory-files directory-tree))))
          ;; The above trickery removes ./ and ../ from the list
          (dir-list)(vsn-list)(the-file))
      (while file-list                  
        ;; find directories which have /bin/gri and /lib/gri.cmd files
        (setq the-file (car file-list))
        (setq file-list (cdr file-list))
        (cond
         ((string-match "^lib$" the-file)
          (cond 
           ;; gri*directory-tree/bin/gri and gri*directory-tree/lib/gri.cmd
           ;; No version numbers!
           ((and
             (file-directory-p (expand-file-name "lib" directory-tree))
             (file-exists-p (expand-file-name "bin/gri" directory-tree))
             (file-exists-p (expand-file-name "lib/gri.cmd" directory-tree)))
            (setq dir-list (cons "default" dir-list))
            (setq vsn-list 
                  (append vsn-list
                          (list (list "default" 
                                      (expand-file-name "bin/gri" 
                                                        directory-tree)
                                      (expand-file-name "lib/gri.cmd" 
                                                        directory-tree))))))
           ;; gri*directory-tree/lib/gri.cmd and gri in the PATH
           ;; No version numbers!
           ((and
             (file-directory-p (expand-file-name "lib" directory-tree))
             (file-exists-p (expand-file-name "lib/gri.cmd" 
                                              directory-tree)))
            (setq dir-list (cons "default" dir-list))
            (setq vsn-list 
                  (append vsn-list
                          (list (list "default" 
                                      "gri"
                                      (expand-file-name "lib/gri.cmd" 
                                                        directory-tree))))))))
         ;; gri*directory-tree/gri.cmd and gri executable in the PATH
         ;; No version numbers!
         ((and
           (string-match "^gri.cmd$" the-file)
           (file-exists-p (expand-file-name "gri.cmd" directory-tree)))
          (setq dir-list (cons "default" dir-list))
          (setq vsn-list 
                (append vsn-list
                        (list (list "default" 
                                    "gri"
                                    (expand-file-name "gri.cmd" 
                                                      directory-tree))))))
         ;; gri*directory-tree/VERSION/bin/gri and 
         ;; gri*directory-tree/VERSION/lib/gri.cmd
         ((and
           (file-directory-p (expand-file-name the-file directory-tree))
           (file-exists-p (expand-file-name (concat the-file "/lib/gri.cmd") 
                                            directory-tree))
           (file-exists-p (expand-file-name (concat the-file "/bin/gri") 
                                            directory-tree)))
          (setq dir-list (cons the-file dir-list))
          (setq vsn-list 
                (append vsn-list
                        (list (list the-file 
                                    (expand-file-name (concat the-file 
                                                              "/bin/gri") 
                                                      directory-tree)
                                    (expand-file-name (concat the-file 
                                                              "/lib/gri.cmd") 
                                                      directory-tree))))))
         ;; gri*directory-tree/VERSION/gri.cmd
         ;; gri-VERSION executable in the PATH
         ((and
           (file-directory-p (expand-file-name the-file directory-tree))
           (file-exists-p (expand-file-name (concat the-file "/gri.cmd") 
                                            directory-tree)))
          (setq dir-list (cons the-file dir-list))
          (setq vsn-list 
                (append vsn-list
                        (list (list the-file 
                                    (concat "gri-" the-file)
                                    (expand-file-name (concat the-file 
                                                              "/gri.cmd") 
                                                      directory-tree))))))))
      (setq gri-version-list vsn-list)
      (mapcar 'list (nreverse dir-list)))))
  
(defun gri-expand-versions ()
  "Returns a list of gri versions in gri*directory-tree, 
either a string or list of strings.
Sets gri-version-list variable."
  (let (versions)
    (cond
     ((listp gri*directory-tree)
      (let ((the-list gri*directory-tree)
            the-tree vsn-list)
        (setq gri-version-list nil)
        (while the-list
          (setq the-tree (car the-list))
          (setq the-list (cdr the-list))
          (setq versions (append (gri-expand-versions-this-directory the-tree) 
                                 versions))
          (setq vsn-list (append vsn-list gri-version-list)))
        (setq gri-version-list vsn-list)))
     ((stringp gri*directory-tree)
      (setq versions (gri-expand-versions-this-directory gri*directory-tree))))
    ;; If list doesn't contain "default", chase gri link or -directory_default
    ;; Can't chase gri link unless I do `which gri` or `whereis gri`
    (if (member '("default") versions)
        versions                        ;Okay, we're done...
      (let ((the-list gri-version-list)
            (default-version (gri-inquire-default-version)))
        (while the-list
          (if (string-equal (car (car the-list)) default-version)
              (progn
                (setq versions (cons '("default") versions))
                (setq gri-version-list 
                      (append gri-version-list 
                              (list (cons "default" (cdr (car the-list))))))
                (setq the-list nil)))
          (setq the-list (cdr the-list)))
        (if versions
            versions
          ;; Not done yet, ask  -directory_default
          (let ((default-version (gri-inquire-default)))
            (setq versions "default")
            (setq gri-version-list 
                  (append gri-version-list 
                          (list (list "default" "gri" default-version))))
            versions))))))

(defun gri-bin-file-for-version (version)
  (if (not gri-version-list)
      (gri-expand-versions))
  (let ((the-list gri-version-list)
        answer)
    (while the-list
      (if (string-equal version (car (car the-list)))
          (progn
            (setq answer (elt (car the-list) 1))
            (setq the-list nil)))
      (setq the-list (cdr the-list)))
    answer))

(defun gri-cmd-file-for-version (version)
  (if (not gri-version-list)
      (gri-expand-versions))
  (let ((the-list gri-version-list)
        answer)
    (while the-list
      (if (string-equal version (car (car the-list)))
          (progn
            (setq answer (elt (car the-list) 2))
            (setq the-list nil)))
      (setq the-list (cdr the-list)))
    answer))

(defun gri-validate-version (version)
  "Check that this VERSION of gri is available on the system."
  (if (not gri-version-list)
      (gri-expand-versions))
  (let ((cmd-file (gri-cmd-file-for-version version))
        (bin-file (gri-bin-file-for-version version)))
    (and cmd-file bin-file 
         (file-executable-p bin-file) (file-readable-p cmd-file))))

(defun gri-validate-cmd-file (&optional pass)
  "Maybe sure gri is ready to run, or report fatal error."
  (cond
   ((and gri-cmd-file
         (not (string-equal "" gri-cmd-file))
         (file-readable-p gri-cmd-file))
    t)                                  ; All is well
    ((not pass)
     ;; Try to recover
     (gri-initialize-version t)
     (gri-validate-cmd-file 2))
    ((equal pass 2)
     ;; Try to recover resetting list of known versions
     (setq gri-version-list nil)
     (gri-initialize-version t)
     (gri-validate-cmd-file 3))
    ((equal pass 3)    
     ;; Already Tried to recover
     (error "Cannot find gri on the system."))))

(defun gri-set-version ()
  "Change the version of gri used in gri-mode.
If you answer with an empty string, the default version of gri will always be 
used (even after it gets upgraded on your system). If you choose another 
version, gri-mode will remember between emacs session by writing it to the
file ~/.gri-using-version.
See also gri-set-local-version"
;; Sets up variable gri-bin-file and gri-cmd-file
;; Sets up (or deletes) ~/.gri-using-version
;; Deletes syntax buffer if it existed (so that it will be rebuilt next time).
  (interactive)
  (if (and (boundp 'gri-local-version)
           gri-local-version
           (y-or-n-p "Unset locally-set Gri version and proceed? "))
      (gri-unset-local-version))
  (if (and (boundp 'gri-local-version)
           gri-local-version)
      ()                              ;Still local; We are done.
    (let* ((table (gri-expand-versions))
           (version (and table          ;Choose if we have possiblities (table)
                         (completing-read 
                          "Gri version number to use: [default] "
                          table nil 0 nil))))
      (cond 
       ((and version                    ;If we have a version number
             (not (string-equal version "")))
        (setq gri-cmd-file (gri-cmd-file-for-version version))
        (setq gri-bin-file (gri-bin-file-for-version version))
        (if (local-variable-p 'gri-cmd-file)
          (set-default 'gri-cmd-file gri-cmd-file))
        (if (local-variable-p 'gri-bin-file)
          (set-default 'gri-bin-file gri-bin-file))
        ;; Write ~/.gri-using-version
        (let ((the-buffer (create-file-buffer "~/.gri-using-version")))
          (save-excursion
            (set-buffer the-buffer)
            (erase-buffer)
            (insert version)
            (write-file "~/.gri-using-version")
            (kill-buffer the-buffer)))
        (message "Using Gri version %s" version))
       (t
        ;;Else set to default value (with or without /lib appended)
        (if (file-exists-p "~/.gri-using-version")
            (delete-file "~/.gri-using-version"))
        (setq gri-bin-file (gri-bin-file-for-version "default"))
        (setq gri-cmd-file (gri-cmd-file-for-version "default"))
        (message "Using Gri default version")))
      ;; Now delete syntax buffer if it exists, and the syntax file.
      (if (get-buffer "*gri-syntax*")
          (kill-buffer "*gri-syntax*"))
      (if (file-exists-p "~/.gri-syntax")
          (delete-file "~/.gri-syntax")))))

(defun gri-build-syntax (local-cmd-file)
  "Called when gri-syntax-file is not found.  Creates ~/.gri-syntax
which contains all commands found in gri.cmd, including some code fragments."
;; assumes (possibly local) gri-cmd-file variable is passed as arg.
  (if (not (file-readable-p local-cmd-file))
      (error "%s not found. Check gri*directory-tree in gri-mode.el"
             local-cmd-file))
  (let ((cmd-buffer (get-buffer-create "*gri-cmd-file*"))
        (syn-buffer (get-buffer-create "*gri-syntax-file*"))
        (version "(unknown)"))
    (save-excursion
      (set-buffer cmd-buffer)
      (insert-file-contents local-cmd-file)
      (if (re-search-forward "(version \\([.0-9]*\\))" nil t)
          (setq version (buffer-substring (match-beginning 1)(match-end 1))))
      (message "Building gri version %s syntax..." version)
      (save-excursion
        (set-buffer syn-buffer)
        (insert " Syntax for gri version " version 
                "  (created by gri-mode.el)\n"
                " Based on: " (file-chase-links local-cmd-file) "\n"
                "-\n--\n---\n"))
      (gri-add-commands-from-current-buffer t syn-buffer)
      (gri-add-variables syn-buffer)
      (set-buffer syn-buffer)
      (write-file "~/.gri-syntax"))
    (kill-buffer syn-buffer)
    (kill-buffer cmd-buffer)))

(defun gri-add-variables (syn-buffer)
  "Add gri variables in current buffer to syntax file.
ARG is gri-syntax buffer to add to."
  (let ((the-list))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^# @variable \\([^ ]*\\) +\\([^@]+\\)\\( @unit \\([^ ]+\\)\\)?\\( @default \\(.*\\)\\)?$" nil t)
;;;# @variable ..fontsize..              size of font @unit point @default 12
        (let ((the-variable (match-string 1))
              (the-def
               (cond
                ((match-string 3)
                 (concat (match-string 1) " (" (match-string 2)
                         ". Default is " (match-string 6) 
                                     " " (match-string 4) ".)"))
                ((match-string 5)
                 (concat (match-string 1) " (" (match-string 2) 
                         ". Default is " (match-string 6) ".)"))
                (t
                 (concat (match-string 1) " (" (match-string 2) ".)")))))
          (setq the-list (cons (list the-variable the-def) the-list))))
      (set-buffer syn-buffer) 
      (setq buffer-read-only nil)
      (goto-char (point-min))
      (re-search-forward "^---$" nil t)
      (while the-list
        (let ((variable-pair (car the-list)))
          (insert "\n" (car (cdr variable-pair)) ";" (car variable-pair))
          (setq the-list (cdr the-list))))
      (set-buffer-modified-p nil)
      (setq buffer-read-only t))))

(defun gri-add-commands-from-current-buffer (system-flag syn-buffer)
  "Add gri commands in current buffer to syntax file.
If ARG1 is true, then this is the gri.cmd buffer for gri system commands.
ARG2 is gri-syntax buffer."
  (save-excursion
    (let ((cmd-buffer (current-buffer)))
      (set-buffer syn-buffer) (setq buffer-read-only nil) 
      (set-buffer cmd-buffer)
      (goto-char (point-min))
      (makunbound 'gri-user-command-alist) ;force later update of commands
      (while (re-search-forward "^`\\(.*\\)'$" nil t)
        (let ((the-command (buffer-substring (match-beginning 1)
                                             (match-end 1)))
              (the-name)(the-default))
          (if (string-equal "?" (substring the-command 0 1))
              ;; A fragment of gri code to extract
              (progn
                (re-search-forward "^{" nil t)
                (let ((the-fragment 
                       (buffer-substring (point) 
                                         (progn 
                                           (re-search-forward "^}" nil t)
                                           (backward-char 2)(point)))))
                  (set-buffer syn-buffer)
                  (goto-char (point-min))
;;                (setq the-command
;;                      (psg-replace-within-string the-command " " "_"))
                  (if (and (not system-flag)  ;; do no checks for gri.cmd
                           (re-search-forward
                            (concat "^" the-command ";") nil t))
                      (progn 
                        (message "Overwriting syntax for %s" the-command)
                        (delete-region (progn (beginning-of-line) (point))
                                       (progn (forward-char 1)
                                              (re-search-forward "^[^ ]" nil t)
                                              (backward-char 2)(point))))
                    (re-search-forward "^-$" nil t) 
                    (insert "\n"))
                  (insert the-command ";" the-fragment)
                  (goto-char (point-max))
                  (set-buffer cmd-buffer)))
            ;; An ordinary gri command
            ;; Extract default value if any...
            (if system-flag
                (save-excursion
                  (let ((help-limit (progn (beginning-of-line)(point))))
                    (forward-line -1)
                    (while (and (looking-at "^#\\*")
                                (= 0 (forward-line -1))))
                    (forward-line 1)
                    (when (re-search-forward "@default +\\([^@\n]+\\) ?" 
                                             help-limit t)
                      (setq the-default (match-string 1))
                      (beginning-of-line)
                      (if (re-search-forward "@unit +\\([a-zA-Z0-9.]+\\) ?"
                                             (save-excursion (end-of-line)(point))
                                             t)
                          (setq the-default
                                (concat the-default
                                        (buffer-substring-no-properties
                                         (match-beginning 1)
                                         (match-end 1)))))
                      (if (re-search-forward "@variable +\\([a-zA-Z0-9_.]+\\)"
                                             (save-excursion (end-of-line)(point))
                                             t)
                          (setq the-default
                                (concat the-default " in variable "
                                        (buffer-substring-no-properties
                                         (match-beginning 1)
                                         (match-end 1)))))))))
            (set-buffer syn-buffer)
            (goto-char (point-max))
            (insert the-command)
            (gri-create-cmd-name nil)
            (setq the-name (buffer-substring (progn (beginning-of-line)(point))
                                             (progn (end-of-line)(point))))
            (if system-flag
                (progn                  ; Don't check if defined twice
                  (if the-default (insert "(default is " the-default ")"))
                  (insert ";" the-command "\n"))
              ;; User command--check if command already exists
              (delete-region (progn (beginning-of-line)(point))
                             (progn (end-of-line)(point)))
              (if (re-search-backward (concat "^" the-name " ") nil t)
                  (if (not (re-search-forward "^---\n" nil t))
                      (message "Cannot overwrite command: %s" the-name)
                    ;; same named user command existed --- overwrite it.
                    (message "Overwriting command: %s" the-name)    
                    (re-search-backward (concat "^" the-name " ") nil t)
                    (delete-region (progn (beginning-of-line)(point))
                                   (progn (end-of-line)(point)))
                    (insert the-name ";" the-command))
                ;; didn't previously exist -- write it.
                  (re-search-backward "^---\n" nil t)
                  (forward-line -1)(end-of-line)
                  (insert "\n"  the-name ";" the-command)))
            (set-buffer cmd-buffer)
            (re-search-forward "^}" nil t))))
      (set-buffer syn-buffer)
      (set-buffer-modified-p nil)
      (setq buffer-read-only t) 
      (set-buffer cmd-buffer))))

(defun gri-create-cmd-name (underscore-flag)
  "Edits full gri syntax line to leave gri command name.
If ARG is true, then put underscores between command words.  
Gri command name may be longer than that used by gri parser, because this
will take words that follow variables (and the gri parser won't check these).
Assumes line is last in buffer, and has no leading whitespace."
  (beginning-of-line)
  (while (search-forward "  " nil t)  ;; trim whitesppace
    (delete-backward-char 1)
    (beginning-of-line))
  (while (re-search-forward "[{|\"\.\\[]" nil t)
    (backward-char 1)                 ;; puts point on found character
    (let ((the-match (buffer-substring (match-beginning 0)(match-end 0)))
          (the-start (point))
          (the-find  (point)))
      (cond
       ((or (string-equal the-match "{") (string-equal the-match "["))
        (goto-char (scan-sexps (point) 1)))  ;; faster than forward-sexp 1?
       ((string-equal the-match "|")
        (skip-chars-backward " \t") ;; place start-deletion before prior option
        (search-backward " " nil t) ;; skipping immediate spaces, find start
        (forward-char 1)            ;; move over first character 
        (setq the-start (point))    ;; set the start-deletion
        (goto-char the-find)        ;; now go back to delete trailing option
        (forward-char 1)            ;; move right after | character
        (skip-chars-forward "\t ")  ;; and skip over spaces
        (re-search-forward "[ {[]\\|$" nil t)
        (if (or (string-equal "{" (buffer-substring (match-beginning 0)
                                                    (match-end 0)))
                (string-equal "[" (buffer-substring (match-beginning 0)
                                                    (match-end 0))))
            (backward-char 1)))     ;; don't delete the bracket
       ((string-equal the-match "\"")
        (forward-char 1)
        (search-forward "\"" nil t))
       (t  ;;case \.
        (forward-char 1)
        (re-search-forward "[ {[]\\|$" nil t)
        (if (or (string-equal "{" (buffer-substring (match-beginning 0)
                                                    (match-end 0)))
                (string-equal "[" (buffer-substring (match-beginning 0)
                                                    (match-end 0))))
            (backward-char 1))))  ;; skip before a bracket
      (skip-chars-forward " \t")
      (delete-region the-start (point))
      (if (looking-at "|") ;; add a dummy option, deleted next iteration 
          (progn (save-excursion (insert "dum"))))))
  (end-of-line)(insert " ")(backward-char 1)   ;; at least one space at end
  (while (char-equal 32 (char-after (point)))  ;; delete all spaces at end
    (delete-char 1) (backward-char 1))                 
  (if underscore-flag
      (progn
        (beginning-of-line) ;;(perform-replace " " "_" nil nil nil)
        (while (search-forward " " nil t)
          (delete-backward-char 1)(insert "_")))))

(defun gri-isolate-this-command (underscore-flag)
  "(gri-mode) returns multi-line command as single string.
The command is trimmed and edited to remove any variables, but is not verified.
You can end up with:
draw label at cm

If ARG is true, then put underscores between command words."
  (if (gri-empty-line)
      (error "This is an empty line"))
  (let ((tmp-buffer (get-buffer-create "*gri-tmp-command*"))
        (the-string))
    (save-excursion
      (set-buffer tmp-buffer)
      (erase-buffer))
    (save-excursion
      (beginning-of-line)
      (while (progn (save-excursion (and (= 0 (forward-line -1)) 
                                         (gri-continuation-line))))
        (forward-line -1))
      (while (and (gri-continuation-line) 
                  (progn (save-excursion (= 0 (forward-line 1)))))
        (setq the-string 
              (buffer-substring 
               (progn (skip-chars-forward " \t") (point))
               (progn (end-of-line) (skip-chars-backward "\\ \t")(point))))
        (save-excursion
          (set-buffer tmp-buffer)
          (insert the-string " "))
        (forward-line 1))
      (setq the-string 
            (buffer-substring 
             (progn (skip-chars-forward " \t") (point))
             (progn (if (re-search-forward 
                         "\\(#\\|//\\)" 
                         (progn (save-excursion (end-of-line) (point)))
                         t)
                        (skip-chars-backward "#/ \t")
                      (end-of-line)
                      (skip-chars-backward "#/ \t"))
                    (point))))
      (set-buffer tmp-buffer)
      (insert the-string)  ;; multi-line command now in single line
      (beginning-of-line)
      (gri-create-cmd-name underscore-flag)
      (setq the-string (buffer-string)))
    (kill-buffer tmp-buffer)
    the-string))


(defun gri-syntax-this-command ()
  "Returns syntax for multi-line gri command on point.
Returns error messages if they occur.
Used for gri-help-this-command, to find what command to look for in gri.cmd.
Used for gri-display-syntax."
  (save-excursion
    (let ((the-command (gri-isolate-this-command nil)))
      ;; the-command could be like draw_label_at_cm
      ;; check in syntax if a command name
      (gri-lookat-syntax-file 0)
      (let ((the-start (point)))
        (while (and (not (re-search-forward
                          (concat "^" the-command "\\(;\\|(\\)") nil t))
                    (progn (setq the-command 
                                 (gri-shorten-guess-command the-command " "))
                           the-command)))
        (if (= (point) the-start)
            (error "Sorry, cannot find such a gri command")
          (if (string-equal "?" (substring the-command 0 1))
              (beginning-of-line)) ;; We'll return the whole line for fragments
          
          ;; Skip over default description
          (forward-char -1)
          (if (looking-at "(")
              (re-search-forward ");" nil t)
            (forward-char 1))

          (buffer-substring (point) 
                            (progn (end-of-line)(point))))))))

(defun gri-syntax-default-this-command ()
  "Returns default settings for multi-line gri command on point.
Return: nil if the command is not found
          0 if there is no default setting to display
        else return the string
Used for gri-display-default-syntax."
  (save-excursion
    (let ((the-command (gri-isolate-this-command nil)))
      (gri-lookat-syntax-file 2)
      (let ((the-start (point)))
        (while (and (not (re-search-forward
                          (concat "^" the-command "\\(;\\|(\\)") nil t))
                    (progn (setq the-command 
                                 (gri-shorten-guess-command the-command " "))
                           the-command)))
        (if (= (point) the-start)
            nil
          (forward-char -1)
          (if (not (looking-at "("))
              0
            (forward-char 1)
            (concat the-command ": "
                    (buffer-substring (point) 
                                      (progn
                                        (re-search-forward ");" nil t)
                                        (forward-char -2)
                                        (point))))))))))

(defun gri-syntax-default-this-builtin ()
  "Returns default settings for builtin variable under point.
Return: nil if not on a variable
          0 if there is no default setting to display
        else return the string
Used for gri-idle-function."
  (save-excursion
    (if (not (progn
               (if (re-search-backward 
                    "[ \t]" (save-excursion (beginning-of-line) (point)) 1)
                   (forward-char 1))
               (looking-at "\\(\\\\\\|\\.\\)[^ \n]+")))
        nil
      (let ((the-builtin (match-string-no-properties 0)))
        (gri-lookat-syntax-file 2)
        (if (not (re-search-forward
                  (concat "^" (regexp-quote the-builtin) " (\\(.*\\));") 
                  nil t))
            0
          (concat the-builtin ": " (match-string-no-properties 1)))))))

(defun gri-idle-function ()
  "Run whenever Emacs is idle to display function defaults."
  (if (eq major-mode 'gri-mode)
      (let ((default-string (gri-syntax-default-this-builtin)))
        (if (stringp default-string)
            (message "%s" default-string)
          (let ((default-string (gri-syntax-default-this-command)))
            (if (stringp default-string)
                (message "%s" default-string)))))))

(defun gri-prompt-for-command (user-flag)
  "Prompt user for gri command name, providing minibuffer completion.
Allow user commands if ARG is t."
  (if (or (not (boundp 'gri-sys-command-alist)) ;Need to build both lists
          (not gri-sys-command-alist))
      (gri-build-command-alist t)
    (if (not (boundp 'gri-user-command-alist))  ;Need only re-build user list
        (gri-build-command-alist nil)))
  ;;(completing-read "gri command: " gri-command-alist 'gri-sysp  0 nil 
  ;; completion-ignore-case value to differentiate system from user commands?
  (if user-flag
      (if (string-equal "18" (substring emacs-version 0 2))
          (completing-read "gri user or system command: " 
                           (append gri-sys-command-alist 
                                   gri-user-command-alist)
                           nil 0 nil)
        (completing-read "gri user or system command: " 
                         (append gri-sys-command-alist gri-user-command-alist)
                         nil 0 nil 'gri-hist-alist))
    (if (string-equal "18" (substring emacs-version 0 2))
        (completing-read "gri system command: " gri-sys-command-alist
                         nil 0 nil)
      (completing-read "gri system command: " gri-sys-command-alist
                       nil 0 nil 'gri-hist-alist))))

;;(defun gri-sysp (element)
;;  "Test whether system command"
;;  (not (cdr element))) 

(defun gri-build-command-alist (system-flag)
  "Build gri-user-command-alist (and gri-sys-command-alist if ARG is t).
The lists are built from the gri syntax file.
It should only be called when the alists are not bound (not existant)."
  ; Could be done using an obarray and `intern' to create it, but you
  ;  can't concatenate obarrays, so this is a problem for user commands.
  ; elisp info doesn't say if completing-read is more efficient with alists
  ;  or obarrays.
  (gri-lookat-syntax-file 1)
  (setq gri-user-command-alist nil)    ;Making sure always starts empty
  (while (not (looking-at "---"))
    (setq gri-user-command-alist
          (nconc gri-user-command-alist 
                 (list (cons ;;;(psg-replace-within-string 
                              (buffer-substring-no-properties
                               (point)(progn (search-forward ";")
                                             (backward-char 1)(point)))
                              ;;;"_" " ")
                             nil))))    ;Last could be true if we could use it.
    (forward-line 1))
  (if system-flag
      (progn
        (message "building list of gri commands...")
        (setq gri-sys-command-alist nil)
        (forward-line 1)
        (when (looking-at "^\\(\.\\|\\\)") ; skip over variables
          (re-search-forward "^[^\.\\]" nil t)
          (beginning-of-line))
        (while (< (point) (point-max))
          (setq gri-sys-command-alist
                (nconc gri-sys-command-alist 
                       (list (cons ;;;(psg-replace-within-string 
                                    (buffer-substring-no-properties 
                                     (point)(progn (re-search-forward ";\\|(")
                                                   (backward-char 1)(point)))
                                   ;;; "_" " ")
                                   nil))))
          (forward-line 1)))))

;;(defun gri-help ()
;;  "Displays help (in *help* buffer) about a prompted gri command.
;;The help text is taken from gri.cmd (a gri system file) and may differ
;;from the gri info file (displayed by gri-info).  Help is also displayed 
;;about user commands from ~/.grirc or from the current gri file.
;;
;;BUGS:  Can't find help on hidden user commands."
;;  (interactive)
;;  (let ((the-command (regexp-quote ;;;(psg-replace-within-string
;;                                    (gri-prompt-for-command t)
;;                                    ;;;" " "_")
;;                                    )))
;;    (if (string-equal "" the-command)
;;        (message "No command to look-up.")
;;      (save-excursion                     ;lookup syntax in syntax file
;;        (gri-lookat-syntax-file 1)
;;        (if (re-search-forward (concat "^" the-command ";") nil t)
;;            (gri-help-function (buffer-substring (point) 
;;                                                 (progn (end-of-line)(point))))
;;          (message "Sorry, can't seem to find help for %s" the-command))))))
(defun gri-help (&optional command)
  "Displays help (in *help* buffer) about a prompted gri command.
The help text is taken from gri.cmd (a gri system file) and may differ
from the gri info file (displayed by gri-info).  Help is also displayed 
about user commands from ~/.grirc or from the current gri file.

BUGS:  Can't find help on hidden user commands."
  (interactive "P")
  (let* ((the-command (regexp-quote (or command (gri-prompt-for-command t)))))
    (if (string-equal "" the-command)
        (message "No command to look-up.")
      (save-excursion                     ;lookup syntax in syntax file
        (gri-lookat-syntax-file 1)
        (if (not (re-search-forward 
                  (concat "^" the-command "\\(;\\|(\\)") 
                  nil t))
            (message "Sorry, can't seem to find help for %s" the-command)
          ;; Skip over default description            
          (forward-char -1)
          (if (looking-at "(")
              (re-search-forward ");" nil t)
            (forward-char 1))
          
          (gri-help-function (buffer-substring 
                              (point) 
                              (progn (end-of-line)(point)))))))))

(defun gri-help-this-command ()
  "Displays help (in *help* buffer) about gri command on point.
The help text is taken from gri.cmd (a gri system file) and may differ
from the gri info file (display by gri-info-this-command).  Help is also
displayed about user commands from ~/.grirc or from the current gri file.

The gri command may span many line, e.g.

  draw x axis \
     at ..ymargin.. \    <gri-help-this-command> 
        {rpn ..xmargin.. .2 -} cm

  will work.

BUGS:  Can't find help on hidden user commands."
  (interactive)
  (gri-help-function (gri-syntax-this-command)))

(defun gri-help-function (the-command)
  "Actual work for gri-help and gri-help-this-command"
  (gri-validate-cmd-file)
  (save-excursion
    (let ((gri-tmp-buffer (get-buffer-create "*gri-tmp-buffer*"))
          (user-flag))
      ;; We've gotten this far; valid command.  But gri or user command?
      (save-excursion
        (gri-lookat-syntax-file 2)
        (if (search-backward (concat " " the-command ";") nil t)
            (setq user-flag t)))
      (if user-flag
          ;; user-command -- look in current buffer, else in .grirc
          (save-excursion
            (goto-char (point-min))
            (if (search-forward (concat "`" the-command "'") nil t) ;;in buffer
                (gri-extract-help-text the-command t)
              (error "no")
              (if (file-readable-p "~/.grirc")
                  (progn
                    (set-buffer gri-tmp-buffer)     ;; look in .grirc
                    (insert-file-contents "~/.grirc")
                    (if (re-search-forward (concat "^`" (regexp-quote the-command) "'") nil t)
                        (gri-extract-help-text the-command t)
                      (kill-buffer gri-tmp-buffer)
                      (error "Sorry, can't find user command: %s"
                             the-command)))
                (kill-buffer gri-tmp-buffer)
                (error "Sorry, can't find user command: %s" the-command))))
        ;; gri system command
        (set-buffer gri-tmp-buffer)
        (insert-file-contents gri-cmd-file)
        (if (not (re-search-forward (concat "^`" (regexp-quote the-command) "'") nil t))
            (progn
              (kill-buffer gri-tmp-buffer)
              (error "Sorry, can't find help about: %s" the-command)))
        (gri-extract-help-text the-command nil))
      (kill-buffer gri-tmp-buffer))))

(defun gri-extract-help-text (the-command user-flag)
  "Extract help text after a command.  Expecting point on title line.
Display message if no help text supplied."
  (forward-line 1)
  (if (= 123 (char-after (point)))  ;; on on opening bracket already
      (if user-flag
          (message "Sorry, no help text for user command: %s" the-command)
        (message "Sorry, no help text about: %s" the-command))
    (if (looking-at "[^a-zA-Z0-9]*$")   ;Skip header or C-like comment tring
        (forward-line 1))
    (let ((the-start (point))
          (the-text))
      (re-search-forward "^{" nil t)
      (while (and (= 0 (forward-line -1))
                  (looking-at "[^a-zA-Z0-9]*$")))
      (forward-line 1)
      (setq the-text (buffer-substring the-start (point)))
      (with-output-to-temp-buffer "*Help*"
        (princ (gri-format-display-command the-command))
        (princ "\n--\n")
        (princ the-text)))))

(defun gri-format-display-command (the-command)
  "return possible 2-line string for ARG, a gri command syntax string."
  (if (> (frame-width) (length the-command))
      the-command
    (let ((the-string)
          (tmp-buffer (get-buffer-create "*gri-format*")))
      (save-excursion
        (set-buffer tmp-buffer)
        (insert the-command)
        (backward-char 1)
        (if (or (char-equal 93  (char-after (point)))   ;; []
                (char-equal 125 (char-after (point))))  ;; {}
            (progn
              (forward-char 1)
              (goto-char (scan-lists (point) -1 0))
              (insert "\n    "))
          ;; just split at previous whitespace
          (if (search-backward " " nil t)
              (insert "\n    ")))
        (setq the-string (buffer-string))
        (kill-buffer tmp-buffer))
      the-string)))

(defun gri-display-syntax ()
  "Displays (in minibuffer) the full syntax of the gri command on point.
The gri command may span many line, e.g.

  draw x axis \
     at ..ymargin.. \    <gri-display-syntax> 
        {rpn ..xmargin.. .2 -} cm

  will display
    draw x axis [at bottom|top|{.y. [cm]} [lower|upper]]
  in the minibuffer."
  (interactive)
  (message "%s" (gri-syntax-this-command)))

(defun gri-display-default ()
  "Displays (in minibuffer) the default settings for the gri command on point.
Note that only a small subset of commands have such defaults.  These are
usually command with the keyword \"default\" in their syntax."
  (interactive)
  (message "%s" (gri-syntax-default-this-command)))

(defvar gri-last-complete-point -1)
(defvar gri-last-complete-command "")
(defvar gri-last-complete-status 0)
(defvar gri-complete-begin-point nil
  "Gri internal variable to remember point of beginning of completion
across multiple invocations.")

(defun gri-build-expansion-regex ()
  "Returns regular expression for abbreviated gri command on current line."
  (save-excursion
    (let ((expansion-regex nil) 
          (word-count 0)
          (end-point (progn (end-of-line)(skip-chars-backward " \t") (point))))
      (save-excursion
        (if (progn
             (if (re-search-backward "[ \t]" (save-excursion (beginning-of-line) (point)) 1)
                 (forward-char 1))
             (looking-at "\\(\\\\\\|\\.\\)[^ \n]+"))
            (progn
              (setq gri-complete-begin-point (point))
              (concat "^" (regexp-quote (match-string-no-properties 0))))
          (beginning-of-line)
          (skip-chars-forward " \t")
          (setq gri-complete-begin-point (point))
          (while (< (point) end-point) ;; Don't go beyond end of line
            (if (looking-at "[^ \t\n]*") ;; If it is a word...
                (progn
                  (setq word-count (1+ word-count))
                  (if (= word-count 1)
                      (setq expansion-regex
                            (concat "^" (buffer-substring-no-properties 
                                         (match-beginning 0)
                                         (match-end 0))))
                    (setq expansion-regex 
                          (concat expansion-regex "[^; ]* "
                                  (buffer-substring-no-properties
                                   (match-beginning 0)
                                   (match-end 0)))))
                  (forward-char (- (match-end 0) (match-beginning 0)))
                  (skip-chars-forward " \t"))))
          expansion-regex)))))

(defun gri-info (&optional command)
  "Runs info about a prompted gri system command."
  (interactive "P")
  (require 'info)
  (let ((the-command (or command (gri-prompt-for-command nil))))
    (if (string-equal "" the-command)
        (message "No command to look-up.")
      (gri-info-function the-command))))
    
(defun gri-info-this-command ()
  "Run info about gri system command at editing point.  
This works when the edit point is on a valid gri command, but it may also
work for uncompleted commands if an info entry exists for that topic.
e.g. 

  draw <gri-info-about-line>

 will display info about gri `draw' commands.

Note: The search for the command is case-insensitive.  Therefore, if
you have a user command like `Draw X Axis', gri-info-this-command will
display the info page for the gri command `draw x axis'."
  (interactive)
  (require 'info)
  (gri-info-function (gri-isolate-this-command nil)))

;; Delete this when I'm happy with new method.
;;  gri-info-function used to read in gri info files and look at all nodes
;;  I changed this in RCS 1.50 to get the proper Index of Commands instead.
;;  This way, we can get to nodes for alternate spelling.
;;(defun gri-info-function (guess)
;;  "Guts for gri-info and gri-info-this-command"
;;  (if (not (gri-info-directory))
;;      (error "Sorry, no gri info files!"))
;;  (let ((flag t)(loopflag t)(tmp-buffer (get-buffer-create "*info-tmp*")))
;;      (save-excursion
;;        (set-buffer tmp-buffer)
;;        (cond
;;         ((fboundp 'info-insert-file-contents) ;Emacs20
;;          (info-insert-file-contents (concat (gri-info-directory) "gri")))
;;         ((and (fboundp 'Info-insert-file-contents) ;XEmacs20
;;              (fboundp 'Info-suffixed-file))
;;          (Info-insert-file-contents 
;;           (Info-suffixed-file (concat (gri-info-directory) "gri")) nil))
;;         (t                             ; old emacs?
;;          (insert-file-contents (concat (gri-info-directory) "gri"))))
;;        (goto-char (point-min))
;;        (if (re-search-forward 
;;             (concat "Node: " (regexp-quote guess) "\177") nil t)
;;            (setq flag t)
;;          (while loopflag  ;; flag true until can't shorten or found
;;            (setq guess (gri-shorten-guess-command guess " "))
;;            (if guess 
;;                (if (re-search-forward (concat "Node: " (regexp-quote guess) 
;;                                               "\177") nil t)
;;                    (setq loopflag nil)) ;; found it!
;;              (setq loopflag nil)  ;; can't shorten no more
;;              (setq flag nil)))))  ;; failed to find a match
;;      (kill-buffer "*info-tmp*")
;;      (if flag
;;          ;;??Replace with: (Info-find-node "gri" guess)
;;          (Info-goto-node (concat "(gri)" guess))
;;        (message "Sorry, can't find this topic in Info."))))

(defun gri-info-function (guess)
  "Guts for gri-info and gri-info-this-command"
;;  (if (not (gri-info-directory))
;;      (error "Sorry, no gri info files!"))
  (let ((flag)(loopflag t)(node))
    (save-excursion
      (save-window-excursion
        (let ((Info-history nil))     ;Don't save this move!
;;        (Info-find-node "gri" "Index of Commands")
          (Info-goto-node "(gri)Index of Commands")
          (goto-char (point-min))
          (search-forward "* Menu:" nil t)
          ;; Search for `guess'
          ;; and if Didn't find it, shorten the command and try again.
          (while (and guess loopflag) ; flag true until can't shorten or found
            (cond 
             ((re-search-forward (concat "^\* " (regexp-quote guess) ":")nil t)
              ;; Found it this time!
              (skip-chars-forward " ")
              (setq node (buffer-substring
                          (point)
                          (progn
                            (search-forward
                             "."
                             (save-excursion (end-of-line)(point)))
                            (forward-char -1)
                            (point))))
              (setq flag t)
              (setq loopflag nil))) ;; exit the loop - found it!
            (setq guess (gri-shorten-guess-command guess " "))))))
    (if flag
        (Info-goto-node (concat "(gri)" node))
      (message "Sorry, can't find this topic in Info."))))

(defun gri-shorten-guess-command (guess separator)
  "Removes a word (separated by ARG2) from end of ARG1 
as a new guess to a gri command"
  (let ((lastindex nil) (index (string-match separator guess nil)))
    (if (not index)
        nil
      (while index
        (setq lastindex index)
        (setq index (string-match separator guess (1+ index))))
      (substring guess 0 lastindex))))
        
(defun gri-complete ()
  "Complete a gri command as much as possible, then indents it.
   Works one word at a time,
    e.g.  
        dr<complete>
      (where <complete> is actually pressing M-Tab) becomes
        draw
    or with many words at a time
     e.g. 
        dr x a
      becomes
        draw x axis [at bottom|top|{.y. [cm]} [lower|upper]]
_
How gri-mode names gri commands:

   The name of a gri command by determined by removing options.
   This is different than what the gri parser does.  In this way,
   the gri command

     draw label \"\\string\" [centered|rightjustified] at .x. .y. [cm] \\
        [rotated .deg.]

    is named by gri-mode

     draw label at

   Note how the `at' stays in the name because it is not optional.
_
Possible Completions:

   Possible completions are shown in the *completions* buffer,
   but only if you insist by using gri-complete again.  In this
   way you can use gri-complete word-by-word to abbreviate commands
   without ever displaying completions, like you would for file 
   completion in emacs or bash.

   If a completion is ambiguous, but could be exact, invoke
   gri-complete a second time to complete it.
     e.g.
        sh<complete>
      becomes
        show
      and informs you that 12 possible completions exists;
      then
        show<complete>
      will display these completions in the completions buffer;
      then
        show<complete>
      forces completion to a complete but not unique possibility. 
        show .value.|{rpn ...}|\"\\text\" [.value.|{rpn ...}|text [...]]

   Completions are shown immediately (without invoking gri-complete 
   again) if the completions window is already displayed or if there 
   are 3 possbilities or less.  In this case they are displayed in 
   the minibuffer. 
  
   The *completions* window is deleted after a command is fully completed.
   gri-complete uses its own *completions* buffer, which is not displayed
   in the buffer-list to avoid clutter.
_
User Commands:

   User gri commands defined in ~/.grirc or at the beginning of a gri 
   file can also be gri-complete'd.  Note that user commands are added
   from the current buffer whenever `gri-mode' is invoked.  They may
   override previous user commands, but not gri system commands.
_
Gri Code Fragments

   Since gri version 1.063, gri has special commands that begin with
   a question mark `?'.  These special commands have no options, and
   are composed only of standard gri commands.  Their purpose is to
   provide a short-cut for entering many lines of gri at once (e.g.
   bits of sample code about contouring grids, or your own preamble
   which you use at the time to set fonts and line widths).

   gri-complete acts in a special way with these commands, by replacing
   the abbreviated name which you are completing by all the lines 
   contained within the gri command.

   The user is allowed to define new fragments in ~/.grirc, and also
   to override the gri system fragments.  You can therefore fine-tune
   gri's fragments to your taste.  To see the names of all gri fragments,
   type in a question mark at the beginning of a line in a gri buffer
   and press M-Tab twice to gri-complete it and display possible choices.
   The gri commands used to replace them is found in the *gri-syntax* 
   buffer."
;;Sets gri-last-complete-point   to point after completion (if matches > 1)
;;Sets gri-last-complete-command to current line (if matches > 1)
  (interactive)
  (let ((expansion-regex (gri-build-expansion-regex))
        (the-line (buffer-substring (progn (beginning-of-line) (point))
                                 (progn (end-of-line) (point)))))
    (if (eq expansion-regex nil)
        (progn
          (message "No gri command no expand.")
          (setq gri-last-complete-status 0))
      (if (and (= 2 gri-last-complete-status) ; try to match exactly
               (= (point) gri-last-complete-point)
               (string-equal the-line gri-last-complete-command))
          (gri-perform-completion (concat expansion-regex ";") t)
        (if (and (= 1 gri-last-complete-status) ; show completions
                 (string-equal the-line gri-last-complete-command))
            (gri-perform-completion expansion-regex nil)
          (setq gri-last-complete-status 0)
          (gri-perform-completion expansion-regex nil)))
      (if gri-last-complete-status
          (progn
            (setq gri-last-complete-point (point))
            (setq gri-last-complete-command 
                  (buffer-substring (progn (beginning-of-line) (point))
                                 (progn (end-of-line)(point)))))))))

(defun gri-perform-completion (expansion-regex exact-flag)
  "Does the actual completion based on ARG1 regex. Returns number of matches.
Second argument t if trying for exact match.  If we fail we will display
a different message.
Sets gri-last-complete-status to 1 if show completions next time
                              to 2 if expand complete match next time
                               (used by gri-complete only, not here)
                              to 0 in other cases."
  (let ((unique) (match-count 0) (expansion-list))
    (save-excursion
      (gri-lookat-syntax-file 0)
      (let ((case-fold-search))
        (while (re-search-forward expansion-regex nil t)
          (setq expansion-list 
                (cons 
                 (buffer-substring (progn (beginning-of-line) (point)) 
                                   (progn (re-search-forward ";\\|(") 
                                          (forward-char -1)(point)))
                 expansion-list))
          (forward-line 1)
          (setq match-count (1+ match-count)))))
    (cond
     ((= match-count 0)
      (if exact-flag
          (message "Sorry, this does not match *exactly* to any gri command.")
        (message "Sorry, this does not match to any known gri command."))
      (setq gri-last-complete-status 0))
     ((= match-count 1)
      (save-excursion
        (if (string-equal "?" (substring (car expansion-list) 0 1))
            (progn           
              (gri-lookat-syntax-file 0)
              (re-search-forward (concat "^" (car expansion-list)) nil t)
              (forward-line 1)
              (setq unique
                    (buffer-substring (point)
                                      (progn
                                        (re-search-forward "^[^ \t]" nil t)
                                        (backward-char 1)(point)))))
          (gri-lookat-syntax-file 1)
          (re-search-forward 
           (concat "^" (regexp-quote (car expansion-list)) "\\(;\\|(\\)")
           nil t)
          ;; Skip over default description, displaying it:
          (forward-char -1)
          (if (not (looking-at "("))
              (forward-char 1)
            (forward-char 1)
            (message "%s"
                     (buffer-substring-no-properties
                      (point)
                      (progn (re-search-forward ");" nil t)
                             (forward-char -2)
                             (point))))
            (forward-char 2))

          (setq unique (buffer-substring (point)
                                         (progn (end-of-line)(point))))))
      (delete-region gri-complete-begin-point (point))
      (let ((the-start (point))         ; indent all inserted lines
            (the-end (progn (insert unique) (gri-indent-line) 
                            (point-marker))))
        (goto-char the-start)
        (gri-indent-line)
        (while (and (= 0 (forward-line 1))
                    (< (point) (marker-position the-end)))
          (gri-indent-line))
        (goto-char (marker-position the-end)))
      (if (and (get-buffer " *Completions*")  ;;need this one line for emacs-18
               (get-buffer-window (get-buffer " *Completions*")))
          (delete-window (get-buffer-window (get-buffer " *Completions*"))))
      (setq gri-last-complete-status 0))
     ((or (= 1 gri-last-complete-status) ;display completions 
          (and (get-buffer " *Completions*")
               (get-buffer-window (get-buffer " *Completions*")))) 
      (delete-region gri-complete-begin-point (point))
;;    (delete-region (progn (end-of-line) (point)) 
;;                   (progn (beginning-of-line) (point)))
      (insert (gri-common-in-list expansion-list nil)) 
      (gri-indent-line)
      (message "%d possible completions" match-count) 
      (with-output-to-temp-buffer " *Completions*"
        (display-completion-list expansion-list))
      (setq gri-last-complete-status 2)) ;Next time, try unique match
     ((< match-count 4)                 ; 3 or fewer matches show in minibuffer
      (delete-region gri-complete-begin-point (point))
;;    (delete-region (point) (progn (beginning-of-line) (point)))
      (insert (gri-common-in-list expansion-list nil)) 
      (gri-indent-line)
      (message "(%d) %s" match-count 
               (gri-match-list-to-string expansion-list))
      (setq gri-last-complete-status 2))
     (t                                 ;complete as much as possible
      (delete-region gri-complete-begin-point (point))
;;    (delete-region (progn (end-of-line) (point)) 
;;                   (progn (beginning-of-line) (point)))
      (insert (gri-common-in-list expansion-list nil)) 
      (gri-indent-line)
      (message "%d possible completions" match-count) 
      (setq gri-last-complete-status 1))) ;show completions next time
    match-count))

(defadvice choose-completion-string (after gri-mode-choose-completion protect activate)
  "Perform completion on mouse selected text."
  (when (string-equal major-mode "gri-mode")
    (delete-backward-char 1)
    (gri-complete)))

(defun gri-common-in-list (list remove-underscore-flag)
  "returns STRING with same beginnings in all strings in LIST"
  (let ((i 1)
        (work-list list) 
        (match-len (length (car list))) 
        (first-string (car list))
        (current-string nil)
        (match-flag t))
    (setq work-list (cdr work-list))
    (while work-list
      (setq current-string (car work-list))
      (if (< (length current-string) match-len)
          (setq match-len (length current-string)))
      (if current-string ;; nil last time around
          (progn
            (while (and (<= i match-len) match-flag)
              (if (equal (substring first-string 0 i) 
                         (substring current-string 0 i))
                  (setq i (1+ i))
                (setq match-flag nil)))
            (setq match-len (1- i))
            (setq match-flag t)
            (setq i 1)))
      (setq work-list (cdr work-list)))
    (if (not remove-underscore-flag)
        (substring first-string 0 match-len)
      (psg-replace-within-string 
       (substring first-string 0 match-len) "_" " "))))

(defun psg-replace-within-string (in-string from to) 
  "Replace ARG2 with ARG3 in ARG1.  emacs didn't do this!"
  (save-excursion
    (let ((newl "") (index 0) (do-more t) (len (length in-string)))
      (while do-more
        (setq do-more (string-match from in-string index))
        (if (or (not do-more) (>= do-more len))            
            ;; finish the line
            (progn
              (setq newl (concat newl (substring in-string index)))
              (setq do-more nil))
          ;; found another replacement
          (setq newl (concat newl (substring in-string index do-more) to))
          (setq index (1+ do-more))))
      newl)))

(defun gri-match-list-to-string (list)
  "returns STRING with all gri commands in list (just the name part)"
  (let ((work-list (nreverse list)) (the-command) (the-string))
    (while work-list
      (setq the-command (car work-list))
      (setq work-list (cdr work-list))
      (setq the-string (concat the-command "   " the-string)))
    (substring the-string 0 -3)))

(defun gri-debug-insert (string)
  "Insert a string in a debug buffer."
  (save-excursion
    (let ((gri-test-buffer
           (get-buffer-create "*gri-test-buffer*")))
      (set-buffer gri-test-buffer)
      (insert string "*\n"))))

(defun gri-lookat-syntax-file (where)
  "Place point in syntax-file buffer, creating it if necessary.
If ARG is 0, go to `-'   to see all commands (gri-complete)
If ARG is 1, go to `--'  to skip fragments   (gri-help-apropos) (gri-help 2)
If ARG is 2, go to `---' to see only gri system commands   (gri-help 1)
If ARG is 3, go to `---' and skip over variables"
  (gri-validate-cmd-file)
  (let ((this-buffer (current-buffer))
        (local-cmd-file gri-cmd-file)
        (gri-syntax-buffer (get-buffer-create "*gri-syntax*"))
        (gri-syntax-file   "~/.gri-syntax")
        rebuilt)
    (set-buffer gri-syntax-buffer)
    (setq buffer-read-only nil)
    (goto-char (point-min))
    ;; Load in existing ~/.gri-syntax if haven't done so yet
    (when (and (file-readable-p gri-syntax-file)
             (= (point-min) (point-max)))
      (insert-file-contents gri-syntax-file)
      (setq rebuilt t))
    (when (or
           ;; Check if existing ~/.gri-syntax is up-to-date wrt gri-cmd-file
           (not (file-readable-p gri-syntax-file))
           (file-newer-than-file-p local-cmd-file gri-syntax-file)
           (file-newer-than-file-p (file-chase-links local-cmd-file)
                                   gri-syntax-file)
           ;; Check that correct version in use.
           (not (re-search-forward "Based on: \\(.*\\)" nil t))
           (not (string-equal (file-chase-links local-cmd-file)
                              (buffer-substring 
                               (match-beginning 1)(match-end 1)))))
      (erase-buffer)
      (gri-build-syntax local-cmd-file) ;build ~/.gri-syntax
      (insert-file-contents gri-syntax-file)
      (setq rebuilt t))
    (goto-char (point-min))
    (when rebuilt
      (goto-char (point-min))
      (if (re-search-forward "gri version \\([.0-9]+\\)" nil t)
          (message "Using syntax for gri version %s" 
                   (buffer-substring (match-beginning 1)(match-end 1)))
        (message "Using syntax for unknown version of gri"))
      (if (file-readable-p "~/.grirc")
          (let ((tmp-buffer (get-buffer-create "*gri-tmp-command*")))
            (set-buffer tmp-buffer)
            (insert-file-contents "~/.grirc")
            (gri-add-commands-from-current-buffer nil gri-syntax-buffer)
            (set-buffer gri-syntax-buffer)
            (kill-buffer tmp-buffer)))
      (set-buffer this-buffer)
      (gri-add-commands-from-current-buffer nil gri-syntax-buffer)
      (set-buffer gri-syntax-buffer)
      (setq mode-line-buffer-identification "*gri-syntax*"))
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    (goto-char (point-min))
    (if (= 0 where)
        (re-search-forward "^-\n" nil t)
      (if (= 1 where)
          (re-search-forward "^--\n" nil t)
        (re-search-forward "^---\n" nil t) ; case 2 or 3
        (when (= 3 where)
          (re-search-forward "^[^\\.\\\\]" nil t)
          (beginning-of-line))))))

;;   {  {{ }}  }
;;     ^^    ^
;; (goto-char (scan-lists (point) 1 0))
;;
;;   {  {{ }}  }
;;     ^^       ^
;; (goto-char (scan-lists (point) 1 1))

(defun gri-kill-option-mouse (EVENT)
  "Kill (delete) a gri command option, variable or string.
See  `C-h f gri-kill-option' for more help"
  (interactive "e")
  (mouse-set-point EVENT)
  (gri-kill-option))

(defun gri-kill-option ()
  "Kill (delete) a gri command option, variable or string.
An option is everything within brackets.  This has highest priority.
e.g. after command completion, you get something like:

  draw x axis [at bottom|top|{.y. [cm]} [lower|upper]]
   put the cursor here and C-c C-k ^ yields:
  draw x axis [at bottom|top|{.y. } [lower|upper]]
       then here and press C-c C-k ^ and you get:
  draw x axis
       because it delete the innermost bracketed option.
  
If the cursor is not within a bracketed option, and is within
a string or on the first character or a variable, then that string
or variable is deleted."
  (interactive)
  (let ((beg-line   (progn (save-excursion (beginning-of-line) (point))))
        (here-point (progn (save-excursion (forward-char 1)(point))))
        (del-flag nil) (brk-point))
    (save-excursion                     ;Start with bracket options
      (while (and (not del-flag) (re-search-backward "[{[]" beg-line t))
        (setq brk-point (point))
        (save-excursion
          (goto-char (scan-lists (point) 1 0))
          (if (>= (point) here-point)
              (progn 
                (setq del-flag t)
                (delete-region (point) brk-point)
                (delete-horizontal-space)
                (insert " "))))))
    (if del-flag
        (gri-next-option)               ; Visit next option
      ;; Check if on first char of a variable, delete it.
      (if (string-match "^\\.\\(\\.\\)?[A-z0-1]+\\(\\.\\)?\\." 
                        (buffer-substring (point)
                                          (progn (save-excursion
                                                   (end-of-line)(point)))))
          (progn
            (delete-char (match-end 0)))
        ;; Check if within a string, delete it
        (save-excursion
          (if (and (re-search-backward "\"" beg-line t) 
                   (progn 
                     (forward-char 1)
                     (setq brk-point (point))
                     (re-search-forward 
                      "\"" (progn (save-excursion (end-of-line) (point))) t))
                   (>= (point) here-point))
              (delete-region (progn (forward-char -1)(point)) brk-point)))))))

(defun gri-old-goto-option ()
  "Go to first bracket on line, else first dot or slash, else don't move"
  (let ((flag t) (here-point) (end-line (progn (end-of-line)(point))))
    (save-excursion
      (beginning-of-line)
      (if (not (re-search-forward "[{[]" end-line t))
          (if (not (re-search-forward "[\\.]" end-line t))
              (setq flag nil)
            (backward-char 1))) ;; move on dot or slash
      (if flag
          (setq here-point (point))))
    (if flag
        (forward-char (- here-point (point))))))

(defun gri-next-option ()
  "Go to next option on line (options first, variables and strings second)"
  (interactive)
  (let ((end-line (progn (save-excursion (end-of-line)(point))))
        (the-point (point)))
      ;; first do brackets, then variables or strings
    (if (or (re-search-forward "[{[|]" end-line t)
            (progn
              (beginning-of-line)
              (re-search-forward "[{[]" end-line t))
            (progn
              (goto-char the-point)
              (re-search-forward " [\"\\.]" end-line t))
            (progn
              (beginning-of-line)
              (re-search-forward " [\"\\.]" end-line t)))
        (progn
          ;;move backward if on a variable (with a dot)
          (backward-char 1)
          (if (not (string-equal (buffer-substring (point) (1+ (point))) "."))
              (forward-char 1))))))

(defun gri-option-select-mouse (EVENT)
  "Select a gri option left by gri-complete. See gri-option-select for help."
  (interactive "e")
  (mouse-set-point EVENT)
  (gri-option-select))

(defun gri-option-select ()
  "Select a gri option left by gri-complete.

  Narrow in on a particular gri command, given a syntax description left
on the line by gri-complete.  The cursor location is used to decide
which gri command(s) to narrow to.

EXAMPLE: If gri-complete is used on the line `dr x a', the result will
be a line like
  draw x axis [at bottom|top|{.y. [cm]} [lower|upper]]

This is the Gri way of describing many commands at once.  All these
commands are described by this syntax description:
  draw x axis
  draw x axis at bottom
  draw x axis at bottom top
  draw x axis at bottom bottom
  draw x axis at top
  draw x axis at top top
  draw x axis at top bottom
  draw x axis at .y. cm
  draw x axis at .y. cm lower
  draw x axis at .y. cm upper

The gri-option-select command provides easy navigation to select one
of these commands.  The narrowing process is governed by the cursor
position.  For example, to get the command narrowed down to
  draw x axis at bottom [lower|upper] place the cursor somewhere in
the word `bottom' and invoke gri-option-select.  To complete the
narrowing process, selecting
  draw x axis at bottom lower
move the cursor to some place in the word `lower' and invoke
gri-option-select again.  On the other hand, to get
  draw x axis at bottom
you would put the cursor over either the word `lower' or `upper', and
invoke gri-kill-option.

NOTE: you might want to practice using this example to learn how to do
it.  If you make a mistake, note that the normal Emacs undo works."
  (interactive)
;;Algorithm is  1) remove other options within brackets
;;              2) while there are grouping brackets
;;                   remove options on either side of brackets
;;                   remove brackets
  (let ((beg-line (progn (save-excursion (beginning-of-line) (point))))
     ;;;(here-point (progn (save-excursion (forward-char 1)(point))))
        )
    (save-excursion
      (skip-chars-backward "^ |[]{}")
      (gri-del-group-opt-backward))
    (save-excursion
      (skip-chars-forward "^ |[][}")
      (gri-del-group-opt-forward))
    (save-excursion
      (while (< beg-line (gri-return-enclosing-group nil beg-line))
        (goto-char (gri-return-enclosing-group nil beg-line))
        ;; on a start bracket of a group
        (save-excursion
          (goto-char (scan-lists (progn (backward-char 1)(point)) 1 0))
          (delete-backward-char 1)    ;; delete the closing bracket
          (gri-del-group-opt-forward))
        (delete-char 1)       ;; delete the opening bracket
        (gri-del-group-opt-backward)
     ;;;(setq here-point (point))
        ))
    (gri-next-option)))
    
(defun gri-del-group-opt-forward ()
  "Called by gri-option-select to delete backward options within brackets
     e.g.   [arg1|arg2]|[[ar3 arg4]|arg5|arg6]|arg8
                        |               ^    |
         becomes
            [arg1|arg2]|[arg5|ar6]|arg8
Always starts on first character to delete."
  (save-excursion
    (let ((end-point (gri-return-enclosing-group 
                      t (progn (save-excursion (end-of-line) (point)))))
          (here-point (point)))
      ;; see if followed by |, if so select option after it for deletion
      (while (and (progn (skip-chars-forward " \t")(looking-at "|"))
                  (> end-point (point)))           ;; and still within group
        (forward-char 1)(skip-chars-forward " \t")
        (if (looking-at "[{[]")                    ;; on an opening bracket
            (goto-char (scan-lists (point) 1 0))
          ;; on a simple word--find end
          (if (re-search-forward "[] |{}[]" end-point t)
              (backward-char 1)                   ;; don't delete bracket or sp
            (goto-char end-point))))
      (skip-chars-backward " \t")
      (if (< end-point (point))
          (goto-char end-point))
      (delete-region (point) here-point))))

(defun gri-del-group-opt-backward ()
  "Called by gri-option-select to delete backward options within brackets
     e.g.   [arg1|arg2]|[[ar3 arg4]| arg5|arg6]|arg8
                        |           ^        |
         becomes
            [arg1|arg2]|[arg5|ar6]|arg8
Always starts on first character to keep."
  (save-excursion
    (let ((beg-point (gri-return-enclosing-group 
                      nil (progn (save-excursion (beginning-of-line)(point)))))
          (here-point (point)))
      ;; see if preceeded by |, if so select option before it for deletion
      (while (progn (save-excursion 
                      (and (progn (skip-chars-backward " \t")(backward-char 1)
                                  (looking-at "|"))   ;; preceeded by | 
                           (< beg-point (point)))))   ;; and still within group
        (skip-chars-backward " \t")(backward-char 1)  ;; on the |
        (skip-chars-backward " \t")(backward-char 1)  ;; on the previous word
        (if (looking-at "}\\|]")                      ;; on a closing bracket 
            (progn (forward-char 1)(goto-char (scan-lists (point) -1 0)))
          (if (re-search-backward "[] |{}[]" beg-point t)  ;; on a simple word
              (forward-char 1)                             ;; on first char
            (goto-char beg-point)(forward-char 1))))
      (skip-chars-forward " \t")
      (if (> beg-point (point))
          (progn (goto-char beg-point) (forward-char 1)))
      (delete-region (point) here-point))))
    
(defun gri-return-enclosing-group (end_flag boundary)
  "Return as a point either the beginning (ARG1 nil) or end (ARG1 t)
of the first enclosing group, either curly or square brakets.
  [   ]
  ^   ^ 
The boundaries are the points not to be exceeded (e.g. end-of-line
for ARG1 t, beginning-of-line for ARG1 nil).
Return that boundary if no containing group within that boundary."
  (save-excursion
    (let ((the-point) (here-point (point)))
      (if end_flag
          (progn
            (while (and (re-search-forward "[]}]" boundary t)
                        (< here-point ;; while group doesn't enclose cursor
                           (progn 
                             (save-excursion 
                               (goto-char (scan-lists (point) -1 0))
                               (backward-char 1)
                               (setq the-point (point))
                               the-point)))))
            ;; return either end of group or boundary
            (if (and the-point                  ;; found at least one group
                     (> here-point the-point))  ;; and it encloses us
                (point)                         ;; then return end of group
              boundary))                        ;; else return boundary  
        ;; end_flag is nil
        (while (and (re-search-backward "[{[]" boundary t)
                    (> here-point ;; while group doesn't enclose cursor
                       (progn 
                         (save-excursion 
                           (goto-char (scan-lists (point) 1 0))
                           (setq the-point (point))
                           the-point)))))
        ;; return either beginning of group or boundary
        (if (and the-point                  ;; found at least one group
                 (< here-point the-point))  ;; and it encloses us
            (point)                         ;; then return end of group
          boundary)))))                     ;; else return boundary  


(defun gri-old-del-group-opt-forward ()
  "Called by gri-option-select to delete forward options within brackets
     e.g.   [arg1|arg2|[ar3 arg4]|{arg5 arg6}]|arg8
              ^
         becomes
            [arg1]|arg8

   Assumes there is always a space between separate options, e.g.
    [.word1. .word2.] [.word4.]
                     ^ "
  (let ((end-line (progn (save-excursion (end-of-line) (point))))
        (brk-point nil))
    (save-excursion
      ;; see if followed by |, if so delete options after
      (if (and (re-search-forward "[]}| ]" end-line t)
               (char-equal 124 (char-after (progn (backward-char 1)(point)))))
          (progn
            (setq brk-point (point))  ;; then go to whitespace, skipping groups
                                      ;; but don't go past group's closing br
            (while (and (not (char-equal 93 (char-after (point))))  ;;close-sq
                        (not (char-equal 125 (char-after (point)))) ;;close-cur
                        (not (char-equal 32 (char-after (point))))  ;;space
                        (re-search-forward "[]} {[]" end-line t))
              (if (or (char-equal 123 (char-after (progn  ;;open-cur
                                                    (backward-char 1)(point))))
                      (char-equal  91 (char-after (point))))       ;;open-sq
                  ;; following is why I need a space between options!
                  (goto-char (scan-lists (point) 1 0))))
            (if (or (not (char-after (point)))                ;;at eol
                    (and (not (char-equal 32  (char-after (point)))) 
                         (not (char-equal 125 (char-after (point))))  
                         (not (char-equal 93  (char-after (point))))))
                (delete-region (progn (end-of-line)(point)) brk-point)
              (delete-region (point) brk-point)))))))

(defvar Info-directory-list)
(defvar Info-directory)

(defun gri-info-directory ()
  "Returns nil or gri info file path 
In emacs 19, path is from Info-default-directory-list and
  gri info file may be compressed, with suffix .Z .z or .gz
In emacs 18, path is Info-directory and cannot be compressed."
  (require 'info)
  (if (boundp 'Info-directory-list)
      (progn
        (let ((work-list Info-directory-list)
              (notfound t)
              (info-directory nil))
          (while (and notfound (car work-list))
            (if (or (file-readable-p (concat (car work-list) "gri"))
                    (file-readable-p (concat (car work-list) "gri.Z"))
                    (file-readable-p (concat (car work-list) "gri.z"))
                    (file-readable-p (concat (car work-list) "gri.gz"))
                    (file-readable-p (concat (car work-list) "gri.info"))
                    (file-readable-p (concat (car work-list) "gri.info.Z"))
                    (file-readable-p (concat (car work-list) "gri.info.gz")))
		(progn
                  (setq info-directory (car work-list))
                  (setq notfound nil))
	      ;; In XEmacs, the directories don't have a trailing slash:
	      (if (or (file-readable-p (concat (car work-list) "/gri"))
		      (file-readable-p (concat (car work-list) "/gri.Z"))
		      (file-readable-p (concat (car work-list) "/gri.z"))
		      (file-readable-p (concat (car work-list) "/gri.gz"))
                      (file-readable-p (concat (car work-list) "/gri.info"))
                      (file-readable-p (concat (car work-list) "/gri.info.Z"))
                      (file-readable-p (concat (car work-list) "/gri.info.gz")))
		  (progn
		    (setq info-directory (concat (car work-list) "/"))
		    (setq notfound nil))
		(setq work-list (cdr work-list)))))
	  info-directory))
    (if (file-readable-p (concat Info-directory "gri"))
        Info-directory
      nil)))
        
(defun gri-help-apropos (keyword)
  "Displays all gri commands containing keyword argument in *help* buffer.
Code fragment abbreviations (e.g. ?set axes) are not included at present time.
The keyword is actually a regular expression;  while this could be a simple 
string, you could also list *all* gri commands with

 gri-help-apropos .

which matches any character." 
  (interactive "sgri apropos: ")
  (save-excursion
    (gri-lookat-syntax-file 1)
    (if (re-search-forward keyword nil t)
        (with-output-to-temp-buffer "*Help*"
          (princ "List of gri commands containing: ")
          (princ  keyword)
          (princ "\n\n")
          (beginning-of-line)
          (princ (gri-format-display-command 
                  (buffer-substring (progn (re-search-forward "\\(;\\|(\\)")
                                           ;; Skip over default description
                                           (forward-char -1)
                                           (if (looking-at "(")
                                               (re-search-forward ");" nil t)
                                             (forward-char 1))
                                           (point))
                                    (progn (end-of-line) (point)))))
          (forward-line 1)
          (while (re-search-forward keyword nil t)
            (beginning-of-line)
            (princ "\n")
            (princ (gri-format-display-command
                    (buffer-substring (progn (search-forward ";") (point))
                                      (progn (end-of-line) (point)))))
            (forward-line 1))
          (print-help-return-message))
      (message "Nothing suitable"))))

(defalias 'gri-apropos 'gri-help-apropos)

(defun gri-show-function (&optional show-all)
  "Uncover function on current line, hidden by gri-hide commands.
If prefixed, show all functions in current buffer (this may easier than
typing in C-c M-S)."
  (interactive "P")
  (let ((modified (buffer-modified-p)))
    (if show-all 
        (gri-show-all)
      (show-entry)
      (set-buffer-modified-p modified))))

(defun gri-show-all ()
  "Uncover all functions in current buffer, hidden by gri-hide commands."
  (interactive)
  (let ((modified (buffer-modified-p)))
    (if (fboundp 'show-all)
	(show-all))
    (set-buffer-modified-p modified)))

(defun gri-hide-function (&optional hide-all)
  "Hide function under point, similarly to outline-mode.
If prefixed, hide all functions in current buffer.

BUGS:  Will get confused if you have a string which looks like a function
       title in your function's help text (i.e. a line which begins with
       a ` character and ends with a ' character." 
  (interactive "P")
  (if hide-all 
      (gri-hide-all)
    (let ((the-begin) (the-end) (modified (buffer-modified-p)))
      (save-excursion
        (if (not (re-search-forward "^}" nil t))
            (error "Sorry, can't find the end of the function to hide.")
          (setq the-end (point)))
        (if (not (re-search-backward "^`.*'$" nil t))
            (error "Sorry, can't find the beginning of the function to hide.")
          (setq the-begin (point))))
      (hide-region-body the-begin the-end)      
      (set-buffer-modified-p modified))))

(defun gri-hide-all (&optional quiet)
  "Hide all functions in current buffer, similarly to outline-mode.
Optional argument t (prefix) will make it quiet about error.  This should 
be used if you call this function in your gri-mode-hook such that it won't
complain when you load a gri file which contains no locally defined gri 
functions.

BUGS:  Will get confused if you have a string which looks like a function
       title in your function's help text (i.e. a line which begins with
       a ` character and ends with a ' character.)" 
  (interactive "P")
  (save-excursion
    (goto-char (point-min))
    (re-search-forward "^`[^']*'$" nil t)
    (beginning-of-line)
    (let ((the-start (point))(the-end) (modified (buffer-modified-p)))
      ;; Find the end of the last new command
      (while (and (re-search-forward "^`[^']*'$" nil t)
                  (re-search-forward "^}$" nil t)))
      (if (= (point) the-start)
          (if (not quiet)
              (message "Sorry, can't find any functions to hide."))
        (forward-line 1)
        (setq the-end (point))
        (hide-region-body the-start the-end)
        (set-buffer-modified-p modified)))))

(defvar gri-arg-hist nil)

(defun gri-command-arguments (arg-string)
  "Set the extra arguments sent to the gri process.
Usually used to send debugging flags."
  (interactive (list (read-string "Gri arguments: ")))
;;(interactive 
;; (list (completing-read "Gri arguments: " nil nil nil nil gri-arg-hist)))
  (setq gri-command-arguments arg-string)
  (message "gri-run will use arguments: -b -y %s" gri-command-arguments))

(defun gri-do-run (the-command inhibit-gri-view)
  "Do actual work for gri-run and gri-run-new."
  (if (buffer-modified-p)
      (save-buffer))
  (let ((resize-mini-windows nil))
    (when (and gri-view-process
               gri*view-watch
               (eq (process-status gri-view-process) 'run))
      ;; If using gri-view with -watch option, stop that process now to
      ;; prevent it from updating while we regenerate the postscript file.
      (signal-process (process-id gri-view-process) 'SIGSTOP)
      (stop-process gri-view-process))
    (cond
     ((string-equal "" gri-command-arguments)
      (message "%s %s %s %s (on newly saved file)" 
               the-command (gri-run-setting-string) 
               (file-name-nondirectory buffer-file-name)
               gri-command-postarguments)
      (shell-command (concat the-command (gri-run-setting-string) 
                             buffer-file-name " " gri-command-postarguments)))
     (t
      (message "%s %s %s %s %s (on newly saved file)" 
               the-command gri-command-arguments
               (gri-run-setting-string) 
               (file-name-nondirectory buffer-file-name)
               gri-command-postarguments)
      (shell-command
       (concat the-command gri-command-arguments " " 
               (gri-run-setting-string)
               (file-name-nondirectory buffer-file-name)
               " " gri-command-postarguments)))))
  (message "Running gri done.")
  (cond
   ((not (get-buffer "*Shell Command Output*"))
    (cond
     ((and gri-view-process
           gri*view-watch
           (eq (process-status gri-view-process) 'stop))
      (signal-process (process-id gri-view-process) 'SIGCONT)
      ;; In Emacs20, the status doesn't change from 'stop, so do this:
      (continue-process gri-view-process))
     ((and gri*view-after-run
           (not inhibit-gri-view))
      (gri-view)))
    (message "Gri command completed with no output."))
   (t
    ;; There is a shell ouput buffer...
    (let ((display-buffer-p)(msg)(eline)(efile))
      (save-excursion
        (set-buffer "*Shell Command Output*")
        (goto-char (point-min))
        (if (re-search-forward "^Segmentation fault" nil t)
            (setq msg "Segmentation Fault while running gri!"))
        ;;FATAL error: gr.m:2352: can't use negative y (0.00000) with LOG
        (if (re-search-forward "^\\(ERROR:\\|FATAL error:\\).*$" nil t)
            (setq msg (buffer-substring (match-beginning 0)(match-end 0))))
        (if (re-search-forward "^PROPER USAGE:" nil t)
            (setq display-buffer-p t))
        (if (re-search-forward "^ Bad command:" nil t)
            (setq display-buffer-p t))
        ;;Error detected at /home/rhogee/new/paper/enlarged_map.gri:42
        (if (re-search-forward 
             "Error\\( detected\\)? at \\([^:]+\\):\\([0-9]+\\)" nil t)
            (setq efile (buffer-substring (match-beginning 2)(match-end 2))
                  eline (string-to-int 
                         (buffer-substring (match-beginning 3)(match-end 3)))))
        (goto-char (point-min))
        (set-window-point (get-buffer-window (current-buffer))
                          (point-max))) ;This won't work !!!
      (cond 
       (efile                           ;Have both msg and line info
        (cond ((not (string-match "gri.cmd$" efile))
               (find-file efile)
               (goto-line eline)))
        (if display-buffer-p (display-buffer "*Shell Command Output*"))
        (if msg (error msg)))
       (msg
        (if display-buffer-p (display-buffer "*Shell Command Output*"))
        (error msg))
       (display-buffer-p 
        (display-buffer "*Shell Command Output*"))
       (t                               ;Clean execution
        (let ((lines
               (save-excursion
                 (if (not (get-buffer "*Shell Command Output*"))
                     0
                   (set-buffer "*Shell Command Output*")
                   (if (= (buffer-size) 0)
                       0
                     (count-lines (point-min) (point-max)))))))
          (cond
           ((and gri-view-process
                 gri*view-watch
                 (eq (process-status gri-view-process) 'stop))
            (signal-process (process-id gri-view-process) 'SIGCONT)
            ;; In Emacs20, the status doesn't change from 'stop, so do this:
            (continue-process gri-view-process))
           ((and gri*view-after-run
                 (not inhibit-gri-view))
            (gri-view)))
          ;; If there was only one line of output from Gri, we should
          ;; repeat it here.
          (cond ((= lines 0)
                 (message "Gri command completed with no output.")
                 (kill-buffer "*Shell Command Output*"))
                ((= lines 1)
                 (message "%s"
                          (save-excursion
                            (set-buffer  "*Shell Command Output*")
                            (goto-char (point-min))
                            (buffer-substring 
                             (point)
                             (progn (end-of-line)(point))))))))))))))

(defun gri-run (&optional inhibit-gri-view)
  "Save buffer to a file, then run Gri on it, creating a PostScript file
called *.ps where * is the basename of the gri command-file.  (If the 
buffer/file name does not end in `.gri', the PostScript file name is
the full buffer name, with suffix `.ps' added.

After its successfull completion, gri-run will invoke gri-view if the
variable gri*view-after-run is set to true.  If gri-run ends in error,
it will try to place the edit point on the source line which contains 
the error.  

If an optional prefix argument is supplied to gri-run, gri-view will not 
be run.

If using \"gv\" and the \"-watch\" option, the gv process will be stopped
during the time gri-run regenerates the menu, and continued thereafter and
gv will redisplay the figure (instead of gri-mode starting up a new gv
process)."
  (interactive "P")
  (gri-validate-cmd-file)
  (if (string-equal gri-bin-file "gri") ; Use shell default version
      (gri-do-run (concat "gri -b -y ") inhibit-gri-view)
    (gri-do-run (concat gri-bin-file
                        " -directory " (file-name-directory gri-cmd-file)
                        " -y -b ")
                inhibit-gri-view)))
  
(defun gri-view (&optional filename)
  "Run X-windows viewer in lower shell on existing .ps file for the gri buffer
using landscape mode if `set page lansdscape' is found in gri buffer.
A gzip'ed postscript file can also be viewed without overwriting the file.  

Reset variables gri*view-command and gri*view-landscape-arg in your .emacs
file to control what commands are sent to the shell to display the
postscript file.  Default values are: 

  (setq gri*view-command \"gv\")
  (setq gri*view-landscape-arg \"-landscape\") 

The default viewer is \"gv\" because is has options that gri-mode knows
about, such as -watch and -scale.  Default values for these options are
selectable from gri-customize, and buffer-local settings can be made
from the menubar.

See also the gri-run command, which calls gri-view automatically after
successfully executing your gri buffer if the variable gri*view-after-run
is set to true.  If using \"gv\" and the \"-watch\" option, the gv process
will be stopped during the time gri-run regenerates the menu, and continued
thereafter and gv will redisplay the figure (instead of gri-mode starting
up a new gv process)."
;;; Asynchronyous output goes to *shell-command* buffer.
;;;  Return windows to original state because that buffer is usually empty
;;;  (if no error occurred) and will probably be empty on error by the time
;;;  the function finishes, because it's asynchronious.
  (interactive)
  (let ((psfile (or filename
                    (concat (filename-sans-gri-suffix buffer-file-name)
                            ".ps")))
        (shell-command-switch
         (or (and (boundp 'shell-command-switch) shell-command-switch) "-c"))
        (command (cond
                  ((and (symbolp gri*view-command)
                        (equal 'gv-old gri*view-command))
                   "gv")
                  ((symbolp gri*view-command)
                   (symbol-name gri*view-command))
                  (t
                   gri*view-command)))
        (landscape) (scale) (watch) (noantialias))
    (if (not (file-readable-p psfile))
        (if (not (file-readable-p (concat psfile ".gz")))
            (error "%s not found or not readable" psfile)
          ;;Found gzipped version of file
          (setq psfile (concat psfile ".gz"))))
    (cond
     ((and (symbolp gri*view-command)
           (equal 'gv gri*view-command))
      (setq landscape
            (save-excursion
              (goto-char (point-min))
              (if (re-search-forward "^[ \t]*set[ ]+page[ ]+landscape" nil t)
                  "--orientation=landscape"
                "--orientation=portrait")))
      (setq scale (format "--scale=%s" (int-to-string gri*view-scale)))
      (setq watch (if gri*view-watch "--watch" "--nowatch"))
      (setq noantialias
            (if gri*view-noantialias "--noantialias" "--antialias")))
     ((and (symbolp gri*view-command)
           (equal 'gv-old gri*view-command))
      (setq landscape
            (save-excursion
              (goto-char (point-min))
              (if (re-search-forward "^[ \t]*set[ ]+page[ ]+landscape" nil t)
                  "-landscape"
                "-portrait")))
      (setq scale (format "-scale %s" (int-to-string gri*view-scale)))
      (setq watch (if gri*view-watch "-watch" "-nowatch"))
      (setq noantialias
            (if gri*view-noantialias "-noantialias" "-antialias")))
     ((not (symbolp gri*view-command))
      (setq landscape
            (save-excursion
              (goto-char (point-min))
              (if (re-search-forward "^[ \t]*set[ ]+page[ ]+landscape" nil t)
                  gri*view-landscape-arg
                nil)))))
     (cond
      ((equal command "gv")
       (message "%s %s %s %s %s %s" command landscape watch scale noantialias
                psfile)
       (setq gri-view-process
             (start-process "gri-view" nil command landscape watch
                            scale noantialias psfile)))
      (landscape
       (message "%s %s %s" command landscape psfile)
       (setq gri-view-process 
             (start-process "gri-view" nil command landscape psfile)))
      (t
       (message "%s %s" command psfile)
       (setq gri-view-process (start-process "gri-view" nil command psfile))))
     ;;(setq mode-line-process '(":%s"))
     ;;(set-process-sentinel gri-view-process 'shell-command-sentinel)
     (set-process-filter   gri-view-process 'gri-insertion-filter)))

(defun gri-insertion-filter (gri-view-process string)
  (message "gri-view: %s" string))

(defun gri-indent-buffer ()
  "Indent the entire gri buffer. Won't indent hidden user commands."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (skip-chars-forward "\n")
    (gri-indent-line)
    (while (= 0 (forward-line 1))
      (gri-indent-line))))

(defun gri-indent-region (from to &optional entire-buffer-flag)
  "Indent the region.  Prefix arg means indent entire buffer.
e.g. 
      ESC 1 ESC q      will indent the entire buffer."
  (interactive "r\nP")
  (save-excursion
    (if entire-buffer-flag
        (gri-indent-buffer)
      (save-restriction
        (narrow-to-region from to)
        (goto-char (point-min))
        (skip-chars-forward "\n")
        (narrow-to-region (point) (point-max))
        (gri-indent-line)
        (while (= 0 (forward-line 1))
          (gri-indent-line)))))
  (gri-indent-line))
  
(defun gri-convert-comments ()
  "Convert Gri // and /* */ comments to # style in current buffer.
You could add this function to an gri-mode-hook such that it runs 
automatically to convert all your old gri files.  To do this add the 
following to your ~/.emacs file:

 (add-hook 'gri-mode-hook ' gri-convert-comments)

See also gri-convert-comments-with-prompt."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "//" nil t)
      (if (gri-system-line)
	  (end-of-line)
	(delete-backward-char 2)
	(insert "#")))
    (goto-char (point-min))
    (while (search-forward "/*" nil t)
      (if (gri-system-line)
	  (end-of-line)
	(delete-backward-char 2)
	(insert "#")
	(let ((start (point)))
	  (if (re-search-forward "*/" nil t)
	      (save-restriction
		(delete-backward-char 2)
		(narrow-to-region start (point))
		(goto-char start)
		(while (= 0 (forward-line 1))
		  (insert "#")))))))))

(defun gri-convert-comments-with-prompt ()
  "A function to put in a gri-mode-hook to convert your files to # comments.
You could add this function to an gri-mode-hook such that it runs 
automatically to convert all your old gri files after prompting you to do 
the conversion.  To do this add the following to your ~/.emacs file:

 (add-hook 'gri-mode-hook ' gri-convert-comments-with-prompt)

See also gri-convert-comments."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((found))
      (while (and (not found)
		  (re-search-forward "//\\|/\*" nil t))
	(if (not (gri-system-line))
	    (setq found t)))
      (if (and found
	       (y-or-n-p "Convert old comment lines? "))
	  (gri-convert-comments)))))
				 
(defun gri-comment-out-region (from to)
  "Comment out the region between point and mark.
You can remove these comments using gri-uncomment-out-region."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (goto-char (point-min))
      (let ((overwrite-mode nil))
        (insert "#")
        (while (and (= 0 (forward-line 1))
                    (not (= (point) (point-max))))
          (insert "#"))))))
 
(defun gri-uncomment-out-region (from to)
  "Remove Comments at beginning of lines in the region between point and mark."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (goto-char (point-min))
      (if (looking-at "//")
          (delete-char 2))
      (if (looking-at "#")
          (delete-char 1))
      (while (= 0 (forward-line 1))
        (if (looking-at "//")
            (delete-char 2))
        (if (looking-at "#")
            (delete-char 1))))))
        
(defun gri*date-function ()
  "Adapted from objective-C-mode.  Add name, author and date on current line."
  (let* ((u (- 63 (length (user-full-name)) (length (gri*date)))))
    (insert "# ")
    (if (not (string-equal (user-full-name) ""))
        (progn
          (setq u (- u 1))
          (insert (user-full-name) " ")))
    (insert-char 32 u)
    (insert (gri*date))))
    
(defun gri*date ()
  "Return the current date in an EB Signal standard form.
Code from objective-C-mode."
  (concat (substring (current-time-string) -4 nil)
	  "-"
	  (gri*month (substring (current-time-string) 4 7))
	  "-"
	  (gri*day (substring (current-time-string) 8 10))))

(defun gri*day (aString)
  (let ((a
	 (car (cdr (assoc aString '((" 1"  "01")
				    (" 2"  "02")
				    (" 3"  "03")
				    (" 4"  "04")
				    (" 5"  "05")
				    (" 6"  "06")
				    (" 7"  "07")
				    (" 8"  "08")
				    (" 9"  "09")))))))
    (if (null a) aString a)))

(defun gri*month (aString)
  (let ((a
	 (car (cdr (assoc aString '(("JAN"  "01")
				    ("FEB"  "02")
				    ("MAR"  "03")
				    ("APR"  "04")
				    ("MAY"  "05")
				    ("JUN"  "06")
				    ("JUL"  "07")
				    ("AUG"  "08")
				    ("SEP"  "09")
				    ("OCT"  "10")
				    ("NOV"  "11")
				    ("DEC"  "12")
				    ))))))
    (if (null a) aString a)))


(defun gri-function-skeleton ()
  "Build a routine skeleton prompting for name."
  (interactive)
  (let ((the-name (read-string "gri function name: ")))
    (if (string-equal the-name "")
        (error "No name given."))
    (goto-char (point-min))
    (insert "\n") (backward-char 1)
    (insert "`" the-name "'\n")
    (insert "------------------------------------")
    (insert "----------------------------------\n\n")
    (insert "------------------------------------")
    (insert "----------------------------------\n")
    (insert "{\n")
    (gri*date-function) (gri-indent-line)
    (insert "\n") (gri-indent-line)
    (insert "\n}")
    (previous-line 5)))

(defun gri-fontify-buffer ()
  "Fontify buffer with font-lock"
  (interactive)
  (cond
   ((featurep 'font-lock)
    (font-lock-fontify-buffer))
   ((load "font-lock" t t)
    (font-lock-fontify-buffer))
   (t
    (message "font-lock is not available."))))

(defun gri-return ()
  "Carriage return in Gri-mode with optional highlighting and indentation.
If variable gri-indent-before-return is t, 
  current line is indented before newline is created."
  (interactive)
  (if gri-indent-before-return
      (gri-indent-line))
  ;; FIXME: I could also use font-lock on region to get continued system lines
  ;;        fontified okay.
  (newline)
  (gri-indent-line))

;;; -- font-lock stuff
(defvar gri-mode-system-face			'gri-mode-system-face
  "Face to use for gri-mode system commands.")

(defun gri-font-lock-setup ()
  (when (featurep 'font-lock)
    (cond
     (gri-mode-is-XEmacs
      ;; XEmacs:
      (make-face 'gri-mode-system-face)
      (set-face-foreground 
       'gri-mode-system-face "red" 'global nil 'append))
     (gri-mode-is-Emacs2X
      (copy-face 'font-lock-warning-face 'gri-mode-system-face))))
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
   '(gri-font-lock-keywords
     nil           ;;; Keywords only? No, let it do syntax via table.
     nil           ;;; case-fold?
     nil           ;;; Local syntax table.
     nil           ;;; Use `backward-paragraph' ? No
     ;;;(font-lock-comment-start-regexp . "%")
     ;;;(font-lock-mark-block-function . mark-paragraph)))
     )))

(defconst gri-font-lock-keywords nil
  "Default expressions to fontify in gri-mode.")

;; (make-regexp 
;;  '("break" "else" "else if" "end if" "end while" "if" "quit" "return" "rpn" 
;;    "while"))

;; Take the list of builtins from gri.cmd, and run
;;   perl -ne 'chop;{print "\"$_\"\n"}'
;; to get the list of strings.  Then:
;;
;; (regexp-opt
;; '(
;; "..R2.."
;; "..coeff0.."
;; "..coeff0_sig.."
;; "..coeff1.."
;; "..coeff1_sig.."
;; "..num_col_data.."
;; "..num_col_data_missing.."
;; "..arrowsize.."
;; "..batch.."
;; "..debug.."
;; "..fontsize.."
;; "..graylevel.."
;; "..linewidth.."
;; "..linewidthaxis.."
;; "..linewidthsymbol.."
;; "..missingvalue.."
;; "..symbolsize.."
;; "..superuser.."
;; "..trace.."
;; "..tic_direction.."
;; "..tic_size.."
;; "..xmargin.."
;; "..xsize.."
;; "..ymargin.."
;; "..ysize.."
;; "..red.."
;; "..blue.."
;; "..green.."
;; "..exit_status.."
;; "..xleft.."
;; "..xright.."
;; "..ybottom.."
;; "..ytop.."
;; "..use_default_for_query.."
;; "..words_in_dataline.."
;; "..eof.."
;; "..landscape.."
;; "..publication.."
;; "..xlast.."
;; "..ylast.."
;; "..image_width.."
;; "..image_height.."))
;; 
;; (regexp-opt
;; '(
;; "\.missingvalue."
;; "\.return_value."
;; "\.version."
;; "\.pid."
;; "\.wd."
;; "\.time."
;; "\.user."
;; "\.host."
;; "\.system."
;; "\.home."
;; "\.lib_dir."
;; "\.command_file."
;; "\.readfrom_file."
;; "\.ps_file."
;; "\.path_data."
;; "\.path_commands."))

(setq
 gri-font-lock-keywords
 '((gri-font-lock-match-functions
    (0 font-lock-function-name-face)
    (1 font-lock-comment-face nil t)
    (2 font-lock-function-name-face nil t)
    (3 font-lock-function-name-face nil t))
   (gri-font-lock-system-commands
    (0 font-lock-function-name-face nil t)
    (1 font-lock-keyword-face nil t)
    (2 gri-mode-system-face prepend t))
 ;;("\\(break\\|e\\(lse\\( if\\)?\\|nd \\(if\\|while\\)\\)\\|if\\|quit\\|r\\(eturn\\|pn\\)\\|while\\)\\b"
   ("\\(quit\\|return\\|if\\|else\\( if\\)?\\|end \\(if\\|while\\)\\|break\\|while\\|rpn\\)\\b"
    . font-lock-keyword-face)
   ("\\\\[^ ]+[ ]+[\\+\\*/^-]?= " . font-lock-function-name-face)
   ("\\.[^ .]+\\.[ ]+[\\+\\*/^-]?= " . font-lock-function-name-face)
   ("\\.\\.\\(\\(R2\\|arrowsize\\|b\\(atch\\|lue\\)\\|coeff\\([01]_sig\\|[01]\\)\\|debug\\|e\\(of\\|xit_status\\)\\|fontsize\\|gr\\(aylevel\\|een\\)\\|image_\\(height\\|width\\)\\|l\\(andscape\\|inewidth\\(axis\\|symbol\\)?\\)\\|missingvalue\\|num_col_data\\(_missing\\)?\\|publication\\|red\\|s\\(uperuser\\|ymbolsize\\)\\|t\\(ic_\\(direction\\|size\\)\\|race\\)\\|use_default_for_query\\|words_in_dataline\\|x\\(l\\(\\(as\\|ef\\)t\\)\\|margin\\|right\\|size\\)\\|y\\(bottom\\|last\\|margin\\|size\\|top\\)\\)\\.\\.\\)"
;; " \\(\\.\\.[A-z][^ .\n\C-m]*\\.\\.\\)" 
    (0 font-lock-type-face))            ; builtin ..variables..
   ("\\\\\\.\\(\\(command_file\\|ho\\(me\\|st\\)\\|lib_dir\\|missingvalue\\|p\\(ath_\\(commands\\|data\\)\\|id\\|s_file\\)\\|re\\(\\(adfrom_fil\\|turn_valu\\)e\\)\\|system\\|time\\|user\\|version\\|wd\\)\\.\\)"
    (0 font-lock-type-face))            ; builtin \.synonyms.
   ("\\(\\\\[^ }\C-m\n]+\\)" 
    (1 font-lock-variable-name-face))   ; \.synonyns.
   ("\\(\\b\\.[A-z][^ .\n\C-m]*\\.\\b\\)"
    (1 font-lock-variable-name-face))   ; user .variables.
   ))

;; V1.28 Stats on gsl-map.gri
;; 0.0202 gri-font-lock-match-functions
;; 0.0831 gri-font-lock-system-commands
;; 0.1074 "\\(quit\\|return\\|if\\|else\\( if\\)?..."
;; 0.0156 "\\\\[^ ]+[ ]+[\\+\\*/^-]?= "
;; 0.0141 "\\.[^ .]+\\.[ ]+[\\+\\*/^-]?= "
;; 0.0447 " \\(\\.\\.[A-z][^ .$]*\\.\\.\\)"
;; 0.0535 " \\(\\.[A-z][^ .$]*\\.\\)"
;; 0.2701 " \\(\\\\[^ $]+\\)"

;; Surprising that optimized regexp is slower...
;; 0.2695 "\\(break\\|e\\(lse\\(\\| if\\)\\|nd \\(if\\|while\\)

(defun gri-font-lock-system-commands (limit)
  "Match gri system commands.
Return: match 0 as the declaration.
        match 1 as the system keyword.
        match 2 as the command text."
  ;; Prior imcomplete multi-line system command?
  (if (not (and gri-mode-is-XEmacs
                (equal (point) (save-excursion (end-of-line)(point)))))
      ;;XEmacs finished last continued system command on eol - don't redo it!
      (let ((start-point (point))
            (start-line (progn (beginning-of-line)(point)))
            (last-step-ok))
        (while (and (setq last-step-ok (= 0 (forward-line -1)))
                    (progn (end-of-line)
                           (eq (preceding-char) ?\\))))
        (if last-step-ok (forward-line 1))
        (if (or (= (point) start-line)
                (not (looking-at
                      "\\(^\\|\C-m\\)[ \t]*\\(\\\\[^ ]+[ ]+=[ ]+\\)?\\(system\\)"
                      )))
            (goto-char start-point))))
;;;FIXME: XEmacs infinite loop:
;;;        - Is it because of the move above?
;;;        - Or because it's font-lock moves to end of match-data 0?
  (if (re-search-forward "\\bsystem\\b" limit t)
      (let ((sys-b  (match-beginning 0))
            (sys-e  (match-end 0))
            decl-b decl-e com-b com-e)
        ;; goto bol to see if commented out
        (re-search-backward "^\\|\C-m" (point-min) t)
        (if (not (looking-at 
                  "\\(^\\|\C-m\\)[ \t]*\\(\\\\[^ ]+[ ]+=[ ]+\\)?\\(system\\)"))
            ;;                         ^^^^^^^^^^^^^^^^^^^^^^^^opt synonym
            (progn                      ; It was commented out or otherwise
              (goto-char sys-e)         ;  invalid
              (store-match-data (list nil nil))
              t)
          (setq decl-b (match-beginning 2))
          (setq decl-e (match-end 2))
          ;; <<EOF form?
          (if (re-search-forward 
               "\\(<<\"?EOF\"?\\)?\\(\n\\|\C-m\\)" limit t)
              (if (match-beginning 1)
                  (progn
                    (setq com-b (1+ sys-e))
                    (setq com-e (match-end 0))
                    (if (re-search-forward "\\(^\\|\C-m\\)EOF" limit t)
                        (setq com-e (match-end 0))))
                ;; Not an EOF form, skip all continuation lines
                (backward-char 1)
                (while (and (re-search-forward "$\\|\C-m" limit t)
                            (eq (preceding-char) ?\\)
                            (re-search-forward "^" limit t)))
                (setq com-b (1+ sys-e))
                (setq com-e (point))))
          (goto-char sys-e)
          (store-match-data
           (list decl-b decl-e sys-b sys-e com-b com-e))
          t))))

(defun gri-font-lock-match-functions (limit)
  "Match gri function declarations.
Return: match 0 as the declaration.
        match 1 as the comment description.
        match 2 as the opening bracket.
        match 3 as the closing bracket."
  (if (re-search-forward "^`" limit t)
      (let ((decl-b (match-beginning 0))
            (decl-e (match-end 0))
            com-b com-e open-b open-e close-b close-e)
        (when (re-search-forward "\\('\\)\\|\C-m\\|\n" limit t)
          (if (not (match-end 1))
              (setq decl-e (match-end 0))
            (setq decl-e (match-end 1))
            (goto-char decl-e)
            (when (re-search-forward "\\(^\\|\C-m\\){$" limit t)
              (setq open-b (match-beginning 0))
              (setq open-e (1+ open-b))
              (when (< (1+ decl-e) open-b)
                ;; Comments are present
                (setq com-b (1+ decl-e))
                (setq com-e (1- open-b)))
              (goto-char open-b)
              (when (condition-case nil
                        (goto-char (or (scan-sexps (point) 1) (point-max)))
                      (error))
                (setq close-b (1- (point)))
                (setq close-e (1+ close-b)))
              (goto-char open-e))))
        (store-match-data
         (list decl-b decl-e com-b com-e open-b open-e close-b close-e))
        t)))

;;; -- End of font-lock stuff

(defun gri-narrow-to-function ()
  "Restrict editing in this buffer to the current gri function.
The rest of the text becomes temporarily invisible and untouchable
but is not deleted; if you save the buffer in a file, the invisible
text is included in the file.  C-x n w makes all visible again."
  (interactive)
  (save-excursion
    (let ((the-begin))
      (if (not (re-search-backward "^`.*'$" nil t))
          (message "Sorry, can't find the beginning of the function.")
        (setq the-begin (point))
        (if (or (not (re-search-forward "^{$" nil t))
                (not (re-search-forward "^}$" nil t)))
            (message "Sorry, can't find the end of the function to.")
          (narrow-to-region the-begin (point)))))))

(defun gri-insert-file-as-comment (&optional number-of-lines)
  "Insert one line as a gri comment, taking filename from under point.
Optional number of lines may be given as prefix argument.

This is useful to comment an `open' statement, e.g. with editing point 
on the filename, the following line:
 open gps.dat
gets the following comment:
 open gps.dat
 #  80 31.224'N  11 48.633'W 10:03:18.2 07/05/93"
  (interactive "p")
  (let ((name (gri-file-name-at-point))
     ;;;(the-end)
        )
    (if (not name)
        (message "Sorry, could not detect file name under editing point")
      (save-excursion
        (end-of-line)
        (newline)
        (shell-command (concat "head -"(int-to-string number-of-lines) 
                               " " name) t)
        (while (< 0 number-of-lines)
          (gri-indent-line)
          (insert "# ")
          (forward-line 1)
          (setq number-of-lines (1- number-of-lines)))
     ;;;(setq the-end (point))
        ))))

(defun gri-string-at-point (chars &optional punct)
  "Return maximal string around point, of chars specified by string CHARS.
Chars from the optional PUNCT string are stripped from the end."
  (buffer-substring 
   (save-excursion (skip-chars-backward chars) (point))
   (save-excursion 
     (let ((pt (point)))
       (skip-chars-forward chars)
       ;; skip back over punctuation, but not beyond pt:
       (and punct (skip-chars-backward punct pt))
       (point)))))
  
(defun gri-file-name-at-point ()
  "Return filename from around point if it exists, or nil.
Based on ffap.el from: mic@cs.ucsd.edu (Michelangelo Grigni)"
  (let* ((case-fold-search t)
	 (name (gri-string-at-point "--:$+<>@-Z_a-z~" ";.,!?")))
      (cond
       ((zerop (length name)) nil)
       ((file-exists-p name) name))))

(defvar gri*WWW-process nil)

(defun gri-WWW-manual ()
  "Start world-wide-web browser displaying gri manual.
The page visited is set in the variable gri-WWW-page, which may be reset on 
your site.  The main site (always up to date) is:

 http://gri.sourceforge.net/gridoc/html/index.html
or
 http://www.phys.ocean.dal.ca/~kelley/gri/index.html

The browser used by determined by the variable gri*WWW-program.
Any output (errors?) is put in the buffer `gri-WWW-manual'."
  (interactive)
  (cond 
   (gri*WWW-program
    (message "Starting process. See buffer gri-WWW-manual about errors.")
    (setq gri*WWW-process
          (start-process "gri-WWW" "gri-WWW-manual" gri*WWW-program
                         gri*WWW-page)))
   (t
    (if (not (featurep 'browse-url))
        (load "browse-url" t t))
    (if (not (featurep 'browse-url))
        (message "Sorry, you don't have browse-url on your system.  Set variable gri*WWW-program")
      (funcall browse-url-browser-function gri*WWW-page)))))

(setq completion-ignored-extensions
      (cons ".ps" completion-ignored-extensions))


(defun gri-close-statement ()
  "Insert a matching closing statement for open, if or while"
  (interactive)
  (let* ((the-statement)(the-string)(depth 1)
         (fullpattern 
          "^[ \t]*\\(open \\|if \\|while \\|end if\\|end while\\|close \\)")
         (pattern fullpattern))
    (save-excursion
      (while (and (not (equal depth 0))
                  (re-search-backward pattern nil t))
        (setq the-statement 
              (buffer-substring (match-beginning 1)(match-end 1)))
        (cond
         ((equal the-statement "end if")
          (setq depth (1+ depth))
          (setq pattern "^[ \t]*\\(if \\)"))
         ((equal the-statement "end while")
          (setq depth (1+ depth))
          (setq pattern "^[ \t]*\\(while \\)"))
         ((equal the-statement "close ")
          (setq depth (1+ depth))
          (goto-char (match-end 1))
          (re-search-forward "[^ \t\n]+" nil t)
          (setq pattern 
                (concat "^[ \t]*\\(open \\)" 
                        (buffer-substring (match-beginning 0)(match-end 0)))))
         ((equal the-statement "if ")
          (setq depth (1- depth))
          (setq pattern fullpattern)
          (setq the-string "end if"))
         ((equal the-statement "while ")
          (setq depth (1- depth))
          (setq pattern fullpattern)
          (setq the-string "end while"))
         ((equal the-statement "open ")
          (setq depth (1- depth))
          (setq pattern fullpattern)
          (goto-char (match-end 1))
          (re-search-forward "[^ \t\n]+" nil t)
          (setq the-string 
                (concat "close "
                        (buffer-substring 
                         (match-beginning 0)(match-end 0))))
          (beginning-of-line)))))
    (if (not (equal depth 0))
        (error "Sorry.  Could not find an unbalanced statement to close.")
      (if (not (string-match "[^ \t]"
                             (buffer-substring (point)
                                               (save-excursion 
                                                 (beginning-of-line)(point)))))
          (insert the-string)
        (end-of-line)
        (insert "\n" the-string))
      (let ((gri-indent-before-return t))
        (gri-return)))))

(defun gri-print ()
  "Print the postscript file associated with the current gri file."
  (interactive)
  (let ((the-option (or (and (stringp gri*lpr-switches)
                             gri*lpr-switches)
                        (car gri*lpr-switches)))
        (rest (and (listp gri*lpr-switches)
                   (cdr gri*lpr-switches))))
    (while rest
      (setq the-option (concat the-option " " (car rest)))
      (setq rest (cdr rest)))
    (let ((psfile (concat (filename-sans-gri-suffix buffer-file-name) ".ps"))
          (the-command))
      (if (not (file-readable-p psfile))
          (if (not (file-readable-p (concat psfile ".gz")))
              (error "%s not found or not readable" psfile)
            ;;Found gzipped version of file
            (setq the-command 
                  (concat "gunzip -c " psfile ".gz | " gri*lpr-command
                          " " the-option)))
        ;;Found postscript file
        (setq the-command 
              (concat gri*lpr-command " " the-option " " psfile)))
      (shell-command the-command)
      (if (get-buffer "*Shell Command Output*");;need this for emacs-18
          (save-excursion
            (set-buffer "*Shell Command Output*")
            (if (= (point-min)(point-max))
                (message "Done: %s" the-command))))
      (message "Done: %s" the-command))))

(defun gri-customize ()
  (interactive)
  (customize-group "gri"))

;; ---The following by Dan E. Kelley (with modifications by Peter Galbraith)
;; V1.01 24Jan91 by Dan Kelley, kelley@cs.dal.ca
;;      Created.  Used matlab.el as a guide.
;;
;; V1.02 29jan93 by Dan Kelley, kelley@open.dal.ca
;;	Change indent level to 2.
;; 
;; V1.03 11nov93 by Peter Galbraith, rhogee@bathybius.meteo.mcgill.ca
;;      fixed: auto-mode on .gri extension
;;      fixed: gri-comment didn't recognise existing comment after command
;;      fixed: gri-indent-line didn't recognise existing comment after command 
;;      fixed: gri-indent-line when previous line is a continued line:
;;               - removed abbrev mode
;;               - added fill mode with \ at end of lines
;;               - increase indent if first continuation
;;               - keep same indent as prev line if 2nd or more continuation
;;               - then indent next un-continued line same as base line
;;                 of continuated line, e.g.
;;       draw label "\string" at {rpn ..xmargin.. .2 +} \
;;                               {rpn ..ymargin.. .5 -}
;;       draw ...                ^ user modified indentation 
;;       ^ proper indentation regardless of continuated line
;;         based on base line of continuated line (draw label ...)

(defconst gri-comment-column 32
  "*The goal comment column in Gri-mode buffers.")

(defconst gri-new-command-help-indent-level 0
  "*The indentation in help lines for new commands.")

(defvar gri-indent-level 4 "Number of spaces to indent in gri-mode.")

(defvar gri-mode-syntax-table nil "Syntax table used in Gri-mode buffers.")

(defvar gri-hist-alist nil "History list for gri-help and gri-info")

(if gri-mode-syntax-table
    ()
  ;;; New syntax-table by PSG -- December 1995
  (setq gri-mode-syntax-table (make-syntax-table))

  ;; Support # style comments
  (modify-syntax-entry ?#  "<"  gri-mode-syntax-table)
  (modify-syntax-entry ?\n "> "    gri-mode-syntax-table)

  ;; Give CR the same syntax as newline, for selective-display
  (modify-syntax-entry ?\^m "> b"   gri-mode-syntax-table)

  ;;(modify-syntax-entry ?_ "_" gri-mode-syntax-table)
  (modify-syntax-entry ?_ "w" gri-mode-syntax-table)
  (modify-syntax-entry ?. "w" gri-mode-syntax-table)

;;(modify-syntax-entry ?\\ "_" gri-mode-syntax-table)
;; For strings like:  "a string with an embedded \" character"
  (modify-syntax-entry ?\\ "\\" gri-mode-syntax-table)

  (modify-syntax-entry ?+ "." gri-mode-syntax-table)
  (modify-syntax-entry ?- "." gri-mode-syntax-table)
  (modify-syntax-entry ?= "." gri-mode-syntax-table)
  (modify-syntax-entry ?< "." gri-mode-syntax-table)
  (modify-syntax-entry ?> "." gri-mode-syntax-table)
  (modify-syntax-entry ?& "." gri-mode-syntax-table)
  (modify-syntax-entry ?| "." gri-mode-syntax-table))

;; Abbrev Table
(defvar gri-mode-abbrev-table nil
  "Abbrev table used in gri-mode buffers.")

(define-abbrev-table 'gri-mode-abbrev-table ())

;; Mode Map
(defvar gri-mode-map ()
  "Keymap used in gri-mode.")

(if gri-mode-map
    ()
  (setq gri-mode-map (make-sparse-keymap))
  (define-key gri-mode-map "\r" 'gri-return)
  (define-key gri-mode-map "\M-\C-v" 'gri-indent-buffer)
  (define-key gri-mode-map "\M-\C-\\" 'gri-indent-region)
  (define-key gri-mode-map "\M-q" 'gri-indent-region)
  (define-key gri-mode-map "\t" 'gri-indent-line)
  (define-key gri-mode-map "\M-;" 'gri-comment)
  (define-key gri-mode-map "\C-c\C-f" 'gri-function-skeleton)
  (define-key gri-mode-map [?\C-\S-l] 'gri-fontify-buffer)
  (define-key gri-mode-map "\M-\r" 'newline)
  (define-key gri-mode-map "\C-c]" 'gri-close-statement)
  (define-key gri-mode-map "\C-c\M-h" 'gri-hide-function)
  (define-key gri-mode-map "\C-c\M-H" 'gri-hide-all)
  (define-key gri-mode-map "\C-c\M-s" 'gri-show-function)
  (define-key gri-mode-map "\C-c\M-S" 'gri-show-all)
  (define-key gri-mode-map "\C-c\M-n" 'gri-narrow-to-function)
  (define-key gri-mode-map "\C-c\C-x" 'gri-insert-file-as-comment)
  (define-key gri-mode-map "\C-c\C-v" 'gri-view)
  (define-key gri-mode-map "\C-c\C-r" 'gri-run)
  (define-key gri-mode-map "\C-c\C-p" 'gri-print)
  (define-key gri-mode-map "\C-c\M-v" 'gri-set-version)
  (define-key gri-mode-map "\C-c\C-a" 'gri-help-apropos)
  (define-key gri-mode-map "\C-c\C-n" 'gri-next-option)
  (define-key gri-mode-map "\C-c\C-k" 'gri-kill-option)
  (define-key gri-mode-map "\C-c\C-o" 'gri-option-select)
  (define-key gri-mode-map "\C-c\C-d" 'gri-display-syntax)
  (define-key gri-mode-map "\C-c\C-w" 'gri-WWW-manual)
  (define-key gri-mode-map "\C-c\C-i" 'gri-info-this-command)
  (define-key gri-mode-map "\C-c\C-h" 'gri-help-this-command)
  (define-key gri-mode-map "\C-c\M-i" 'gri-info)
  (define-key gri-mode-map "\C-c\M-h" 'gri-help)
  (define-key gri-mode-map "\C-c#"    'gri-comment-out-region)
  (define-key gri-mode-map "\C-u\C-c#" 'gri-uncomment-out-region)
  (define-key gri-mode-map "\M-\t"    'gri-complete)
  (define-key gri-mode-map "\C-c?"    'describe-mode)
  (cond 
   ((string-match "XEmacs\\|Lucid" emacs-version)
    (define-key gri-mode-map [(shift button1)] 'gri-option-select-mouse)
    (define-key gri-mode-map [(shift button2)] 'gri-kill-option-mouse))
   (window-system
    ;; Note [S-down-mouse-1] because of emacs-19.30 !!!
    ;; It has a font-selection function there, so [S-mouse-1] won't work.
    (define-key gri-mode-map [S-down-mouse-1] 'gri-option-select-mouse)
    (define-key gri-mode-map [S-mouse-2] 'gri-kill-option-mouse))))

;;; Menus - in emacs 19 only...

;;; From XEmacs-19.14 NEWS:
;;; Here is an example of a menubar definition:
;;; 
;;; (defvar default-menubar
;;;   '(("File"     ["Open File..."         find-file               t]
;;; 		    ["Save Buffer"          save-buffer             t]
;;; 		    ["Save Buffer As..."    write-file              t]
;;; 		    ["Revert Buffer"        revert-buffer           t]
;;; 		    "-----"
;;; 		    ["Print Buffer"         lpr-buffer              t]
;;; 		    "-----"
;;; 		    ["Delete Frame"         delete-frame            t]
;;; 		    ["Kill Buffer..."       kill-buffer             t]
;;; 		    ["Exit Emacs"           save-buffers-kill-emacs t]
;;; 		    )
;;; 	("Edit"     ["Undo"                 advertised-undo         t]
;;; 		    ["Cut"                  kill-primary-selection  t]
;;; 		    ["Copy"                 copy-primary-selection  t]
;;; 		    ["Paste"                yank-clipboard-selection t]
;;; 		    ["Clear"                delete-primary-selection t]
;;; 		    )
;;; 	...))

(let ((topics '(("while" "(gri)While")
                ("if" "(gri)If Statements")
                ("localSynonyms" "(gri)Local Synonyms")
                ("synonyms" "(gri)About Synonyms")
                ("builtInVariables" "(gri)Built-in Variables")
                ("variables" "(gri)About Variables")
                ("rpn" "(gri)rpn Mathematics")
                ("columns" "(gri)Manipulation of Columns etc")
                ("conceptIndex" "(gri)Concept Index")
                ("history" "(gri)History"))))
  (while topics
    (let* ((topic (car topics))
	   value menu name)
      (setq topics (cdr topics))
      (setq value (nth 0 topic)
            menu (nth 1 topic))
      (setq name (intern (concat "gri-info-" value)))
      (fset name (list 'lambda () 
                       (list 'interactive)
                       (list 'require ''info)
                       (list 'Info-goto-node menu))))
;; In latex.el, Per even builds the menu at this stage!
    ))

(cond 
 ((fboundp 'easy-menu-define)
  (easy-menu-define
   gri-mode-menu4 gri-mode-map "Menu keymap for gri-mode."
   '("Gri-Help"
     ["Help about current command"          gri-help-this-command t]
     ["Help about any command"              gri-help t]
     ["Info about current command"          gri-info-this-command t]
     ["Info about any command"              gri-info t]
     ("InfoTopics"
;;; Old way!
;;;	["While Statements" (lambda () 
;;;			      (interactive)(require 'info)
;;;			      (Info-goto-node "(gri)While")) t]
      ["Concept Index"                      gri-info-conceptIndex t]
      ["Manipulating Columns"               gri-info-columns t]
      ["Reverse Polish Math (rpn stuff)"    gri-info-rpn t]
      ["About Variables"                    gri-info-variables t]
      ["Built-in Variables"                 gri-info-builtInVariables t]
      ["About Synonyms"                     gri-info-synonyms t]
      ["Local Synonyms"                     gri-info-localSynonyms t]
      ["If Statements"                      gri-info-if t]
      ["While Statements"                   gri-info-while t]
      ["History"                            gri-info-history t]
      )
     ["Gri Manual on WWW"                   gri-WWW-manual t]
     ["Display syntax for current command"  gri-display-syntax t]
     ["List gri commands containing string" gri-help-apropos t]
;;   ["Customize Gri" (list 'lambda () (interactive)(customize-group "gri")) t]
     ["Customize Gri" (customize-group "gri") t]
     ))
  (easy-menu-define
   gri-mode-menu3 gri-mode-map "Menu keymap for gri-mode."
   '("Hide"
     ["Hide this gri function"        gri-hide-function t]
     ["Hide all gri functions"        gri-hide-all t]
     ["Show this gri function"        gri-show-function t]
     ["Show all gri functions"        gri-show-all t]
     ["Restrict editing to function"  gri-narrow-to-function t]
     ["Remove function restriction"   widen t]
     ))
  (load "executable" t t)       ; executable-find not autoloaded in emacs20
  (easy-menu-define
   gri-mode-menu2 gri-mode-map "Menu keymap for gri-mode."
   '("Perform"
     ["Save, Run and View gri"        gri-run t]
     ("Run Settings"
      "Global run-time options"
      ["-publication" (gri-run-setting-toggle "-publication")
       :style toggle :selected (member "-publication" gri*run-settings)]
      ["-trace" (gri-run-setting-toggle "-trace")
       :style toggle :selected (member "-trace" gri*run-settings)]
      ["-nowarn_offpage" (gri-run-setting-toggle "-nowarn_offpage")
       :style toggle :selected (member "-nowarn_offpage" gri*run-settings)]
      ["-debug" (gri-run-setting-toggle "-debug")
       :style toggle :selected (member "-debug" gri*run-settings)]
      ["-no_bounding_box" (gri-run-setting-toggle "-no_bounding_box")
       :style toggle :selected (member "-no_bounding_box" gri*run-settings)]
;; -superuser ?
      ["Display graph after compilation" 
       (setq gri*view-after-run (not gri*view-after-run))
       :style toggle :selected gri*view-after-run]
      ["Set gri version to use"        gri-set-version t]
      "Local run-time options"      
      ["Set gri version for this file" gri-set-local-version t]
      ["set filename arguments" (gri-menu-set-command-postarguments)
       :visible (not gri-command-postarguments)]
      ["clear filename arguments" (gri-unset-command-postarguments)
       :visible gri-command-postarguments]
      )
     ["View existing PostScript"      gri-view  t]
     ("Postscript viewer"
      ["gv" (setq gri*view-command 'gv)
       :style radio :selected (equal gri*view-command 'gv)
       :active (and (fboundp 'executable-find)(executable-find "gv"))]
      ["gv (old version)" (setq gri*view-command 'gv-old)
       :style radio :selected (equal gri*view-command 'gv-old)
       :active (and (fboundp 'executable-find)(executable-find "gv"))]
      ["ggv" (setq gri*view-command 'ggv)
       :style radio :selected (equal gri*view-command 'ggv)
       :active (and (fboundp 'executable-find)(executable-find "ggv"))]
      ["gnome-gv" (setq gri*view-command 'gnome-gv)
       :style radio :selected (equal gri*view-command 'gnome-gv)
       :active (and (fboundp 'executable-find)(executable-find "gnome-gv"))]
      ["ghostview" (setq gri*view-command 'ghostview)
       :style radio :selected (equal gri*view-command 'ghostview)
       :active (and (fboundp 'executable-find)(executable-find "ghostview"))]
      ["kghostview" (setq gri*view-command 'kghostview)
       :style radio :selected (equal gri*view-command 'kghostview)
       :active (and (fboundp 'executable-find)(executable-find "kghostview"))]
      )
     ("gv settings"
      "Run-Time Options"
      ["-watch" (if gri*view-watch 
                    (setq gri*view-watch nil)
                  (setq gri*view-watch t))
       :style toggle :selected gri*view-watch]
      ["-noantialias" (if gri*view-noantialias
                          (setq gri*view-noantialias nil)
                        (setq gri*view-noantialias t))
       :style toggle :selected gri*view-noantialias]
      "Scale Selection"
      ["0.1" 
;;FIXME: simply this code!
;;Try  (setq gri*view-scale -5)
       (list 'lambda () (interactive)(setq gri*view-scale -5))
       :style radio :selected (equal gri*view-scale -5)]
      ["0.125" 
       (list 'lambda () (interactive)(setq gri*view-scale -4))
       :style radio :selected (equal gri*view-scale -4)]
      ["0.25" 
       (list 'lambda () (interactive)(setq gri*view-scale -3))
       :style radio :selected (equal gri*view-scale -3)]
      ["0.5" 
       (list 'lambda () (interactive)(setq gri*view-scale -2))
       :style radio :selected (equal gri*view-scale -2)]
      ["0.707" 
       (list 'lambda () (interactive)(setq gri*view-scale -1))
       :style radio :selected (equal gri*view-scale -1)]
      ["1" 
       (list 'lambda () (interactive)(setq gri*view-scale 0))
       :style radio :selected (equal gri*view-scale 0)]
      ["1.414" 
       (list 'lambda () (interactive)(setq gri*view-scale 1))
       :style radio :selected (equal gri*view-scale 1)]
      ["2" 
       (list 'lambda () (interactive)(setq gri*view-scale 2))
       :style radio :selected (equal gri*view-scale 2)]
      ["4" 
       (list 'lambda () (interactive)(setq gri*view-scale 3))
       :style radio :selected (equal gri*view-scale 3)]
      ["8" 
       (list 'lambda () (interactive)(setq gri*view-scale 4))
       :style radio :selected (equal gri*view-scale 4)]
      ["10" 
       (list 'lambda () (interactive)(setq gri*view-scale 5))
       :style radio :selected (equal gri*view-scale 5)])
     ["Print existing PostScript"     gri-print t]
     ))
  (easy-menu-define
   gri-mode-menu1 gri-mode-map "Menu keymap for gri-mode."
   '("Format" 
     ["Complete gri command"          gri-complete t]
     ["Select option under point"     gri-option-select t]
     ["Kill option under point"       gri-kill-option t]
     ["Add Comment to current line"   gri-comment t]
     ["Insert file head as a comment" gri-insert-file-as-comment t]
     ["Indent current line"           gri-indent-line t]
     ["Indent selected region"        gri-indent-region t]
     ["Indent entire buffer"          gri-indent-buffer t]
     ["Comment-out region"            gri-comment-out-region t]
     ["Uncomment-out region"          gri-uncomment-out-region t]
     ["Create function skeleton"      gri-function-skeleton t]
     ["Fontify buffer"                gri-fontify-buffer t]
     ))))


(defun gri-run-setting-toggle (item)
  "If ITEM is selected, unselect it.  Else select it."
  (interactive "P")
  (if (not (member item gri*run-settings))
      (setq gri*run-settings (cons item gri*run-settings))
    (let ((work-list gri*run-settings)
          (new-list))
      (while work-list
        (let ((entry (car work-list)))
          (if (not (equal item entry))
              (setq new-list (cons entry new-list))))
        (setq work-list (cdr work-list)))
      (setq gri*run-settings new-list))))

(defun gri-run-setting-string ()
  "Return a string of gri*run-settings elements"
  (if (not gri*run-settings)
      ""
    (let ((work-list gri*run-settings)
          (new-list))
      (while work-list
        (let ((entry (car work-list)))
          (setq new-list (concat entry " " new-list)))
        (setq work-list (cdr work-list)))
      new-list)))

;;;----------------------------------------------------------------
;;; Automatic generation of a menubar menu listing all Gri commands.
;;;  (gri-easy-menu-build) to regenerate it.

(defun gri-menubar-cmds-action (command)
  (interactive)
  (cond
   ((equal gri-menubar-cmds-action 'Info)
    (gri-info command))
   ((equal gri-menubar-cmds-action 'Help)
    (gri-help command))
   ((equal gri-menubar-cmds-action 'Insert)
    (let ((string))
      (save-excursion
        (cond
         ;;; This is in here for possible future use, but I'm not
         ;;; adding code fragments to the command list for now.
         ((string-equal "?" (substring command 0 1))
          (gri-lookat-syntax-file 0)
          (re-search-forward (concat "^" command "\\(;\\|(\\)") nil t)
          (forward-line 1)
          (setq string 
                (buffer-substring (point)
                                  (progn (re-search-forward "^[^ \t]" nil t)
                                         (backward-char 1)(point)))))
         (t
          (gri-lookat-syntax-file 1)
          (re-search-forward (concat "^" command "\\(;\\|(\\)") nil t)

          ;; Skip over default description
          (forward-char -1)
          (if (looking-at "(")
              (re-search-forward ");" nil t)
            (forward-char 1))

          (setq string (buffer-substring (point)
                                         (progn (end-of-line)(point)))))))
      (insert string)))))

(defun gri-menubar-cmds-build ()
  "Creates a buffer from ~/.gri-syntax to evaluate and define a menu map"
  (save-excursion
    (gri-lookat-syntax-file 3)
    ;; Get list of known commands
    (let ((syntax-entries (buffer-substring (point)(point-max)))
          (gri-tmp-buffer (get-buffer-create "*gri-tmp-buffer*")))
      (set-buffer gri-tmp-buffer)
      (insert syntax-entries)
      (delete-backward-char 1)
      (goto-char (point-min))
      ;; Strip out syntax defs
      (while (re-search-forward "\\(;\\|(\\)" nil t)
        (forward-char -1)
        (delete-region (point) (progn (end-of-line)(point))))
      ;;Transform every command into a line like:
      ;; ["cd" (list (gri-menubar-cmds-action "cd")) t]
      (goto-char (point-min))(insert "\n")(goto-char (point-min))
      (while (= 0 (forward-line 1))
        (let ((command (buffer-substring (point)(progn (end-of-line)(point)))))
          (beginning-of-line)
          (insert "[\"")
          (end-of-line)
          (insert "\" (list (gri-menubar-cmds-action \"" command "\")) t]")))
      ;; insert proper bracing to block out submenus
      (gri-easy-menu-keyword-split)
      ;; Split the generated easymenu entries dedending on frame height
      (gri-easy-menu-size-split)
      ;; insert easy-menu-define preamble
      (goto-char (point-min))
      (insert "(easy-menu-define
 gri-commands-menu gri-mode-map \"Commands for Gri.\"
   '(\"Cmds\"
      [\"Display Info\" 
       (list (setq gri-menubar-cmds-action 'Info))
       :style radio :selected (equal gri-menubar-cmds-action 'Info)]
      [\"Display Help\" 
       (list (setq gri-menubar-cmds-action 'Help))
       :style radio :selected (equal gri-menubar-cmds-action 'Help)]
      [\"Insert commands\" 
       (list (setq gri-menubar-cmds-action 'Insert))
       :style radio :selected (equal gri-menubar-cmds-action 'Insert)]
      \"-\"")
      ;; insert closing braces
      (goto-char (point-max))
      (insert "))")
      (eval-buffer nil nil)
      (kill-buffer gri-tmp-buffer))))

;;; Functions to split the easymenu into smaller segments.
;;; As it turns out, this was _more_ work than the rest combined!

(defvar gri-cmds-submenu-keywords
  '("convert" "create" "draw" "draw curve" "draw image" "draw label"
    "draw line" "draw symbol" "filter" "new" "read" "read image" "resize" 
    "set" "set contour" "set font" "set image" "set line" "set x" 
    "set y" "show" "write")
  "List of Gri command keywords used to fraction menu into submenus")

(defun gri-easy-menu-keyword-split ()
  "Insert proper bracing to block out submenus using gri-cmds-submenu-keywords"
  (let ((case-fold-search)
        (entry-list gri-cmds-submenu-keywords)
        (entry))
    (while entry-list
      (goto-char (point-min))
      (setq entry (car entry-list))
      (search-forward (concat "[\"" entry) nil t)
      (beginning-of-line)
      (insert "(\"" entry "\"\n")
      (goto-char (point-max))
      (search-backward (concat "[\"" entry) nil t)
      (end-of-line)
      (insert "\n)")
      (setq entry-list (cdr entry-list)))))

(defun gri-easy-menu-size-split ()
  "Split the generated easymenu entries dedending on frame height"
  (goto-char (point-min))
  (re-search-forward "^\\[" nil t)
  (beginning-of-line)
  (let* ((menu-count (gri-easy-menu-count-entries))
         (frame-lines (cond ((< 60 (frame-height)) ;Big frames
                             (- (frame-height) 17))
                            ((< 40 (frame-height)) ;Med frames
                             (- (frame-height) 10))
                            (t
                             (- (frame-height) 6)))) ;Smaller frames
         (split-number)
         (split-count))
    (if (>= frame-lines menu-count)
        nil                    ; No split at all
      ;; Figure out in many pieces we want the menu to be
      (setq split-number (/ menu-count frame-lines))
      (if (not (= 0 (% menu-count frame-lines)))
          (setq split-number (1+ split-number)))
      ;; Figure out many entries in each
      (setq split-count (/ menu-count split-number))
      (if (not (= 0 (% menu-count split-number)))
          (setq split-count (1+ split-count)))
;;    (message "Menu lines: %d   Frame lines: %d   Split: %d   Each: %d" 
;;             menu-count frame-lines split-number split-count)
      ;; Do the actual splitting
      (goto-char (point-min))
      (re-search-forward "^\\[" nil t)
      (beginning-of-line)
      (while (gri-easy-menu-split-here split-count)))))

(defun gri-easy-menu-split-here (size)
  "Do an actual split at this point in the menu"
  (let ((title (format "\"%s - %s ...\""
                       (gri-easy-menu-commandname-at 0)
                       (gri-easy-menu-commandname-at size)))
        (status))
    (beginning-of-line)
    (insert "(" title "\n")
    (setq status (gri-forward-sexp size))
    (insert ")")
    (if (not status)
        nil
      (forward-line 1)
      t)))
                     
(defun gri-easy-menu-commandname-at (count)
  "Return name of Gri command COUNT-1 lines down"
  (save-excursion
    (beginning-of-line)
    (if (not (= 0 count))
        (progn
          (gri-forward-sexp count)
          (forward-sexp -1)))
    (forward-char 2)
    (buffer-substring 
     (point) 
     (progn (search-forward "\"" nil t)(forward-char -1)(point)))))

(defun gri-easy-menu-count-entries ()
  "Return the number of easymenu sexps from point to end of buffer."
  (let ((count 1))
    (while (gri-forward-sexp 1)
      (setq count (1+ count)))
    count))

(defun gri-forward-sexp (count)
  "Advance by ARG sexp, and returns nil if error occurs or at EOF, t otherwise.
By error, I mean un improperly balanced sexp."
  (when (condition-case nil
                (goto-char (or (scan-sexps (point) count) (point-max)))
              (error))
    (if (= (point)(point-max))
        nil
      t)))

;;; End of easymenu commands generation.
;;;-------------------------------------

;;;-------------
;;; imenu stuff

;; (Comments from gre-mode)
;; Instead of setting the variable imenu-create-index-function to
;; imenu--create-gri-index, I could set the following REGEXP variable:
;; 
;;  (setq imenu-generic-expression
;;        '((nil "^cmd \\([^(]+\\)" 1)
;;          ("Variables" "^\\($[a-zA-Z_]+\\) [+-/*]?=" 1)))
;; 
;; and make a simple `imenu-prev-index-position-function' to move backwards
;; to these regexps.  (See gri-imenu-prev-index-position-function below).

(if (fboundp 'imenu)			;Make sure it's auto-loaded
    (eval-when-compile 
      (require 'imenu)))

(if (and (= emacs-major-version 20)
         (<= emacs-minor-version 2))
    (defun imenu-add-to-menubar (name)
      "Adds an `imenu' entry to the menu bar for the current buffer.
NAME is a string used to name the menu bar item.
See the command `imenu' for more information."
      (interactive "sImenu menu item name: ")
      (if (or (and (equal imenu-create-index-function 
                          'imenu-default-create-index-function)
                   imenu-generic-expression)
              (fboundp imenu-create-index-function))
          (let ((newmap (make-sparse-keymap))
                (menu-bar (lookup-key (current-local-map) [menu-bar])))
            (define-key newmap [menu-bar]
              (append (make-sparse-keymap) menu-bar))
            (define-key newmap [menu-bar index]
              (cons name (nconc (make-sparse-keymap "Imenu")
                                (make-sparse-keymap))))
            (use-local-map (append newmap (current-local-map)))
            (add-hook 'menu-bar-update-hook 'imenu-update-menubar))
        (error "The mode `%s' does not support Imenu" mode-name))))

(defun gri-imenu-prev-index-position-function ()
  (re-search-backward 
   "\\(^`\\(.*\\)'$\\)\\|\\(^[ \t]*\\(\\\\[a-zA-Z0-9_]+\\)\\|\\(\\.\\.?[a-zA-Z0-9_]\\.\\.?\\) *=\\)"
   nil t))

(defvar gri-imenu-counter nil "gri-mode internal variable for imenu support")

(defun imenu--create-gri-index ()
    (save-match-data
      (save-excursion
        (let ((index-alist '())
              (index-var-alist '())
              (index-syn-alist '())
              (prev-pos)
              (imenu-scanning-message 
               "Scanning gri functions, variables and synonyms (%3d%%)"))
          (setq gri-imenu-counter -99) ;IDs menu entries starting at -100
          (goto-char (point-max))
          (imenu-progress-message prev-pos 0 t)
          (while (gri-imenu-prev-index-position-function)
            (imenu-progress-message prev-pos nil t)
            (let ((marker (make-marker)))
              (set-marker marker (point))
              (cond
               ((match-beginning 2)     ;function
                (push (cons (match-string-no-properties 2) marker)
                      index-alist))
               ((match-beginning 4)     ;synonym
                (push (cons (match-string-no-properties 4) marker)
                      index-syn-alist))
               (t                       ;variable
                (push (cons (match-string-no-properties 5) marker)
                      index-var-alist)))))
          (imenu-progress-message prev-pos 100 t)
          (cond
           ((and index-var-alist
                 (elt index-var-alist 5))
            (push (cons "Variables"
           ;;Or this:   (sort index-var-alist 'gri-imenu-label-cmp))
                        index-var-alist) 
                  index-alist))
           (index-var-alist
            (setq index-alist (append index-var-alist index-alist))))
          (cond
           ((and index-syn-alist
                 (elt index-syn-alist 5))
            (push (cons "Synonyms"
                        index-syn-alist) 
                  index-alist))
           (index-syn-alist
            (setq index-alist (append index-syn-alist index-alist))))
          index-alist))))

(defun gri-imenu-label-cmp (el1 el2)
  "Predicate to compare labels in lists."
  (string< (car el1) (car el2)))

;;; end of imenu stuff
;;;-------------

;;(defvar gri::toolbar-run-icon
;;  (if (featurep 'toolbar)
;;      (toolbar-make-button-list "/home/rhogee/gri.xpm" "Run Gri")))

;; XEmacs toolbar
(cond 
 ((featurep 'toolbar)
  (defvar gri::toolbar-run-icon
    (toolbar-make-button-list
     "/* XPM */
static char *magick[] = {
/* columns rows colors chars-per-pixel */
\"32 32 4 1\",
\"  c #f9fbff\",
\". c #d6dae4\",
\"X c #97999e\",
\"o c #343434\",
/* pixels */
\"                                \",
\"                                \",
\"                                \",
\"   Xooooooooooooooooooooooooo.  \",
\"    XX......................XX  \",
\"    XX......................XX  \",
\"    XX......................XX  \",
\"    XX......................XX  \",
\"    XX......................XX  \",
\"   XoX......................XX  \",
\"    oX......................XX  \",
\"    XX......................XX  \",
\"    XX......................XX  \",
\"    XX.....ooooX........o...XX  \",
\"   .oX .X X . oo........oX..XX  \",
\"   .oX..o......o........X...XX  \",
\"    XX.o....................XX  \",
\"    XX.o....................XX  \",
\"    XXXo.........XXX..X.XX..XX  \",
\"    XXXo.........XXo..oXoo..XX  \",
\"   .oX.o.....X.....o.....o..XX  \",
\"   .oXXo.....ooo...o....Xo..XX  \",
\"    XX.oX.....Xo...o....Xo..XX  \",
\"    XX.Xo.... Xo...o....Xo..XX  \",
\"    XX..oooXXXXX..XXXX..XXX.XX  \",
\"    XX....XXXXXX..XXXX..XX..XX  \",
\"   .ooXXXXXXXXXXXXXXXXXXXXXXoX  \",
\"   .ooXXXXoXXXXXoXXXXXooXXXXoX  \",
\"                                \",
\"                                \",
\"                                \",
\"                                \"
};")
    "Run Gri")

  (defvar gri-mode-toolbar 
    (append 
     initial-toolbar-spec 
     '([gri::toolbar-run-icon gri-run t "Run Gri"]))
     "XEmacs toolbar for gri")))

;; Emacs-21 tool-bar
(cond 
 ((featurep 'tool-bar)

  (defun gri-mode-toolbar-make-button (image)
    "From idlw-toolbar.el"
    (list 'image :type 'xpm :data image))

  (defvar gri::toolbar-run-icon
    (gri-mode-toolbar-make-button
"/* XPM */
static char * gri24x24_xpm[] = {
/* columns rows colors chars-per-pixel */
\"24 24 5 1\",
\" 	c None\",
\".	c black\",
\"X	c white\",
\"o	c grey90\",
\"O	c #010101\",
/* pixels */
\" .      .      .      . \",
\" ...................... \",
\"..XXXX..XXXXXXXXXXXXXX..\",
\" .XXXX..XXXXXXXXXXXXXX. \",
\" .XXX.oo.XXXXXXXXXXXXX. \",
\" .XX.oooo.XXXXXXX..XXX. \",
\" .X.oooooo.XXXXXX..XXX. \",
\" ...oooooo.XXXX..oo.XX. \",
\" ...ooooooo.XX.ooooo... \",
\" .oooooooooo..oooooo... \",
\" .oooooooooo..oooooooo. \",
\" .oooooooooooooooooooo. \",
\"..oooooooooooooooooooo..\",
\" .ooooO...Oooooooooooo. \",
\" .oooO.ooo.ooooooo.ooo. \",
\" .oooOoooooooooooooooo. \",
\" .ooOOooooooooO.ooOooo. \",
\" .ooO.ooo.O.o.OoooOooo. \",
\" .oooOoooo.oooOoooOooo. \",
\" .oooO.oooOoooOoooOooo. \",
\" .ooooO...OoooOoooOooo. \",
\" .oooooooooooooooooooo. \",
\"........................\",
\" .      .      .      . \"
};")
  "The run gri icon.")

  (defvar gri::toolbar-view-icon
    (gri-mode-toolbar-make-button
"/* XPM */
static char * gri_gv24x24_xpm[] = {
/* columns rows colors chars-per-pixel */
\"24 24 4 1\",
\" 	c None\",
\".	c black\",
\"X	c white\",
\"o	c grey90\",
/* pixels */
\" .      .      .      . \",
\" ...................... \",
\"..XXXX..XXXXXXXXXXXXXX..\",
\" .XXXX..XXXXXXXXXXXXXX. \",
\" .XXX.oo.XXXXXXXXXXXXX. \",
\" .XX.oooo.XXXXXXX..XXX. \",
\" .X.oooooo.XXXXXX..XXX. \",
\" ...oooooo.XXXX..oo.XX. \",
\" ...ooooooo.XX.ooooo... \",
\" .oooooooooo..oooooo... \",
\" .oooooooooo..oooooooo. \",
\" .oooooooooooooooooooo. \",
\"..oooooooooooooooooooo..\",
\" .oooooooooooooooooooo. \",
\" .oooooooooooooooooooo. \",
\" .oooooooooooooooooooo. \",
\" .oooooo..oo.ooo.ooooo. \",
\" .ooooo.oo.o.ooo.ooooo. \",
\" .ooooo.oo.oo.o.oooooo. \",
\" .oooooo...oo...oooooo. \",
\" .oooooooo.ooo.ooooooo. \",
\" .ooooo.oo.ooooooooooo. \",
\"........oo..............\",
\" .      ..     .      . \"
};")
  "The gri view icon.")

  (defvar gri::toolbar-info-icon
    (gri-mode-toolbar-make-button
"/* XPM */
static char * gri_info24x24_xpm[] = {
/* columns rows colors chars-per-pixel */
\"24 24 5 1\",
\" 	c None\",
\".	c black\",
\"X	c white\",
\"o	c grey90\",
\"O	c #010101\",
/* pixels */
\" .      .      .      . \",
\" ...................... \",
\"..XXXX..XXXXXXXXXXXXXX..\",
\" .XXXX..XXXXXXXXXXXXXX. \",
\" .XXX.oo.XXXXXXXXXXXXX. \",
\" .XX.oooo.XXXXXXX..XXX. \",
\" .X.oooooo.XXXXXX..XXX. \",
\" ...oooooo.XXXX..oo.XX. \",
\" ...ooooooo.XX.ooooo... \",
\" .oooooooooo..oooooo... \",
\" .oooooooooo..oooooooo. \",
\" .oooooooooooooooooooo. \",
\"..oooooooooooooooooooo..\",
\" .ooo.oooooo...ooooooo. \",
\" .ooo.oooooo.ooooooooo. \",
\" .oooooooooo.ooooooooo. \",
\" .ooo.o.oooo..oooooooo. \",
\" .ooo.o.OO.o.oo....ooo. \",
\" .ooo.o.oo.o.oo.oo.ooo. \",
\" .ooo.o.oo.o.oo.oo.ooo. \",
\" .ooo.o.oo.o.oo....ooo. \",
\" .oooooooooooooooooooo. \",
\"........................\",
\" .      .      .      . \"
};")
  "The gri Info icon.")

;;  (define-key global-map [tool-bar gri-run]
;;    '(menu-item "Run Gri" gri-run
;;                :image gri::toolbar-run-icon))))
 
  (defvar gri::toolbar
    '([gri::toolbar-run-icon gri-run t "Run gri on this file"]
      [gri::toolbar-view-icon gri-view t "View PostScript file"]
      [gri::toolbar-info-icon gri-info-this-command t 
                              "Lookup Info about command under cursor"]))

  (mapcar (lambda (x)            
            (let* ((icon (aref x 0))
                   (func (aref x 1))
                   ;;(show (aref x 2))
                   (help (aref x 3))
                   (key (vector 'tool-bar func))
                   (def (list 'menu-item
                              "a"
                              func
                              :image (symbol-value icon)
                              :help help)))
              (define-key gri-mode-map key def)))
          (reverse gri::toolbar))
  ))

;; Gri Mode
(defun gri-mode ()
  "Major mode for editing and running Gri files. 
V2.68 (c) 01 March 2005 --  Peter Galbraith <psg@debian.org>
COMMANDS AND DEFAULT KEY BINDINGS:
   gri-mode                           Enter Gri major mode.
 Running Gri; viewing output:
   gri-run               C-c C-r      Run gri on this file, and view result.
   gri-view              C-c C-v      Run ghostview on the existing .ps file.
   gri-print             C-c C-p      Print gri .ps file.
 To insert and edit full syntax:
   gri-complete          M-Tab        Complete abbreviated gri command.
   gri-next-option       C-c C-n      Goto to next option, string or variable.
   gri-kill-option       C-c C-k      Deletes gri syntax within brackets.
   gri-option-select     C-c C-o      Selects gri optional syntax.
   gri-close-statement   C-c ]        Closes a gri statement (if, while, open)
 To obtain help or find commands:
   gri-help-apropos      C-c C-a      Display commands containing keyword.
   gri-display-syntax    C-c C-d      Display syntax for command on point.
   gri-help-this-command C-c C-h      Help about user/system command on point.
   gri-help              C-c M-h      Help about prompted-for command.
   gri-info-this-command C-c C-i      Info about system command on point.
   gri-info              C-c M-i      Info about prompted-for command.
   gri-WWW-manual        C-c C-w      World Wide Web gri manual.
   gri-set-version       C-c M-v      Displays version numbers of databases.
   describe-mode         C-c ?        Displays help about gri mode.
 Indenting/formatting gri code:
   gri-function-skeleton C-c C-f      Add skeleton for a new function. 
   gri-narrow-to-function 
                         C-c M-n      Narrow editing region to function.
                        (C-x n w      Widens editing region back to normal)
   gri-comment           M-;          Add comment to current line.
   gri-insert-file-as-comment 
                         C-c C-x      Insert filename under point as a comment.
   gri-indent-line       Tab          Indent line for structure.
   gri-indent-region     M-q          Indent all lines between point and mark.
   gri-indent-buffer     M-C-v        Indent all lines in buffer.
   gri-comment-out-region C-c#        To avoid running a block of code.
   gri-uncomment-out-region C-uC-c#   To undo comments.
   gri-return            RET          Handle return with indenting.
 To use multiple versions of Gri installed on the system
   gri-set-local-version              Set version of gri for this file only.
   gri-unset-local-version            Unset and use default value instead.
   gri-set-version                    Change version of gri used in gri-mode.
 To convert comment styles
   gri-convert-comments               Convert Gri // and /* */ comments to #
   gri-convert-comments-with-prompt   A function to put in a gri-mode-hook.
 To use outline-minor-mode to hide gri functions:
   gri-hide-function     C-c M-h      Hides the gri function under point.
   gri-hide-all          C-c M-H      Hides all gri functions in buffer.
                   ESC 1 C-c M-h       (ESC 1 prefixes a true argument)
   gri-show-function     C-c M-s      Shows the gri function on current line.
   gri-show-all          C-c M-S      Shows all gri functions in buffer.
                   ESC 1 C-c M-s       
 Misc debugging commands:
   gri-command-arguments              Tell gri-run about extra arguments to use
--

VARIABLES:
  gri*directory-tree                New path to gri installation with versions.
  gri*view-after-run                t or nil, view ps file after gri-run if t.
  gri*view-command                  String for shell command used by gri-view.
  gri*view-landscape-arg            String for landscape argument in gri-view. 
  gri*lpr-command                   Command used to print PostScript files.
  gri*lpr-switches                  print command switches to use
  gri*use-imenu                     Use imenu package?
  gri*WWW-program                   String for local WWW browser program.
  gri*WWW-page                      Page to use by browser
  fill-column                       Column used in auto-fill (default=70).
  gri-comment-column                Goal column for on-line comments.
  gri-indent-before-return          If true, indent current line on <CR>
  gri-indent-level                  Level to indent blocks.
  gri-new-command-help-indent-level Level to indent help in new commands.

ACCESSING:  
To add automatic support put something like the following in your .emacs file:
  (autoload 'gri-mode \"gri-mode\" \"Enter Gri-mode.\" t)
  (setq auto-mode-alist (cons '(\"\\\\.gri$\" . gri-mode) auto-mode-alist))
If gri is installed in a non-standard place, then you'll need something like:
  (setq gri*directory-tree \"/home/opt/gri/\") ;Path to our gri installation
 See C-h v gri*directory-tree to find out more.
 
And optionally, customize the mode in your .emacs file:
  (setq gri*lpr-switches \"-P laser\")    ; Select a printer
  (setq gri*view-command \"ghostview -magstep -1\") ;for small screens
  (setq gri*view-after-run nil)         ;Don't call gri-view after gri-run.
  (setq gri*WWW-program \"xmosaic\")      ;Our local WWW browser program
  (setq gri-indent-before-return t)     ;Indent current line on <CR>
  (setq gri-mode-hook                   ;Hook gets invoked after gri-mode
       '(lambda () 
          (gri-hide-all t)              ;Hide gri functions on C-x C-f file.gri
          (setq fill-column 74)))       ;Set fill column for gri buffers

SEE ALSO: help about gri-complete (C-h f gri-complete)

KNOWN BUGS:
   gri-help-this-command
     Can't find help on hidden user commands.
   gri-complete
     *completions* buffer lies: you can't use the mouse to make a selection.
      Completions relies on entire line, not just up to the editing point.
   gri-show-all, gri-hide-all
      May get confused if you have a string which looks like a function
      title in your function's help text (i.e. a line which begins with
      a ` character and ends with a ' character.

PLANNED ADDITIONS:
   Fix bugs!
   Make gri-complete able to complete to options.
   Add mouse support to make selection in *completions* buffer.
   Add mouse support to select and kill options."
  (interactive)
  (kill-all-local-variables)
  (use-local-map gri-mode-map)
  (setq major-mode 'gri-mode)
  (setq mode-name "gri")
  (set-syntax-table gri-mode-syntax-table)

  ;; Paragraph definitions
  (make-local-variable 'paragraph-start)
  (setq paragraph-start (concat "^$\\|" page-delimiter))
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)
  (make-local-variable 'paragraph-ignore-fill-prefix)
  (setq paragraph-ignore-fill-prefix t)

  ;; Indentation
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'gri-indent-line)

  ;; Comments
  (make-local-variable 'comment-start-skip)  ;Need this for font-lock...
  (setq comment-start-skip "\\(^\\|\\s-\\);?#+ *") ;;From perl-mode
  ;(setq comment-start-skip "\\(#\\) *")
  (make-local-variable 'comment-start)
  (make-local-variable 'comment-end)
  (setq comment-start "#"
        comment-end "")
  (make-local-variable 'comment-column)
  (setq comment-column 'gri-comment-column)
  (make-local-variable 'fill-column)
  (setq fill-column default-fill-column)
;;  (make-local-variable 'auto-fill-hook)
;;  (setq auto-fill-hook 
;;        '(lambda () 
;;           (insert "\\\n")))

  (cond
   (gri*use-imenu
    (require 'imenu)
    (setq imenu-create-index-function 'imenu--create-gri-index)
 ;;;Instead of setting `imenu-create-index-function', I could set (for gre):
 ;; (setq imenu-prev-index-position-function 
 ;;       'gri-imenu-prev-index-position-function)
 ;; (setq imenu-generic-expression
 ;;       '((nil "^cmd \\([^(]+\\)" 1)
 ;;        ("Variables" "^\\($[a-zA-Z_]+\\) [+-/*]?=" 1)))
    (if (or window-system
            (fboundp 'tmm-menubar))
        (imenu-add-to-menubar "Imenu"))))

  (gri-font-lock-setup)

  ;; Local version
  (make-local-variable 'gri-local-version)

  ;; Gri-mode's own completion mechanisms
  (make-local-variable 'gri-last-complete-point)
  (setq gri-last-complete-point -1)
  (make-local-variable 'gri-last-complete-command)
  (setq gri-last-complete-command "")
  (make-local-variable 'gri-last-complete-status)
  (setq gri-last-complete-status 0)

  (make-local-variable 'require-final-newline)
  (setq require-final-newline t)

  ;; Outlininng
  ;;(require 'outline)  this is not provided in emacs 18.59
  (if (not (fboundp 'hide-body))
      (load "outline" t t))
  (make-local-variable 'outline-regexp)
  (cond 
   ((> emacs-major-version 19)
    (make-local-variable 'line-move-ignore-invisible)
    (setq line-move-ignore-invisible t)
    (if (fboundp 'add-to-invisibility-spec)
        (progn
          (add-to-invisibility-spec '(hs . t)) ;;hs invisible
          (add-to-invisibility-spec '(outline . t))))
    (setq outline-regexp "^`.*'\n"))
   (t
    (setq selective-display t
          selective-display-ellipses t)
    (setq outline-regexp "^`.*'[\n\^M]")))
  (gri-show-all)                        ; show all before adding commands
  ;; Adds this buffer's local commands to gri-syntax
  (if (get-buffer "*gri-syntax*")
      (save-excursion
        (goto-char (point-min))
        (gri-add-commands-from-current-buffer nil 
                                              (get-buffer "*gri-syntax*"))))
  (and (boundp 'gri-menubar)
       gri-menubar
       (fboundp 'add-submenu)     ;Insurance for emacs
       (set-buffer-menubar (copy-sequence current-menubar))
       (add-submenu nil gri-menubar))
  (and (boundp 'gri-mode-menu1)
       gri-mode-menu1
       (fboundp 'add-submenu)     ;Insurance for emacs
       (set-buffer-menubar (copy-sequence current-menubar))
       (if (and (boundp 'gri-commands-menu) gri-commands-menu)
	   (add-submenu nil gri-commands-menu))
       (add-submenu nil gri-mode-menu1)
       (add-submenu nil gri-mode-menu2)
       (add-submenu nil gri-mode-menu3)
       (add-submenu nil gri-mode-menu4))
  (if (and (featurep 'toolbar)
	   (console-on-window-system-p))
      (set-specifier default-toolbar (cons (current-buffer) gri-mode-toolbar)))
  
  ;; FIXME: See other FIXME comments above about installing multiple menus.

  ;; Figure Out what version of gri to use, where to call it
  (hack-local-variables)
  (gri-initialize-version nil)          ;Try to set gri version without errors
  (cond
   ((and gri-idle-display-defaults
         gri-cmd-file
         (file-exists-p gri-cmd-file)
         (not gri-idle-timer))
    ;; Initiate timer
    (setq gri-idle-timer (run-with-idle-timer 2 t 'gri-idle-function)))
   ((and (not gri-idle-display-defaults)
         gri-idle-timer)
    ;; Cancel timer
    (cancel-timer gri-idle-timer)
    (setq gri-idle-timer nil)))

  (if (and (or (not (boundp 'gri-commands-menu))
               (not gri-commands-menu))
      ;; Maybe I should redo it all the time in case frame size was changed?
           (not (equal gri-cmd-file "")))
      (gri-menubar-cmds-build))
  (run-hooks 'gri-mode-hook))

(defun gri-determine-local-version ()
  (save-excursion
    (goto-char (point-max))
    (if (and (re-search-backward "\\(//\\|#\\) Local Variables:" nil t)
             (re-search-forward  "\\(//\\|#\\) gri-local-version: \"\\(.*\\)\""
                                nil t))
        (buffer-substring (match-beginning 1) (match-end 1)))))

(defun gri-comment ()
  "Add a comment to the following line, or format if one already exists."
  (interactive)
  (cond
   ((gri-empty-line)
    (gri-indent-line)
    (insert "# "))
   ((gri-comment-line-only)
    (save-excursion
      (beginning-of-line)
      (delete-horizontal-space)
      (indent-to (gri-calc-indent))))
   ((gri-comment-line-after-command)
    (save-excursion
      (beginning-of-line)
      (if (re-search-forward "//" (save-excursion (end-of-line)(point)) t)
          (backward-char 2))
      (if (re-search-forward "#" (save-excursion (end-of-line)(point)) t)
          (backward-char 1))
      (re-search-backward "[^ \t]" (save-excursion (beginning-of-line)(point))
                          t)
      (forward-char)
      (delete-horizontal-space)
      (if (< (current-column) gri-comment-column)
          (indent-to gri-comment-column)
        (insert " "))))
   (t
    (end-of-line)
    (re-search-backward "[^ \t^]" 0 t)
    (forward-char)
    (delete-horizontal-space)
    (if (< (current-column) gri-comment-column)
        (indent-to gri-comment-column)
      (insert " "))
    (insert "# "))))

(defun gri-indent-line ()
  "Indent a line and its comments in Gri-mode.

gri `system' commands do not get their comments indented, since the // string
 is legal within a system command. 
 e.g. system sed -e \"s/'N//g;s/'W//g;\" gpsfile > gps.tmp
  to remove 'N and 'W strings from a lat-lon file.

`system any-command <<\"EOF\"' lines are treated specially.
If the editing point is on the first column, then gri-indent-line will
indent the line and skip over the text before the ending EOF.
This means that gri-indent-buffer and gri-indent-region will skip
over system scripts."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (delete-horizontal-space)
    (indent-to (gri-calc-indent))
    (if (and (not (gri-system-line))
             (gri-comment-line-after-command))
        (gri-comment)))
  (if (looking-at "^[ \t]*system[^$]*<<\"EOF\"")
      (re-search-forward "^[ \t]*EOF" nil t))
  (skip-chars-forward " \t"))

(defun gri-system-line ()
  "Returns t if current line is, or is continued from, a system command"
  (save-excursion
    (beginning-of-line)
    (while (save-excursion (and (= 0 (forward-line -1)) 
                                (gri-continuation-line)))
      (forward-line -1))
    (looking-at "[ \t]*\\(\\\\[^ ]+[ ]+=[ ]+\\)?system")))

(defun gri-line-type ()
  "Display type of current line.  Used in debugging."
  (interactive)
  (cond
   ((gri-empty-line)
    (message "gri-line-type: empty-line"))
   ((gri-new-command-name-line)
    (message "gri-line-type: new-command-name-line"))
   ((gri-new-command-syntax-start-line)
    (message "gri-line-type: new-command-syntax-start-line"))
   ((gri-new-command-syntax-end-line)
    (message "gri-line-type: new-command-syntax-end-line"))
   ((gri-comment-line)
    (message "gri-line-type: comment-line"))
   ((gri-continuation-line)
    (message "gri-line-type: continuation-line"))
   ((gri-block-beg-end-line)
    (message "gri-line-type: block-beg-end-line"))
   ((gri-block-beg-line)
    (message "gri-line-type: block-beg-line"))
   ((gri-block-end-line)
    (message "gri-line-type: block-end-line"))
   (t
    (message "gri-line-type: other"))))

(defvar gri-last-indent-type "unknown"
  "String to tell line type.")

(defun gri-indent-type ()
  "Display type of current or previous nonempty line.  Used in debugging."
  (interactive)
  (message (concat "gri-ident-type: " gri-last-indent-type)))

(defun gri-fill-region (from to)
  "Fill the region of comments."
  (interactive "r")
  (message "gri-fill-region not implemented yet."))

(defun gri-calc-indent ()
  "Return the appropriate indentation for this line as an int."
  (let ((indent 0)(here-point (point)))
    (save-excursion
      (while (and (= 0 (forward-line -1)) (gri-empty-line)))
      (cond
       ((= here-point (point)))      ;; we din't move, so beginning of file. 
       ((gri-continuation-line)      ;; has \ at the end of line
        ;; PSG -- if first continued line then increase indentation,
        ;;        if continued from yet another continued line, then don't.
        (setq gri-last-indent-type "continuation")
        (save-excursion
          (if (or (= -1 (forward-line -1)) (not (gri-continuation-line)))
              (setq indent (+ indent (* 1 gri-indent-level))))))
       (t
        ;; PSG -- not a continuation line, but could be the end of a 
        ;;        continuation, so move up until it's previous line is not a
        ;;        continuation line (start of command) to base indentation.
        (while (and (save-excursion
                     (and (= 0 (forward-line -1)) (gri-continuation-line)))
                    (= 0 (forward-line -1))))
        (cond
         ((gri-new-command-name-line)
          (setq gri-last-indent-type "new-command-name")
          (setq indent gri-new-command-help-indent-level))
         ((gri-new-command-syntax-start-line)
          (setq gri-last-indent-type "new-command-syntax-start")
          (setq indent gri-indent-level))
         ((gri-new-command-syntax-end-line)
          (setq gri-last-indent-type "new-command-syntax-end")
          (setq indent (- indent gri-indent-level)))
         ((gri-comment-line) 
          (setq gri-last-indent-type "comment"))
         ((gri-block-beg-end-line)
          (setq gri-last-indent-type "block begin-end"))
         ((gri-block-beg-line)
          (setq gri-last-indent-type "block begin")
          (setq indent gri-indent-level))
         (t
          (setq gri-last-indent-type "other")))))
      (setq indent (+ indent (current-indentation))))
    (if (and (gri-block-end-line) (not (gri-system-line)))
	(setq indent (- indent gri-indent-level)))
    (if (gri-new-command-syntax-start-line)
	(setq indent 0))
    (if (gri-new-command-syntax-end-line)
	(setq indent 0))
    (if (< indent 0) 
        (setq indent 0))
    indent))


(defun gri-empty-line ()
  "Returns t if current line is empty."
  (save-excursion
    (beginning-of-line)
    (looking-at "^[ \t]*$")))

(defun gri-new-command-name-line ()
  "Returns t if current line is a Gri new-command-name line; that is,
if it begins with ` and ends with '."
    (and
     (save-excursion
       (beginning-of-line)
       (skip-chars-forward " \t")
       (looking-at "`"))
     (save-excursion
       (end-of-line)
       (backward-char)
       (looking-at "'"))))

(defun gri-new-command-syntax-start-line ()
  "Returns t if current line is a left brace, indicating the start of 
syntax for a new Gri command."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (looking-at "{ *\n")))

(defun gri-new-command-syntax-end-line ()
  "Returns t if current line is a right brace, indicating the end of 
syntax for a new Gri command."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (looking-at "} *\n")))

(defun gri-comment-line ()
  "Returns t if current line is a Gri comment line."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (looking-at "\\(//\\|#\\)")))

(defun gri-comment-line-only ()
  "Returns t if current line is only a Gri comment line"
  (save-excursion
    (beginning-of-line)
    (looking-at "[ \t]*\\(//\\|#\\)")))

(defun gri-comment-line-after-command ()
  "Returns t if current line contains a Gri comment after a command line"
  (save-excursion
    (beginning-of-line)
    (looking-at ".+\\(//\\|#\\).*$")))

(defun gri-continuation-line ()
  "Returns t if current line ends in \\."
  (save-excursion
    (beginning-of-line)
    (re-search-forward "\\\\$" (gri-eoln-point) t)))

(defun gri-eoln-point ()
  "Returns point for end-of-line in Gri-mode."
  (save-excursion
    (end-of-line)
    (point)))

(defconst gri-block-beg-kw "\\(if\\|else\\|else if\\|while\\)"
  "Regular expression for keywords which begin blocks in Gri-mode.")
(defconst gri-block-end-kw "\\(\\end if\\|else\\|end while\\)"
  "Regular expression for keywords which end blocks.")

(defun gri-block-beg-line ()
  "Returns t if line contains beginning of Gri block."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (looking-at gri-block-beg-kw)))

(defun gri-block-end-line ()
  "Returns t if line contains end of Gri block."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (looking-at gri-block-end-kw)))

(defun gri-block-beg-end-line ()
  "Returns t if line contains matching block begin-end in Gri-mode."
  (save-excursion
    (beginning-of-line)
    (looking-at (concat
                 "\\([^[//]\n]*[ \t]\\)?" gri-block-beg-kw 
                 "." "\\([^[//]\n]*[ \t]\\)?" gri-block-end-kw))))

(defun gri-comment-on-line ()
  "Returns t if current line contains a comment."
  (save-excursion
    (beginning-of-line)
    (looking-at "[^\n]*\\(//\\|#\\)")))

(defun gri-in-comment ()
  "Returns t if point is in a comment."
  (save-excursion
    (and (/= (point) (point-max)) (forward-char))
    (re-search-backward "\\(//\\|#\\)" 
                        (save-excursion (beginning-of-line) (point)) t)))

(defun filename-sans-gri-suffix (name)
  "Return FILENAME sans .gri suffix.  
If FILENAME does not end in `.gri', return FILENAME."
  (substring name 0
	     (or (string-match ".gri\$" name)
	 (length name))))

;; Setup auto-mode-alist
(if (not (assoc '"\\.gri$" auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.gri$" . gri-mode) auto-mode-alist)))
(if (not (assoc '"\\.grirc$" auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.grirc$" . gri-mode) auto-mode-alist)))

(provide 'gri-mode)
;;; gri-mode.el ends here
