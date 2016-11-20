/* Copyright (C) 1999-2000 Free Software Foundation, Inc.
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

#ifndef _UTF8_WCHAR_H
#define _UTF8_WCHAR_H

/* Get FILE definition. */
#include <stdio.h>

/* Define wchar_t and wint_t. */
#include <utf8/types.h>

/* Get errno declaration and values. */
#include <errno.h>
/* Some systems, like SunOS 4, don't have EILSEQ. On these systems, define
   EILSEQ ourselves, but don't define it as EINVAL, because iconv() callers
   want to distinguish EINVAL and EILSEQ. */
#ifndef EILSEQ
#define EILSEQ ENOENT
#endif

/* Conversion state information. */
/*
   In ISO C 89 + Amendment 1, a state was *not* a partially accumulated
   UTF-8 character, or empty, because the Dinkumware C library manual for
   mbsrtowcs and wcsrtombs says that these functions proceed by treating
   entire wide characters one at a time:
   "The function effectively increments dst by x and *src by one after each
    call to wcrtomb that stores a complete converted multibyte character in
    the remaining space available."
   And neither 8-bit locales nor UTF-8 have "shift state", i.e. state between
   complete converted characters.

   But in ISO C 99, this has changed:
   7.24.6 paragraph 4 says:
   "On entry, each function takes the described conversion state (either
    internal or pointed to by an argument) as current. The conversion state
    described by the pointed-to object is altered as needed to track the shift
    state, and the position within a multibyte character, for the associated
    multibyte character sequence."
   7.24.6.3.2, the description of mbrtowc's return value, says:
   "(size_t)(-2)  if the next n bytes contribute to an incomplete (but
    potentially valid) multibyte character, and all n bytes have been
    processed (no value is stored)."
   Note the words "contribute to" (not "start"!) and "processed" (not
   "examined"!).
 */
#ifdef LIBUTF8_PLUG
/* This struct must not be larger than the platform's native mbstate_t. */
#endif
typedef struct
{
#if WCHAR_T_BITS == 32
  unsigned int count;        /* number of bytes remaining to be processed */
  unsigned int value;        /* if count > 0: partial wide character */
#else
  unsigned int count : 16;   /* number of bytes remaining to be processed */
  unsigned int value : 16;   /* if count > 0: partial wide character */
#endif
/* If WCHAR_T_BITS == 32, need 3 bits for count,
   30 bits for value (25 for mbstowcs direction, 30 for wcstombs direction).
   If WCHAR_T_BITS == 16, need 2 bits for count,
   12 bits for value (10 for mbstowcs direction, 12 for wcstombs direction). */
} utf8_mbstate_t;
#ifndef LIBUTF8_PLUG
#define mbstate_t utf8_mbstate_t
#endif


#ifdef __cplusplus
extern "C" {
#endif


/* Copy SRC to DEST. */
#ifndef LIBUTF8_PLUG
#define wcscpy utf8_wcscpy
#endif
extern wchar_t* wcscpy (wchar_t* dest, const wchar_t* src);

/* Copy no more than N wide-characters of SRC to DEST. */
#ifndef LIBUTF8_PLUG
#define wcsncpy utf8_wcsncpy
#endif
extern wchar_t* wcsncpy (wchar_t* dest, const wchar_t* src, size_t n);

/* Append SRC onto DEST. */
#ifndef LIBUTF8_PLUG
#define wcscat utf8_wcscat
#endif
extern wchar_t* wcscat (wchar_t* dest, const wchar_t* src);

/* Append no more than N wide-characters of SRC onto DEST. */
#ifndef LIBUTF8_PLUG
#define wcsncat utf8_wcsncat
#endif
extern wchar_t* wcsncat (wchar_t* dest, const wchar_t* src, size_t n);

/* Compare S1 and S2. */
#ifndef LIBUTF8_PLUG
#define wcscmp utf8_wcscmp
#endif
extern int wcscmp (const wchar_t* s1, const wchar_t* s2);

/* Compare no more than N wide-characters of S1 and S2. */
#ifndef LIBUTF8_PLUG
#define wcsncmp utf8_wcsncmp
#endif
extern int wcsncmp (const wchar_t* s1, const wchar_t* s2, size_t n);

/* GNU extension. */
/* Compare S1 and S2, ignoring case. */
#ifndef LIBUTF8_PLUG
#define wcscasecmp utf8_wcscasecmp
#endif
extern int wcscasecmp (const wchar_t* s1, const wchar_t* s2);

/* GNU extension. */
/* Compare no more than N chars of S1 and S2, ignoring case. */
#ifndef LIBUTF8_PLUG
#define wcsncasecmp utf8_wcsncasecmp
#endif
extern int wcsncasecmp (const wchar_t* s1, const wchar_t* s2, size_t n);

#if 0

/* Compare S1 and S2, both interpreted as appropriate to the LC_COLLATE
   category of the current locale. */
#ifndef LIBUTF8_PLUG
#define wcscoll utf8_wcscoll
#endif
extern int wcscoll (const wchar_t* s1, const wchar_t* s2);

/* Transform S2 into array pointed to by S1 such that if wcscmp is applied
   to two transformed strings the result is the as applying `wcscoll' to the
   original strings. */
#ifndef LIBUTF8_PLUG
#define wcsxfrm utf8_wcsxfrm
#endif
extern size_t wcsxfrm (wchar_t* s1, const wchar_t* s2, size_t n);

#endif

/* GNU extension. */
/* Duplicate S, returning an identical malloc'd string. */
#ifndef LIBUTF8_PLUG
#define wcsdup utf8_wcsdup
#endif
extern wchar_t* wcsdup (const wchar_t* s);

/* Find the first occurrence of WC in WCS. */
#ifndef LIBUTF8_PLUG
#define wcschr utf8_wcschr
#endif
extern wchar_t* wcschr (const wchar_t* wcs, wchar_t wc);

/* Find the last occurrence of WC in WCS. */
#ifndef LIBUTF8_PLUG
#define wcsrchr utf8_wcsrchr
#endif
extern wchar_t* wcsrchr (const wchar_t* wcs, wchar_t wc);

/* Return the length of the initial segmet of WCS which consists entirely
   of wide characters not in REJECT. */
#ifndef LIBUTF8_PLUG
#define wcscspn utf8_wcscspn
#endif
extern size_t wcscspn (const wchar_t* wcs, const wchar_t* reject);

/* Return the length of the initial segmet of WCS which consists entirely
   of wide characters in ACCEPT. */
#ifndef LIBUTF8_PLUG
#define wcsspn utf8_wcsspn
#endif
extern size_t wcsspn (const wchar_t* wcs, const wchar_t* accept);

/* Find the first occurrence in WCS of any character in ACCEPT. */
#ifndef LIBUTF8_PLUG
#define wcspbrk utf8_wcspbrk
#endif
extern wchar_t* wcspbrk (const wchar_t* wcs, const wchar_t* accept);

/* Find the first occurrence of NEEDLE in HAYSTACK. */
#ifndef LIBUTF8_PLUG
#define wcsstr utf8_wcsstr
#endif
extern wchar_t* wcsstr (const wchar_t* haystack, const wchar_t* needle);

/* Divide WCS into tokens separated by characters in DELIM. */
#ifndef LIBUTF8_PLUG
#undef wcstok /* already defined on Solaris */
#define wcstok utf8_wcstok
#endif
extern wchar_t* wcstok (wchar_t* wcs, const wchar_t* delim, wchar_t** ptr);

/* Return the number of wide characters in S. */
#ifndef LIBUTF8_PLUG
#define wcslen utf8_wcslen
#endif
extern size_t wcslen (const wchar_t* s);

/* GNU extension. */
/* Return the number of wide characters in S, but at most MAXLEN. */
#ifndef LIBUTF8_PLUG
#define wcsnlen utf8_wcsnlen
#endif
extern size_t wcsnlen (const wchar_t* s, size_t maxlen);


/* Search N wide characters of S for C. */
#ifndef LIBUTF8_PLUG
#define wmemchr utf8_wmemchr
#endif
extern wchar_t* wmemchr (const wchar_t* s, wchar_t c, size_t n);

/* Compare N wide characters of S1 and S2. */
#ifndef LIBUTF8_PLUG
#define wmemcmp utf8_wmemcmp
#endif
extern int wmemcmp (const wchar_t* s1, const wchar_t* s2, size_t n);

/* Copy N wide characters of SRC to DEST.  */
#ifndef LIBUTF8_PLUG
#define wmemcpy utf8_wmemcpy
#endif
extern wchar_t* wmemcpy (wchar_t* dest, const wchar_t* src, size_t n);

/* Copy N wide characters of SRC to DEST, guaranteeing correct behavior for
   overlapping memory areas.  */
#ifndef LIBUTF8_PLUG
#define wmemmove utf8_wmemmove
#endif
extern wchar_t* wmemmove (wchar_t* dest, const wchar_t* src, size_t n);

/* Set N wide characters of S to C. */
#ifndef LIBUTF8_PLUG
#define wmemset utf8_wmemset
#endif
extern wchar_t* wmemset (wchar_t* s, wchar_t c, size_t n);


/* Determine whether C constitutes a valid (one-byte) multibyte character. */
#ifndef LIBUTF8_PLUG
#define btowc utf8_btowc
#endif
extern wint_t btowc (int c);

/* Determine whether C corresponds to a member of the extended character set
   whose multibyte representation is a single byte. */
#ifndef LIBUTF8_PLUG
#define wctob utf8_wctob
#endif
extern int wctob (wint_t c);

/* Determine whether PS points to an object representing the initial state. */
#ifndef LIBUTF8_PLUG
#define mbsinit utf8_mbsinit
#endif
extern int mbsinit (const mbstate_t* ps);

/* Write wide character representation of multibyte character pointed to by S
   to PWC. */
#ifndef LIBUTF8_PLUG
#define mbrtowc utf8_mbrtowc
#endif
extern size_t mbrtowc (wchar_t* pwc, const char* s, size_t n, mbstate_t* ps);

/* Write multibyte representation of wide character WC to S. */
#ifndef LIBUTF8_PLUG
#define wcrtomb utf8_wcrtomb
#endif
extern size_t wcrtomb (char* s, wchar_t wc, mbstate_t* ps);

/* Return number of bytes in multibyte character pointed to by S. */
#ifndef LIBUTF8_PLUG
#define mbrlen utf8_mbrlen
#endif
extern size_t mbrlen (const char* s, size_t n, mbstate_t* ps);

/* Write wide character representation of multibyte character string SRC
   to DEST. */
#ifndef LIBUTF8_PLUG
#define mbsrtowcs utf8_mbsrtowcs
#endif
extern size_t mbsrtowcs (wchar_t* dest, const char** src, size_t len, mbstate_t* ps);

/* Write multibyte character representation of wide character string SRC
   to DEST. */
#ifndef LIBUTF8_PLUG
#define wcsrtombs utf8_wcsrtombs
#endif
extern size_t wcsrtombs (char* dest, const wchar_t** src, size_t len, mbstate_t* ps);

/* GNU extension. */
/* Write wide character representation of at most NMC bytes of the multibyte
   character string SRC to DEST. */
#ifndef LIBUTF8_PLUG
#define mbsnrtowcs utf8_mbsnrtowcs
#endif
extern size_t mbsnrtowcs (wchar_t* dest, const char** src, size_t nms, size_t len, mbstate_t* ps);

/* GNU extension. */
/* Write multibyte character representation of at most NWC characters from
   the wide character string SRC to DEST. */
#ifndef LIBUTF8_PLUG
#define wcsnrtombs utf8_wcsnrtombs
#endif
extern size_t wcsnrtombs (char* dest, const wchar_t** src, size_t nwc, size_t len, mbstate_t* ps);

/* X/Open extension. */
/* Determine number of column positions required for C. */
#ifndef LIBUTF8_PLUG
#define wcwidth utf8_wcwidth
#endif
#if defined(LIBUTF8_PLUG) && defined(__sun) /* Solaris 2.7 */
extern int wcwidth (const wchar_t c);
#else
extern int wcwidth (wint_t c);
#endif

/* X/Open extension. */
/* Determine number of column positions required for first N wide characters
   (or fewer if S ends before this) in S. */
#ifndef LIBUTF8_PLUG
#define wcswidth utf8_wcswidth
#endif
extern int wcswidth (const wchar_t* s, size_t n);

/* Convert initial portion of the wide string NPTR to `float'
   representation. */
#ifndef LIBUTF8_PLUG
#define wcstof utf8_wcstof
#endif
extern float wcstof (const wchar_t* nptr, wchar_t** endptr);

/* Convert initial portion of the wide string NPTR to `double'
   representation. */
#ifndef LIBUTF8_PLUG
#define wcstod utf8_wcstod
#endif
extern double wcstod (const wchar_t* nptr, wchar_t** endptr);

#if 1
/* Convert initial portion of the wide string NPTR to `long double'
   representation. */
#ifndef LIBUTF8_PLUG
#define wcstold utf8_wcstold
#endif
extern long double wcstold (const wchar_t* nptr, wchar_t** endptr);
#endif

/* Convert initial portion of wide string NPTR to `long int'
   representation. */
#ifndef LIBUTF8_PLUG
#define wcstol utf8_wcstol
#endif
extern long int wcstol (const wchar_t* nptr, wchar_t** endptr, int base);

/* Convert initial portion of wide string NPTR to `unsigned long int'
   representation. */
#ifndef LIBUTF8_PLUG
#define wcstoul utf8_wcstoul
#endif
extern unsigned long int wcstoul (const wchar_t* nptr, wchar_t** endptr, int base);

#if 1
/* Convert initial portion of wide string NPTR to `long long int'
   representation. */
#ifndef LIBUTF8_PLUG
#define wcstoll utf8_wcstoll
#endif
extern long long int wcstoll (const wchar_t* nptr, wchar_t** endptr, int base);
#endif

#if 1
/* Convert initial portion of wide string NPTR to `unsigned long long int'
   representation. */
#ifndef LIBUTF8_PLUG
#define wcstoull utf8_wcstoull
#endif
extern unsigned long long int wcstoull (const wchar_t* nptr, wchar_t** endptr, int base);
#endif

/* GNU extension. */
/* Copy SRC to DEST, returning the address of the terminating L'\0' in DEST. */
#ifndef LIBUTF8_PLUG
#define wcpcpy utf8_wcpcpy
#endif
extern wchar_t* wcpcpy (wchar_t* dest, const wchar_t* src);

/* GNU extension. */
/* Copy no more than N characters of SRC to DEST, returning the address of
   the last character written into DEST. */
#ifndef LIBUTF8_PLUG
#define wcpncpy utf8_wcpncpy
#endif
extern wchar_t* wcpncpy (wchar_t* dest, const wchar_t* src, size_t n);


/* Reads the next wide character from STREAM, and returns it. Returns WEOF
   when end-of-file is reached or an error is encountered. */
#ifndef LIBUTF8_PLUG
#undef fgetwc /* already defined on Solaris */
#define fgetwc utf8_fgetwc
#endif
extern wint_t fgetwc (FILE* stream);
#undef getwc /* already defined on Solaris */
#define getwc fgetwc

/* Reads the next wide character from stdin, and returns it. Returns WEOF
   when end-of-file is reached or an error is encountered. */
#ifndef LIBUTF8_PLUG
#undef getwchar /* already defined on Solaris */
#define getwchar utf8_getwchar
#endif
#if defined(LIBUTF8_PLUG) && defined(__osf__)
#undef getwchar /* already defined on OSF/1 */
#endif
extern wint_t getwchar (void);

/* Reads a line of wide characters from STREAM. WS points to a buffer for
   N wide characters. At most N-1 wide characters will be read, stopping
   after the first seen newline character. A null wide character will be
   appended. Then WS is returned. If no wide character could be read from
   STREAM, or if an error is encountered, NULL is returned.
   Note: This function is unreliable, because it does not permit to deal
   properly with null wide characters that may be present in the input. */
#ifndef LIBUTF8_PLUG
#undef fgetws /* already defined on Solaris */
#define fgetws utf8_fgetws
#endif
extern wchar_t* fgetws (wchar_t* ws, int n, FILE* stream);

/* Pushes back a wide character onto STREAM. Returns WC if successful, or
   WEOF if WC is WEOF or when an error is encountered. */
#ifndef LIBUTF8_PLUG
#undef ungetwc /* already defined on Solaris */
#define ungetwc utf8_ungetwc
#endif
extern wint_t ungetwc (wint_t wc, FILE* stream);


/* Writes WC to STREAM. Returns WC if successful, or WEOF when an error is
   encountered. */
#ifndef LIBUTF8_PLUG
#undef fputwc /* already defined on Solaris */
#define fputwc utf8_fputwc
#endif
#if defined(LIBUTF8_PLUG) && defined(__sun) /* Solaris 2.7 */
extern wint_t fputwc (wint_t wc, FILE* stream);
#else
extern wint_t fputwc (wchar_t wc, FILE* stream);
#endif
#undef putwc /* already defined on Solaris */
#define putwc fputwc

/* Writes WC to stdout. Returns WC if successful, or WEOF when an error is
   encountered. */
#ifndef LIBUTF8_PLUG
#undef putwchar /* already defined on Solaris */
#define putwchar utf8_putwchar
#endif
#if defined(LIBUTF8_PLUG) && defined(__osf__)
#undef putwchar /* already defined on OSF/1 */
#endif
#if defined(LIBUTF8_PLUG) && defined(__sun) /* Solaris 2.7 */
extern wint_t putwchar (wint_t wc);
#else
extern wint_t putwchar (wchar_t wc);
#endif

/* Writes the contents of the wide string WS, up to but not including the
   terminating null wide character, to STREAM. Returns a nonnegative integer
   if successful, or -1 in case of error. */
#ifndef LIBUTF8_PLUG
#undef fputws /* already defined on Solaris */
#define fputws utf8_fputws
#endif
extern int fputws (const wchar_t* ws, FILE* stream);


/* If MODE != 0, attempts to change the orientation of STREAM. Then returns
   the orientation of STREAM. */
#ifndef LIBUTF8_PLUG
#define fwide utf8_fwide
#endif
extern int fwide (FILE* stream, int mode);


#ifdef __cplusplus
}
#endif

#endif /* _UTF8_WCHAR_H */
