/* edll.h -- Enhanced Dynamic Link Library for MS-Windows
 * Copyright (c) 2005-2006  Alexis Wilke <alexis@m2osw.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * As a special exception to the GNU Lesser General Public License,
 * if you distribute this file as part of a program or library that
 * is built using GNU libtool, you may include it under the same
 * distribution terms that you use for the rest of that program.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 * 02111-1307  USA
 *
 * I hereby authorize anyone to use this library in closed source
 * software. However, if you make any modification to the library,
 * you must make these changes available to everyone (preferably
 * sent to me, but this is not a requirement.)
 */

/* Only include this header file once. */
#ifndef __EDLL_H__
#define __EDLL_H__


#ifdef __cplusplus
extern "C" {
#endif

#include	<edll/edll_config.h>


/*
 * Errors that edll_error() returns
 *
 * This table will be used in the enum {}; below and also when the
 * table of error messages is created.
 */
#ifdef EDLL_FRENCH
#define	edll_errors \
	EDLL_ERROR(none, "aucune erreur") \
	EDLL_ERROR(unknown, "numéro d'erreur EDLL inconnue") \
	EDLL_ERROR(out_of_memory, "plus de mémoire") \
	EDLL_ERROR(filename_overflow, "nom de fichier trop long") \
	EDLL_ERROR(invalid_filename, "nom de fichier invalide pour un module (vide ou inclus * ? \" < > ou |)") \
	EDLL_ERROR(invalid_path, "chemin d'accès invalid") \
	EDLL_ERROR(invalid_string, "chaine de caractères invalide") \
	EDLL_ERROR(cant_find_module, "impossible de trouver le module") \
	EDLL_ERROR(still_referenced, "module est encore référencé; il n'a pas encore été fermé") \
	EDLL_ERROR(not_initialized, "EDLL n'est pas actuellement utilisée") \
	EDLL_ERROR(cant_load_dll, "une erreur est survenue pendant le chargement d'une DLL") \
	EDLL_ERROR(cant_load_self, "une erreur est survenue pendant que je me chargeais moi-même") \
	EDLL_ERROR(cant_load_plugin, "une erreur est survenue pendant le chargement d'un plug-in") \
	EDLL_ERROR(incompatible_format, "le plug-in n'est pas d'un format compatible") \
	EDLL_ERROR(io_error, "une erreur est survenue pendant la lecture d'un fichier d'entrée") \
	EDLL_ERROR(bfd_error, "la librarie BFD a eut des problèmes pendant la lecture du fichier d'entrée") \
	EDLL_ERROR(bad_protection, "impossible de correctement définir les informations de protection pour la memoire") \
	EDLL_ERROR(version_mismatch, "les versions du programme et du module ne concordent pas -- chargement du module annulé") \

#else
#define	edll_errors \
	EDLL_ERROR(none, "no error") \
	EDLL_ERROR(unknown, "unknown EDLL error number") \
	EDLL_ERROR(out_of_memory, "out of memory") \
	EDLL_ERROR(filename_overflow, "filename is too long") \
	EDLL_ERROR(invalid_filename, "invalid filename for a module (empty or includes * ? \" < > or |)") \
	EDLL_ERROR(invalid_path, "invalid path") \
	EDLL_ERROR(invalid_string, "invalid string") \
	EDLL_ERROR(cant_find_module, "cannot find module") \
	EDLL_ERROR(still_referenced, "module is still referenced; it was not closed yet") \
	EDLL_ERROR(not_initialized, "the EDLL is not currently in use") \
	EDLL_ERROR(cant_load_dll, "an error occured while loading a dll") \
	EDLL_ERROR(cant_load_self, "an error occured while loading myself") \
	EDLL_ERROR(cant_load_plugin, "an error occured while loading a plug-in") \
	EDLL_ERROR(incompatible_format, "the plug-in is not in a compatible format") \
	EDLL_ERROR(io_error, "an error occured while reading an input file") \
	EDLL_ERROR(bfd_error, "the BFD library encountered some problems while reading the input file") \
	EDLL_ERROR(bad_protection, "cannot properly setup the memory protection information") \
	EDLL_ERROR(version_mismatch, "the program and module versions do not match -- module loading abort") \

#endif

typedef enum edll_errno_enum {
#define	EDLL_ERROR(name, msg)	edll_err_##name,
	edll_errors
#undef EDLL_ERROR

	/* errors are between none & max */
	edll_err_max
} edll_errno_t;


/* the content of this structure is private */
typedef struct edll_module_struct edll_module;

typedef void *		edll_ptr;

/* The EDLL functions, see the docs for more info */
extern	const char *	edll_getversion(void);
extern	int		edll_init(void);
extern	int		edll_exit(void);
#ifdef EDLL_VERSION_CHECK
extern	void		edll_set_self_version(const char *version);
#endif

extern	edll_ptr	edll_alloc(int size, int clear);
extern	edll_ptr	edll_realloc(edll_ptr ptr, int size, int oldsize);
extern	void		edll_free(edll_ptr ptr);

extern	edll_module *	edll_open(const char *filename);
extern	edll_ptr	edll_sym(edll_module *module, const char *name);
extern	edll_ptr	edll_msym(edll_module **module_ptr, const char *name);
#ifdef EDLL_VERSION_CHECK
extern	const char *	edll_module_version(edll_module *module);
#endif
extern	int		edll_close(edll_module *module);


extern	void		edll_seterror(edll_errno_t err);
extern	edll_errno_t	edll_geterror(void);
extern	const char *	edll_strerror(void);

extern	int		edll_setunixsearchpath(const char *path);
extern	int		edll_setsearchpath(const char *path);
extern	char *		edll_getsearchpath(void);


#ifdef EDLL_VERSION_CHECK
typedef int		(*edll_check_version)(
				const char *self_version,
				const char *module_version);
#endif

extern void		edll_callback_register(
#ifdef EDLL_VERSION_CHECK
				edll_check_version check_version_func
#endif
			);


/*
 * The EDLL can be used with multiple threads.
 * However, it needs you to specify a function to lock
 * and unlock threads to ensure atomicity when required.
 */
typedef void		(*edll_mutex_lock)(edll_ptr userdata);
typedef void		(*edll_mutex_unlock)(edll_ptr userdata);
typedef void		(*edll_mutex_seterror)(edll_ptr userdata, edll_errno_t err);
typedef edll_errno_t	(*edll_mutex_geterror)(edll_ptr userdata);

extern	void		edll_mutex_register(
				edll_mutex_lock lock_func,
				edll_mutex_unlock unlock_func,
				edll_mutex_seterror seterror_func,
				edll_mutex_geterror geterror_func,
				edll_ptr userdata);




/*
 * The following adds a section with the name of a dependency.
 * This should become an automated function with the usual
 * -l<name> of the ld tool. Also, the name of the section may need
 * to be changed to match some existing such section... (I think
 * ELF format already has such a section, the COFF PE format uses
 * import/export data.)
 *
 * Example to include the standard Kernel 32 DLL file:
 *
 *		EDLL_ADDLIB("kernel32.dll");
 *
 * Example to include your own plugin:
 *
 *		EDLL_ADDLIB("my_own_plugin.so");
 *
 * BUG:
 * Somehow, gcc/g++ now do not enter the string in the order we
 * put them in our file. This is rather annoying. I therefore added
 * the line number before the name. Number we will have to use to
 * sort the strings when read.
 */
#define	EDLL_ADDLIBS(name, n)	const char libsection_##n[] __attribute__((section(".load"))) = #n ">" name
#ifdef __cplusplus
#define	EDLL_ADDLIBN(name, n)	extern "C" EDLL_ADDLIBS(name, n)
#else
#define	EDLL_ADDLIBN(name, n)	EDLL_ADDLIBS(name, n)
#endif
#define	EDLL_ADDLIB(name)	EDLL_ADDLIBN(name, __LINE__)




#ifdef EDLL_VERSION_CHECK
/*
 * The EDLL_MODULE_VERSION() macro inserts a version mark in your module(s)
 * and executable. If the versions don't match, then the module(s)
 * and/or executable are considered incapable to function together
 * and the link fails.
 *
 * You cannot define more than one version per module and executable.
 *
 * The version parameter has to be a string such as:
 *
 *		"1.3.2b"
 *
 * The default matching is very simply done with strcmp() at this time.
 */
#define	EDLL_MODULE_VERSIONS(version_string)	const char module_version_section[] __attribute__((section(".version"))) = version_string
#ifdef __cplusplus
#define	EDLL_MODULE_VERSION(version_string)	extern "C" EDLL_MODULE_VERSIONS(version_string)
#else
#define	EDLL_MODULE_VERSION(version_string)	EDLL_MODULE_VERSIONS(version_string)
#endif


#endif	/* #ifdef EDLL_VERSION_CHECK */




#ifdef __cplusplus
};	/* extern "C" */
#endif


/* vim: set ts=8 */
#endif		/* #ifndef __EDLL_H__ */
