/*
 *  Compface - 48x48x1 image compression and decompression
 *
 *  Copyright (c) James Ashton - Sydney University - June 1990.
 *
 *  Written 11th November 1989.
 *
 *  Permission is given to distribute these sources, as long as the
 *  copyright messages are not removed, and no monies are exchanged. 
 *
 *  No responsibility is taken for any errors on inaccuracies inherent
 *  either to the comments or the code of this program, but if reported
 *  to me, then an attempt will be made to fix them.
 */

#ifndef COMPFACE_H
#define COMPFACE_H

#include <setjmp.h>
#include <errno.h>

/* For all function declarations, if ANSI then use a prototype. */

#if  defined(__STDC__)
#define P(args)  args
#else  /* ! __STDC__ */
#define P(args)  ()
#endif  /* STDC */

#ifndef __GNUC__
# define __DLL_IMPORT__  __declspec(dllimport)
# define __DLL_EXPORT__  __declspec(dllexport)
#else
# define __DLL_IMPORT__  __attribute__((dllimport)) extern
# define __DLL_EXPORT__  __attribute__((dllexport)) extern
#endif 

#if (defined __WIN32__) || (defined _WIN32)
# ifdef BUILD_COMPFACE_DLL
#  define COMPFACE_DLL_IMPEXP     __DLL_EXPORT__
# elif defined(BUILD_COMPFACE_STATIC)
#  define COMPFACE_DLL_IMPEXP      
# elif defined (USE_COMPFACE_DLL)
#  define COMPFACE_DLL_IMPEXP     __DLL_IMPORT__
# elif defined (USE_COMPFACE_STATIC)
#  define COMPFACE_DLL_IMPEXP      
# else /* assume USE_COMPFACE_DLL */
#  define COMPFACE_DLL_IMPEXP     __DLL_IMPORT__
# endif
#else /* __WIN32__ */
# define COMPFACE_DLL_IMPEXP  
#endif

/* need to know how many bits per hexadecimal digit for io */
#define BITSPERDIG 4
extern char HexDigits[];

/* define the face size - 48x48x1 */
#define WIDTH 48
#define HEIGHT WIDTH

/* total number of pixels and digits */
#define PIXELS (WIDTH * HEIGHT)
#define DIGITS (PIXELS / BITSPERDIG)

/* internal face representation - 1 char per pixel is faster */
extern char F[PIXELS];

COMPFACE_DLL_IMPEXP int compface_xbitmap;

/* output formatting word lengths and line lengths */
#define DIGSPERWORD 4
#define WORDSPERLINE (WIDTH / DIGSPERWORD / BITSPERDIG)

/* compressed output uses the full range of printable characters.
 * in ascii these are in a contiguous block so we just need to know
 * the first and last.  The total number of printables is needed too */
#define FIRSTPRINT '!'
#define LASTPRINT '~'
#define NUMPRINTS (LASTPRINT - FIRSTPRINT + 1)

/* output line length for compressed data */
#define MAXLINELEN 78

/* Portable, very large unsigned integer arithmetic is needed.
 * Implementation uses arrays of WORDs.  COMPs must have at least
 * twice as many bits as WORDs to handle intermediate results */
#define WORD unsigned char
#define COMP unsigned long
#define BITSPERWORD 8
#define WORDCARRY (1 << BITSPERWORD)
#define WORDMASK (WORDCARRY - 1)
#define MAXWORDS ((PIXELS * 2 + BITSPERWORD - 1) / BITSPERWORD)

typedef struct bigint
{
	int b_words;
	WORD b_word[MAXWORDS];
} BigInt;

extern BigInt B;

/* This is the guess the next pixel table.  Normally there are 12 neighbour
 * pixels used to give 1<<12 cases but in the upper left corner lesser
 * numbers of neighbours are available, leading to 6231 different guesses */
typedef struct guesses
{
	char g_00[1<<12];
	char g_01[1<<7];
	char g_02[1<<2];
	char g_10[1<<9];
	char g_20[1<<6];
	char g_30[1<<8];
	char g_40[1<<10];
	char g_11[1<<5];
	char g_21[1<<3];
	char g_31[1<<5];
	char g_41[1<<6];
	char g_12[1<<1];
	char g_22[1<<0];
	char g_32[1<<2];
	char g_42[1<<2];
} Guesses;

/* data.h was established by sampling over 1000 faces and icons */
extern Guesses G;

/* Data of varying probabilities are encoded by a value in the range 0 - 255.
 * The probability of the data determines the range of possible encodings.
 * Offset gives the first possible encoding of the range */
typedef struct prob
{
	WORD p_range;
	WORD p_offset;
} Prob;

/* A stack of probability values */
extern Prob *ProbBuf[PIXELS * 2];
extern int NumProbs;

/* Each face is encoded using 9 octrees of 16x16 each.  Each level of the
 * trees has varying probabilities of being white, grey or black.
 * The table below is based on sampling many faces */

#define BLACK 0
#define GREY 1
#define WHITE 2

extern Prob levels[4][3];

/* At the bottom of the octree 2x2 elements are considered black if any
 * pixel is black.  The probabilities below give the distribution of the
 * 16 possible 2x2 patterns.  All white is not really a possibility and
 * has a probability range of zero.  Again, experimentally derived data */
extern Prob freqs[16];

#define ERR_OK		0	/* successful completion */
#define ERR_EXCESS	1	/* completed OK but some input was ignored */
#define ERR_INSUFF	-1	/* insufficient input.  Bad face format? */
#define ERR_INTERNAL	-2	/* Arithmetic overflow or buffer overflow */

extern int status;


extern jmp_buf comp_env;

extern int AllBlack P((char *, int, int)) ;
extern int AllWhite P((char *, int, int)) ;
extern int BigPop P((Prob *)) ;
extern int compface P((char *)) ;
extern int main P((int, char *[])) ;
extern int ReadBuf P(()) ;
extern int Same P((char *, int, int)) ;
COMPFACE_DLL_IMPEXP int uncompface P((char *)) ;
extern int WriteBuf P(()) ;

extern void BigAdd P((unsigned char)) ;
extern void BigClear P(()) ;
extern void BigDiv P((unsigned char, unsigned char *)) ;
extern void BigMul P((unsigned char)) ;
extern void BigPrint P(()) ;
extern void BigPush P((Prob *)) ;
extern void BigRead P((char *)) ;
extern void BigSub P((unsigned int)) ;
extern void BigWrite P((char *)) ;
COMPFACE_DLL_IMPEXP void CompAll P((char *)) ;
COMPFACE_DLL_IMPEXP void Compress P((char *, int, int, int)) ;
COMPFACE_DLL_IMPEXP void GenFace P(()) ;
extern void PopGreys P((char *, int, int)) ;
extern void PushGreys P((char *, int, int)) ;
COMPFACE_DLL_IMPEXP void ReadFace P((char *)) ;
extern void RevPush P((Prob *)) ;
COMPFACE_DLL_IMPEXP void UnCompAll P((char *)) ;
COMPFACE_DLL_IMPEXP void UnCompress P((char *, int, int, int)) ;
COMPFACE_DLL_IMPEXP void UnGenFace P(()) ;
COMPFACE_DLL_IMPEXP void WriteFace P((char *)) ;
#endif /*COMPFACE_H*/
