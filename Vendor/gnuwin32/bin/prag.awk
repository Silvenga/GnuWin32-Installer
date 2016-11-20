#!gawk -f
#	Copyright (C) 1992, 1993 Holger J. Meyer, Rostock, Germany
#	hm@GUUG.de
#
#	See file ``Copyright'' for terms of copyright.
#
# Module:
#	Process a grap(1) like language, to produce graphs.  The input language
#	syntax is documented in lines marked with double hash marks ('##').
#	The first implementation was much inspired by the graph program from
#	``Aho, A.V., Kernighan, B. W., Weinberger, P. J. "The AWK Programming
#	Language", Addison-Wesley, Reading, 1988''.
#
# Source:
#	NAWK
#
# History:
#	92/4/20	hme, initial version written
#	93/8/24	hme, multiple graphs, grids, etc. added
#	93/10/20	hme, labeled margin boxes, generate `reset' before .PE
#	95/9/24	hme, more grap conformance, improved ticks (by eduardo@nostromo.medusa.es)
#	95/11/15	hme, put out only labeled margin boxes
#
# Layout:
#
#	GRAPH
#	+----------+------------------------+----------+
#	|          |                     ^  |          |
#	|          | TMARG              ht/6|          |
#	|          |                     v  |          |
#	+----------+------------------------+----------+
#	| LMARG    | FRAME               ^  | RMARG    |
#	|          |                     |  |          |
#	|          |                     |  |          |
#	|          |                     ht |          |
#	|          |                     |  |          |
#	|          |                     |  |          |
#	|<-wid/6-->|<---------wid--------v->|<--wid/6->|
#	+----------+------------------------+----------+
#	|          |                     ^  |          |
#	|          | BMARG              ht/6|          |
#	|          |                     v  |          |
#	+----------+------------------------+----------+
#
#
BEGIN {
	MYADDR = "hm@GUUG.de";
	# number (RE)
	NUMBER = "^[-+]?([0-9]+[.]?[0-9]*|[.][0-9]+)" "([eE][-+]?[0-9]+)?$";
	GNAME = "GRAPH";			# label for whole picture
	FNAME = "FRAME";			# label for frame
	MNAME = "MARG";			# label for [top|....] margin boxes
	DEFLSTYLE = "solid";
	DEFCH = "\\s+2\\(bu\\s-2";
	MARKED = 1;
	MINXTICKS = 5;
	MINYTICKS = 5;
	nG1 = 0;
	grapinput = 0;
	err = 0;
	dot_lf = 1;
	warn = 1;
	debug = 0;
}
## .G1 [width [height]]
# start of graph input
/^.G1/ {
	++nG1;
	grapinput = 1;
	data = 0;
	initgraph();
	if (NF >= 2) {
		wid = $2;
	}
	if (NF >= 3) {
		ht = $3;
	}
	resizegraph();
	if (dot_lf) {
		printf(".lf %d %s\n", FNR, FILENAME);
	}
	next;
}
## .G2
# end of graph input -- draw graph
/^.G2/ {
	if (!grapinput) {
		printf("\"%s\":%d: missing previous .G1\n", FILENAME, FNR) |"cat >&2";
		errexit(-1);
	}
	else {
		endgraph();
		grapinput = 0;
	}
	if (dot_lf) {
		printf(".lf %d %s\n", FNR, FILENAME);
	}
	next;
}
# copy all outside from .G1 and .G2
!grapinput {
	print $0;
	next;
}
## # comment
# delete comments
/^#/ {
	next;
}
## draw line-style
$1 == "draw" {
	if (NF != 2) {
		printf("\"%s\":%d: draw line-style\n", FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	if ($2 == "marked") {
		g_flags[ngs] = MARKED;
	}
	else {
		g_lstyle[ngs] = $2;
	}
	next;
}
## new [line-style [name [label]]]
# begin new graph, put old data points out
$1 == "new" {
	cg = ++ngs;
	newgraph(ngs);
	if (NF >= 2) {
		if ($2 == "marked") {
			g_flags[ngs] = MARKED;
		}
		else {
			g_lstyle[ngs] = $2;
		}
	}
	if (NF >= 3) {
		g_name[ngs] = $3;
	}
	if (NF >= 4) {
		$1 = $2 = $3 = "";
		sub(/^[ \t]*/, "");
		g_label[ngs] = $0;
	}
	g_ndata[ngs] = 0;
	next;
}
## label [left | right | top | bot] label-string
# left, right, top, bottom label
$1 == "label" {
	pos = $2;
	if (pos == "left") {
		sub(/^[ \t]*label[ \t]+left[ \t]*/, "");
	}
	else if (pos == "right") {
		sub(/^[ \t]*label[ \t]+right[ \t]*/, "");
	}
	else if (pos == "top") {
		sub(/^[ \t]*label[ \t]+top[ \t]*/, "");
	}
	else if (pos == "bot") {
		sub(/^[ \t]*label[ \t]+bot[ \t]*/, "");
	}
	else {
		printf("\"%s\":%d: label [left|right|top|bot] string ...\n",
			FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	t_label[pos] = $0;
	next;
}
## ticks [left | right | top | bot] [where] position ...
## ticks [left | right | top | bot] [where] from begin to end [by step]
# ticks for x- & y-axis, left, top, right or bottom position
$1 == "ticks" {
	if (NF <= 3) {
		printf("\"%s\":%d: ticks [left|right|top|bot] [where] position ...\n",
			FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	if ($2 != "left" && $2 != "right" && $2 != "top" && $2 != "bot") {
		printf("\"%s\":%d: ticks [left|right|top|bot] [where] position ...\n",
			FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	i = 3;
	t_num[$2] = 0;
	if ($3 == "in" || $3 == "out") {
		t_where[$2] = $3;
		++i;
	}
	if ($i != "from") {
		while (i <= NF) {
			t_pos[$2, t_num[$2]] = $i;
			++t_num[$2];
			++i;
		}
	}
	else {
		if ($(i+2) != "to" || NF < i+3) {
			printf( "\"%s\":%d: ticks [left|right|top|bot] [where] from begin to end [by step]\n",
				FILENAME, FNR) | "cat >&2";
			errexit(-1);
		}
		if ($(i+4) == "by") {
			if (NF == i+5) {
				tickstep = $(i+5);
			}
			else {
				printf( "\"%s\":%d: ticks [left|right|top|bot] [where] from begin to end [by step]\n",
						FILENAME, FNR) | "cat >&2";
				errexit(-1);
			}
		}
		else {
			tickstep = 1;
		}
		for (tick = $(i+1); tick <= $(i+3); tick += tickstep) {
			t_pos[$2, t_num[$2]] = tick;
			++t_num[$2];
		}
	}
	next;
}
## frame frame-attributes ...
# frame-attributes
$1 == "frame" {
	if (NF == 1) {
		printf("\"%s\":%d: frame frame-attributes ...\n",
			FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	sub(/^[ \t]*frame[ \t]+/, "");
	fattr = $0;
	next;
}
## spline
## nospline
$1 == "spline" {
	g_spline[ngs] = "sp";
	next;
}
$1 == "nospline" {
	g_spline[ngs] = "";
	next;
}
## range xmin ymin xmax ymax
$1 == "range" && $2 ~ NUMBER && $3 ~ NUMBER && $4 ~ NUMBER && $5 ~ NUMBER {
	if (NF != 5) {
		printf("\"%s\":%d: range xmin ymin xmax ymax\n",
			FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	xmin = $2;
	ymin = $3;
	xmax = $4;
	ymax = $5;
	next;
}
## ht number
# graph height
$1 == "ht" && $2 ~ NUMBER {
	if (NF != 2) {
		printf("\"%s\":%d: ht height\n", FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	ht = $2;
	resizegraph();
	next;
}
## wid number
# graph width
$1 == "wid" && $2 ~ NUMBER {
	if (NF != 2) {
		printf("\"%s\":%d: wid width\n", FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	wid = $2;
	resizegraph();
	next;
}
## grid [line-style]
# graph with grid
$1 == "grid" {
	if (NF == 1) {
		grid = "dotted";
	}
	else if (NF == 2) {
		grid = $2;
	}
	else {
		printf("\"%s\":%d: grid [line-style]\n", FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	next;
}
## mark drawing-character
# set default drawing character for this graph
$1 == "mark" {
	if (NF != 2) {
		printf("\"%s\":%d: mark drawing-character\n", FILENAME, FNR) | "cat >&2";
		errexit(-1);
	}
	g_defch[ngs] = $2;
	g_flags[ngs] = MARKED;
	next;
}
## .lf line-number file-name
# groff's ``.lf line file''
$1 == ".lf" {
	print $0;
	next;
}
# collecting DATA
## next [graph-name] [at] position
# next point extraction: awk falls through these actions!!!
$1 == "next" && $3 == "at" {
	found = 0;
	for (i = 0; i <= ngs; ++i) {
		if (g_name[i] == $2) {
			# alter cg to point temporarily to an other graph
			# after collecting data, it shall be restored
			cg = i;
			++found;
			break;
		}
	}
	if (!found) {
		printf("\"%s\":%d: illegal graph-name \"%s\": ignored\n",
			FILENAME, FNR, $2) | "cat >&2";
	}
	sub(/^[ \t]*next[ \t]+[a-zA-Z]+[ \t]+at[ \t]*/, "next at ");
}
$1 == "next" && $2 == "at" {
	sub(/^[ \t]*next[ \t]+at[ \t]*/, "next ");
}
$1 == "next" {
	sub(/^[ \t]*next[ \t]*/, "");
}
# pairs of numbers with opt drawing char
$1 ~ NUMBER && $2 ~ NUMBER {
	g_x[cg, g_ndata[cg]] = $1;
	g_y[cg, g_ndata[cg]] = $2;
	if (NF >= 3) {
		$1 = $2 = "";
		sub(/^[ \t]*/, "");
		g_ch[cg, g_ndata[cg]] = $0;	# extra plotting character
	}
	else {
		g_ch[cg, g_ndata[cg]] = "";
	}
	++g_ndata[cg];			# count number of data points
	cg = ngs;				# reset current graph
	data = 1;
	next;
}
# a single number with opt drawing char
$1 ~ NUMBER && $2 !~ NUMBER {
	g_y[cg, g_ndata[cg]] = $1;
	g_x[cg, g_ndata[cg]] = g_ndata[cg];
	if (NF >= 2) {
		$1 = "";
		sub(/^[ \t]*/, "");
		g_ch[cg, g_ndata[cg]] = $0;	# extra plotting character
	}
	else {
		g_ch[cg, g_ndata[cg]] = "";
	}
	++g_ndata[cg];
	cg = ngs;				# reset current graph
	data = 1;
	next;
}
## pic '{' anything '}'
# rest of input goes direct to pic
$1 != "pic" {
	if (warn) {
		printf("\"%s\":%d: inputline passed through pic\n",
			FILENAME, FNR) | "cat >&2";
	}
}
{
	sub(/^[ \t]*pic[ \t]*{[ \t]*/, "");
	sub(/[ \t]*}[ \t]*$/, "");
	piccode = sprintf("%s%s\n", piccode, $0);
	next;
}
END {
	if (err) {
		exit(err);
	}
	if (grapinput) {
		printf("\"%s\":%d: missing .G2 \n", FILENAME, FNR) | "cat >&2";
		endgraph();
	}
	exit(0);
}
#
# subroutine stuff
#
function errexit(e) {
	err = e;
	exit(-1);
}
function initgraph() {
	ht = 2;					# default frame size
	wid = 3;
	fattr = "";				# frame-attributes
	grid = "";
	ngs = 0;					# number of graphs
	cg = 0;					# current graph, may differ from ngs due to next stmnt.
	# struct graph {
	#	integer	g_flags,		# various flags indicating mark style etc.
	#	string	g_lstyle;		# line style
	#	string	g_spline;		# draw graph with [sp]line
	#	string	g_name;		# graph name
	#	string	g_label;		# graph label
	#	integer	g_ndata;		# # of data items
	#	real		g_x[];		# x coords
	#	real		g_y[];		# y coords
	#	string	g_ch[];		# optional point drawing character
	#	string	g_defch;		# default drawing character
	# };
	g_defch[0] = DEFCH;
	g_defch[1] = "\\(*D";
	g_defch[2] = "\\(pl";
	g_defch[3] = "\\(sq";
	g_defch[4] = "\\(mu";
	newticks("left");
	newticks("right");
	newticks("top");
	newticks("bot");
	newgraph(ngs);

	piccode = "";
	xmin = xmax = ymin = ymax = 0;
}
function resizegraph()
{
	# left, right, top, bot margin of frame
	m_size["left"] = m_size["right"] = wid/6;
	m_size["top"] = m_size["bot"] = ht/6;
	ticklen = ht/32;			# default len for tick marker
}
function newgraph(g) {
	g_flags[g] = 0;
	g_lstyle[g] = DEFLSTYLE;
	g_spline[g] = "sp";			# [sp]line used for graph drawing
	g_name[g] = "OOPS";
	g_label[g] = "";
	g_ndata[g] = 0;
}
function newticks(where) {
	t_label[where] = "";
	t_where[where] = "out";
	t_num[where] = 0;
	t_pos[where, 0] = 0;
}
function endgraph() {
	grapinput = 0;
	if (!xmin && !xmax && !ymin && !ymax) {	# no range was given
		xmin = xmax = g_x[0, 0];
		ymin = ymax = g_y[0, 0];
		for (g = 0; g <= ngs; ++g) {
			for (i = 0; i < g_ndata[g]; ++i) {
				if (g_x[g, i] < xmin) {
					xmin = g_x[g, i];
				}
				if (g_x[g, i] > xmax) {
					xmax = g_x[g, i];
				}
				if (g_y[g, i] < ymin) {
					ymin = g_y[g, i];
				}
				if (g_y[g, i] > ymax) {
					ymax = g_y[g, i];
				}
			}
		}
	}
	printf(".PS %g %g\n", wid+m_size["left"]+m_size["right"], ht+m_size["top"]+m_size["bot"]);
	printf("# DO NOT EDIT!\n");
	printf("# generated from \"%s\" by prag (C) %s\n", FILENAME, MYADDR);
	if (data) {	# any data?
		cutmarg();
		frame();
		label();
		ticks();
		for (g = 0; g <= ngs; ++g) {
			drawgraph(g);
		}
	}
	if (piccode != "") {
		printf("%s", piccode);
	}
	printf("reset\n.PE\n");
}
# cut off margins without a label
function cutmarg(	w) {
	for (w in m_size) {
		if (t_label[w] == "") {
			m_size[w] = 0;
		}
	}
}
# create frame from graph
function frame() {
	printf("%s:\tbox invis ht %g wid %g\n",
		GNAME, ht+m_size["top"]+m_size["bot"], wid+m_size["left"]+m_size["right"]);
	printf("%s:\tbox %s ht %g wid %g with .sw at %s.sw + (%g, %g)\n",
		FNAME, fattr, ht, wid, GNAME, m_size["left"], m_size["bot"]);
}
# center label under x-axis and left from y-axis
function label() {
	if (t_label["left"]) {
		printf("%s%s:\tbox wid %g ht %g invis %s with .e at %s.w\n",
			MNAME, "left", m_size["left"], ht, t_label["left"], GNAME);
	}
	if (t_label["right"]) {
		printf("%s%s:\tbox wid %g ht %g invis %s with .w at %s.e\n",
			MNAME, "right", m_size["right"], ht, t_label["right"], GNAME);
	}
	if (t_label["top"]) {
		printf("%s%s:\tbox wid %g ht %g invis %s with .s at %s.n\n",
			MNAME, "top", wid, m_size["top"], t_label["top"], GNAME);
	}
	if (t_label["bot"]) {
		printf("%s%s:\tbox wid %g ht %g invis %s with .n at %s.s\n",
			MNAME, "bot", wid, m_size["bot"], t_label["bot"], GNAME);
	}
}
# create tick marks for all axes
function ticks(	i, user_ticks, w) {
	user_ticks = 0;
	for (i = 0; i < t_num["left"]; ++i) {
		printf("line %s %g at %g <%s.sw, %s.nw>\n",
			t_where["left"] == "out" ? "left" : "right",
			ticklen, w = yscale(t_pos["left", i]), FNAME, FNAME);
		printf("\"%s \" at last line.w rjust\n", t_pos["left", i]);
		if (w != 0 && w != 1 && grid != "") {
			printf("line %s from %g <%s.sw, %s.nw> to %g <%s.se, %s.ne>\n",
				grid, w, FNAME, FNAME, w, FNAME, FNAME);
		}
		++user_ticks;
	}
	for (i = 0; i < t_num["right"]; ++i) {
		printf("line %s %g at %g <%s.se, %s.ne>\n",
			t_where["right"] == "out" ? "right" : "left",
			ticklen, yscale(t_pos["right", i]), FNAME, FNAME);
		printf("\" %s\" at last line.e ljust\n", t_pos["right", i]);
		++user_ticks;
	}
	for (i = 0; i < t_num["top"]; ++i) {
		printf("line %s %g at %g <%s.nw, %s.ne>\n",
			t_where["bot"] == "out" ? "up" : "down",
			ticklen, xscale(t_pos["top", i]), FNAME, FNAME);
		printf("\"%s\" at last line.n above\n", t_pos["top", i]);
		++user_ticks;
	}
	for (i = 0; i < t_num["bot"]; ++i) {
		printf("line %s %g at %g <%s.sw, %s.se>\n",
			t_where["bot"] == "out" ? "down" : "up",
			ticklen, w = xscale(t_pos["bot", i]), FNAME, FNAME);
		printf("\"%s\" at last line.s below\n", t_pos["bot", i]);
		if (w != 0 && w != 1 && grid != "") {
			printf("line %s from %g <%s.sw, %s.se> to %g <%s.nw, %s.ne>\n",
				grid, w, FNAME, FNAME, w, FNAME, FNAME);
		}
		++user_ticks;
	}
	if (!user_ticks) {
		xmax = roundceil(MINXTICKS, xmax);
		ymax = roundceil(MINYTICKS, ymax);
		xmin = roundfloor(MINXTICKS, xmin);
		ymin = roundfloor(MINYTICKS, ymin);
		ysteps = steps(MINYTICKS, ymin, ymax);
		#for (i = 0; i <= ysteps; ++i) {
		for (i = 1; i < ysteps; ++i) {
			printf("line left %g at %g <%s.sw, %s.nw>\n",
				ticklen, w = i/ysteps, FNAME, FNAME);
			printf("\"%s\" at last line.w rjust\n", ymin + (ymax - ymin)*i/ysteps);
			if (w != 0 && w != 1 && grid != "") {
				printf("line %s from %g <%s.sw, %s.nw> to %g <%s.se, %s.ne>\n",
					grid, w, FNAME, FNAME, w, FNAME, FNAME);
			}
		}
		xsteps = steps(MINXTICKS, xmin, xmax);
		#for (i = 0; i <= xsteps; ++i) {
		for (i = 1; i < xsteps; ++i) {
			printf("line down %g at %g <%s.sw, %s.se>\n",
				ticklen, w = i/xsteps, FNAME, FNAME);
			printf("\"%s\" at last line.s below\n", xmin + (xmax - xmin)*i/xsteps);
			if (w != 0 && w != 1 && grid != "") {
				printf("line %s from %g <%s.sw, %s.se> to %g <%s.nw, %s.ne>\n",
					grid, w, FNAME, FNAME, w, FNAME, FNAME);
			}
		}
	}
}
# scale x-value
function xscale(x) {
	return((x-xmin)/(xmax-xmin));
}
# scale y-value
function yscale(y) {
	return((y-ymin)/(ymax-ymin));
}
# round ranges, VERY POOR!
# round to smallest e*10^log10(val) + n*e .gt. val
function roundceil(ex, val,	e, v) {
	e = ex;
	while (e < val) {
		e *= 10;
	}
	v = val;
	if (int(v) % e) {
		v = e*(int(v/e) + 1);
	}
	while (v >= val) {
		v -= ex;
	}
	if (debug) {
		printf("roundceil(%g, %g) returns %g\n",
			ex, val, v + ex) | "cat >&2";
	}
	return(v + ex);
}
# round to greatest e*10^log10(val) - n*e .lt. val
function roundfloor(ex, val,	e, v) {
	e = ex;
	while (e < val) {
		e *= 10;
	}
	if (e > ex) {
		e /= 10;
	}
	v = val;
	if (int(v) % e) {
		v = e*(int(v/e));
	}
	while (v <= val) {
		v += ex;
	}
	if (debug) {
		printf("roundfloor(%g, %g) returns %g\n",
			ex, val, v - ex) | "cat >&2";
	}
	return(v - ex);
}
# count of ticks
function steps(defsteps, min, max)
{
	# very simple solution
	return(defsteps);
}
# sorting routine
function swap(g, i, j,	t) {
	t = g_x[g, i];
	g_x[g, i] = g_x[g, j];
	g_x[g, j] = t;
	t = g_y[g, i];
	g_y[g, i] = g_y[g, j];
	g_y[g, j] = t;
	t = g_ch[g, i];
	g_ch[g, i] = g_ch[g, j];
	g_ch[g, j] = t;
}
# insertion sort
function sort(g,	i, j) {
	for (i = 1; i < g_ndata[g]; ++i) {
		for (j = i; j > 0 && g_x[g, j - 1] > g_x[g, j]; --j) {
			swap(g, j - 1, j);
		}
	}
}

# create data points
function drawgraph(g,	i) {
	if (g_ndata[g] == 0) {
		return;
	}
	sort(g);
	printf("G_%s: # graph no. %d\n", g_name[g], g + 1);
	if (g_lstyle[g] == "invis" || g_flags[g] == MARKED) {
		for (i = 0; i < g_ndata[g]; ++i) {
			printf("\"%s\" at %s.sw + (%g, %g)\n",
				g_ch[g, i] != "" ? g_ch[g, i] : (g_defch[g] != "" ? g_defch[g] : DEFCH), 
				FNAME, xscale(g_x[g, i])*wid, yscale(g_y[g, i])*ht);
		}
	}
	if (g_lstyle[g] != "invis") {
		printf("%sline %s %s from %s.sw + (%g, %g)",
			g_spline[g], g_label[g], g_lstyle[g] == "solid" ? "" : g_lstyle[g],
			FNAME, xscale(g_x[g, 0])*wid, yscale(g_y[g, 0])*ht);
		for (i = 1; i < g_ndata[g]; ++i) {
			printf("\t\\\n\tthen to %s.sw + (%g, %g)", FNAME,
				xscale(g_x[g, i])*wid, yscale(g_y[g, i])*ht);
		}
		printf("\n");
	}
}
#vi: set tabstop=5 shiftwidth=5:
