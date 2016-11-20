
/*
 * Copyright (C) Yves Arrouye <Yves.Arrouye@marin.fdn.fr>, 1996.
 *
 * Use under the GPL version 2. You are not allowed to remove this
 * copyright notice.
 *
 */

#ifndef PAPER_H
#define PAPER_H

/*
 * systempapername() returns the preferred paper size got from either the
 *   PAPER environment variable or the /etc/papersize file. If 0 is
 *   returned, one should use the value of defaultpapername().
 *
 * paperinfo() looks from the given paper name in a table of known sizes
 *   and returns 0 if it found it; if this is the case, the width and
 *   height arguments have been set to the correct values in points (one
 *   inch contains 72 points). The case of paper size is not significant.
 *
 */

#if __STDC__ - 0 == 0

#define __PAPER_CONST
#define __PAPER_PROTO(p)	()

#else

#define __PAPER_CONST		const
#define __PAPER_PROTO(p)	p

#endif

#ifdef _WIN32
# define USLETTER_NR	"1"
# define USLEGAL_NR		"5"
# define A3_NR			"8"
# define A4_NR			"9"
# define USLETTER_STR	"Letter"
# define USLEGAL_STR	"Legal"
# define A3_STR			"A3"
# define A4_STR			"A4"
#endif /* _WIN32 */

#ifndef __GNUC__
# define __DLL_IMPORT__	__declspec(dllimport)
# define __DLL_EXPORT__	__declspec(dllexport)
#else
# define __DLL_IMPORT__	__attribute__((dllimport)) extern
# define __DLL_EXPORT__	__attribute__((dllexport)) extern
#endif 

#if (defined __WIN32__) || (defined _WIN32)
# ifdef BUILD_LIBPAPER_DLL
#  define LIBPAPER_DLL_IMPEXP	__DLL_EXPORT__
# elif defined(LIBPAPER_STATIC)
#  define LIBPAPER_DLL_IMPEXP	 
# elif defined (USE_LIBPAPER_DLL)
#  define LIBPAPER_DLL_IMPEXP	__DLL_IMPORT__
# elif defined (USE_LIBPAPER_STATIC)
#  define LIBPAPER_DLL_IMPEXP 	 
# else /* assume USE_LIBPAPER_DLL */
#  define LIBPAPER_DLL_IMPEXP	__DLL_IMPORT__
# endif
#else /* __WIN32__ */
# define LIBPAPER_DLL_IMPEXP	 
#endif

#ifdef __cplusplus
extern "C" {
#endif

struct paper;

LIBPAPER_DLL_IMPEXP int paperinit __PAPER_PROTO((void));
LIBPAPER_DLL_IMPEXP int paperdone __PAPER_PROTO((void));

LIBPAPER_DLL_IMPEXP __PAPER_CONST char* papername __PAPER_PROTO((const struct paper*));
LIBPAPER_DLL_IMPEXP double paperpswidth __PAPER_PROTO((const struct paper*));
LIBPAPER_DLL_IMPEXP double paperpsheight __PAPER_PROTO((const struct paper*));

LIBPAPER_DLL_IMPEXP __PAPER_CONST char* defaultpapersizefile __PAPER_PROTO((void));
LIBPAPER_DLL_IMPEXP __PAPER_CONST char* systempapersizefile __PAPER_PROTO((void));
LIBPAPER_DLL_IMPEXP __PAPER_CONST char* defaultpapername __PAPER_PROTO((void));
LIBPAPER_DLL_IMPEXP char* systempapername __PAPER_PROTO((void));
LIBPAPER_DLL_IMPEXP __PAPER_CONST struct paper* paperinfo __PAPER_PROTO((const char*));
LIBPAPER_DLL_IMPEXP __PAPER_CONST struct paper* paperwithsize __PAPER_PROTO((
    double pswidth, double psheight));

LIBPAPER_DLL_IMPEXP __PAPER_CONST struct paper* paperfirst __PAPER_PROTO((void));
LIBPAPER_DLL_IMPEXP __PAPER_CONST struct paper* paperlast __PAPER_PROTO((void));
LIBPAPER_DLL_IMPEXP __PAPER_CONST struct paper* papernext __PAPER_PROTO((
    const struct paper*));
LIBPAPER_DLL_IMPEXP __PAPER_CONST struct paper* paperprev __PAPER_PROTO((
    const struct paper*));

#undef __PAPER_CONST
#undef __PAPER_PROTO

#ifdef __cplusplus
}
#endif

#endif

