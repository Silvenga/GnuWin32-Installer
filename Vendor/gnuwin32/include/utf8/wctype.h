/* Copyright (C) 1999 Free Software Foundation, Inc.
   This file is part of the GNU UTF-8 Library.

   The GNU UTF-8 Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public License as
   published by the Free Software Foundation; either version 2 of the
   License, or (at your option) any later version.

   The GNU UTF-8 Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with the GNU UTF-8 Library; see the file COPYING.LIB.  If not,
   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

#ifndef _UTF8_WCTYPE_H
#define _UTF8_WCTYPE_H

/* Define wchar_t and wint_t. */
#include <utf8/types.h>

/* Scalar type that can hold values which represent locale-specific
   character classifications. */
#define wctype_t utf8_wctype_t
#if defined(LIBUTF8_PLUG) && defined(__sun) /* Solaris 2.7 */
typedef int wctype_t;
#elif defined(LIBUTF8_PLUG) && defined(__osf__) /* OSF/1 4.0d */
typedef unsigned int wctype_t;
#else
typedef unsigned long int wctype_t;
#endif


#ifdef __cplusplus
extern "C" {
#endif


/* Test for any wide character for which `iswalpha' or `iswdigit' is true. */
#undef iswalnum
#ifndef LIBUTF8_PLUG
#define iswalnum utf8_iswalnum
#endif
extern int iswalnum (wint_t wc);

/* Test for any wide character for which `iswupper' or 'iswlower' is true,
   or any wide character that is one of a locale-specific set of
   wide-characters for which none of `iswcntrl', `iswdigit', `iswpunct',
   or `iswspace' is true. */
#undef iswalpha
#ifndef LIBUTF8_PLUG
#define iswalpha utf8_iswalpha
#endif
extern int iswalpha (wint_t wc);

/* Test for any control wide character. */
#undef iswcntrl
#ifndef LIBUTF8_PLUG
#define iswcntrl utf8_iswcntrl
#endif
extern int iswcntrl (wint_t wc);

/* Test for any wide character that corresponds to a decimal-digit
   character. */
#undef iswdigit
#ifndef LIBUTF8_PLUG
#define iswdigit utf8_iswdigit
#endif
extern int iswdigit (wint_t wc);

/* Test for any wide character for which `iswprint' is true and `iswspace'
   is false. */
#undef iswgraph
#ifndef LIBUTF8_PLUG
#define iswgraph utf8_iswgraph
#endif
extern int iswgraph (wint_t wc);

/* Test for any wide character that corresponds to a lowercase letter or is
   one of a locale-specific set of wide characters for which none of
   `iswcntrl', `iswdigit', `iswpunct', or `iswspace' is true. */
#undef iswlower
#ifndef LIBUTF8_PLUG
#define iswlower utf8_iswlower
#endif
extern int iswlower (wint_t wc);

/* Test for any printing wide character. */
#undef iswprint
#ifndef LIBUTF8_PLUG
#define iswprint utf8_iswprint
#endif
extern int iswprint (wint_t wc);

/* Test for any printing wide character that is one of a locale-specific set
   of wide characters for which neither `iswspace' nor `iswalnum' is true. */
#undef iswpunct
#ifndef LIBUTF8_PLUG
#define iswpunct utf8_iswpunct
#endif
extern int iswpunct (wint_t wc);

/* Test for any wide character that corresponds to a locale-specific set of
   wide characters for which none of `iswalnum', `iswgraph', or `iswpunct'
   is true. */
#undef iswspace
#ifndef LIBUTF8_PLUG
#define iswspace utf8_iswspace
#endif
extern int iswspace (wint_t wc);

/* Test for any wide character that corresponds to an uppercase letter or is
   one of a locale-specific set of wide character for which none of
   `iswcntrl', `iswdigit', `iswpunct', or `iswspace' is true. */
#undef iswupper
#ifndef LIBUTF8_PLUG
#define iswupper utf8_iswupper
#endif
extern int iswupper (wint_t wc);

/* Test for any wide character that corresponds to a hexadecimal-digit
   character equivalent to that performed be the functions described in the
   previous subclause. */
#undef iswxdigit
#ifndef LIBUTF8_PLUG
#define iswxdigit utf8_iswxdigit
#endif
extern int iswxdigit (wint_t wc);

/* GNU extension. */
/* Test for any wide character that corresponds to a standard blank wide
   character or a locale-specific set of wide characters for which `iswalnum'
   is false. */
#undef iswblank
#ifndef LIBUTF8_PLUG
#define iswblank utf8_iswblank
#endif
extern int iswblank (wint_t wc);


/* Construct value that describes a class of wide characters identified
   by the string argument PROPERTY. */
#ifndef LIBUTF8_PLUG
#define wctype utf8_wctype
#endif
extern wctype_t wctype (const char* property);

/* Determine whether the wide-character WC has the property described by
   DESC. */
#undef iswctype
#ifndef LIBUTF8_PLUG
#define iswctype utf8_iswctype
#endif
extern int iswctype (wint_t wc, wctype_t desc);


/* Scalar type that can hold values which represent locale-specific character
   mappings. */
typedef const short * const * utf8_wctrans_t;
#ifndef LIBUTF8_PLUG
#define wctrans_t utf8_wctrans_t
#endif

/* Converts an uppercase letter to the corresponding lowercase letter. */
#undef towlower
#ifndef LIBUTF8_PLUG
#define towlower utf8_towlower
#endif
extern wint_t towlower (wint_t wc);

/* Converts a lowercase letter to the corresponding uppercase letter.  */
#undef towupper
#ifndef LIBUTF8_PLUG
#define towupper utf8_towupper
#endif
extern wint_t towupper (wint_t wc);

/* Construct value that describes a mapping between wide characters
   identified by the string argument PROPERTY. */
#ifndef LIBUTF8_PLUG
#define wctrans utf8_wctrans
#endif
extern wctrans_t wctrans (const char* property);

/* Map the wide character WC using the mapping described by DESC. */
#ifndef LIBUTF8_PLUG
#define towctrans utf8_towctrans
#endif
extern wint_t towctrans (wint_t wc, wctrans_t desc);


#ifdef __cplusplus
}
#endif

#endif /* _UTF8_WCTYPE_H */
