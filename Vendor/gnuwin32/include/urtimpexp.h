/* replace URT with the name of the library */
#ifndef _URTDLLIMPEXP_H_
#define _URTDLLIMPEXP_H_ 1

#ifndef __GNUC__
# define __DLL_IMPORT__	__declspec(dllimport)
# define __DLL_EXPORT__	__declspec(dllexport)
#else
# define __DLL_IMPORT__	__attribute__((dllimport)) extern
# define __DLL_EXPORT__	__attribute__((dllexport)) extern
#endif 

#if (defined __WIN32__) || (defined _WIN32)
# ifdef BUILD_URT_DLL
#  define URT_DLL_IMPEXP	__DLL_EXPORT__
# elif defined(BUILD_URT_STATIC)
#  define URT_DLL_IMPEXP	 
# elif defined (USE_URT_DLL)
#  define URT_DLL_IMPEXP	__DLL_IMPORT__
# elif defined (USE_URT_STATIC)
#  define URT_DLL_IMPEXP 	 
# else /* assume USE_URT_DLL */
#  define URT_DLL_IMPEXP	__DLL_IMPORT__
# endif
#else /* __WIN32__ */
# define URT_DLL_IMPEXP	 
#endif

#endif /* _URTDLLIMPEXP_H_ */
