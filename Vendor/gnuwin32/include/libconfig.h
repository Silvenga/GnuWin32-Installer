#  ifndef _RSK_LIBCONFIG_H
#  define _RSK_LIBCONFIG_H

#  ifdef __cplusplus
extern "C" {
#  endif


#  ifndef __GNUC__
#   define __DLL_IMPORT__ __declspec(dllimport)
#   define __DLL_EXPORT__ __declspec(dllexport)
#  else
#   define __DLL_IMPORT__ __attribute__((dllimport)) extern
#   define __DLL_EXPORT__ __attribute__((dllexport)) extern
#  endif 

#  if (defined __WIN32__) || (defined _WIN32)
#   ifdef BUILD_LIBCONFIG_DLL
#    define LIBCONFIG_DLL_IMPEXP __DLL_EXPORT__
#   elif defined(LIBCONFIG_STATIC)
#    define LIBCONFIG_DLL_IMPEXP  
#   elif defined (USE_LIBCONFIG_DLL)
#    define LIBCONFIG_DLL_IMPEXP __DLL_IMPORT__
#   elif defined (USE_LIBCONFIG_STATIC)
#    define LIBCONFIG_DLL_IMPEXP   
#   else /* assume USE_LIBCONFIG_DLL */
#    define LIBCONFIG_DLL_IMPEXP __DLL_IMPORT__
#   endif
#  else /* __WIN32__ */
#   define LIBCONFIG_DLL_IMPEXP  
#  endif


typedef enum {
        LC_CONF_SECTION,
        LC_CONF_APACHE,
        LC_CONF_COLON,
        LC_CONF_EQUAL,
        LC_CONF_SPACE,
        LC_CONF_XML
} lc_conf_type_t;



typedef enum {
        LC_VAR_UNKNOWN,
        LC_VAR_NONE,
        LC_VAR_STRING,
        LC_VAR_LONG_LONG,
        LC_VAR_LONG,
        LC_VAR_INT,
        LC_VAR_SHORT,
        LC_VAR_BOOL,
        LC_VAR_FILENAME,
        LC_VAR_DIRECTORY,
        LC_VAR_SIZE_LONG_LONG,
        LC_VAR_SIZE_LONG,
        LC_VAR_SIZE_INT,
        LC_VAR_SIZE_SHORT,
        LC_VAR_TIME,
        LC_VAR_DATE,
        LC_VAR_SECTION,
        LC_VAR_SECTIONSTART,
        LC_VAR_SECTIONEND,
        LC_VAR_BOOL_BY_EXISTANCE,
        LC_VAR_SIZE_SIZE_T,
	LC_VAR_CIDR,
	LC_VAR_IP,
} lc_var_type_t;



typedef enum {
        LC_FLAGS_VAR,
        LC_FLAGS_CMDLINE,
        LC_FLAGS_ENVIRON,
        LC_FLAGS_SECTIONSTART,
        LC_FLAGS_SECTIONEND
} lc_flags_t;



typedef enum {
        LC_ERR_NONE,
        LC_ERR_INVCMD,
        LC_ERR_INVSECTION,
        LC_ERR_INVDATA,
        LC_ERR_BADFORMAT,
        LC_ERR_CANTOPEN,
        LC_ERR_CALLBACK,
        LC_ERR_ENOMEM
} lc_err_t;



LIBCONFIG_DLL_IMPEXP int lc_process(int argc, char **argv, const char *appname, lc_conf_type_t type, const char *extra);
LIBCONFIG_DLL_IMPEXP int lc_register_callback(const char *var, char opt, lc_var_type_t type, int (*callback)(const char *, const char *, const char *, const char *, lc_flags_t, void *), void *extra);
LIBCONFIG_DLL_IMPEXP int lc_register_var(const char *var, lc_var_type_t type, void *data, char opt);
LIBCONFIG_DLL_IMPEXP lc_err_t lc_geterrno(void);
LIBCONFIG_DLL_IMPEXP char *lc_geterrstr(void);
LIBCONFIG_DLL_IMPEXP int lc_process_file(const char *appname, const char *pathname, lc_conf_type_t type);
LIBCONFIG_DLL_IMPEXP void lc_cleanup(void);



#  define LC_CBRET_IGNORESECTION (255)
#  define LC_CBRET_OKAY (0)
#  define LC_CBRET_ERROR (-1)



LIBCONFIG_DLL_IMPEXP int lc_optind;


#  ifdef __cplusplus
}
#  endif

#  endif
