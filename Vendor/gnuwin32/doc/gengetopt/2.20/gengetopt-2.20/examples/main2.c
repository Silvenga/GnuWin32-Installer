/* sample2.c */

/* If we use autoconf.  */
#ifdef HAVE_CONFIG_H
#	include "config.h"
#endif

#include <stdio.h>
#include <stdlib.h>

#include "cmdline2.h"

int
main (int argc, char **argv)
{
  struct gengetopt_args_info args_info;

  /* let's call our cmdline parser */
  if (my_cmdline_parser (argc, argv, &args_info) != 0)
    exit(1) ;

  if (args_info.help_given)
    {
      printf ("This is a simple test for gengetopt\n");
      my_cmdline_parser_print_help ();
    }

  if (args_info.full_help_given)
    {
      printf ("This is a simple test for gengetopt\n");
      my_cmdline_parser_print_full_help ();
    }

  if (args_info.version_given)
    {
      printf ("Here is the version\n");
      my_cmdline_parser_print_version ();
    }

  return 0;
}
