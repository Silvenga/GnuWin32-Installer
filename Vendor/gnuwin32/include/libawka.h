/*------------------------------------------------------------*
 | libawka.h                                                  |
 | copyright 1999,  Andrew Sumner (andrewsumner@yahoo.com)    |
 |                                                            |
 | This is a source file for the awka package, a translator   |
 | of the AWK programming language to ANSI C.                 |
 |                                                            |
 | This library is free software; you can redistribute it     |
 | and/or modify it under the terms of the GNU General        |
 | Public License (GPL).                                      |
 |                                                            |
 | This library is distributed in the hope that it will be    |
 | useful, but WITHOUT ANY WARRANTY; without even the implied |
 | warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR    |
 | PURPOSE.                                                   |
 *------------------------------------------------------------*/

/*------------------------------------------------------------*
 | Warning: this file was automatically generated.            |
 | Any changes should be made to libawka.h.in or other        |
 | files that it references.                                  |
 *------------------------------------------------------------*/

#ifndef _AWKA_H
#  define _AWKA_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>
#include <ctype.h>

#define A_MIN(a, b) ((a) > (b) ? (b) : (a))
#define A_MAX(a, b) ((a) > (b) ? (a) : (b))

#include "config.h"

#if defined(__cplusplus)
#undef INLINE
#define INLINE inline
#endif

#define AWKAVERSION "0.7.5"
#define DATE_STRING "12 July 2001"

#ifndef TRUE
#  define TRUE  1
#  define FALSE 0
#endif

/*--------------------------------------------------*
 | varg.h                                           |
 | Part of the Awka Library,                        |
 | Copyright (c) 1999, Andrew Sumner.               |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _VARG_H
#define _VARG_H

#ifdef     NO_PROTOS
#  ifndef    NO_STDARG_H   
#    define    NO_STDARG_H  1
#  endif
#endif

#if     NO_STDARG_H
#  include <varargs.h>
#else  /* have stdarg.h */
#  include <stdarg.h>
#endif

#endif

#if defined(__cplusplus)
extern "C" {
#endif

/*--------------------------------------------------*
 | error.h                                          |
 | Header file for array.c, part of the Awka        |
 | Library, Copyright 1999, Andrew Sumner.          |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _ERROR_H
#define _ERROR_H

void awka_error( char *fmt, ... );
void awka_init_parachute();

#endif

/*--------------------------------------------------*
 | mem.h                                            |
 | Memory-based defines & functions, part of the    |
 | Awka Library, Copyright 1999, Andrew Sumner.     |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _MEM_H
#define _MEM_H

#ifndef _ERROR_H
void awka_error( char *fmt, ... );
#endif

extern int _print_mem;

#ifdef MEM_DEBUG
#define A_PROT_SIZE 64
void awka_mprotect(char *, size_t);
void awka_mfree(char *);
int  awka_mcheck(char *);
void awka_mtest(char *);
void awka_mtestall();
size_t awka_malloc(void **ptr, size_t size, char *file, int line);
size_t awka_realloc(void **oldptr, size_t size, char *file, int line);
void awka_free(void *ptr, char *file, int line);
#else

static size_t
awka_malloc(void **ptr, size_t size, char *file, int line)
{
  size = size + (16 - (size % 16));

  if (!(*ptr = malloc(size)))
    awka_error("Memory Error - Failed to allocate %d bytes, file %s line %d.\n",size,file,line);

  /*
fprintf(stderr,"m %p %s %d %u\n",*ptr,file,line,size); 
*/

  return size;
}

static size_t
awka_realloc(void **oldptr, size_t size, char *file, int line)
{
  void *ptr = *oldptr;

  size = size + (16 - (size % 16));

  if (!ptr)
    return awka_malloc(oldptr, size, file, line);

  if (!(ptr = realloc(ptr, size)))
    awka_error("Memory Error - Failed to reallocate ptr %p to %d bytes, file %s line %d.\n",*oldptr,size,file,line);

  /*
if (ptr != *oldptr)
{
  fprintf(stderr,"f %p %s %d\n",*oldptr,file,line);
  fprintf(stderr,"m %p %s %d %u\n",ptr,file,line,size);
}
*/

  *oldptr = ptr;

  return size;
}

static void 
awka_free(void *ptr, char *file, int line)
{
  if (!ptr)
  {
    awka_error("Memory Error - Free of Null ptr, file %s, line %d.\n",file,line);
    return;
  }

  /*
fprintf(stderr,"f %p %s %d\n",ptr,file,line); 
*/

  free(ptr);
}

#endif /* MEM_DEBUG */

#define malloc(ptr, size)  awka_malloc((void **) ptr, size, __FILE__, __LINE__)
#define realloc(ptr, size) awka_realloc((void **) ptr, size, __FILE__, __LINE__)
#define free(ptr)          awka_free(ptr, __FILE__, __LINE__)

#endif

/* Definitions for data structures and routines for the regular
   expression library, version 0.12.
   Copyright (C) 1985,1989-1993,1995-1998,2000 Free Software Foundation, Inc.

   This file is part of the GNU C Library.  Its master source is NOT part of
   the C library, however.  The master source lives in /gd/gnu/lib.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public License as
   published by the Free Software Foundation; either version 2 of the
   License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with the GNU C Library; see the file COPYING.LIB.  If not,
   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

#ifndef _REGEX_H
#define _REGEX_H 1

/* Allow the use in C++ code.  */
#ifdef __cplusplus
extern "C" {
#endif

/* POSIX says that <sys/types.h> must be included (by the caller) before
   <regex.h>.  */

#if !defined _POSIX_C_SOURCE && !defined _POSIX_SOURCE && defined VMS
/* VMS doesn't have `size_t' in <sys/types.h>, even though POSIX says it
   should be there.  */
# include <stddef.h>
#endif

/* The following two types have to be signed and unsigned integer type
   wide enough to hold a value of a pointer.  For most ANSI compilers
   ptrdiff_t and size_t should be likely OK.  Still size of these two
   types is 2 for Microsoft C.  Ugh... */
typedef long int s_reg_t;
typedef unsigned long int active_reg_t;

/* The following bits are used to determine the regexp syntax we
   recognize.  The set/not-set meanings are chosen so that Emacs syntax
   remains the value 0.  The bits are given in alphabetical order, and
   the definitions shifted by one from the previous bit; thus, when we
   add or remove a bit, only one other definition need change.  */
typedef unsigned long int reg_syntax_t;

/* If this bit is not set, then \ inside a bracket expression is literal.
   If set, then such a \ quotes the following character.  */
#define RE_BACKSLASH_ESCAPE_IN_LISTS ((unsigned long int) 1)

/* If this bit is not set, then + and ? are operators, and \+ and \? are
     literals.
   If set, then \+ and \? are operators and + and ? are literals.  */
#define RE_BK_PLUS_QM (RE_BACKSLASH_ESCAPE_IN_LISTS << 1)

/* If this bit is set, then character classes are supported.  They are:
     [:alpha:], [:upper:], [:lower:],  [:digit:], [:alnum:], [:xdigit:],
     [:space:], [:print:], [:punct:], [:graph:], and [:cntrl:].
   If not set, then character classes are not supported.  */
#define RE_CHAR_CLASSES (RE_BK_PLUS_QM << 1)

/* If this bit is set, then ^ and $ are always anchors (outside bracket
     expressions, of course).
   If this bit is not set, then it depends:
        ^  is an anchor if it is at the beginning of a regular
           expression or after an open-group or an alternation operator;
        $  is an anchor if it is at the end of a regular expression, or
           before a close-group or an alternation operator.

   This bit could be (re)combined with RE_CONTEXT_INDEP_OPS, because
   POSIX draft 11.2 says that * etc. in leading positions is undefined.
   We already implemented a previous draft which made those constructs
   invalid, though, so we haven't changed the code back.  */
#define RE_CONTEXT_INDEP_ANCHORS (RE_CHAR_CLASSES << 1)

/* If this bit is set, then special characters are always special
     regardless of where they are in the pattern.
   If this bit is not set, then special characters are special only in
     some contexts; otherwise they are ordinary.  Specifically,
     * + ? and intervals are only special when not after the beginning,
     open-group, or alternation operator.  */
#define RE_CONTEXT_INDEP_OPS (RE_CONTEXT_INDEP_ANCHORS << 1)

/* If this bit is set, then *, +, ?, and { cannot be first in an re or
     immediately after an alternation or begin-group operator.  */
#define RE_CONTEXT_INVALID_OPS (RE_CONTEXT_INDEP_OPS << 1)

/* If this bit is set, then . matches newline.
   If not set, then it doesn't.  */
#define RE_DOT_NEWLINE (RE_CONTEXT_INVALID_OPS << 1)

/* If this bit is set, then . doesn't match NUL.
   If not set, then it does.  */
#define RE_DOT_NOT_NULL (RE_DOT_NEWLINE << 1)

/* If this bit is set, nonmatching lists [^...] do not match newline.
   If not set, they do.  */
#define RE_HAT_LISTS_NOT_NEWLINE (RE_DOT_NOT_NULL << 1)

/* If this bit is set, either \{...\} or {...} defines an
     interval, depending on RE_NO_BK_BRACES.
   If not set, \{, \}, {, and } are literals.  */
#define RE_INTERVALS (RE_HAT_LISTS_NOT_NEWLINE << 1)

/* If this bit is set, +, ? and | aren't recognized as operators.
   If not set, they are.  */
#define RE_LIMITED_OPS (RE_INTERVALS << 1)

/* If this bit is set, newline is an alternation operator.
   If not set, newline is literal.  */
#define RE_NEWLINE_ALT (RE_LIMITED_OPS << 1)

/* If this bit is set, then `{...}' defines an interval, and \{ and \}
     are literals.
  If not set, then `\{...\}' defines an interval.  */
#define RE_NO_BK_BRACES (RE_NEWLINE_ALT << 1)

/* If this bit is set, (...) defines a group, and \( and \) are literals.
   If not set, \(...\) defines a group, and ( and ) are literals.  */
#define RE_NO_BK_PARENS (RE_NO_BK_BRACES << 1)

/* If this bit is set, then \<digit> matches <digit>.
   If not set, then \<digit> is a back-reference.  */
#define RE_NO_BK_REFS (RE_NO_BK_PARENS << 1)

/* If this bit is set, then | is an alternation operator, and \| is literal.
   If not set, then \| is an alternation operator, and | is literal.  */
#define RE_NO_BK_VBAR (RE_NO_BK_REFS << 1)

/* If this bit is set, then an ending range point collating higher
     than the starting range point, as in [z-a], is invalid.
   If not set, then when ending range point collates higher than the
     starting range point, the range is ignored.  */
#define RE_NO_EMPTY_RANGES (RE_NO_BK_VBAR << 1)

/* If this bit is set, then an unmatched ) is ordinary.
   If not set, then an unmatched ) is invalid.  */
#define RE_UNMATCHED_RIGHT_PAREN_ORD (RE_NO_EMPTY_RANGES << 1)

/* If this bit is set, succeed as soon as we match the whole pattern,
   without further backtracking.  */
#define RE_NO_POSIX_BACKTRACKING (RE_UNMATCHED_RIGHT_PAREN_ORD << 1)

/* If this bit is set, do not process the GNU regex operators.
   If not set, then the GNU regex operators are recognized. */
#define RE_NO_GNU_OPS (RE_NO_POSIX_BACKTRACKING << 1)

/* If this bit is set, turn on internal regex debugging.
   If not set, and debugging was on, turn it off.
   This only works if regex.c is compiled -DDEBUG.
   We define this bit always, so that all that's needed to turn on
   debugging is to recompile regex.c; the calling code can always have
   this bit set, and it won't affect anything in the normal case. */
#define RE_DEBUG (RE_NO_GNU_OPS << 1)

/* This global variable defines the particular regexp syntax to use (for
   some interfaces).  When a regexp is compiled, the syntax used is
   stored in the pattern buffer, so changing this does not affect
   already-compiled regexps.  */
extern reg_syntax_t re_syntax_options;

/* Define combinations of the above bits for the standard possibilities.
   (The [[[ comments delimit what gets put into the Texinfo file, so
   don't delete them!)  */
/* [[[begin syntaxes]]] */
#define RE_SYNTAX_EMACS 0

#define RE_SYNTAX_AWK                                                        \
  (RE_BACKSLASH_ESCAPE_IN_LISTS   | RE_DOT_NOT_NULL                        \
   | RE_NO_BK_PARENS              | RE_NO_BK_REFS                        \
   | RE_NO_BK_VBAR                | RE_NO_EMPTY_RANGES                        \
   | RE_DOT_NEWLINE                  | RE_CONTEXT_INDEP_ANCHORS                \
   | RE_UNMATCHED_RIGHT_PAREN_ORD | RE_NO_GNU_OPS)

#define RE_SYNTAX_GNU_AWK                                                \
  ((RE_SYNTAX_POSIX_EXTENDED | RE_BACKSLASH_ESCAPE_IN_LISTS | RE_DEBUG)        \
   & ~(RE_DOT_NOT_NULL | RE_INTERVALS | RE_CONTEXT_INDEP_OPS))

#define RE_SYNTAX_POSIX_AWK                                                 \
  (RE_SYNTAX_POSIX_EXTENDED | RE_BACKSLASH_ESCAPE_IN_LISTS                \
   | RE_INTERVALS            | RE_NO_GNU_OPS)

#define RE_SYNTAX_GREP                                                        \
  (RE_BK_PLUS_QM              | RE_CHAR_CLASSES                                \
   | RE_HAT_LISTS_NOT_NEWLINE | RE_INTERVALS                                \
   | RE_NEWLINE_ALT)

#define RE_SYNTAX_EGREP                                                        \
  (RE_CHAR_CLASSES        | RE_CONTEXT_INDEP_ANCHORS                        \
   | RE_CONTEXT_INDEP_OPS | RE_HAT_LISTS_NOT_NEWLINE                        \
   | RE_NEWLINE_ALT       | RE_NO_BK_PARENS                                \
   | RE_NO_BK_VBAR)

#define RE_SYNTAX_POSIX_EGREP                                                \
  (RE_SYNTAX_EGREP | RE_INTERVALS | RE_NO_BK_BRACES)

/* P1003.2/D11.2, section 4.20.7.1, lines 5078ff.  */
#define RE_SYNTAX_ED RE_SYNTAX_POSIX_BASIC

#define RE_SYNTAX_SED RE_SYNTAX_POSIX_BASIC

/* Syntax bits common to both basic and extended POSIX regex syntax.  */
#define _RE_SYNTAX_POSIX_COMMON                                                \
  (RE_CHAR_CLASSES | RE_DOT_NEWLINE      | RE_DOT_NOT_NULL                \
   | RE_INTERVALS  | RE_NO_EMPTY_RANGES)

#define RE_SYNTAX_POSIX_BASIC                                                \
  (_RE_SYNTAX_POSIX_COMMON | RE_BK_PLUS_QM)

/* Differs from ..._POSIX_BASIC only in that RE_BK_PLUS_QM becomes
   RE_LIMITED_OPS, i.e., \? \+ \| are not recognized.  Actually, this
   isn't minimal, since other operators, such as \`, aren't disabled.  */
#define RE_SYNTAX_POSIX_MINIMAL_BASIC                                        \
  (_RE_SYNTAX_POSIX_COMMON | RE_LIMITED_OPS)

#define RE_SYNTAX_POSIX_EXTENDED                                        \
  (_RE_SYNTAX_POSIX_COMMON | RE_CONTEXT_INDEP_ANCHORS                   \
   | RE_CONTEXT_INDEP_OPS  | RE_NO_BK_BRACES                            \
   | RE_NO_BK_PARENS       | RE_NO_BK_VBAR                              \
   | RE_UNMATCHED_RIGHT_PAREN_ORD)

/* Differs from ..._POSIX_EXTENDED in that RE_CONTEXT_INVALID_OPS
   replaces RE_CONTEXT_INDEP_OPS and RE_NO_BK_REFS is added.  */
#define RE_SYNTAX_POSIX_MINIMAL_EXTENDED                                \
  (_RE_SYNTAX_POSIX_COMMON  | RE_CONTEXT_INDEP_ANCHORS                        \
   | RE_CONTEXT_INVALID_OPS | RE_NO_BK_BRACES                                \
   | RE_NO_BK_PARENS        | RE_NO_BK_REFS                                \
   | RE_NO_BK_VBAR            | RE_UNMATCHED_RIGHT_PAREN_ORD)
/* [[[end syntaxes]]] */

/* Maximum number of duplicates an interval can allow.  Some systems
   (erroneously) define this in other header files, but we want our
   value, so remove any previous define.  */
#ifdef RE_DUP_MAX
# undef RE_DUP_MAX
#endif
/* If sizeof(int) == 2, then ((1 << 15) - 1) overflows.  */
#define RE_DUP_MAX (0x7fff)


/* POSIX `cflags' bits (i.e., information for `regcomp').  */

/* If this bit is set, then use extended regular expression syntax.
   If not set, then use basic regular expression syntax.  */
#define REG_EXTENDED 1

/* If this bit is set, then ignore case when matching.
   If not set, then case is significant.  */
#define REG_ICASE (REG_EXTENDED << 1)

/* If this bit is set, then anchors do not match at newline
     characters in the string.
   If not set, then anchors do match at newlines.  */
#define REG_NEWLINE (REG_ICASE << 1)

/* If this bit is set, then report only success or fail in regexec.
   If not set, then returns differ between not matching and errors.  */
#define REG_NOSUB (REG_NEWLINE << 1)

/* These next two flags for awka's exact-string shortcut */
#define REG_ISBOL 1
#define REG_ISEOL 2


/* POSIX `eflags' bits (i.e., information for regexec).  */

/* If this bit is set, then the beginning-of-line operator doesn't match
     the beginning of the string (presumably because it's not the
     beginning of a line).
   If not set, then the beginning-of-line operator does match the
     beginning of the string.  */
#define REG_NOTBOL 1

/* Like REG_NOTBOL, except for the end-of-line.  */
#define REG_NOTEOL (1 << 1)

#define REG_NEEDSTART (1 << 2)


/* If any error codes are removed, changed, or added, update the
   `re_error_msg' table in regex.c.  */
typedef enum
{
#ifdef _XOPEN_SOURCE
  REG_ENOSYS = -1,        /* This will never happen for this implementation.  */
#endif

  REG_NOERROR = 0,        /* Success.  */
  REG_NOMATCH,                /* Didn't find a match (for regexec).  */

  /* POSIX regcomp return error codes.  (In the order listed in the
     standard.)  */
  REG_BADPAT,                /* Invalid pattern.  */
  REG_ECOLLATE,                /* Not implemented.  */
  REG_ECTYPE,                /* Invalid character class name.  */
  REG_EESCAPE,                /* Trailing backslash.  */
  REG_ESUBREG,                /* Invalid back reference.  */
  REG_EBRACK,                /* Unmatched left bracket.  */
  REG_EPAREN,                /* Parenthesis imbalance.  */
  REG_EBRACE,                /* Unmatched \{.  */
  REG_BADBR,                /* Invalid contents of \{\}.  */
  REG_ERANGE,                /* Invalid range end.  */
  REG_ESPACE,                /* Ran out of memory.  */
  REG_BADRPT,                /* No preceding re for repetition op.  */

  /* Error codes we've added.  */
  REG_EEND,                /* Premature end.  */
  REG_ESIZE,                /* Compiled pattern bigger than 2^16 bytes.  */
  REG_ERPAREN                /* Unmatched ) or \); not returned from regcomp.  */
} reg_errcode_t;

/* This data structure represents a compiled pattern.  Before calling
   the pattern compiler, the fields `buffer', `allocated', `fastmap',
   `translate', and `no_sub' can be set.  After the pattern has been
   compiled, the `re_nsub' field is available.  All other fields are
   private to the regex routines.  */

#ifndef RE_TRANSLATE_TYPE
# define RE_TRANSLATE_TYPE char *
#endif

struct re_pattern_buffer
{
/* [[[begin pattern_buffer]]] */
        /* Space that holds the compiled pattern.  It is declared as
          `unsigned char *' because its elements are
           sometimes used as array indexes.  */
  char *origstr;
  unsigned char *buffer;
  void *dfa;   /* contains dfa structure if its used */

        /* Number of bytes to which `buffer' points.  */
  unsigned long int allocated;

        /* Number of bytes actually used in `buffer'.  */
  unsigned long int used;

        /* Syntax setting with which the pattern was compiled.  */
  reg_syntax_t syntax;

        /* Pointer to a fastmap, if any, otherwise zero.  re_search uses
           the fastmap, if there is one, to skip over impossible
           starting points for matches.  */
  char *fastmap;

        /* Either a translate table to apply to all characters before
           comparing them, or zero for no translation.  The translation
           is applied to a pattern when it is compiled and to a string
           when it is matched.  */
  RE_TRANSLATE_TYPE translate;

  int fs;

  int cant_be_null;

  int gsub;

  int strlen;

  int max_sub;

  int reganch;

  int isexact;

        /* Number of subexpressions found by the compiler.  */
  size_t re_nsub;

        /* Zero if this pattern cannot match the empty string, one else.
           Well, in truth it's used only in `re_search_2', to see
           whether or not we should use the fastmap, so we don't set
           this absolutely perfectly; see `re_compile_fastmap' (the
           `duplicate' case).  */
  unsigned can_be_null : 1;

        /* If REGS_UNALLOCATED, allocate space in the `regs' structure
             for `max (RE_NREGS, re_nsub + 1)' groups.
           If REGS_REALLOCATE, reallocate space if necessary.
           If REGS_FIXED, use what's there.  */
#define REGS_UNALLOCATED 0
#define REGS_REALLOCATE 1
#define REGS_FIXED 2
  unsigned regs_allocated : 2;

        /* Set to zero when `regex_compile' compiles a pattern; set to one
           by `re_compile_fastmap' if it updates the fastmap.  */
  unsigned fastmap_accurate : 1;

        /* If set, `re_match_2' does not return information about
           subexpressions.  */
  unsigned no_sub : 1;

        /* If set, a beginning-of-line anchor doesn't match at the
           beginning of the string.  */
  unsigned not_bol : 1;

        /* Similarly for an end-of-line anchor.  */
  unsigned not_eol : 1;

        /* If true, an anchor at a newline matches.  */
  unsigned newline_anchor : 1;

/* [[[end pattern_buffer]]] */
};

/* typedef struct re_pattern_buffer regex_t; */
typedef struct re_pattern_buffer awka_regexp;

/* Type for byte offsets within the string.  POSIX mandates this.  */
typedef int regoff_t;


/* This is the structure we store register match data in.  See
   regex.texinfo for a full description of what registers match.  */
struct re_registers
{
  unsigned num_regs;
  regoff_t *start;
  regoff_t *end;
};


/* If `regs_allocated' is REGS_UNALLOCATED in the pattern buffer,
   `re_match_2' returns information about at least this many registers
   the first time a `regs' structure is passed.  */
#ifndef RE_NREGS
# define RE_NREGS 30
#endif


/* POSIX specification for registers.  Aside from the different names than
   `re_registers', POSIX uses an array of structures, instead of a
   structure of arrays.  */
typedef struct
{
  regoff_t rm_so;  /* Byte offset from string's start to substring's start.  */
  regoff_t rm_eo;  /* Byte offset from string's start to substring's end.  */
} regmatch_t;

/* Declarations for routines.  */

/* To avoid duplicating every routine declaration -- once with a
   prototype (if we are ANSI), and once without (if we aren't) -- we
   use the following macro to declare argument types.  This
   unfortunately clutters up the declarations a bit, but I think it's
   worth it.  */

#if __STDC__

# define _RE_ARGS(args) args

#else /* not __STDC__ */

# define _RE_ARGS(args) ()

#endif /* not __STDC__ */

/* Sets the current default syntax to SYNTAX, and return the old syntax.
   You can also simply assign to the `re_syntax_options' variable.  */
extern reg_syntax_t re_set_syntax _RE_ARGS ((reg_syntax_t syntax));

/* Compile the regular expression PATTERN, with length LENGTH
   and syntax given by the global `re_syntax_options', into the buffer
   BUFFER.  Return NULL if successful, and an error string if not.  */
extern const char *re_compile_pattern
  _RE_ARGS ((const char *pattern, size_t length,
             struct re_pattern_buffer *buffer));


/* Compile a fastmap for the compiled pattern in BUFFER; used to
   accelerate searches.  Return 0 if successful and -2 if was an
   internal error.  */
extern int re_compile_fastmap _RE_ARGS ((struct re_pattern_buffer *buffer));


/* Search in the string STRING (with length LENGTH) for the pattern
   compiled into BUFFER.  Start searching at position START, for RANGE
   characters.  Return the starting position of the match, -1 for no
   match, or -2 for an internal error.  Also return register
   information in REGS (if REGS and BUFFER->no_sub are nonzero).  */
extern int re_search
  _RE_ARGS ((struct re_pattern_buffer *buffer, const char *string,
            int length, int start, int range, struct re_registers *regs));


/* Like `re_search', but search in the concatenation of STRING1 and
   STRING2.  Also, stop searching at index START + STOP.  */
extern int re_search_2
  _RE_ARGS ((struct re_pattern_buffer *buffer, const char *string1,
             int length1, const char *string2, int length2,
             int start, int range, struct re_registers *regs, int stop));


/* Like `re_search', but return how many characters in STRING the regexp
   in BUFFER matched, starting at position START.  */
extern int re_match
  _RE_ARGS ((struct re_pattern_buffer *buffer, const char *string,
             int length, int start, struct re_registers *regs));


/* Relates to `re_match' as `re_search_2' relates to `re_search'.  */
extern int re_match_2
  _RE_ARGS ((struct re_pattern_buffer *buffer, const char *string1,
             int length1, const char *string2, int length2,
             int start, struct re_registers *regs, int stop));


/* Set REGS to hold NUM_REGS registers, storing them in STARTS and
   ENDS.  Subsequent matches using BUFFER and REGS will use this memory
   for recording register information.  STARTS and ENDS must be
   allocated with malloc, and must each be at least `NUM_REGS * sizeof
   (regoff_t)' bytes long.

   If NUM_REGS == 0, then subsequent matches should allocate their own
   register data.

   Unless this function is called, the first search or match using
   PATTERN_BUFFER will allocate its own register data, without
   freeing the old data.  */
extern void re_set_registers
  _RE_ARGS ((struct re_pattern_buffer *buffer, struct re_registers *regs,
             unsigned num_regs, regoff_t *starts, regoff_t *ends));

  
#if defined _REGEX_RE_COMP || defined _LIBC
# ifndef _CRAY
/* 4.2 bsd compatibility.  */
extern char *re_comp _RE_ARGS ((const char *));
extern int re_exec _RE_ARGS ((const char *));
# endif
#endif

/* POSIX compatibility.  */
/* extern int regcomp _RE_ARGS ((awka_regexp *__preg, const char *__pattern,
                              int __cflags)); */
extern awka_regexp * awka_regcomp _RE_ARGS ((char *__pattern, char gsub));

extern int awka_regexec _RE_ARGS ((awka_regexp *__preg,
                              char *__string, size_t __nmatch,
                              regmatch_t __pmatch[], int __eflags));

extern size_t regerror _RE_ARGS ((int __errcode, const awka_regexp *__preg,
                                  char *__errbuf, size_t __errbuf_size));

extern void regfree _RE_ARGS ((awka_regexp *__preg));


#ifdef __cplusplus
}
#endif        /* C++ */

#endif /* regex.h */

/*
Local variables:
make-backup-files: t
version-control: t
trim-versions-without-asking: nil
End:
*/

/*--------------------------------------------------*
 | var.h                                            |
 | Header file for var.c, part of the Awka          |
 | Library, Copyright 1999, Andrew Sumner.          |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _VAR_H
#define _VAR_H

#define a_VARNUL 0  /* vars not set to anything yet */
#define a_VARDBL 1  /* vars set to double */
#define a_VARSTR 2  /* vars set to string */
#define a_VARARR 4  /* array variables */
#define a_VARREG 5  /* regular expressions */
#define a_VARUNK 6  /* contents of a split array & return from getline */

#define a_DBLSET 7  /* indicates string var with double value set */
#define a_STRSET 8  /* indicates double var with string value set */

/* builtin variables */
#define a_ARGC        0
#define a_ARGIND      1
#define a_ARGV        2
#define a_CONVFMT     3
#define a_ENVIRON     4
#define a_FILENAME    5
#define a_FNR         6
#define a_FS          7
#define a_NF          8
#define a_NR          9
#define a_OFMT        10
#define a_OFS         11
#define a_ORS         12
#define a_RLENGTH     13
#define a_RS          14
#define a_RSTART      15
#define a_RT          16
#define a_SUBSEP      17
#define a_DOL0        18
#define a_DOLN        19
#define a_FIELDWIDTHS 20
#define a_SAVEWIDTHS  21
#define a_SORTTYPE    22
#define a_PROCINFO    23

#define a_BIVARS      24

#define _RE_SPLIT   0
#define _RE_MATCH   1
#define _RE_GSUB    2

typedef struct {
  double dval;          /* double value, set when type & a_DBLVAR */
  char * ptr;           /* string value, except with array vars */
  unsigned int slen;    /* length of ptr as returned by strlen */
  unsigned int allc;    /* space mallocated for ptr */
  char type;            /* records current cast of variable */
  char type2;           /* for string vars, TRUE if dval is set */
  char temp;            /* TRUE if a temporary variable */
} a_VAR;

typedef struct {
  a_VAR *var[256];
  int used;
} a_VARARG;

void          awka_killvar( a_VAR * );
a_VAR *       _awka_getdval( a_VAR *, char *, int );
a_VAR *       _awka_setdval( a_VAR *, char *, int );
char *        _awka_getsval( a_VAR *, char, char *, int );
char **       awka_setsval( a_VAR *, char *, int );
awka_regexp * _awka_getreval( a_VAR *, char *, int, char );
awka_regexp * _awka_compile_regexp_SPLIT(char *str, unsigned len);
awka_regexp * _awka_compile_regexp_MATCH(char *str, unsigned len);
awka_regexp * _awka_compile_regexp_GSUB(char *str, unsigned len);
a_VAR *       awka_strdcpy( a_VAR *, double d );
a_VAR *       awka_strscpy( a_VAR *, char *s );
double        awka_vardblset( a_VAR *, double d );
a_VAR *       awka_varcpy( a_VAR *, a_VAR * );
int           awka_vartrue( a_VAR *v );
double        awka_varcmp( a_VAR *, a_VAR * );
double        awka_dbl2varcmp( double, a_VAR * );
double        awka_var2dblcmp( a_VAR *, double );
int           awka_nullval( char * );
double        awka_str2pow( char * );
void          awka_parsecmdline(int first);
a_VAR *       awka_tmp_dbl2var(double);
char *        awka_tmp_dbl2str(double);
a_VAR *       awka_tmp_str2var(char *);
a_VAR *       awka_ro_str2var(char *);
a_VAR *       awka_tmp_str2revar(char *);
a_VAR *       awka_tmp_re2var(awka_regexp *r);
void          _awka_re2s(a_VAR *);
void          _awka_re2null(a_VAR *);
a_VAR *       awka_vardup(a_VAR *);
double        awka_postinc(a_VAR *);
double        awka_postdec(a_VAR *);

#ifndef _INIT_C
extern a_VAR *a_bivar[a_BIVARS];
#else
a_VAR *a_bivar[a_BIVARS];
#endif

#ifndef _VAR_C
extern char _awka_arg_change;
#endif

#ifndef _ARRAY_C
extern char fs_or_fw, _awka_setdol0_len;
extern char _rebuild0, _rebuildn, _rebuild0_now;
#endif

#define _awka_set_FW(v) \
  if ((v) == a_bivar[a_FS]) \
    fs_or_fw = 0; \
  else if ((v) == a_bivar[a_FIELDWIDTHS]) \
    fs_or_fw = 1;

static int
awka_isadbl( char *s, int len )
{
  register char *p = s, dot = FALSE;

  /* while (*p == ' ') p++; */
  for ( ;*p; p++)
  {
    if (*p == '.')
    {
      if (dot == TRUE)
        return FALSE;
      dot = TRUE;
      continue;
    }
    if (*p == ' ') break;
    if (!isdigit(*p)) return FALSE;
  }

  if (!*p) return TRUE;

  /* while (*p == ' ') p++; */
  if (*p) return FALSE;
  return TRUE;
}

static a_VAR *
awka_getdval( a_VAR *v, char *file, int line )
{
  if (v->type == a_VARDBL || v->type2 == a_DBLSET) 
    return v;
  return _awka_getdval(v, file, line);
}

static a_VAR *
awka_setdval( a_VAR *v, char *file, int line )
{
  v->type2 = 0;
  if (v->type == a_VARDBL)
    return v;
 
  return _awka_setdval(v, file, line);
}

static char *
awka_getsval( a_VAR *v, char ofmt, char *file, int line )
{
  if (v->type == a_VARSTR || v->type == a_VARUNK ||
     (v->type == a_VARDBL && v->type2 == a_STRSET))
    return v->ptr;
  return _awka_getsval(v, ofmt, file, line );
}

static char *
awka_getsvalP( a_VAR *v, char ofmt, char *file, int line )
{
  if (v->type == a_VARSTR || v->type == a_VARUNK)
    return v->ptr;
  return _awka_getsval(v, ofmt, file, line );
}

static awka_regexp *
awka_getreval( a_VAR *v, char *file, int line )
{
  v->type2 = 0;
  if (v->type == a_VARREG && v->ptr)
    return (awka_regexp *) v->ptr;
  return _awka_getreval(v, file, line, _RE_MATCH);
}

static void
awka_forcestr( a_VAR *v )
{
  v->type2 = 0;
  if (v->type != a_VARSTR && v->type != a_VARUNK)
    awka_setsval(v, __FILE__, __LINE__);
  v->type = a_VARSTR;
}

static a_VAR *
awka_argv()
{
  _awka_arg_change = TRUE;
  return a_bivar[a_ARGV];
}

static a_VAR *
awka_argc()
{
  _awka_arg_change = TRUE;
  return a_bivar[a_ARGC];
}

static void
awka_lcopy(a_VAR *va, a_VAR *vb)
{
  va->ptr = vb->ptr;
  va->slen = vb->slen;
  va->allc = 0;
  va->dval = vb->dval;
  va->type = vb->type;
  va->type2 = vb->type2;
}

#define awka_getd(v)  (awka_getdval((v),__FILE__,__LINE__)->dval) 
#define awka_setd(v)  (awka_setdval((v),__FILE__,__LINE__)->dval)
#define awka_gets(v)  (awka_getsval((v),0,__FILE__,__LINE__)) 
#define awka_getsP(v) (awka_getsvalP((v),1,__FILE__,__LINE__)) 
#define awka_sets(v)  (*(awka_setsval((v),__FILE__,__LINE__)))
#define awka_getre(v) (awka_getreval((v),__FILE__,__LINE__))

#define awka_gets1(v) ((v)->ptr && ((v)->type == a_VARSTR || (v)->type == a_VARUNK) ? (v)->ptr : _awka_getsval((v),0,__FILE__,__LINE__)) 
#define awka_gets1P(v) ((v)->ptr && ((v)->type == a_VARSTR || (v)->type == a_VARUNK) ? (v)->ptr : _awka_getsval((v),1,__FILE__,__LINE__)) 
#define awka_getd1(v) ((v)->type == a_VARDBL || (v)->type2 == a_DBLSET ? (v)->dval : _awka_getdval((v),__FILE__,__LINE__)->dval)

#define awka_poi(v) (((v)->type == a_VARDBL && (v)->type2 != a_STRSET) ? ((v)->dval)++ : awka_postinc(v))
#define awka_pri(v) (((v)->type == a_VARDBL && (v)->type2 != a_STRSET) ? ++(v)->dval : ++awka_setd(v))
#define awka_pod(v) (((v)->type == a_VARDBL && (v)->type2 != a_STRSET) ? ((v)->dval)-- : awka_postdec(v))
#define awka_prd(v) (((v)->type == a_VARDBL && (v)->type2 != a_STRSET) ? --(v)->dval : --awka_setd(v))

#define awka_varinit(v) { \
       malloc( (void **) &(v), sizeof(a_VAR) ); \
       (v)->dval = 0.0; \
       (v)->temp = (v)->type2 = 0; \
       (v)->type = a_VARNUL; \
       (v)->slen = (v)->allc = 0; \
       (v)->ptr = NULL; }

a_VAR *  awka_argval(int, a_VAR *, int, int, a_VARARG *);
void    _awka_addfnvar(int, int, a_VAR *, int);
a_VAR * _awka_usefnvar(int, int);
a_VAR * _awka_addfncall(int);
void    _awka_retfn(int);
int     _awka_registerfn(char *, int);

static a_VAR *
awka_fn_varinit(int fn_idx, int var_idx, int type)
{
  a_VAR *var;

  if (!(var = _awka_usefnvar(fn_idx, var_idx)))
  {
    awka_varinit(var);
    var->temp = 2;
    _awka_addfnvar(fn_idx, var_idx, var, type);
  }
  return var;
}

#ifdef MEM_DEBUG
char *awka_strcpy(a_VAR *v, char *s);
#else
static char *
awka_strcpy(a_VAR *v, char *s)
{ 
  register int _slen = strlen(s)+1;
  _awka_set_FW(v);
  if (v->type == a_VARREG)
    _awka_re2s(v);
  if (v->type != a_VARSTR && v->type != a_VARUNK) 
    awka_setsval(v, __FILE__, __LINE__);
  if (v->ptr && v->allc <= _slen)
    v->allc = realloc( (void **) &v->ptr, _slen );
  else if (!v->ptr)
    v->allc = malloc( (void **) &v->ptr, _slen );
  v->slen = _slen-1;
  memcpy(v->ptr, s, _slen);
  v->type = a_VARSTR;
  v->type2 = 0;
  if (v == a_bivar[a_DOL0])
  {
    _rebuild0_now = _rebuild0 = FALSE;
    _rebuildn = _awka_setdol0_len = TRUE;
  }
  return v->ptr;
}
#endif

static char *
awka_strncpy(a_VAR *v, char *s, int _slen)
{ 
  _awka_set_FW(v);
  if (v->type == a_VARREG)
    _awka_re2s(v);
  if (v->type != a_VARSTR && v->type != a_VARUNK) 
    awka_setsval(v, __FILE__, __LINE__);
  if (v->ptr && v->allc <= _slen+1)
    v->allc = realloc( (void **) &v->ptr, _slen+1 );
  else if (!v->ptr)
    v->allc = malloc( (void **) &v->ptr, _slen+1 );
  v->slen = _slen;
  memcpy(v->ptr, s, _slen);
  v->ptr[_slen] = '\0';
  v->type = a_VARSTR;
  v->type2 = 0;
  return v->ptr;
}

static void
awka_setstrlen(a_VAR *v, register int slen)
{
  _awka_set_FW(v);
  slen++;
  if (v->type == a_VARREG)
    _awka_re2s(v);
  if (v->type != a_VARSTR && v->type != a_VARUNK)
    awka_setsval(v, __FILE__, __LINE__);
  if (v->ptr && v->allc < slen)
    v->allc = realloc( (void **) &v->ptr, slen );
  else if (!(v)->ptr)
    v->allc = malloc( (void **) &v->ptr, slen );
  v->slen = slen - 1;
  v->type2 = 0;
}

#define awka_strtrue(s) ((s)[0] != '\0' ? 1 : 0)

static double
_awka_dnotzero(double d, char *file, int line) 
{
  if (d == 0.0)
    awka_error("Math Error: Divide By Zero, file %s line %d.\n",file,line); 
  return d;
}

#define awka_dnotzero(d) _awka_dnotzero(d, __FILE__, __LINE__)

static double
awka_div(double d1, double d2)
{
  if (d2 == 0.0)
    awka_error("Math Error: Divide By Zero");
  return d1 / d2;
}

#endif

/*--------------------------------------------------*
 | array.h                                          |
 | Header file for array.c, part of the Awka        |
 | Library, Copyright 1999, Andrew Sumner.          |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _ARRAY_H
#define _ARRAY_H

#define a_ARR_TYPE_NULL  0
#define a_ARR_TYPE_SPLIT 1
#define a_ARR_TYPE_HSH   2

#define a_ARR_CREATE 1
#define a_ARR_QUERY  2
#define a_ARR_DELETE 3

typedef struct _hshnode a_HSHNode;
struct _hshnode {
  a_HSHNode *next;
  char *key;
  a_VAR *var;
  unsigned int hval;
  char type;
  char shadow;
};

typedef struct {
  a_HSHNode **node;
  int type;
  int base;
  int nodeno;
  int id;
} a_List;

typedef struct {
  a_List *list;
  int allc;
  int used;
} a_ListHdr;

typedef struct {
  char *str;
  double *delem;
  char **pelem;
  int *lelem;
  char *dset;
  int alloc;
  int elem;
  int dalloc;
} _a_Subscript;

typedef struct {
  a_HSHNode **slot;
  _a_Subscript *subscript;
  a_HSHNode *last;
  char *splitstr;
  int nodeno; 
  int nodeallc;  /* used with split arrays to monitor allocated size */
  int splitallc;
  int base;      /* for split arrays */
  unsigned int hashmask;   /* current number of hash slots */
  char type;
  char flag;
  char fill_1;
  char fill_2;
} _a_HSHarray;

void         awka_arraycreate( a_VAR *var, char type );
void         awka_arrayclear( a_VAR *var );
a_VAR *      awka_arraysearch1( a_VAR *v, a_VAR *element, char create, int set );
a_VAR *      awka_arraysearch( a_VAR *v, a_VARARG *va, char create );
double       awka_arraysplitstr( char *str, a_VAR *v, a_VAR *fs, int max, char );
int          awka_arrayloop( a_ListHdr *ah, a_VAR *v, char );
int          awka_arraynext( a_VAR *v, a_ListHdr *, int );
void         awka_alistfree( a_ListHdr * );
void         awka_alistfreeall( a_ListHdr * );
a_VAR *      awka_doln(int, int);
a_VAR *      _awka_dol0(int);
double       awka_asort( a_VAR *src, a_VAR *dst );

#ifndef _ARRAY_C
extern char _awka_setdoln;
extern int  _awka_dol0_len;
extern char _dol0_only;
#endif

extern int _split_max;

static INLINE a_VAR *
awka_NFset()
{
  _rebuild0_now = _rebuild0 = _awka_setdoln = TRUE;
  _rebuildn = FALSE;
  return a_bivar[a_NF];
}

static INLINE a_VAR *
awka_NFget()
{
  if (_rebuildn)
  {
    awka_setd(a_bivar[a_NF]) = awka_arraysplitstr(awka_gets1(a_bivar[a_DOL0]), a_bivar[a_DOLN], a_bivar[a_FS], _split_max, TRUE);
    _rebuildn = FALSE;
  }
  return a_bivar[a_NF];
}

static INLINE int
awka_alength( a_VAR *v )
{
  if (v->type != a_VARARR)
    awka_error("Runtime Error: Scalar used as Array when passed to alength()\n");
  if (!v->ptr) return 0;
  return ((_a_HSHarray *) v->ptr)->nodeno;
}

static INLINE a_VAR *
awka_dol0(int set)
{
  if (_dol0_only)
    return a_bivar[a_DOL0];
  else
    return _awka_dol0(set);
}

#endif

/*--------------------------------------------------*
 | builtin.h                                        |
 | Header file for builtin.c, part of the Awka      |
 | Library, Copyright 1999, Andrew Sumner.          |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _BUILTIN_H
#define _BUILTIN_H

#define a_KEEP 0
#define a_TEMP 1

#define a_BI_TOUPPER 1
#define a_BI_TOLOWER 2
#define a_BI_TOTITLE 3

#ifndef _IN_LIBRARY
static double
awka_length(a_VAR *v)
{
  awka_gets1(v);
  return (double) v->slen;
}

static double
awka_index(a_VAR *va, a_VAR *vb)
{
  register char *c, *a, *b;

  a = awka_gets1(va);
  b = awka_gets1(vb);
  c = strstr(a, b);

  if (c)
    return (double) ((c - a) + 1);
  return 0;
}

static double
awka_and(a_VAR *va, a_VAR *vb)
{
  return (double) ((int) awka_getd1(va) & (int) awka_getd1(vb));
}

static double
awka_or(a_VAR *va, a_VAR *vb)
{
  return (double) ((int) awka_getd1(va) | (int) awka_getd1(vb));
}

static double
awka_xor(a_VAR *va, a_VAR *vb)
{
  return (double) ((int) awka_getd1(va) ^ (int) awka_getd1(vb));
}

static double
awka_compl(a_VAR *va)
{
  return (double) (~((int) awka_getd1(va)));
}

static double
awka_lshift(a_VAR *va, a_VAR *vb)
{
  return (double) ((int) awka_getd1(va) << (int) awka_getd1(vb));
}

static double
awka_rshift(a_VAR *va, a_VAR *vb)
{
  return (double) ((int) awka_getd1(va) >> (int) awka_getd1(vb));
}

#endif

a_VAR *    awka_getstringvar(char);
a_VAR *    awka_getdoublevar(char);
a_VAR *    awka_strconcat2(char, a_VAR *, a_VAR *);
a_VAR *    awka_strconcat3(char, a_VAR *, a_VAR *, a_VAR *);
a_VAR *    awka_strconcat4(char, a_VAR *, a_VAR *, a_VAR *, a_VAR *);
a_VAR *    awka_strconcat5(char, a_VAR *, a_VAR *, a_VAR *, a_VAR *, a_VAR *);
a_VAR *    awka_strconcat(char, a_VARARG *);
a_VAR *    awka_match(char, char, a_VAR *, a_VAR *, a_VAR *);
a_VAR *    awka_substr(char, a_VAR *, double, double);
a_VAR *    awka_sub(char, char, int, a_VAR *, a_VAR *, a_VAR *);
a_VAR *    awka_gensub(char, a_VAR *, a_VAR *, a_VAR *, a_VAR *);
a_VAR *    awka_tocase(char, char, a_VAR *);
a_VAR *    awka_system(char, a_VAR *);
a_VAR *    awka_trim(char, a_VARARG *);
a_VAR *    awka_ltrim(char, a_VARARG *);
a_VAR *    awka_rtrim(char, a_VARARG *);
double     awka_rand();
a_VAR *    awka_srand(char, a_VARARG *);
a_VAR *    awka_left(char, a_VAR *, a_VAR *);
a_VAR *    awka_right(char, a_VAR *, a_VAR *);
a_VAR *    awka_ascii(char, a_VARARG *);
a_VAR *    awka_char(char, a_VAR *);
a_VAR *    awka_time(char, a_VARARG *);
a_VAR *    awka_systime(char);
a_VAR *    awka_gmtime(char, a_VARARG *);
a_VAR *    awka_localtime(char, a_VARARG *);
a_VAR *    awka_mktime(char, a_VARARG *);
a_VAR *    awka_strftime(char, a_VARARG *);
a_VAR *    awka_min(char, a_VARARG *);
a_VAR *    awka_max(char, a_VARARG *);
a_VAR *    awka_sprintf(char, a_VARARG *);
a_VAR *    awka_getline(char, a_VAR *, char *, int, char);
a_VAR *    awka_fflush(char, a_VARARG *);
a_VAR *    awka_close(char, a_VARARG *);
void       awka_printf( char *, int, int, a_VARARG * );
void       awka_print( char *, int, int, a_VARARG * );
a_VARARG * awka_vararg(char, a_VAR *var, ...);
a_VARARG * awka_arg0(char);
a_VARARG * awka_arg1(char, a_VAR *);
a_VARARG * awka_arg2(char, a_VAR *, a_VAR *);
a_VARARG * awka_arg3(char, a_VAR *, a_VAR *, a_VAR *);

#define awka_length0   awka_length(awka_doln(0,0))
                          
#ifndef BUILTIN_HOME
extern int _awka_file_read;
#endif

#endif


/*--------------------------------------------------*
 | io.h                                             |
 | Header file for io.c, part of the Awka           |
 | Library, Copyright 1999, Andrew Sumner.          |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _IO_H
#define _IO_H

#define A_BUFSIZ 16384 

#define _a_IO_CLOSED 0
#define _a_IO_READ   1
#define _a_IO_WRITE  2
#define _a_IO_APPEND 4
#define _a_IO_EOF    8

typedef struct {
  char *name;       /* name of output file or device */
  FILE *fp;         /* file pointer */
  char *buf;        /* input buffer */
  char *current;    /* where up to in buffer */
  char *end;        /* end of data in buffer */
  int alloc;        /* size of input buffer */
  char io;          /* input or output stream flag */
  char pipe;        /* true/false */
  char lastmode;    /* for |& this records whether stream was last read from
                       or written to */
  char interactive; /* whether from a /dev/xxx stream or not */
} _a_IOSTREAM;

#ifndef _IO_C
extern _a_IOSTREAM *_a_iostream;
extern int _a_ioallc, _a_ioused;
#endif

int _awka_io_addstream( char *name, char flag, int pipe );
int awka_io_readline( a_VAR *var, int, int );
void awka_exit(double);
void awka_cleanup();
int _awka_wait_pid(int);

#endif

/*--------------------------------------------------*
 | init.h                                           |
 | Header file for init.c, part of the Awka         |
 | Library, Copyright 1999, Andrew Sumner.          |
 | This file is covered by the GNU General Public   |
 | License (GPL).                                   |
 *--------------------------------------------------*/

#ifndef _INIT_H
#define _INIT_H

void awka_init(int argc, char *argv[], char *, char *);
void _awka_kill_ivar();
void _awka_kill_gvar();
void _awka_kill_fn();

#if defined(__cplusplus)
extern "C" {
#endif

struct awka_fn_struct {
  char *name;
  a_VAR * (*fn)( a_VARARG *);
};

#if defined(__cplusplus)
}
#endif

struct gvar_struct {
  char *name;
  a_VAR *var;
};

void     awka_initgvar(int, char *, a_VAR *);
#ifndef _INIT_C
extern char **awka_filein;
extern int awka_filein_no;
extern struct awka_fn_struct *_awkafn;
#endif

static INLINE char
awka_setNF()
{
  extern int _split_req, _split_max;
  if (_split_req == 1)
    awka_setd(a_bivar[a_NF]) = awka_arraysplitstr(awka_gets1(a_bivar[a_DOL0]), a_bivar[a_DOLN], NULL, _split_max, TRUE);
  return 1;
}


#endif

#if defined(__cplusplus)
}
#endif

#endif
