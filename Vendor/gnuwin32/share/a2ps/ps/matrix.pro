% -*-postscript-*-
% PostScript Prologue
%
% $Id: matrix.pro,v 1.1.1.1.2.1 2007/12/29 01:58:27 mhatta Exp $
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
The layout is the same as samp(bw)samp, but alternating gray and white lines.
There are two macros defining the behavior:
samp(pro.matrix.cycle)samp defines the length of the cycle (number of white
and gray lines).  It defaults to 6.
samp(pro.matrix.gray)samp defines the number of gray lines.  Default is 3.
EndDocumentation
% -- code follows this line --
%%IncludeResource: file base.ps
%%IncludeResource: file a2ps.hdr
%%BeginResource: procset a2ps-matrix-Prolog 2.0 1

% Function T(ab), jumps to the n-th tabulation in the current line
/T { 
  cw mul x0 add y0 moveto
} bind def

% Function n: move to the next line
/n { %def
  /y0 y0 bfs sub store
  % Draw a grey background
  /nline nline 1 add def
%Expand:  nline #{pro.matrix.cycle:-6} mod #{pro.matrix.gray:-3} ge {
    gsave
      newpath
      x v get y0 currentfont /Descent get currentfontsize mul add moveto
      pw 0 rlineto
      0 bfs rlineto
      pw neg 0 rlineto
      closepath
      0.9 setgray
      fill
    grestore
  } if
  x0 y0 moveto
} bind def

% Function N: show and move to the next line
/N {
  Show
  n
} bind def

/S {
  Show
} bind def

/p {
  false UL
  false BX
%Face: Plain Courier bfs
  Show
} bind def

/sy {
  false UL
  false BX
%Face: Symbol Symbol bfs
  Show
} bind def

/k {
  false UL
  false BX
%Face: Keyword Courier-Oblique bfs
  Show
} bind def

/K {
  false UL
  false BX
%Face: Keyword_strong Courier-Bold bfs
  Show
} bind def

/c {
  false UL
  false BX
%Face: Comment Courier-Oblique bfs
  Show
} bind def

/C {
  false UL
  false BX
%Face: Comment_strong Courier-BoldOblique bfs
  Show 
} bind def

/l {
  false UL
  false BX
%Face: Label Helvetica bfs
  Show
} bind def

/L {
  false UL
  false BX
%Face: Label_strong Helvetica-Bold bfs
  Show 
} bind def

/str{
  false UL
  false BX
%Face: String Times-Roman bfs
  Show
} bind def

/e{
  false UL
  true BX
%Face: Error Helvetica-Bold bfs
  Show
} bind def

%%EndResource
%%BeginSetup
% The font for line numbering
/f# /Helvetica findfont bfs .6 mul scalefont def
/nline 0 def
%%EndSetup
