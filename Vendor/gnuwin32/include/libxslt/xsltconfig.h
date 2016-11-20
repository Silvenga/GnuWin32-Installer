/*
 * xsltconfig.h: compile-time version informations for the XSLT engine
 *
 * See Copyright for the status of this software.
 *
 * daniel@veillard.com
 */

#ifndef __XML_XSLTCONFIG_H__
#define __XML_XSLTCONFIG_H__

#ifdef __cplusplus
extern "C" {
#endif

/**
 * LIBXSLT_DOTTED_VERSION:
 *
 * the version string like "1.2.3"
 */
#define LIBXSLT_DOTTED_VERSION "1.0.9"

/**
 * LIBXSLT_VERSION:
 *
 * the version number: 1.2.3 value is 1002003
 */
#define LIBXSLT_VERSION 10009

/**
 * LIBXSLT_VERSION_STRING:
 *
 * the version number string, 1.2.3 value is "1002003"
 */
#define LIBXSLT_VERSION_STRING "10009"

/**
 * WITH_XSLT_DEBUG:
 *
 * Activate the compilation of the debug reporting. Speed penalty
 * is insignifiant and being able to run xsltpoc -v is useful. On
 * by default unless --without-debug is passed to configure
 */
#if 1
#define WITH_XSLT_DEBUG
#endif

#if 0
/**
 * DEBUG_MEMORY:
 *
 * should be activated only when debugging libxslt. It replaces the
 * allocator with a collect and debug shell to the libc allocator.
 * Use configure --with-mem-debug to activate it on both library
 */
#define DEBUG_MEMORY

/**
 * DEBUG_MEMORY_LOCATION:
 *
 * should be activated only when debugging libxslt.
 * DEBUG_MEMORY_LOCATION should be activated only when libxml has
 * been configured with --with-debug-mem too
 */
#define DEBUG_MEMORY_LOCATION
#endif

/**
 * WITH_XSLT_DEBUGGER:
 *
 * Activate the compilation of the debugger support. Speed penalty
 * is insignifiant.
 * On by default unless --without-debugger is passed to configure
 */
#if 1
#define WITH_XSLT_DEBUGGER
#endif

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
 * LIBXSLT_PUBLIC:
 *
 * This macro is used to declare PUBLIC variables for MSC on Windows
 */
#if !defined(WIN32) || defined(__CYGWIN__)
#define LIBXSLT_PUBLIC
#endif

#ifdef __cplusplus
}
#endif

#endif /* __XML_XSLTCONFIG_H__ */
