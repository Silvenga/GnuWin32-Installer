/* -*- C -*-
 * liba2ps.h
 *
 * shared header with the whole package
 * Copyright (c) 1988, 89, 90, 91, 92, 93 Miguel Santana
 * Copyright (c) 1995, 96, 97, 98 Akim Demaille, Miguel Santana
 * $Id: liba2ps.h.in,v 1.1.1.1.2.1 2007/12/29 01:58:19 mhatta Exp $
 */

/*
 * This file is part of a2ps.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef LIBA2PS_H_
#define LIBA2PS_H_

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

#ifndef VOID
# if defined (__GNUC__) || __STDC__
#  define VOID void
# else
#  define VOID char
# endif
#endif

#ifndef PARAMS
#  if PROTOTYPES || defined (__STDC__) || defined (_AIX) \
      || (defined (__mips) && defined (_SYSTYPE_SVR4)) \
      || defined(WIN32) || defined(__cplusplus)
#    define PARAMS(protos) protos
#  else
#    define PARAMS(protos) ()
#  endif
#endif

/*
 * The type bool must be defined, for instance with

 #if HAVE_STDBOOL_H
 # include <stdbool.h>
 #else
 typedef enum {false = 0, true = 1} bool;
 #endif

*/

__BEGIN_DECLS

/*
 * A structure which records any global information liba2ps needs
 */
struct a2ps_job;

/* File liba2ps.h.extract */
/* From faces.h */
/* 
 * Available faces.  No_face should never be given to liba2ps.
 */
enum face_e { 
  No_face = -1,
  First_face = 0,
  Plain = 0,
  Keyword = 1,
  Keyword_strong = 2,
  Label = 3,
  Label_strong = 4,
  String = 5,
  Symbol = 6,
  Error = 7,
  Comment = 8,
  Comment_strong = 9,
  Last_face = 9
};

/* From gen.h */
/* Print a single char C in FACE */
void a2ps_print_char PARAMS ((struct a2ps_job * job, 
			    int c, 
			    enum face_e face));
/* Print a C string (nul terminated) in FACE */
void a2ps_print_string PARAMS ((struct a2ps_job * job, 
			      const unsigned char * string, 
			      enum face_e face)); 
/* Print the N chars contained in BUFFER, in FACE */
void a2ps_print_buffer PARAMS ((struct a2ps_job * job, 
			      const unsigned char * buffer, 
			      size_t start, size_t end,
			      enum face_e face));
/* Open/close the outer structure */
void a2ps_open_output_session PARAMS ((struct a2ps_job * job));
void a2ps_close_output_session PARAMS ((struct a2ps_job * job));

/* Open/Close the section structure */
void a2ps_open_input_session PARAMS ((struct a2ps_job * job, unsigned char * name));
void a2ps_close_input_session PARAMS ((struct a2ps_job * job));


/* From jobs.h */
/* Return a newly allocated output session storage */
struct a2ps_job * a2ps_job_new PARAMS ((void));

/* Finalize it */
void a2ps_job_finalize PARAMS ((struct a2ps_job * job));

/* Free the memory used by JOB */
void a2ps_job_free PARAMS ((struct a2ps_job * job));

/* From confg.h */
/*
 * Read the configuration file
 */
int a2_read_config PARAMS ((struct a2ps_job * job,
			 const char *path, const char *file));

/*
 * Read the system's configuration file
 * (i.e., a2_read_config  (job, etc, a2ps.cfg))
 */
void a2_read_sys_config PARAMS ((struct a2ps_job * job));


__END_DECLS

#endif /* !defined(LIBA2PS_H_) */
