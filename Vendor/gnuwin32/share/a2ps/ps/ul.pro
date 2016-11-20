% PostScript Prologue                                  -*- postscript -*-
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
This style uses bold faces and underlines, but never italics.  This is
particularly meant for printing formatted man pages.
EndDocumentation

% -- code follows this line --
%%IncludeResource: file base.ps
%%IncludeResource: file a2ps.hdr
%%BeginResource: procset a2ps-black+white-Prolog 2.0 1

% Function T(ab), jumps to the n-th tabulation in the current line
/T {
  cw mul x0 add y0 moveto
} bind def

% Function n: move to the next line
/n { %def
  /y0 y0 bfs sub store
  x0 y0 moveto
} bind def

% Function N: show and move to the next line
/N {
  Show
  /y0 y0 bfs sub store
  x0 y0 moveto
}  bind def

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
  true UL
  false BX
%Face: Keyword Courier bfs
  Show
} bind def

/K {
  false UL
  false BX
%Face: Keyword_strong Courier-Bold bfs
  Show
} bind def

/c {
  true UL
  false BX
%Face: Comment Courier bfs
  Show
} bind def

/C {
  true UL
  false BX
%Face: Comment_strong Courier-Bold bfs
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
%%EndSetup
