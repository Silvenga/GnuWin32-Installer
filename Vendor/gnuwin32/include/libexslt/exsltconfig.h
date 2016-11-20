/*
 * exsltconfig.h: compile-time version informations for the EXSLT library
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 */

#ifndef __XML_EXSLTCONFIG_H__
#define __XML_EXSLTCONFIG_H__

#ifdef __cplusplus
extern "C" {
#endif

/**
 * LIBEXSLT_DOTTED_VERSION:
 *
 * the version string like "1.2.3"
 */
#define LIBEXSLT_DOTTED_VERSION "1.0.9"

/**
 * LIBEXSLT_VERSION:
 *
 * the version number: 1.2.3 value is 1002003
 */
#define LIBEXSLT_VERSION 702

/**
 * LIBEXSLT_VERSION_STRING:
 *
 * the version number string, 1.2.3 value is "1002003"
 */
#define LIBEXSLT_VERSION_STRING "702"

/**
 * ATTRIBUTE_UNUSED:
 *
 * This macro is used to flag unused function parameters to GCC
 */
#ifdef __GNUC__
#ifdef HAVE_ANSIDECL_H
#include <ansidecl.h>
#endif
#ifndef ATTRIBUTE_UNUSED
#define ATTRIBUTE_UNUSED
#endif
#else
#define ATTRIBUTE_UNUSED
#endif

/**
 * LIBEXSLT_PUBLIC:
 *
 * This macro is needed on Win32 when using MSVC. It enables the client code
 * to access exported variables. It should expand to nothing when compiling
 * this library itself, but must expand to __declspec(dllimport) when a
 * client includes the library header and that only if it links dynamically
 * against this library.
 */
#if !defined LIBEXSLT_PUBLIC
#if defined _MSC_VER && !defined IN_LIBEXSLT && !defined LIBEXSLT_STATIC
#define LIBEXSLT_PUBLIC __declspec(dllimport)
#else
#define LIBEXSLT_PUBLIC 
#endif
#endif

#ifdef __cplusplus
}
#endif

#endif /* __XML_EXSLTCONFIG_H__ */
