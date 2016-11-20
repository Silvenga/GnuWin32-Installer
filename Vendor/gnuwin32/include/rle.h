/*
 * This software is copyrighted as noted below.  It may be freely copied,
 * modified, and redistributed, provided that the copyright notice is 
 * preserved on all copies.
 * 
 * There is no warranty or other guarantee of fitness for this software,
 * it is provided solely "as is".  Bug reports or fixes may be sent
 * to the author, who may or may not act on them as he desires.
 *
 * You may not include this software in a program or other software product
 * without supplying the source, or without informing the end-user that the 
 * source is available for no extra charge.
 *
 * If you modify this software, you should include a notice giving the
 * name of the person performing the modification, the date of modification,
 * and the reason for such modification.
 */
/* 
 * rle.h - Global declarations for Utah Raster Toolkit RLE programs.
 * 
 * Author:	Todd W. Fuqua
 * 		Computer Science Dept.
 * 		University of Utah
 * Date:	Sun Jul 29 1984
 * Copyright (c) 1984 Todd W. Fuqua
 * 
 * $Id: rle.h,v 3.0.1.5 1992/04/30 14:05:56 spencer Exp $
 */

#ifndef RLE_H
#define RLE_H

#include "rle_config.h"		/* Configuration parameters. */

#include <stdio.h>		/* Declare FILE. */

#include "urtimpexp.h"

#ifdef c_plusplus
#define USE_PROTOTYPES
#endif
#ifndef CONST_DECL
#define CONST_DECL
#endif

enum rle_dispatch {
    NO_DISPATCH = -1,
    RUN_DISPATCH = 0
};

/* ****************************************************************
 * TAG( rle_pixel rle_map )
 *
 * Typedef for 8-bit (or less) pixel data.
 *
 * Typedef for 16-bit color map data.
 */
typedef unsigned char rle_pixel;
typedef unsigned short rle_map;

/*
 * Defines for traditional channel numbers.
 */
#define	RLE_RED		0	/* Red channel traditionally here. */
#define RLE_GREEN	1	/* Green channel traditionally here. */
#define	RLE_BLUE	2	/* Blue channel traditionally here. */
#define RLE_ALPHA      -1	/* Alpha channel here. */

/*
 * Return values from rle_get_setup.
 */
#define	RLE_SUCCESS	 0
#define	RLE_NOT_RLE	-1
#define	RLE_NO_SPACE	-2
#define	RLE_EMPTY	-3
#define	RLE_EOF		-4

/*
 * "Magic" value for is_init field.  Pi * 2^29.
 */
#define RLE_INIT_MAGIC	0x6487ED51L

/*****************************************************************
 * TAG( RLE_CHECK_ALLOC )
 *
 * Test for allocation failure, scream and die if so.
 */
#define RLE_CHECK_ALLOC( pgm, ptr, name )				\
    ( !(ptr) ?	rle_alloc_error( pgm, name ) : 0 )

/*
 * TAG( rle_hdr )
 *
 * Definition of header structure used by RLE routines.
 */

#ifndef c_plusplus
typedef
#endif
struct rle_hdr {
    enum 	rle_dispatch dispatch;	/* Type of file to create. */
    int	    	ncolors,	/* Number of color channels. */
	       *bg_color,	/* Pointer to bg color vector. */
	    	alpha,		/* If !0, save alpha channel. */
	    	background,	/* 0->just save all pixels, */
				/* 1->overlay, 2->clear to bg first. */
	    	xmin,		/* Lower X bound (left.) */
	    	xmax,		/* Upper X bound (right.) */
	    	ymin,		/* Lower Y bound (bottom.) */
	    	ymax,		/* Upper Y bound (top.) */
	    	ncmap,		/* Number of color channels in color map. */
				/* Map only saved if != 0. */
	    	cmaplen;	/* Log2 of color map length. */
    rle_map    *cmap;		/* Pointer to color map array. */
    CONST_DECL char **comments;	/* Pointer to array of pointers to comments. */
    FILE       *rle_file;	/* Input or output file. */
    /* 
     * Bit map of channels to read/save.  Indexed by (channel mod 256).
     * Alpha channel sets bit 255.
     * 
     * Indexing (0 <= c <= 255):
     *	    bits[c/8] & (1 << (c%8))
     */
#define RLE_SET_BIT(glob,bit) \
     ((glob).bits[((bit)&0xff)/8] |= (1<<((bit)&0x7)))
#define RLE_CLR_BIT(glob,bit) \
	((glob).bits[((bit)&0xff)/8] &= ~(1<<((bit)&0x7)))
#define RLE_BIT(glob,bit) \
	((glob).bits[((bit)&0xff)/8] & (1<<((bit)&0x7)))
    char    bits[256/8];
    /* Set to magic pattern if following fields are initialized. */
    /* This gives a 2^(-32) chance of missing. */
    long int is_init;	
    /* Save the command, file name and image number for error messages. */
    CONST_DECL char *cmd;
    CONST_DECL char *file_name;
    int img_num;
    /* 
     * Local storage for rle_getrow & rle_putrow.
     * rle_getrow has
     *	    scan_y	int	    current Y scanline.
     *	    vert_skip	int	    number of lines to skip.
     * rle_putrow has
     *	    nblank	int	    number of blank lines.
     *	    brun	short(*)[2] Array of background runs.
     *	    fileptr	long	    Position in output file.
     */
     union {
	struct {
	    int	scan_y,
		vert_skip;
	    char is_eof,	/* Set when EOF or EofOp encountered. */
		is_seek;	/* If true, can seek input file. */
	} get;
	struct {
	    int	nblank;
	    short (*brun)[2];
	    long fileptr;
	} put;
     } priv;
}
#ifndef c_plusplus
rle_hdr				/* End of typedef. */
#endif
;

/* 
 * TAG( rle_dflt_hdr )
 *
 * Global variable with possibly useful default values.
 */
URT_DLL_IMPEXP rle_hdr rle_dflt_hdr;


/* Declare RLE library routines. */

#ifdef USE_PROTOTYPES
    /* From rle_error.c. */
    /*****************************************************************
     * TAG( rle_alloc_error )
     * 
     * Print memory allocation error message and exit.
     */
    URT_DLL_IMPEXP int rle_alloc_error( CONST_DECL char *pgm,
				  CONST_DECL char *name );

    /*****************************************************************
     * TAG( rle_get_error )
     *
     * Print an error message based on the error code returned by
     * rle_get_setup.
     */
    URT_DLL_IMPEXP int rle_get_error( int code,
			      CONST_DECL char *pgmname,
			      CONST_DECL char *fname );
			  
    /* From rle_getrow.c */

    /*****************************************************************
     * TAG( rle_debug )
     * 
     * Turn RLE debugging on or off.
     */
    URT_DLL_IMPEXP void rle_debug( int on_off );

    /*****************************************************************
     * TAG( rle_get_setup )
     */
    URT_DLL_IMPEXP int rle_get_setup( rle_hdr *the_hdr );

    /*****************************************************************
     * TAG( rle_get_setup_ok )
     *
     * Call rle_get_setup.  If it returns an error code, call
     * rle_get_error to print the error message, then exit with the error
     * code. 
     */
    URT_DLL_IMPEXP void rle_get_setup_ok( rle_hdr *the_hdr,
				  CONST_DECL char *prog_name,
				  CONST_DECL char *file_name);

    /*****************************************************************
     * TAG( rle_getrow )
     *
     * Read a scanline worth of data from an RLE file.
     */
    URT_DLL_IMPEXP int rle_getrow( rle_hdr * the_hdr, 
			   rle_pixel * scanline[] );

    /* From rle_getskip.c */

    /*****************************************************************
     * TAG( rle_getskip )
     * Skip a scanline, return the number of the next one.
     */
    URT_DLL_IMPEXP unsigned int rle_getskip( rle_hdr *the_hdr );

    /* From rle_hdr.c. */

    /*****************************************************************
     * TAG( rle_names )
     *
     * Load the command and file names into the rle_hdr.
     */
    URT_DLL_IMPEXP void rle_names( rle_hdr *the_hdr,
			   CONST_DECL char *pgmname,
			   CONST_DECL char *fname,
			   int img_num );

    /*****************************************************************
     * TAG( rle_hdr_cp )
     * 
     * Make a "safe" copy of a rle_hdr structure.
     */
    URT_DLL_IMPEXP rle_hdr * rle_hdr_cp( rle_hdr *from_hdr,
				 rle_hdr *to_hdr );

    /*****************************************************************
     * TAG( rle_hdr_init )
     * 
     * Initialize a rle_hdr structure.
     */
    URT_DLL_IMPEXP rle_hdr * rle_hdr_init( rle_hdr *the_hdr );

    /*****************************************************************
     * TAG( rle_hdr_clear )
     * 
     */
    URT_DLL_IMPEXP void rle_hdr_clear( rle_hdr *the_hdr );

    /* From rle_putrow.c. */

    /*****************************************************************
     * TAG( rgb_to_bw )
     *
     * Converts RGB data to gray data via the NTSC Y transform.
     */
    URT_DLL_IMPEXP void rgb_to_bw( rle_pixel *red_row,
			   rle_pixel *green_row,
			   rle_pixel *blue_row,
			   rle_pixel *bw_row,
			   int rowlen );

    /*****************************************************************
     * TAG( rle_puteof )
     *
     * Write an End-of-image opcode to the RLE file.
     */
    URT_DLL_IMPEXP void rle_puteof( rle_hdr *the_hdr );

    /*****************************************************************
     * TAG( rle_putrow )
     *
     * Write a scanline of data to the RLE file.
     */
    URT_DLL_IMPEXP void rle_putrow( rle_pixel *rows[], int rowlen, rle_hdr *the_hdr );

    /*****************************************************************
     * TAG( rle_put_init )
     *
     * Initialize header for output, but don't write it to the file.
     */
    URT_DLL_IMPEXP void rle_put_init( rle_hdr * the_hdr );

    /*****************************************************************
     * TAG( rle_put_setup )
     *
     * Write header information to a new RLE image file.
     */
    URT_DLL_IMPEXP void rle_put_setup( rle_hdr * the_hdr );

    /*****************************************************************
     * TAG( rle_skiprow )
     *
     * Skip nrow scanlines in the output file.
     */
    URT_DLL_IMPEXP void rle_skiprow( rle_hdr *the_hdr, int nrow );

    /* From rle_cp.c */
    /*****************************************************************
     * TAG( rle_cp )
     * Copy image data from input to output with minimal interpretation.
     */
    URT_DLL_IMPEXP void rle_cp( rle_hdr *in_hdr, rle_hdr *out_hdr );

    /* From rle_row_alc.c. */
    /*****************************************************************
     * TAG( rle_row_alloc )
     *
     * Allocate scanline memory for use by rle_getrow.
     */
    URT_DLL_IMPEXP int rle_row_alloc( rle_hdr * the_hdr,
			      rle_pixel *** scanp );

    /*****************************************************************
     * TAG( rle_row_free )
     *
     * Free the above.
     */
    URT_DLL_IMPEXP void rle_row_free( rle_hdr *the_hdr, rle_pixel **scanp );

    /* From buildmap.c. */
    /* 
     * buildmap - build a more usable colormap from data in the_hdr struct.
     */
    URT_DLL_IMPEXP rle_pixel **buildmap( rle_hdr *the_hdr,
				 int minmap,
				 double orig_gamma,
				 double new_gamma );

    /* From rle_getcom.c. */
    /*****************************************************************
     * TAG( rle_getcom )
     *
     * Get a specific comment from the image comments.
     */
    URT_DLL_IMPEXP char * rle_getcom( CONST_DECL char * name, rle_hdr * the_hdr );

    /* From rle_putcom.c. */
    /*****************************************************************
     * TAG( rle_delcom )
     *
     * Delete a specific comment from the image comments.
     */
    URT_DLL_IMPEXP CONST_DECL char *
    rle_delcom( CONST_DECL char * name, rle_hdr * the_hdr );

    /*****************************************************************
     * TAG( rle_putcom )
     * 
     * Put (or replace) a comment into the image comments.
     */
    URT_DLL_IMPEXP CONST_DECL char *
    rle_putcom( CONST_DECL char * value, rle_hdr * the_hdr );

    /* From dither.c. */
    /*****************************************************************
     * TAG( bwdithermap )
     * Create a color map for ordered dithering in grays.
     */
    URT_DLL_IMPEXP void bwdithermap( int levels, double gamma, int bwmap[],
			     int divN[256], int modN[256], int magic[16][16] );
    /*****************************************************************
     * TAG( ditherbw )
     * Dither a gray-scale value.
     */
    URT_DLL_IMPEXP int ditherbw( int x, int y, int val, 
			 int divN[256], int modN[256], int magic[16][16] );
    /*****************************************************************
     * TAG( dithergb )
     * Dither a color value.
     */
    URT_DLL_IMPEXP int dithergb( int x, int y, int r, int g, int b,
			 int divN[256], int modN[256], int magic[16][16] );
    /*****************************************************************
     * TAG( dithermap )
     * Create a color map for ordered dithering in color.
     */
    URT_DLL_IMPEXP void dithermap( int levels, double gamma, int rgbmap[][3],
			   int divN[256], int modN[256], int magic[16][16] );
    /*****************************************************************
     * TAG( make_square )
     * Make a 16x16 magic square for ordered dithering.
     */
    URT_DLL_IMPEXP void make_square( double N, int divN[256], int modN[256],
			     int magic[16][16] );

    /* From float_to_exp.c. */
    /*****************************************************************
     * TAG( float_to_exp )
     * Convert a list of floating point numbers to "exp" format.
     */
    URT_DLL_IMPEXP void float_to_exp( int count, float * floats, rle_pixel * pixels );

    /* From rle_open_f.c. */
    /*****************************************************************
     * TAG( rle_open_f )
     *
     * Open an input/output file with default.
     */
     URT_DLL_IMPEXP FILE *
     rle_open_f(const char * prog_name, const char * file_name, 
                const char * mode);

    /*****************************************************************
     * TAG( rle_open_f_noexit )
     *
     * Open an input/output file with default.
     */
    URT_DLL_IMPEXP FILE *
    rle_open_f_noexit(const char * prog_name, const char * file_name, 
                      const char * mode );

    /*****************************************************************
     * TAG( rle_close_f )
     * 
     * Close a file opened by rle_open_f.  If the file is stdin or stdout,
     * it will not be closed.
     */
    URT_DLL_IMPEXP void 
    rle_close_f( FILE *fd );

    /* From colorquant.c. */
    /*****************************************************************
     * TAG( colorquant )
     * Compute a colormap for quantizing an image to a limited set of colors.
     */
    URT_DLL_IMPEXP int colorquant( rle_pixel *red, rle_pixel *green, rle_pixel *blue,
			   unsigned long pixels, rle_pixel *colormap[3],
			   int colors, int bits,
                         rle_pixel *rgbmap, int fast, int otherimages );

    /* From rle_addhist.c. */
    /*****************************************************************
     * TAG( rle_addhist )
     * Append history information to the HISTORY comment.
     */
    URT_DLL_IMPEXP void rle_addhist( char *argv[],
			     rle_hdr *in_hdr,
			     rle_hdr *out_hdr );

    /* From cmd_name.c. */
    /*****************************************************************
     * TAG( cmd_name )
     * Extract command name from argv.
     */
    URT_DLL_IMPEXP char *cmd_name( char **argv );

    /* From scanargs.c. */
    /*****************************************************************
     * TAG( scanargs )
     * Scan command argument list and parse arguments.
     */
    URT_DLL_IMPEXP int scanargs( int argc,
			 char **argv,
			 CONST_DECL char *format,
			 ... );

    /* From hilbert.c */
    /*****************************************************************
     * TAG( hilbert_i2c )
     * Convert an index into a Hilbert curve to a set of coordinates.
     */
    URT_DLL_IMPEXP void hilbert_c2i( int n, int m, int a[], long int *r );

    /*****************************************************************
     * TAG( hilbert_c2i )
     * Convert coordinates of a point on a Hilbert curve to its index.
     */
    URT_DLL_IMPEXP void hilbert_i2c( int n, int m, long int r, int a[] );

    /* From inv_cmap.c */
    /*****************************************************************
     * TAG( inv_cmap )
     * Compute an inverse colormap efficiently.
     */
    URT_DLL_IMPEXP void inv_cmap( int colors,
			  unsigned char *colormap[3],
			  int bits,
			  unsigned long *dist_buf,
			  unsigned char *rgbmap );

#else /* USE_PROTOTYPES */
    /* Return value decls for "K&R" C.  See above for full descriptions. */
    /* From rle_error.c. */
    URT_DLL_IMPEXP int rle_alloc_error();
    URT_DLL_IMPEXP int rle_get_error();

    /* From rle_getrow.c. */
    URT_DLL_IMPEXP void rle_debug();
    URT_DLL_IMPEXP int rle_get_setup();
    URT_DLL_IMPEXP void rle_get_setup_ok();
    URT_DLL_IMPEXP int rle_getrow();

    /* From rle_getskip.c */
    URT_DLL_IMPEXP unsigned int rle_getskip();

    /* From rle_hdr.c */
    URT_DLL_IMPEXP void rle_names();
    URT_DLL_IMPEXP rle_hdr *rle_hdr_cp();
    URT_DLL_IMPEXP rle_hdr *rle_hdr_init();
    URT_DLL_IMPEXP void rle_hdr_clear();

    /* From rle_putrow.c. */
    URT_DLL_IMPEXP void rgb_to_bw();
    URT_DLL_IMPEXP void rle_puteof();
    URT_DLL_IMPEXP void rle_putrow();
    URT_DLL_IMPEXP void rle_put_init();
    URT_DLL_IMPEXP void rle_put_setup();
    URT_DLL_IMPEXP void rle_skiprow();

    /* From rle_cp.c */
    URT_DLL_IMPEXP void rle_cp();

    /* From rle_row_alc.c. */
    URT_DLL_IMPEXP int rle_row_alloc();
    URT_DLL_IMPEXP void rle_row_free();

    /* From buildmap.c. */
    URT_DLL_IMPEXP rle_pixel **buildmap();
    
    /* From rle_getcom.c. */
    URT_DLL_IMPEXP char *rle_getcom();

    /* From rle_putcom.c. */
    URT_DLL_IMPEXP char *rle_delcom();
    URT_DLL_IMPEXP char *rle_putcom();

    /* From dither.c. */
    URT_DLL_IMPEXP void bwdithermap();
    URT_DLL_IMPEXP int ditherbw();
    URT_DLL_IMPEXP int dithergb();
    URT_DLL_IMPEXP void dithermap();
    URT_DLL_IMPEXP void magic4x4();
    URT_DLL_IMPEXP void make_square();

    /* From float_to_exp.c. */
    URT_DLL_IMPEXP void float_to_exp();

    /* From rle_open_f.c. */
    URT_DLL_IMPEXP FILE *rle_open_f();
    URT_DLL_IMPEXP FILE *rle_open_f_noexit();
    URT_DLL_IMPEXP void rle_close_f( );

    /* From colorquant.c. */
    URT_DLL_IMPEXP int colorquant();

    /* From rle_addhist.c. */
    URT_DLL_IMPEXP void rle_addhist();

    /* From cmd_name.c. */
    URT_DLL_IMPEXP char *cmd_name();

    /* From scanargs.c. */
    URT_DLL_IMPEXP int scanargs();

    /* From hilbert.c */
    URT_DLL_IMPEXP void hilbert_c2i();
    URT_DLL_IMPEXP void hilbert_i2c();

    /* From inv_cmap.c */
    URT_DLL_IMPEXP void inv_cmap();

#endif /* USE_PROTOTYPES */

#endif /* RLE_H */
