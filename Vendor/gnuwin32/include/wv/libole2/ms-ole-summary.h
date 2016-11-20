/**
 * ms-ole-summary.h: MS Office OLE support
 *
 * Author:
 *    Michael Meeks (michael@imaginator.com)
 * From work by:
 *    Caolan McNamara (Caolan.McNamara@ul.ie)
 * Built on work by:
 *    Somar Software's CPPSUM (http://www.somar.com)
 *
 * Copyright 1998-2000 Helix Code, Inc., Frank Chiulli, and others.
 **/

#ifndef MS_OLE_SUMMARY_H
#define MS_OLE_SUMMARY_H

#include <time.h>
#include <libole2/ms-ole.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * MS Ole Property Set IDs
 * The SummaryInformation stream contains the SummaryInformation property set.
 * The DocumentSummaryInformation stream contains both the
 * DocumentSummaryInformation and the UserDefined property sets as sections.
 */
typedef enum {
	MS_OLE_PS_SUMMARY_INFO,
	MS_OLE_PS_DOCUMENT_SUMMARY_INFO,
	MS_OLE_PS_USER_DEFINED_SUMMARY_INFO
} MsOlePropertySetID;

typedef struct {
	guint8			class_id[16];
	GArray *		sections;
	GArray *		items;
	GList *			write_items;
	gboolean		read_mode;
	MsOleStream *		s;
	MsOlePropertySetID	ps_id;
} MsOleSummary;

/* Could store the FID, but why bother ? */
typedef struct {
	guint32			offset;
	guint32			props;
	guint32			bytes;
	MsOlePropertySetID	ps_id;
} MsOleSummarySection;

MsOleSummary *ms_ole_summary_open		(MsOle *f);
MsOleSummary *ms_ole_docsummary_open		(MsOle *f);
MsOleSummary *ms_ole_summary_open_stream	(MsOleStream *stream,
						 const MsOlePropertySetID psid);
MsOleSummary *ms_ole_summary_create		(MsOle *f);
MsOleSummary *ms_ole_docsummary_create		(MsOle *f);
MsOleSummary *ms_ole_summary_create_stream	(MsOleStream *s,
						 const MsOlePropertySetID psid);
GArray       *ms_ole_summary_get_properties	(MsOleSummary *si);
void	      ms_ole_summary_close		(MsOleSummary *si);


/*
 * Can be used to interrogate a summary item as to its type
 */
typedef enum {
	MS_OLE_SUMMARY_TYPE_STRING  = 0x10,
	MS_OLE_SUMMARY_TYPE_TIME    = 0x20,
	MS_OLE_SUMMARY_TYPE_LONG    = 0x30,
	MS_OLE_SUMMARY_TYPE_SHORT   = 0x40,
	MS_OLE_SUMMARY_TYPE_BOOLEAN = 0x50,
	MS_OLE_SUMMARY_TYPE_OTHER   = 0x60
} MsOleSummaryType;

#define MS_OLE_SUMMARY_TYPE(x) ((MsOleSummaryType)((x)>>8))

/* FIXME MS_OLE_SUMMARY_THUMBNAIL is Preview, no Security, isn't it? */
/*
 *  The MS byte specifies the type, the LS byte is the
 * 'standard' MS PID.
 */
typedef enum {
/* SummaryInformation Stream Properties */
/* String properties */
	MS_OLE_SUMMARY_TITLE          = 0x1002,
	MS_OLE_SUMMARY_SUBJECT        = 0x1003,
	MS_OLE_SUMMARY_AUTHOR         = 0x1004,
	MS_OLE_SUMMARY_KEYWORDS       = 0x1005,
	MS_OLE_SUMMARY_COMMENTS       = 0x1006,
	MS_OLE_SUMMARY_TEMPLATE       = 0x1007,
	MS_OLE_SUMMARY_LASTAUTHOR     = 0x1008,
	MS_OLE_SUMMARY_REVNUMBER      = 0x1009,
	MS_OLE_SUMMARY_APPNAME        = 0x1012,
	
/* Time properties */
	MS_OLE_SUMMARY_TOTAL_EDITTIME = 0x200A,
	MS_OLE_SUMMARY_LASTPRINTED    = 0x200B,
	MS_OLE_SUMMARY_CREATED        = 0x200C,
	MS_OLE_SUMMARY_LASTSAVED      = 0x200D,
	
/* Long integer properties */
	MS_OLE_SUMMARY_PAGECOUNT      = 0x300E,
	MS_OLE_SUMMARY_WORDCOUNT      = 0x300F,
	MS_OLE_SUMMARY_CHARCOUNT      = 0x3010,
	MS_OLE_SUMMARY_SECURITY       = 0x3013,

/* Short integer properties */
	MS_OLE_SUMMARY_CODEPAGE       = 0x4001,

/* Security */	
	MS_OLE_SUMMARY_THUMBNAIL      = 0x6011,


/* DocumentSummaryInformation Properties */
/* String properties */
	MS_OLE_SUMMARY_CATEGORY	      = 0x1002,
	MS_OLE_SUMMARY_PRESFORMAT     = 0x1003,
	MS_OLE_SUMMARY_MANAGER        = 0x100E,
	MS_OLE_SUMMARY_COMPANY        = 0x100F,

/* Long integer properties */
	MS_OLE_SUMMARY_BYTECOUNT      = 0x3004,
	MS_OLE_SUMMARY_LINECOUNT      = 0x3005,
	MS_OLE_SUMMARY_PARCOUNT       = 0x3006,
	MS_OLE_SUMMARY_SLIDECOUNT     = 0x3007,
	MS_OLE_SUMMARY_NOTECOUNT      = 0x3008,
	MS_OLE_SUMMARY_HIDDENCOUNT    = 0x3009,
	MS_OLE_SUMMARY_MMCLIPCOUNT    = 0X300A,

/* Boolean properties */
	MS_OLE_SUMMARY_SCALE          = 0x500B,
	MS_OLE_SUMMARY_LINKSDIRTY     = 0x5010
} MsOleSummaryPID;


/* bit masks for security long integer */
#define MsOleSummaryAllSecurityFlagsEqNone        0x00
#define MsOleSummarySecurityPassworded            0x01
#define MsOleSummarySecurityRORecommended         0x02
#define MsOleSummarySecurityRO                    0x04
#define MsOleSummarySecurityLockedForAnnotations  0x08

#if 0
typedef struct {
	GTimeVal time;
	GDate    date;
} MsOleSummaryTime;
#endif

typedef struct {
	guint32 len;
	guint8 *data;
} MsOleSummaryPreview;

gchar *			ms_ole_summary_get_string	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 gboolean *available);
gboolean		ms_ole_summary_get_boolean	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 gboolean *available);
guint16			ms_ole_summary_get_short	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 gboolean *available);
guint32			ms_ole_summary_get_long		(MsOleSummary *si,
							 MsOleSummaryPID id,
							 gboolean *available);
#if 0
GTimeVal		ms_ole_summary_get_time		(MsOleSummary *si,
							 MsOleSummaryPID id,
							 gboolean *available);
#endif

MsOleSummaryPreview	ms_ole_summary_get_preview	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 gboolean *available);
void			ms_ole_summary_preview_destroy	(MsOleSummaryPreview d);

/* FIXME The next comment isn't true, is it?
   Return TRUE if write is successful */
void			ms_ole_summary_set_string	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 const gchar *str);
void			ms_ole_summary_set_boolean	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 gboolean value);
void			ms_ole_summary_set_short	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 guint16 i);
void			ms_ole_summary_set_long		(MsOleSummary *si,
							 MsOleSummaryPID id,
							 guint32 i);
#if 0
void			ms_ole_summary_set_time		(MsOleSummary *si,
							 MsOleSummaryPID id,
							 GTimeVal time);
#endif
void			ms_ole_summary_set_preview	(MsOleSummary *si,
							 MsOleSummaryPID id,
							 const
							 MsOleSummaryPreview *
							 preview);

#ifdef __cplusplus
}
#endif

#endif	/* MS_OLE_SUMMARY_H */

