/*
 * globals.h: interface for all global variables of the library
 *
 * The bottom of this file is automatically generated by build_glob.py
 * based on the description file global.data
 *
 * See Copyright for the status of this software.
 *
 * Gary Pennington <Gary.Pennington@uk.sun.com>
 * daniel@veillard.com
 */

#ifndef __XML_GLOBALS_H
#define __XML_GLOBALS_H

#include <libxml/parser.h>
#include <libxml/xmlerror.h>
#include <libxml/SAX.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Externally global symbols which need to be protected for backwards
 * compatibility support.
 */

#undef	docbDefaultSAXHandler
#undef	htmlDefaultSAXHandler
#undef	oldXMLWDcompatibility
#undef	xmlBufferAllocScheme
#undef	xmlDefaultBufferSize
#undef	xmlDefaultSAXHandler
#undef	xmlDefaultSAXLocator
#undef	xmlDoValidityCheckingDefaultValue
#undef	xmlFree
#undef	xmlGenericError
#undef	xmlGenericErrorContext
#undef	xmlGetWarningsDefaultValue
#undef	xmlIndentTreeOutput
#undef	xmlKeepBlanksDefaultValue
#undef	xmlLineNumbersDefaultValue
#undef	xmlLoadExtDtdDefaultValue
#undef	xmlMalloc
#undef	xmlMemStrdup
#undef	xmlParserDebugEntities
#undef	xmlParserVersion
#undef	xmlPedanticParserDefaultValue
#undef	xmlRealloc
#undef	xmlSaveNoEmptyTags
#undef	xmlSubstituteEntitiesDefaultValue

typedef struct _xmlGlobalState xmlGlobalState;
typedef xmlGlobalState *xmlGlobalStatePtr;
struct _xmlGlobalState 
{
	const char *xmlParserVersion;

	xmlSAXLocator xmlDefaultSAXLocator;
	xmlSAXHandler xmlDefaultSAXHandler;
	xmlSAXHandler docbDefaultSAXHandler;
	xmlSAXHandler htmlDefaultSAXHandler;

	xmlFreeFunc xmlFree;
	xmlMallocFunc xmlMalloc;
	xmlStrdupFunc xmlMemStrdup;
	xmlReallocFunc xmlRealloc;

	xmlGenericErrorFunc xmlGenericError;
	void *xmlGenericErrorContext;

	int oldXMLWDcompatibility;

	xmlBufferAllocationScheme xmlBufferAllocScheme;
	int xmlDefaultBufferSize;

	int xmlSubstituteEntitiesDefaultValue;
	int xmlDoValidityCheckingDefaultValue;
	int xmlGetWarningsDefaultValue;
	int xmlKeepBlanksDefaultValue;
	int xmlLineNumbersDefaultValue;
	int xmlLoadExtDtdDefaultValue;
	int xmlParserDebugEntities;
	int xmlPedanticParserDefaultValue;

	int xmlSaveNoEmptyTags;
	int xmlIndentTreeOutput;
};

void	xmlInitializeGlobalState(xmlGlobalStatePtr gs);

/*
 * In general the memory allocation entry points are not kept
 * thread specific but this can be overriden by LIBXML_THREAD_ALLOC_ENABLED
 *    - xmlMalloc
 *    - xmlRealloc
 *    - xmlMemStrdup
 *    - xmlFree
 */

#ifdef LIBXML_THREAD_ALLOC_ENABLED
#ifdef LIBXML_THREAD_ENABLED
extern xmlMallocFunc *__xmlMalloc(void);
#define xmlMalloc \
(*(__xmlMalloc()))
#else
LIBXML_DLL_IMPORT extern xmlMallocFunc xmlMalloc;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlReallocFunc *__xmlRealloc(void);
#define xmlRealloc \
(*(__xmlRealloc()))
#else
LIBXML_DLL_IMPORT extern xmlReallocFunc xmlRealloc;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlFreeFunc *__xmlFree(void);
#define xmlFree \
(*(__xmlFree()))
#else
LIBXML_DLL_IMPORT extern xmlFreeFunc xmlFree;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlStrdupFunc *__xmlMemStrdup(void);
#define xmlMemStrdup \
(*(__xmlMemStrdup()))
#else
LIBXML_DLL_IMPORT extern xmlStrdupFunc xmlMemStrdup;
#endif
#else /* !LIBXML_THREAD_ALLOC_ENABLED */
LIBXML_DLL_IMPORT extern xmlMallocFunc xmlMalloc;
LIBXML_DLL_IMPORT extern xmlReallocFunc xmlRealloc;
LIBXML_DLL_IMPORT extern xmlFreeFunc xmlFree;
LIBXML_DLL_IMPORT extern xmlStrdupFunc xmlMemStrdup;
#endif /* LIBXML_THREAD_ALLOC_ENABLED */

/*
 * Everything starting from the line below is
 * Automatically generated by build_glob.py.
 * Do not modify the previous line.
 */


#ifdef LIBXML_THREAD_ENABLED
extern xmlSAXHandler *__docbDefaultSAXHandler(void);
#define docbDefaultSAXHandler \
(*(__docbDefaultSAXHandler()))
#else
LIBXML_DLL_IMPORT extern xmlSAXHandler docbDefaultSAXHandler;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlSAXHandler *__htmlDefaultSAXHandler(void);
#define htmlDefaultSAXHandler \
(*(__htmlDefaultSAXHandler()))
#else
LIBXML_DLL_IMPORT extern xmlSAXHandler htmlDefaultSAXHandler;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__oldXMLWDcompatibility(void);
#define oldXMLWDcompatibility \
(*(__oldXMLWDcompatibility()))
#else
LIBXML_DLL_IMPORT extern int oldXMLWDcompatibility;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlBufferAllocationScheme *__xmlBufferAllocScheme(void);
#define xmlBufferAllocScheme \
(*(__xmlBufferAllocScheme()))
#else
LIBXML_DLL_IMPORT extern xmlBufferAllocationScheme xmlBufferAllocScheme;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlDefaultBufferSize(void);
#define xmlDefaultBufferSize \
(*(__xmlDefaultBufferSize()))
#else
LIBXML_DLL_IMPORT extern int xmlDefaultBufferSize;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlSAXHandler *__xmlDefaultSAXHandler(void);
#define xmlDefaultSAXHandler \
(*(__xmlDefaultSAXHandler()))
#else
LIBXML_DLL_IMPORT extern xmlSAXHandler xmlDefaultSAXHandler;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlSAXLocator *__xmlDefaultSAXLocator(void);
#define xmlDefaultSAXLocator \
(*(__xmlDefaultSAXLocator()))
#else
LIBXML_DLL_IMPORT extern xmlSAXLocator xmlDefaultSAXLocator;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlDoValidityCheckingDefaultValue(void);
#define xmlDoValidityCheckingDefaultValue \
(*(__xmlDoValidityCheckingDefaultValue()))
#else
LIBXML_DLL_IMPORT extern int xmlDoValidityCheckingDefaultValue;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern xmlGenericErrorFunc *__xmlGenericError(void);
#define xmlGenericError \
(*(__xmlGenericError()))
#else
LIBXML_DLL_IMPORT extern xmlGenericErrorFunc xmlGenericError;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern void * *__xmlGenericErrorContext(void);
#define xmlGenericErrorContext \
(*(__xmlGenericErrorContext()))
#else
LIBXML_DLL_IMPORT extern void * xmlGenericErrorContext;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlGetWarningsDefaultValue(void);
#define xmlGetWarningsDefaultValue \
(*(__xmlGetWarningsDefaultValue()))
#else
LIBXML_DLL_IMPORT extern int xmlGetWarningsDefaultValue;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlIndentTreeOutput(void);
#define xmlIndentTreeOutput \
(*(__xmlIndentTreeOutput()))
#else
LIBXML_DLL_IMPORT extern int xmlIndentTreeOutput;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlKeepBlanksDefaultValue(void);
#define xmlKeepBlanksDefaultValue \
(*(__xmlKeepBlanksDefaultValue()))
#else
LIBXML_DLL_IMPORT extern int xmlKeepBlanksDefaultValue;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlLineNumbersDefaultValue(void);
#define xmlLineNumbersDefaultValue \
(*(__xmlLineNumbersDefaultValue()))
#else
LIBXML_DLL_IMPORT extern int xmlLineNumbersDefaultValue;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlLoadExtDtdDefaultValue(void);
#define xmlLoadExtDtdDefaultValue \
(*(__xmlLoadExtDtdDefaultValue()))
#else
LIBXML_DLL_IMPORT extern int xmlLoadExtDtdDefaultValue;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlParserDebugEntities(void);
#define xmlParserDebugEntities \
(*(__xmlParserDebugEntities()))
#else
LIBXML_DLL_IMPORT extern int xmlParserDebugEntities;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern const char * *__xmlParserVersion(void);
#define xmlParserVersion \
(*(__xmlParserVersion()))
#else
LIBXML_DLL_IMPORT extern const char * xmlParserVersion;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlPedanticParserDefaultValue(void);
#define xmlPedanticParserDefaultValue \
(*(__xmlPedanticParserDefaultValue()))
#else
LIBXML_DLL_IMPORT extern int xmlPedanticParserDefaultValue;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlSaveNoEmptyTags(void);
#define xmlSaveNoEmptyTags \
(*(__xmlSaveNoEmptyTags()))
#else
LIBXML_DLL_IMPORT extern int xmlSaveNoEmptyTags;
#endif

#ifdef LIBXML_THREAD_ENABLED
extern int *__xmlSubstituteEntitiesDefaultValue(void);
#define xmlSubstituteEntitiesDefaultValue \
(*(__xmlSubstituteEntitiesDefaultValue()))
#else
LIBXML_DLL_IMPORT extern int xmlSubstituteEntitiesDefaultValue;
#endif

#ifdef __cplusplus
}
#endif

#endif /* __XML_GLOBALS_H */
