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

#ifndef _UTF8_STDIO_H
#define _UTF8_STDIO_H

#include <stdio.h>
#include <stdarg.h>

#include <utf8/types.h>

#ifdef __cplusplus
extern "C" {
#endif


/* Write formatted output to STREAM. */
#ifndef LIBUTF8_PLUG
#define fprintf utf8_fprintf
#endif
extern int fprintf (FILE* stream, const char* format, ...);

/* Write formatted output to stdout. */
#ifndef LIBUTF8_PLUG
#define printf utf8_printf
#endif
extern int printf (const char* format, ...);

/* Write formatted output to string S. */
#ifndef LIBUTF8_PLUG
#define sprintf utf8_sprintf
#endif
extern int sprintf (char* s, const char* format, ...);

/* Write formatted output to string S, at most MAXLEN bytes. */
#ifndef LIBUTF8_PLUG
#define snprintf utf8_snprintf
#endif
extern int snprintf (char* s, size_t maxlen, const char* format, ...);

/* Write formatted output to STREAM. */
#ifndef LIBUTF8_PLUG
#define vfprintf utf8_vfprintf
#endif
extern int vfprintf (FILE* stream, const char* format, va_list args);

/* Write formatted output to stdout. */
#ifndef LIBUTF8_PLUG
#define vprintf utf8_vprintf
#endif
extern int vprintf (const char* format, va_list args);

/* Write formatted output to string S. */
#ifndef LIBUTF8_PLUG
#define vsprintf utf8_vsprintf
#endif
extern int vsprintf (char* s, const char* format, va_list args);

/* Write formatted output to string S, at most MAXLEN bytes. */
#ifndef LIBUTF8_PLUG
#define vsnprintf utf8_vsnprintf
#endif
extern int vsnprintf (char* s, size_t maxlen, const char* format, va_list args);


/* Write formatted output to STREAM. */
#ifndef LIBUTF8_PLUG
#define fwprintf utf8_fwprintf
#endif
extern int fwprintf (FILE* stream, const wchar_t* format, ...);

/* Write formatted output to stdout. */
#ifndef LIBUTF8_PLUG
#define wprintf utf8_wprintf
#endif
extern int wprintf (const wchar_t* format, ...);

/* Write formatted output to string S, at most MAXLEN bytes. */
#ifndef LIBUTF8_PLUG
#define swprintf utf8_swprintf
#endif
extern int swprintf (wchar_t* s, size_t maxlen, const wchar_t* format, ...);

/* Write formatted output to STREAM. */
#ifndef LIBUTF8_PLUG
#define vfwprintf utf8_vfwprintf
#endif
extern int vfwprintf (FILE* stream, const wchar_t* format, va_list args);

/* Write formatted output to stdout. */
#ifndef LIBUTF8_PLUG
#define vwprintf utf8_vwprintf
#endif
extern int vwprintf (const wchar_t* format, va_list args);

/* Write formatted output to string S, at most MAXLEN bytes. */
#ifndef LIBUTF8_PLUG
#define vswprintf utf8_vswprintf
#endif
extern int vswprintf (wchar_t* s, size_t maxlen, const wchar_t* format, va_list args);


#ifdef __cplusplus
}
#endif

#endif /* _UTF8_STDIO_H */
