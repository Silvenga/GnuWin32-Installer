/*
 * file - file I/O routines callable by users
 *
 * Copyright (C) 1999  David I. Bell and Landon Curt Noll
 *
 * Primary author:  David I. Bell
 *
 * Calc is open software; you can redistribute it and/or modify it under
 * the terms of the version 2.1 of the GNU Lesser General Public License
 * as published by the Free Software Foundation.
 *
 * Calc is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU Lesser General
 * Public License for more details.
 *
 * A copy of version 2.1 of the GNU Lesser General Public License is
 * distributed with calc under the filename COPYING-LGPL.  You should have
 * received a copy with calc; if not, write to Free Software Foundation, Inc.
 * 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 *
 * @(#) $Revision: 29.5 $
 * @(#) $Id: file.h,v 29.5 2001/06/08 21:00:58 chongo Exp $
 * @(#) $Source: /usr/local/src/cmd/calc/RCS/file.h,v $
 *
 * Under source code control:	1996/05/24 05:55:58
 * File existed as early as:	1996
 *
 * chongo <was here> /\oo/\	http://www.isthe.com/chongo/
 * Share and enjoy!  :-)	http://www.isthe.com/chongo/tech/comp/calc/
 */


#if !defined(__FILE_H__)
#define __FILE_H__


#if defined(CALC_SRC)	/* if we are building from the calc source tree */
# include "calc/have_fpos.h"
#else
# include <calc/have_fpos.h>
#endif


/*
 * Definition of opened files.
 */
typedef struct {
	FILEID id;		/* id to identify this file */
	FILE *fp;		/* real file structure for I/O */
	dev_t dev;		/* file device */
	ino_t inode;		/* file inode */
	char *name;		/* file name */
	BOOL reading;		/* TRUE if opened for reading */
	BOOL writing;		/* TRUE if opened for writing */
	char action;		/* most recent use for 'r', 'w' or 0 */
	char mode[sizeof("rb+")];/* open mode */
} FILEIO;


/*
 * fgetpos/fsetpos vs fseek/ftell interface
 *
 * f_seek_set(FILE *stream, FILEPOS *loc)
 *	Seek loc bytes from the beginning of the open file, stream.
 *
 * f_tell(FILE *stream, FILEPOS *loc)
 *	Set loc to bytes from the beinning of the open file, stream.
 *
 * We assume that if your system does not have fgetpos/fsetpos,
 * then it will have a FILEPOS that is a scalar type (e.g., long).
 * Some obscure systems without fgetpos/fsetpos may not have a simple
 * scalar type.	 In these cases the f_tell macro below will fail.
 */
#if defined(HAVE_FPOS)

#define f_seek_set(stream, loc) fsetpos((FILE*)(stream), (FILEPOS*)(loc))
#define f_tell(stream, loc) fgetpos((FILE*)(stream), (FILEPOS*)(loc))

#else

#define f_seek_set(stream, loc)	 \
	fseek((FILE*)(stream), *(FILEPOS*)(loc), SEEK_SET)
#define f_tell(stream, loc) (*((FILEPOS*)(loc)) = ftell((FILE*)(stream)))

#endif


/*
 * external functions
 */
extern FILEIO * findid(FILEID id, int writable);
extern int fgetposid(FILEID id, FILEPOS *ptr);
extern int fsetposid(FILEID id, FILEPOS *ptr);
extern int get_open_siz(FILE *fp, ZVALUE *res);
extern char* findfname(FILEID);


#endif /* !__FILE_H__ */
