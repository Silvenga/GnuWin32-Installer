% -*-postscript-*-
% PostScript Prologue for a2ps (meant for diffs)
%
% $Id: diff.pro,v 1.1.1.1.2.1 2007/12/29 01:58:27 mhatta Exp $
%

%
% This file is part of a2ps.
% 
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3, or (at your option)
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; see the file COPYING.  If not, write to
% the Free Software Foundation, 59 Temple Place - Suite 330,
% Boston, MA 02111-1307, USA.
%

Documentation
This style is meant to be used with the code(udiff)code, code(wdiff)code
style sheets, to underline the differences.  New things are in bold
on a diff background, while removed sequences are in italic.
EndDocumentation

% -- code follows this line --
%%BeginResource: procset a2ps-diff-Prolog 2.0 1
%%IncludeResource: file base.ps
%%IncludeResource: file a2ps.hdr

% Another version of `dounderline' which strikes through the string,
% not under.
% width --
/dounderline {
  currentpoint
  gsave
    moveto
    0
    currentfont /UnderlineThickness get currentfontsize mul setlinewidth
    % Move to half the height of the font
    currentfontsize 4 div rmoveto
    0 rlineto
    stroke
  grestore
} bind def

/p {
  0 0 0 FG
  false BG
  false UL
  false BX
%Face: Plain Courier bfs
  Show
} bind def

/sy {
  0 0 0 FG
  false BG
  false UL
  false BX
%Face: Symbol Symbol bfs
  Show
} bind def

% Removed
/k {
  0 0 0 FG
  false BG
  true UL
  false BX
%Face: Keyword Courier bfs
  Show
} bind def

% Added
/K {
  0 0 0 FG
  0.9 0.9 0.9 true BG
  false UL
  false BX
%Face: Keyword_strong Courier bfs
  Show
} bind def

/c {
  0 0 0 FG
  0.9 0.9 0.9 true BG
  false UL
  false BX
%Face: Comment Courier-Oblique bfs
  Show 
} bind def

/C {
  1.0 1.0 1.0 FG
  false BG
  false UL
  false BX
%Face: Comment_strong Courier-Bold bfs
  Show 
} bind def

/l {
  0 0 0 FG
  0.9 0.9 0.9 true BG
  false UL
  false BX
%Face: Label Courier bfs
  Show 
} bind def

/L {
  0 0 0 true BG
  false UL
  false BX
  1.0 1.0 1.0 FG
%Face: Label_strong Courier-Bold bfs
  Show 
} bind def

/str {
  0 0 0 FG
  false BG
  false UL
  false BX
%Face: String Times-Roman bfs
  Show
} bind def

/e{
  0 0 0 true BG
  false UL
  false BX
  1.0 1.0 1.0 FG
%Face: Error Helvetica-Bold bfs
  Show
} bind def
%%EndResource
%%BeginSetup
% The font for line numbering
/f# /Helvetica findfont bfs .6 mul scalefont def
%%EndSetup
