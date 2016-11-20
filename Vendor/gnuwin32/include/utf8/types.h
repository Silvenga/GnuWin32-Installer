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

#ifndef _UTF8_TYPES_H
#define _UTF8_TYPES_H

/* Include all possible include files which could define wchar_t, wint_t,
   WCHAR_MIN, WCHAR_MAX and WEOF. */
#include <stddef.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdint.h>
#include <wchar.h>
#include <wctype.h>


#if defined(LIBUTF8_PLUG)
/* This is needed if we want to use the system's wchar_t, wint_t. */

/* Get size_t, wchar_t, wint_t and NULL from <stddef.h>. */
#include <stddef.h>

/* We try to get wint_t from <stddef.h>, but not all GCC versions define it
   there.  So define it ourselves if it remains undefined.  */
#ifndef _WINT_T
/* Integral type unchanged by default argument promotions that can
   hold any value corresponding to members of the extended character
   set, as well as at least one value that does not correspond to any
   member of the extended character set.  */
# define _WINT_T
typedef unsigned int wint_t;
#endif

#ifndef WCHAR_MIN
/* These constants might also be defined in <inttypes.h>.  */
# define WCHAR_MIN ((wchar_t) 0)
# define WCHAR_MAX (~WCHAR_MIN)
#endif

/* Constant expression of type `wint_t' whose value does not correspond
   to any member of the extended character set.  */
#ifndef WEOF
# define WEOF (0xffffffffu)
#endif

/* Get definitions of WCHAR_T_BITS and U_WCHAR_T. */
#include <utf8/config.h>

#else
/* Here we define wchar_t and wint_t ourselves. */

#if 1
/* Use 16-bit Unicode, if locale_is_utf8. This does not cover 100% of the
   standards, but it is more space-saving than 32-bit Unicode.
   If !locale_is_utf8, then every `wchar_t' contains only an `unsigned char',
   in the current locale's encoding (which is not necessarily ISO-8859-1!). */
#undef wchar_t
#define wchar_t utf8_wchar_t
typedef unsigned short wchar_t;
#define WCHAR_T_BITS 16
#else
/* Use 32-bit Unicode. This wastes a lot of space.
   If !locale_is_utf8, then every `wchar_t' contains only an `unsigned char',
   in the current locale's encoding (which is not necessarily ISO-8859-1!). */
#undef wchar_t
#define wchar_t utf8_wchar_t
typedef unsigned int wchar_t;
#define WCHAR_T_BITS 32
#endif

/* Integral type unchanged by default argument promotions that can
   hold any value corresponding to members of the extended character
   set, as well as at least one value that does not correspond to any
   member of the extended character set.  */
#undef wint_t
#define wint_t utf8_wint_t
typedef unsigned int wint_t;

#undef WCHAR_MIN
#undef WCHAR_MAX
#define WCHAR_MIN ((wchar_t) 0)
#define WCHAR_MAX (~WCHAR_MIN)

/* Constant expression of type `wint_t' whose value does not correspond
   to any member of the extended character set.  */
#ifndef WEOF
# define WEOF (0xffffffffu)
#endif

/* Unsigned version of the `wchar_t' type. */
#define u_wchar_t wchar_t

#endif


#endif /* _UTF8_TYPES_H */
