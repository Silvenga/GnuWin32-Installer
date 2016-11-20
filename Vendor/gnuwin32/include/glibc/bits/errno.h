/* 
 * errno.h
 *
 * Error numbers and access to error reporting.
 *
 * This file is part of the Mingw32 package.
 *
 * Contributors:
 *  Created by Colin Peters <colin@bird.fu.is.saga-u.ac.jp>
 *
 *  THIS SOFTWARE IS NOT COPYRIGHTED
 *
 *  This source code is offered for use in the public domain. You may
 *  use, modify or distribute it freely.
 *
 *  This code is distributed in the hope that it will be useful but
 *  WITHOUT ANY WARRANTY. ALL WARRANTIES, EXPRESS OR IMPLIED ARE HEREBY
 *  DISCLAIMED. This includes but is not limited to warranties of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * $Revision: 1.4 $
 * $Author: dannysmith $
 * $Date: 2001/11/29 04:26:33 $
 *
 */

#ifndef _ERRNO_H_
#define	_ERRNO_H_

/* All the headers include this file. */
#include <_mingw.h>

/*
 * Error numbers.
 * TODO: Can't be sure of some of these assignments, I guessed from the
 * names given by strerror and the defines in the Cygnus errno.h. A lot
 * of the names from the Cygnus errno.h are not represented, and a few
 * of the descriptions returned by strerror do not obviously match
 * their error naming.
 */
#define EPERM		1	/* Operation not permitted */
#define	ENOFILE		2	/* No such file or directory */
#define	ENOENT		2
#define	ESRCH		3	/* No such process */
#define	EINTR		4	/* Interrupted function call */
#define	EIO		5	/* Input/output error */
#define	ENXIO		6	/* No such device or address */
#define	E2BIG		7	/* Arg list too long */
#define	ENOEXEC		8	/* Exec format error */
#define	EBADF		9	/* Bad file descriptor */
#define	ECHILD		10	/* No child processes */
#define	EAGAIN		11	/* Resource temporarily unavailable */
#define	ENOMEM		12	/* Not enough space */
#define	EACCES		13	/* Permission denied */
#define	EFAULT		14	/* Bad address */
/* 15 - Unknown Error */
#define	EBUSY		16	/* strerror reports "Resource device" */
#define	EEXIST		17	/* File exists */
#define	EXDEV		18	/* Improper link (cross-device link?) */
#define	ENODEV		19	/* No such device */
#define	ENOTDIR		20	/* Not a directory */
#define	EISDIR		21	/* Is a directory */
#define	EINVAL		22	/* Invalid argument */
#define	ENFILE		23	/* Too many open files in system */
#define	EMFILE		24	/* Too many open files */
#define	ENOTTY		25	/* Inappropriate I/O control operation */
/* 26 - Unknown Error */
#define	EFBIG		27	/* File too large */
#define	ENOSPC		28	/* No space left on device */
#define	ESPIPE		29	/* Invalid seek (seek on a pipe?) */
#define	EROFS		30	/* Read-only file system */
#define	EMLINK		31	/* Too many links */
#define	EPIPE		32	/* Broken pipe */
#define	EDOM		33	/* Domain error (math functions) */
#define	ERANGE		34	/* Result too large (possibly too small) */
/* 35 - Unknown Error */
#define	EDEADLOCK	36	/* Resource deadlock avoided (non-Cyg) */
#define	EDEADLK		36
/* 37 - Unknown Error */
#define	ENAMETOOLONG	38	/* Filename too long (91 in Cyg?) */
#define	ENOLCK		39	/* No locks available (46 in Cyg?) */
#define	ENOSYS		40	/* Function not implemented (88 in Cyg?) */
#define	ENOTEMPTY	41	/* Directory not empty (90 in Cyg?) */
#define	EILSEQ		42	/* Illegal byte sequence */

#define   EWOULDBLOCK                EAGAIN     /* Operation would block */
#define   EINPROGRESS                35     /* Operation now in progress */
#define   EALREADY                   37     /* Operation already in progress */
#define   ENOTSOCK                   63     /* Socket operation on non-socket */
#define   EMSGSIZE                   77     /* Message too long */
#define   EPROTOTYPE                 78     /* Protocol wrong type for socket */
#define   ENOPROTOOPT                106     /* Protocol not available */
#define   EPROTONOSUPPORT            43     /* Protocol not supported */
#define   ESOCKTNOSUPPORT            44     /* Socket type not supported */
#define   EOPNOTSUPP                 45     /* Operation not supported */
#define   EPFNOSUPPORT               46     /* Protocol family not supported */
#define   EAFNOSUPPORT               47     /* Address family not supported by protocol */
#define   EADDRINUSE                 48     /* Address already in use */
#define   EADDRNOTAVAIL              49     /* Cannot assign requested address */
#define   ENETDOWN                   50     /* Network is down */
#define   ENETUNREACH                51     /* Network is unreachable */
#define   ENETRESET                  52     /* Network dropped connection on reset */
#define   ECONNABORTED               53     /* Software caused connection abort */
#define   ECONNRESET                 54     /* Connection reset by peer */
#define   ENOBUFS                    55     /* No buffer space available */
#define   EISCONN                    56     /* Transport endpoint is already connected */
#define   ENOTCONN                   57     /* Transport endpoint is not connected */
#define   EDESTADDRREQ               39     /* Destination address required */
#define   ESHUTDOWN                  58     /* Cannot send after transport endpoint shutdown */
#define   ETOOMANYREFS               59     /* Too many references: cannot splice */
#define   ETIMEDOUT                  60     /* Connection timed out */
#define   ECONNREFUSED               61     /* Connection refused */
#define   ELOOP                      62     /* Too many levels of symbolic links */
//#define ENAMETOOLONG               63     /* File name too long */
#define   EHOSTDOWN                  64     /* Host is down */
#define   EHOSTUNREACH               65     /* No route to host */
//#define ENOTEMPTY                  66     /* Directory not empty */
#define   EPROCLIM                   67     /* Too many processes */
#define   EUSERS                     68     /* Too many users */
#define   EDQUOT                     69     /* Disk quota exceeded */
#define   ESTALE                     70     /* Stale NFS file handle */
#define   EREMOTE                    71     /* Object is remote */
#define   EBADRPC                    72     /* RPC struct is bad */
#define   ERPCMISMATCH               73     /* RPC version wrong */
#define   EPROGUNAVAIL               74     /* RPC program not available */
#define   EPROGMISMATCH              75     /* RPC program version wrong */
#define   EPROCUNAVAIL               76     /* RPC bad procedure for program */
//#define ENOLCK                     77     /* No locks available */
//#define ENOSYS                     78     /* Function not implemented */
#define   EFTYPE                     79     /* Inappropriate file type or format */
#define   EAUTH                      80     /* Authentication error */
#define   ENEEDAUTH                  81     /* Need authenticator */
#define   EBACKGROUND                100     /* Inappropriate operation for background process */
#define   EDIED                      101     /* Translator died */
#define   ED                         102     /* ? */
#define   EGREGIOUS                  103     /* You really blew it this time */
#define   EIEIO                      104     /* Computer bought the farm */
#define   EGRATUITOUS                105     /* Gratuitous error */
//#define EILSEQ                     106     /* Invalid or incomplete multibyte or wide character */
#define   EBADMSG                    107     /* Bad message */
#define   EIDRM                      108     /* Identifier removed */
#define   EMULTIHOP                  109     /* Multihop attempted */
#define   ENODATA                    110     /* No data available */
#define   ENOLINK                    111     /* Link has been severed */
#define   ENOMSG                     112     /* No message of desired type */
#define   ENOSR                      113     /* Out of streams resources */
#define   ENOSTR                     114     /* Device not a stream */
#define   EOVERFLOW                  115     /* Value too large for defined data type */
#define   EPROTO                     116     /* Protocol error */
#define   ETIME                      117     /* Timer expired */
#define   ENOTSUP                    118     /* Not supported */
/*
 * NOTE: ENAMETOOLONG and ENOTEMPTY conflict with definitions in the
 *       sockets.h header provided with windows32api-0.1.2.
 *       You should go and put an #if 0 ... #endif around the whole block
 *       of errors (look at the comment above them).
 */

#endif /* _ERRNO_H_ */
