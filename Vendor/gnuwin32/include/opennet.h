/*
 * Copyright (C) 2001, 2002, and 2003  Roy Keene
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 *      email: libopennet@rkeene.org
 */

#ifndef _OPENNET_H 
#define _OPENNET_H
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

#ifndef __GNUC__
# define __DLL_IMPORT__ __declspec(dllimport)
# define __DLL_EXPORT__ __declspec(dllexport)
#else
# define __DLL_IMPORT__ __attribute__((dllimport)) extern
# define __DLL_EXPORT__ __attribute__((dllexport)) extern
#endif 

#if (defined __WIN32__) || (defined _WIN32)
# ifdef BUILD_LIBOPENNET_DLL
#  define LIBOPENNET_DLL_IMPEXP __DLL_EXPORT__
# elif defined(LIBOPENNET_STATIC)
#  define LIBOPENNET_DLL_IMPEXP  
# elif defined (USE_LIBOPENNET_DLL)
#  define LIBOPENNET_DLL_IMPEXP __DLL_IMPORT__
# elif defined (USE_LIBOPENNET_STATIC)
#  define LIBOPENNET_DLL_IMPEXP   
# else /* assume USE_LIBOPENNET_DLL */
#  define LIBOPENNET_DLL_IMPEXP __DLL_IMPORT__
# endif
#else /* __WIN32__ */
# define LIBOPENNET_DLL_IMPEXP  
#endif

#ifdef  __cplusplus
extern "C" {
#endif

typedef struct {
	int fd;
	ssize_t (*recv_func)();
	ssize_t (*send_func)();
	char *buf;
	char *buf_s;
	unsigned long bufsize;
	unsigned long bufsize_s;
	unsigned long bufused;
	int eof;
	int socket;
} NETFILE;


/* Open a URL.  Same syntax as POSIX open(), except `mode' is required. */
LIBOPENNET_DLL_IMPEXP int open_net(const char *pathname, int flags, mode_t mode);

/* Seek in a file or stream.  Same syntax as POSIX lseek(). */
LIBOPENNET_DLL_IMPEXP off_t lseek_net(int filedes, off_t offset, int whence);

/* A more deterministic POSIX read(). */
LIBOPENNET_DLL_IMPEXP ssize_t read_net(int fd, void *buf, size_t count);

/* ANSI fopen() clone. */
LIBOPENNET_DLL_IMPEXP NETFILE *fopen_net(const char *path, const char *mode);

/* ANSI fgets() clone */
LIBOPENNET_DLL_IMPEXP char *fgets_net(char *s, int size, NETFILE *stream);

/* ANSI feof() clone */
LIBOPENNET_DLL_IMPEXP int feof_net(NETFILE *stream);

/* ANSI fread() clone */
size_t fread_net(void *ptr, size_t size, size_t nmemb, NETFILE *stream);

/* ANSI fseek() clone. */
LIBOPENNET_DLL_IMPEXP int fseek_net(NETFILE *stream, long offset, int whence);

/* ANSI fclose() clone */
LIBOPENNET_DLL_IMPEXP int fclose_net(NETFILE *stream);

#ifdef  __cplusplus
}
#endif

#endif
