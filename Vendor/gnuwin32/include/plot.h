/* This is "plot.h", the public header file for GNU libplot, a shared
   library for 2-dimensional vector graphics.  It declares both the new C
   binding, which is thread-safe, and the old C binding, which is not. */

/* stdio.h must be included before this file is included. */

/* This header file is written for ANSI C compilers.  If you use it with a
   pre-ANSI C compiler that does not support the `const' keyword, such as
   the `cc' compiler supplied with SunOS (i.e., Solaris 1.x), you should
   use the -DNO_CONST_SUPPORT option when compiling your code. */

#ifndef _PLOT_H_
#define _PLOT_H_ 1

/***********************************************************************/

/* Version of GNU libplot/libplotter which this header file accompanies.
   This information is included beginning with version 4.0.

   The PL_LIBPLOT_VER_STRING macro is compiled into the library, as
   `pl_libplot_ver'.  The PL_LIBPLOT_VER macro is not compiled into it.
   Both are available to applications that include this header file. */

#define PL_LIBPLOT_VER_STRING "4.1"
#define PL_LIBPLOT_VER         401

extern const char pl_libplot_ver[8];   /* need room for 99.99aa */

/***********************************************************************/

/* The functions in the new C binding deal with `plPlotter' and
   `plPlotterParams' objects.  They are the same as the `Plotter' and
   `PlotterParams' objects of the C++ binding.  Internally, they are called
   `plPlotterStruct' and `plPlotterParamsStruct'. */
typedef struct plPlotterStruct plPlotter;
typedef struct plPlotterParamsStruct plPlotterParams;

/* support C++ */
#ifdef ___BEGIN_DECLS
#undef ___BEGIN_DECLS
#endif
#ifdef ___END_DECLS
#undef ___END_DECLS
#endif
#ifdef __cplusplus
# define ___BEGIN_DECLS extern "C" {
# define ___END_DECLS }
#else
# define ___BEGIN_DECLS		/* empty */
# define ___END_DECLS		/* empty */
#endif
     
/* ___P is a macro used to wrap function prototypes, so that compilers that
   don't understand ANSI C prototypes still work, and ANSI C compilers can
   issue warnings about type mismatches. */
#ifdef ___P
#undef ___P
#endif
#if defined (__STDC__) || defined (_AIX) \
	|| (defined (__mips) && defined (_SYSTYPE_SVR4)) \
	|| defined(WIN32) || defined(__cplusplus)
#define ___P(protos) protos
#else
#define ___P(protos) ()
#endif

/* For old compilers (e.g. SunOS) */
#ifdef ___const
#undef ___const
#endif
#ifdef NO_CONST_SUPPORT
#define ___const
#else
#define ___const const
#endif

___BEGIN_DECLS

/* THE NEW (thread-safe) C API */

/* Constructor/destructor for the plPlotter type.  Parameter values are
   specified at creation time via a plPlotterParams instance.  There is no
   copy constructor. */
plPlotter * pl_newpl_r ___P((___const char *type, FILE *infile, FILE *outfile, FILE *errfile, const plPlotterParams *plotter_params));
int pl_deletepl_r ___P((plPlotter *plotter));

/* Constructor/destructor/copy constructor for the plPlotterParams type,
   any instance of which stores parameters that are used when creating a
   plPlotter. */
plPlotterParams * pl_newplparams ___P((void));
int pl_deleteplparams ___P((plPlotterParams *plotter_params));
plPlotterParams * pl_copyplparams ___P((const plPlotterParams *plotter_params));

/* A function for setting a single Plotter parameter in a plPlotterParams
   instance.  */
#ifdef NO_VOID_SUPPORT
int pl_setplparam ___P((plPlotterParams *plotter_params, const char *parameter, char *value));
#else
int pl_setplparam ___P((plPlotterParams *plotter_params, const char *parameter, void *value));
#endif

/* THE PLOTTER METHODS */

/* 13 functions in traditional (pre-GNU) libplot */
int pl_arc_r ___P((plPlotter *plotter, int xc, int yc, int x0, int y0, int x1, int y1));
int pl_box_r ___P((plPlotter *plotter, int x0, int y0, int x1, int y1));
int pl_circle_r ___P((plPlotter *plotter, int x, int y, int r));
int pl_closepl_r ___P((plPlotter *plotter));
int pl_cont_r ___P((plPlotter *plotter, int x, int y));
int pl_erase_r ___P((plPlotter *plotter));
int pl_label_r ___P((plPlotter *plotter, ___const char *s));
int pl_line_r ___P((plPlotter *plotter, int x0, int y0, int x1, int y1));
int pl_linemod_r ___P((plPlotter *plotter, ___const char *s));
int pl_move_r ___P((plPlotter *plotter, int x, int y));
int pl_openpl_r ___P((plPlotter *plotter));
int pl_point_r ___P((plPlotter *plotter, int x, int y));
int pl_space_r ___P((plPlotter *plotter, int x0, int y0, int x1, int y1));

/* 46 additional functions in GNU libplot, plus 1 obsolete function
   [pl_outfile_r]. */
FILE* pl_outfile_r ___P((plPlotter *plotter, FILE* outfile));/* OBSOLETE */
int pl_alabel_r ___P((plPlotter *plotter, int x_justify, int y_justify, ___const char *s));
int pl_arcrel_r ___P((plPlotter *plotter, int dxc, int dyc, int dx0, int dy0, int dx1, int dy1));
int pl_bezier2_r ___P((plPlotter *plotter, int x0, int y0, int x1, int y1, int x2, int y2));
int pl_bezier2rel_r ___P((plPlotter *plotter, int dx0, int dy0, int dx1, int dy1, int dx2, int dy2));
int pl_bezier3_r ___P((plPlotter *plotter, int x0, int y0, int x1, int y1, int x2, int y2, int x3, int y3));
int pl_bezier3rel_r ___P((plPlotter *plotter, int dx0, int dy0, int dx1, int dy1, int dx2, int dy2, int dx3, int dy3));
int pl_bgcolor_r ___P((plPlotter *plotter, int red, int green, int blue));
int pl_bgcolorname_r ___P((plPlotter *plotter, ___const char *name));
int pl_boxrel_r ___P((plPlotter *plotter, int dx0, int dy0, int dx1, int dy1));
int pl_capmod_r ___P((plPlotter *plotter, ___const char *s));
int pl_circlerel_r ___P((plPlotter *plotter, int dx, int dy, int r));
int pl_closepath_r ___P((plPlotter *plotter));
int pl_color_r ___P((plPlotter *plotter, int red, int green, int blue));
int pl_colorname_r ___P((plPlotter *plotter, ___const char *name));
int pl_contrel_r ___P((plPlotter *plotter, int x, int y));
int pl_ellarc_r ___P((plPlotter *plotter, int xc, int yc, int x0, int y0, int x1, int y1));
int pl_ellarcrel_r ___P((plPlotter *plotter, int dxc, int dyc, int dx0, int dy0, int dx1, int dy1));
int pl_ellipse_r ___P((plPlotter *plotter, int x, int y, int rx, int ry, int angle));
int pl_ellipserel_r ___P((plPlotter *plotter, int dx, int dy, int rx, int ry, int angle));
int pl_endpath_r ___P((plPlotter *plotter));
int pl_endsubpath_r ___P((plPlotter *plotter));
int pl_fillcolor_r ___P((plPlotter *plotter, int red, int green, int blue));
int pl_fillcolorname_r ___P((plPlotter *plotter, ___const char *name));
int pl_fillmod_r ___P((plPlotter *plotter, ___const char *s));
int pl_filltype_r ___P((plPlotter *plotter, int level));
int pl_flushpl_r ___P((plPlotter *plotter));
int pl_fontname_r ___P((plPlotter *plotter, ___const char *s));
int pl_fontsize_r ___P((plPlotter *plotter, int size));
int pl_havecap_r ___P((plPlotter *plotter, ___const char *s));
int pl_joinmod_r ___P((plPlotter *plotter, ___const char *s));
int pl_labelwidth_r ___P((plPlotter *plotter, ___const char *s));
int pl_linedash_r ___P((plPlotter *plotter, int n, const int *dashes, int offset));
int pl_linerel_r ___P((plPlotter *plotter, int dx0, int dy0, int dx1, int dy1));
int pl_linewidth_r ___P((plPlotter *plotter, int size));
int pl_marker_r ___P((plPlotter *plotter, int x, int y, int type, int size));
int pl_markerrel_r ___P((plPlotter *plotter, int dx, int dy, int type, int size));
int pl_moverel_r ___P((plPlotter *plotter, int x, int y));
int pl_orientation_r ___P((plPlotter *plotter, int direction));
int pl_pencolor_r ___P((plPlotter *plotter, int red, int green, int blue));
int pl_pencolorname_r ___P((plPlotter *plotter, ___const char *name));
int pl_pentype_r ___P((plPlotter *plotter, int level));
int pl_pointrel_r ___P((plPlotter *plotter, int dx, int dy));
int pl_restorestate_r ___P((plPlotter *plotter));
int pl_savestate_r ___P((plPlotter *plotter));
int pl_space2_r ___P((plPlotter *plotter, int x0, int y0, int x1, int y1, int x2, int y2));
int pl_textangle_r ___P((plPlotter *plotter, int angle));

/* 32 floating point counterparts to some of the above (all GNU additions) */
double pl_ffontname_r ___P((plPlotter *plotter, ___const char *s));
double pl_ffontsize_r ___P((plPlotter *plotter, double size));
double pl_flabelwidth_r ___P((plPlotter *plotter, ___const char *s));
double pl_ftextangle_r ___P((plPlotter *plotter, double angle));
int pl_farc_r ___P((plPlotter *plotter, double xc, double yc, double x0, double y0, double x1, double y1));
int pl_farcrel_r ___P((plPlotter *plotter, double dxc, double dyc, double dx0, double dy0, double dx1, double dy1));
int pl_fbezier2_r ___P((plPlotter *plotter, double x0, double y0, double x1, double y1, double x2, double y2));
int pl_fbezier2rel_r ___P((plPlotter *plotter, double dx0, double dy0, double dx1, double dy1, double dx2, double dy2));
int pl_fbezier3_r ___P((plPlotter *plotter, double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3));
int pl_fbezier3rel_r ___P((plPlotter *plotter, double dx0, double dy0, double dx1, double dy1, double dx2, double dy2, double dx3, double dy3));
int pl_fbox_r ___P((plPlotter *plotter, double x0, double y0, double x1, double y1));
int pl_fboxrel_r ___P((plPlotter *plotter, double dx0, double dy0, double dx1, double dy1));
int pl_fcircle_r ___P((plPlotter *plotter, double x, double y, double r));
int pl_fcirclerel_r ___P((plPlotter *plotter, double dx, double dy, double r));
int pl_fcont_r ___P((plPlotter *plotter, double x, double y));
int pl_fcontrel_r ___P((plPlotter *plotter, double dx, double dy));
int pl_fellarc_r ___P((plPlotter *plotter, double xc, double yc, double x0, double y0, double x1, double y1));
int pl_fellarcrel_r ___P((plPlotter *plotter, double dxc, double dyc, double dx0, double dy0, double dx1, double dy1));
int pl_fellipse_r ___P((plPlotter *plotter, double x, double y, double rx, double ry, double angle));
int pl_fellipserel_r ___P((plPlotter *plotter, double dx, double dy, double rx, double ry, double angle));
int pl_flinedash_r ___P((plPlotter *plotter, int n, const double *dashes, double offset));
int pl_fline_r ___P((plPlotter *plotter, double x0, double y0, double x1, double y1));
int pl_flinerel_r ___P((plPlotter *plotter, double dx0, double dy0, double dx1, double dy1));
int pl_flinewidth_r ___P((plPlotter *plotter, double size));
int pl_fmarker_r ___P((plPlotter *plotter, double x, double y, int type, double size));
int pl_fmarkerrel_r ___P((plPlotter *plotter, double dx, double dy, int type, double size));
int pl_fmove_r ___P((plPlotter *plotter, double x, double y));
int pl_fmoverel_r ___P((plPlotter *plotter, double dx, double dy));
int pl_fpoint_r ___P((plPlotter *plotter, double x, double y));
int pl_fpointrel_r ___P((plPlotter *plotter, double dx, double dy));
int pl_fspace_r ___P((plPlotter *plotter, double x0, double y0, double x1, double y1));
int pl_fspace2_r ___P((plPlotter *plotter, double x0, double y0, double x1, double y1, double x2, double y2));

/* 6 floating point operations with no integer counterpart (GNU additions) */
int pl_fconcat_r ___P((plPlotter *plotter, double m0, double m1, double m2, double m3, double m4, double m5));
int pl_fmiterlimit_r ___P((plPlotter *plotter, double limit));
int pl_frotate_r ___P((plPlotter *plotter, double theta));
int pl_fscale_r ___P((plPlotter *plotter, double x, double y));
int pl_fsetmatrix_r ___P((plPlotter *plotter, double m0, double m1, double m2, double m3, double m4, double m5));
int pl_ftranslate_r ___P((plPlotter *plotter, double x, double y));

/* THE OLD (non-thread-safe) C API */

/* 3 functions specific to the old C API.  (For construction/destruction
   and selection of Plotters, and setting of Plotter parameters.  The fact
   that a single Plotter is globally `selected' makes the old API
   non-thread-safe.) */
int pl_newpl ___P((___const char *type, FILE *infile, FILE *outfile, FILE *errfile));
int pl_selectpl ___P((int handle));
int pl_deletepl ___P((int handle));

/* A function for setting parameters of Plotters that will subsequently be
   created.  This also makes the old API non-thread-safe. */
#ifdef NO_VOID_SUPPORT
int pl_parampl ___P((___const char *parameter, char *value));
#else
int pl_parampl ___P((___const char *parameter, void *value));
#endif

/* THE PLOTTER METHODS */
/* In the old API, the Plotter to be acted on is specified by first calling 
   selectpl(). */

/* 13 functions in traditional (pre-GNU) libplot */
int pl_arc ___P((int xc, int yc, int x0, int y0, int x1, int y1));
int pl_box ___P((int x0, int y0, int x1, int y1));
int pl_circle ___P((int x, int y, int r));
int pl_closepl ___P((void));
int pl_cont ___P((int x, int y));
int pl_erase ___P((void));
int pl_label ___P((___const char *s));
int pl_line ___P((int x0, int y0, int x1, int y1));
int pl_linemod ___P((___const char *s));
int pl_move ___P((int x, int y));
int pl_openpl ___P((void));
int pl_point ___P((int x, int y));
int pl_space ___P((int x0, int y0, int x1, int y1));

/* 46 additional functions in GNU libplot, plus 1 obsolete function
   [pl_outfile]. */
FILE* pl_outfile ___P((FILE* outfile));/* OBSOLETE */
int pl_alabel ___P((int x_justify, int y_justify, ___const char *s));
int pl_arcrel ___P((int dxc, int dyc, int dx0, int dy0, int dx1, int dy1));
int pl_bezier2 ___P((int x0, int y0, int x1, int y1, int x2, int y2));
int pl_bezier2rel ___P((int dx0, int dy0, int dx1, int dy1, int dx2, int dy2));
int pl_bezier3 ___P((int x0, int y0, int x1, int y1, int x2, int y2, int x3, int y3));
int pl_bezier3rel ___P((int dx0, int dy0, int dx1, int dy1, int dx2, int dy2, int dx3, int dy3));
int pl_bgcolor ___P((int red, int green, int blue));
int pl_bgcolorname ___P((___const char *name));
int pl_boxrel ___P((int dx0, int dy0, int dx1, int dy1));
int pl_capmod ___P((___const char *s));
int pl_circlerel ___P((int dx, int dy, int r));
int pl_closepath ___P((void));
int pl_color ___P((int red, int green, int blue));
int pl_colorname ___P((___const char *name));
int pl_contrel ___P((int x, int y));
int pl_ellarc ___P((int xc, int yc, int x0, int y0, int x1, int y1));
int pl_ellarcrel ___P((int dxc, int dyc, int dx0, int dy0, int dx1, int dy1));
int pl_ellipse ___P((int x, int y, int rx, int ry, int angle));
int pl_ellipserel ___P((int dx, int dy, int rx, int ry, int angle));
int pl_endpath ___P((void));
int pl_endsubpath ___P((void));
int pl_fillcolor ___P((int red, int green, int blue));
int pl_fillcolorname ___P((___const char *name));
int pl_fillmod ___P((___const char *s));
int pl_filltype ___P((int level));
int pl_flushpl ___P((void));
int pl_fontname ___P((___const char *s));
int pl_fontsize ___P((int size));
int pl_havecap ___P((___const char *s));
int pl_joinmod ___P((___const char *s));
int pl_labelwidth ___P((___const char *s));
int pl_linedash ___P((int n, const int *dashes, int offset));
int pl_linerel ___P((int dx0, int dy0, int dx1, int dy1));
int pl_linewidth ___P((int size));
int pl_marker ___P((int x, int y, int type, int size));
int pl_markerrel ___P((int dx, int dy, int type, int size));
int pl_moverel ___P((int x, int y));
int pl_orientation ___P((int direction));
int pl_pencolor ___P((int red, int green, int blue));
int pl_pencolorname ___P((___const char *name));
int pl_pentype ___P((int level));
int pl_pointrel ___P((int dx, int dy));
int pl_restorestate ___P((void));
int pl_savestate ___P((void));
int pl_space2 ___P((int x0, int y0, int x1, int y1, int x2, int y2));
int pl_textangle ___P((int angle));

/* 32 floating point counterparts to some of the above (all GNU additions) */
double pl_ffontname ___P((___const char *s));
double pl_ffontsize ___P((double size));
double pl_flabelwidth ___P((___const char *s));
double pl_ftextangle ___P((double angle));
int pl_farc ___P((double xc, double yc, double x0, double y0, double x1, double y1));
int pl_farcrel ___P((double dxc, double dyc, double dx0, double dy0, double dx1, double dy1));
int pl_fbezier2 ___P((double x0, double y0, double x1, double y1, double x2, double y2));
int pl_fbezier2rel ___P((double dx0, double dy0, double dx1, double dy1, double dx2, double dy2));
int pl_fbezier3 ___P((double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3));
int pl_fbezier3rel ___P((double dx0, double dy0, double dx1, double dy1, double dx2, double dy2, double dx3, double dy3));
int pl_fbox ___P((double x0, double y0, double x1, double y1));
int pl_fboxrel ___P((double dx0, double dy0, double dx1, double dy1));
int pl_fcircle ___P((double x, double y, double r));
int pl_fcirclerel ___P((double dx, double dy, double r));
int pl_fcont ___P((double x, double y));
int pl_fcontrel ___P((double dx, double dy));
int pl_fellarc ___P((double xc, double yc, double x0, double y0, double x1, double y1));
int pl_fellarcrel ___P((double dxc, double dyc, double dx0, double dy0, double dx1, double dy1));
int pl_fellipse ___P((double x, double y, double rx, double ry, double angle));
int pl_fellipserel ___P((double dx, double dy, double rx, double ry, double angle));
int pl_flinedash ___P((int n, const double *dashes, double offset));
int pl_fline ___P((double x0, double y0, double x1, double y1));
int pl_flinerel ___P((double dx0, double dy0, double dx1, double dy1));
int pl_flinewidth ___P((double size));
int pl_fmarker ___P((double x, double y, int type, double size));
int pl_fmarkerrel ___P((double dx, double dy, int type, double size));
int pl_fmove ___P((double x, double y));
int pl_fmoverel ___P((double dx, double dy));
int pl_fpoint ___P((double x, double y));
int pl_fpointrel ___P((double dx, double dy));
int pl_fspace ___P((double x0, double y0, double x1, double y1));
int pl_fspace2 ___P((double x0, double y0, double x1, double y1, double x2, double y2));

/* 6 floating point operations with no integer counterpart (GNU additions) */
int pl_fconcat ___P((double m0, double m1, double m2, double m3, double m4, double m5));
int pl_fmiterlimit ___P((double limit));
int pl_frotate ___P((double theta));
int pl_fscale ___P((double x, double y));
int pl_fsetmatrix ___P((double m0, double m1, double m2, double m3, double m4, double m5));
int pl_ftranslate ___P((double x, double y));


/* UNDOCUMENTED FONT API CALLS */
/* These are used by the graphics programs in the plotutils package (e.g.,
   `graph') to access the font tables within libplot, so that the user can
   be given lists of font names. */

#ifdef NO_VOID_SUPPORT
char * pl_get_hershey_font_info ___P((plPlotter *plotter));
char * pl_get_ps_font_info ___P((plPlotter *plotter));
char * pl_get_pcl_font_info ___P((plPlotter *plotter));
char * pl_get_stick_font_info ___P((plPlotter *plotter));
#else
void * pl_get_hershey_font_info ___P((plPlotter *plotter));
void * pl_get_ps_font_info ___P((plPlotter *plotter));
void * pl_get_pcl_font_info ___P((plPlotter *plotter));
void * pl_get_stick_font_info ___P((plPlotter *plotter));
#endif

___END_DECLS

/* THE GLOBAL VARIABLES IN GNU LIBPLOT */
/* There are two: user-settable error handlers (not yet documented). */
extern int (*libplot_warning_handler) ___P((___const char *msg));
extern int (*libplot_error_handler) ___P((___const char *msg));

#undef ___const
#undef ___P


/***********************************************************************/

/* Useful definitions, included in both plot.h and plotter.h. */

#ifndef _PL_LIBPLOT_USEFUL_DEFS
#define _PL_LIBPLOT_USEFUL_DEFS 1

/* Symbol types for the marker() function, extending over the range 0..31.
   (1 through 5 are the same as in the GKS [Graphical Kernel System].)

   These are now defined as enums rather than ints.  Cast them to ints if
   necessary. */
enum 
{ M_NONE, M_DOT, M_PLUS, M_ASTERISK, M_CIRCLE, M_CROSS, 
  M_SQUARE, M_TRIANGLE, M_DIAMOND, M_STAR, M_INVERTED_TRIANGLE, 
  M_STARBURST, M_FANCY_PLUS, M_FANCY_CROSS, M_FANCY_SQUARE, 
  M_FANCY_DIAMOND, M_FILLED_CIRCLE, M_FILLED_SQUARE, M_FILLED_TRIANGLE, 
  M_FILLED_DIAMOND, M_FILLED_INVERTED_TRIANGLE, M_FILLED_FANCY_SQUARE,
  M_FILLED_FANCY_DIAMOND, M_HALF_FILLED_CIRCLE, M_HALF_FILLED_SQUARE,
  M_HALF_FILLED_TRIANGLE, M_HALF_FILLED_DIAMOND,
  M_HALF_FILLED_INVERTED_TRIANGLE, M_HALF_FILLED_FANCY_SQUARE,
  M_HALF_FILLED_FANCY_DIAMOND, M_OCTAGON, M_FILLED_OCTAGON 
};

/* ONE-BYTE OPERATION CODES FOR GNU METAFILE FORMAT. These are now defined
   as enums rather than ints.  Cast them to ints if necessary.

   There are 85 currently recognized op codes.  The first 10 date back to
   Unix plot(5) format. */

enum
{  
/* 10 op codes for primitive graphics operations, as in Unix plot(5) format. */
  O_ARC		=	'a',  
  O_CIRCLE	=	'c',  
  O_CONT	=	'n',
  O_ERASE	=	'e',
  O_LABEL	=	't',
  O_LINEMOD	=	'f',
  O_LINE	=	'l',
  O_MOVE	=	'm',
  O_POINT	=	'p',
  O_SPACE	=	's',
  
/* 42 op codes that are GNU extensions */
  O_ALABEL	=	'T',
  O_ARCREL	=	'A',
  O_BEZIER2	=       'q',
  O_BEZIER2REL	=       'r',
  O_BEZIER3	=       'y',
  O_BEZIER3REL	=       'z',
  O_BGCOLOR	=	'~',
  O_BOX		=	'B',	/* not an op code in Unix plot(5) */
  O_BOXREL	=	'H',
  O_CAPMOD	=	'K',
  O_CIRCLEREL	=	'G',
  O_CLOSEPATH	=	'k',
  O_CLOSEPL	=	'x',	/* not an op code in Unix plot(5) */
  O_COMMENT	=	'#',
  O_CONTREL	=	'N',
  O_ELLARC	=	'?',
  O_ELLARCREL	=	'/',
  O_ELLIPSE	=	'+',
  O_ELLIPSEREL	=	'=',
  O_ENDPATH	=	'E',
  O_ENDSUBPATH	=	']',
  O_FILLTYPE	=	'L',
  O_FILLCOLOR	=	'D',
  O_FILLMOD	=	'g',
  O_FONTNAME	=	'F',
  O_FONTSIZE	=	'S',
  O_JOINMOD	=	'J',
  O_LINEDASH	= 	'd',
  O_LINEREL	=	'I',
  O_LINEWIDTH	=	'W',
  O_MARKER	=	'Y',
  O_MARKERREL	=	'Z',
  O_MOVEREL	=	'M',
  O_OPENPL	=	'o',	/* not an op code in Unix plot(5) */
  O_ORIENTATION	=	'b',
  O_PENCOLOR	=	'-',
  O_PENTYPE	=	'h',
  O_POINTREL	=	'P',
  O_RESTORESTATE=	'O',
  O_SAVESTATE	=	'U',
  O_SPACE2	=	':',
  O_TEXTANGLE	=	'R',

/* 30 floating point counterparts to many of the above.  They are not even
   slightly mnemonic. */
  O_FARC	=	'1',
  O_FARCREL	=	'2',
  O_FBEZIER2	=       '`',
  O_FBEZIER2REL	=       '\'',
  O_FBEZIER3	=       ',',
  O_FBEZIER3REL	=       '.',
  O_FBOX	=	'3',
  O_FBOXREL	=	'4',
  O_FCIRCLE	=	'5',
  O_FCIRCLEREL	=	'6',
  O_FCONT	=	')',
  O_FCONTREL	=	'_',
  O_FELLARC	=	'}',
  O_FELLARCREL	=	'|',
  O_FELLIPSE	=	'{',
  O_FELLIPSEREL	=	'[',
  O_FFONTSIZE	=	'7',
  O_FLINE	=	'8',
  O_FLINEDASH	= 	'w',
  O_FLINEREL	=	'9',
  O_FLINEWIDTH	=	'0',
  O_FMARKER	=	'!',
  O_FMARKERREL	=	'@',
  O_FMOVE	=	'$',
  O_FMOVEREL	=	'%',
  O_FPOINT	=	'^',
  O_FPOINTREL	=	'&',
  O_FSPACE	=	'*',
  O_FSPACE2	=	';',
  O_FTEXTANGLE	=	'(',

/* 3 op codes for floating point operations with no integer counterpart */
  O_FCONCAT		=	'\\',
  O_FMITERLIMIT		=	'i',
  O_FSETMATRIX		=	'j'
};

#endif /* not _PL_LIBPLOT_USEFUL_DEFS */

/***********************************************************************/

#endif /* not _PLOT_H_ */
