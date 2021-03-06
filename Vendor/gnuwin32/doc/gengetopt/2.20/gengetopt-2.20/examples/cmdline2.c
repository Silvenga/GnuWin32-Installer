/*
  File autogenerated by gengetopt version 2.20
  generated with the following command:
  ../src/gengetopt --input=./sample2.ggo --func-name=my_cmdline_parser --file-name=cmdline2 --unamed-opts --no-handle-help --no-handle-version 

  The developers of gengetopt consider the fixed text that goes in all
  gengetopt output files to be in the public domain:
  we make no copyright claims on it.
*/

/* If we use autoconf.  */
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "getopt.h"

#include "cmdline2.h"

const char *gengetopt_args_info_purpose = "this is just a test program for gengetopt";

const char *gengetopt_args_info_usage = "Usage: " MY_CMDLINE_PARSER_PACKAGE " [OPTIONS]... [FILES]...";

const char *gengetopt_args_info_description = "";

const char *gengetopt_args_info_help[] = {
  "  -h, --help                    Print help and exit",
  "      --full-help               Print help, including hidden options, and exit",
  "  -V, --version                 Print version and exit",
  "  -s, --str-opt=STRING          A string option",
  "  -i, --int-opt=INT             A int option",
  "  -S, --short-opt=SHORT         A short option",
  "  -l, --long-opt=LONG           A long option",
  "  -f, --float-opt=FLOAT         A float option",
  "  -d, --double-opt=DOUBLE       A double option",
  "  -L, --long-double-opt=LONGDOUBLE\n                                A long double option",
  "  -y, --long-long-opt=LONGLONG  A long long option",
  "  -F, --func-opt                A function option",
  "  -x, --flag-opt                A flag option  (default=off)",
    0
};
const char *gengetopt_args_info_full_help[] = {
  "  -h, --help                    Print help and exit",
  "      --full-help               Print help, including hidden options, and exit",
  "  -V, --version                 Print version and exit",
  "  -s, --str-opt=STRING          A string option",
  "  -i, --int-opt=INT             A int option",
  "  -S, --short-opt=SHORT         A short option",
  "  -l, --long-opt=LONG           A long option",
  "  -f, --float-opt=FLOAT         A float option",
  "  -d, --double-opt=DOUBLE       A double option",
  "  -L, --long-double-opt=LONGDOUBLE\n                                A long double option",
  "  -y, --long-long-opt=LONGLONG  A long long option",
  "  -F, --func-opt                A function option",
  "  -N, --hidden-opt              A hidden option",
  "  -x, --flag-opt                A flag option  (default=off)",
    0
};

static
void clear_given (struct gengetopt_args_info *args_info);
static
void clear_args (struct gengetopt_args_info *args_info);

static int
my_cmdline_parser_internal (int argc, char * const *argv, struct gengetopt_args_info *args_info, int override, int initialize, int check_required, const char *additional_error);

static int
my_cmdline_parser_required2 (struct gengetopt_args_info *args_info, const char *prog_name, const char *additional_error);

static char *
gengetopt_strdup (const char *s);

static
void clear_given (struct gengetopt_args_info *args_info)
{
  args_info->help_given = 0 ;
  args_info->full_help_given = 0 ;
  args_info->version_given = 0 ;
  args_info->str_opt_given = 0 ;
  args_info->int_opt_given = 0 ;
  args_info->short_opt_given = 0 ;
  args_info->long_opt_given = 0 ;
  args_info->float_opt_given = 0 ;
  args_info->double_opt_given = 0 ;
  args_info->long_double_opt_given = 0 ;
  args_info->long_long_opt_given = 0 ;
  args_info->func_opt_given = 0 ;
  args_info->hidden_opt_given = 0 ;
  args_info->flag_opt_given = 0 ;
}

static
void clear_args (struct gengetopt_args_info *args_info)
{
  args_info->str_opt_arg = NULL;
  args_info->str_opt_orig = NULL;
  args_info->int_opt_orig = NULL;
  args_info->short_opt_orig = NULL;
  args_info->long_opt_orig = NULL;
  args_info->float_opt_orig = NULL;
  args_info->double_opt_orig = NULL;
  args_info->long_double_opt_orig = NULL;
  args_info->long_long_opt_orig = NULL;
  args_info->flag_opt_flag = 0;
  
}

static
void init_args_info(struct gengetopt_args_info *args_info)
{
  args_info->help_help = gengetopt_args_info_full_help[0] ;
  args_info->full_help_help = gengetopt_args_info_full_help[1] ;
  args_info->version_help = gengetopt_args_info_full_help[2] ;
  args_info->str_opt_help = gengetopt_args_info_full_help[3] ;
  args_info->int_opt_help = gengetopt_args_info_full_help[4] ;
  args_info->short_opt_help = gengetopt_args_info_full_help[5] ;
  args_info->long_opt_help = gengetopt_args_info_full_help[6] ;
  args_info->float_opt_help = gengetopt_args_info_full_help[7] ;
  args_info->double_opt_help = gengetopt_args_info_full_help[8] ;
  args_info->long_double_opt_help = gengetopt_args_info_full_help[9] ;
  args_info->long_long_opt_help = gengetopt_args_info_full_help[10] ;
  args_info->func_opt_help = gengetopt_args_info_full_help[11] ;
  args_info->hidden_opt_help = gengetopt_args_info_full_help[12] ;
  args_info->flag_opt_help = gengetopt_args_info_full_help[13] ;
  
}

void
my_cmdline_parser_print_version (void)
{
  printf ("%s %s\n", MY_CMDLINE_PARSER_PACKAGE, MY_CMDLINE_PARSER_VERSION);
}

void
my_cmdline_parser_print_help (void)
{
  int i = 0;
  my_cmdline_parser_print_version ();

  if (strlen(gengetopt_args_info_purpose) > 0)
    printf("\n%s\n", gengetopt_args_info_purpose);

  printf("\n%s\n\n", gengetopt_args_info_usage);

  if (strlen(gengetopt_args_info_description) > 0)
    printf("%s\n", gengetopt_args_info_description);

  while (gengetopt_args_info_help[i])
    printf("%s\n", gengetopt_args_info_help[i++]);
}

void
my_cmdline_parser_print_full_help (void)
{
  int i = 0;
  my_cmdline_parser_print_version ();

  if (strlen(gengetopt_args_info_purpose) > 0)
    printf("\n%s\n", gengetopt_args_info_purpose);

  printf("\n%s\n\n", gengetopt_args_info_usage);

  if (strlen(gengetopt_args_info_description) > 0)
    printf("%s\n", gengetopt_args_info_description);

  while (gengetopt_args_info_full_help[i])
    printf("%s\n", gengetopt_args_info_full_help[i++]);
}

void
my_cmdline_parser_init (struct gengetopt_args_info *args_info)
{
  clear_given (args_info);
  clear_args (args_info);
  init_args_info (args_info);

  args_info->inputs = NULL;
  args_info->inputs_num = 0;
}

static void
my_cmdline_parser_release (struct gengetopt_args_info *args_info)
{
  
  unsigned int i;
  if (args_info->str_opt_arg)
    {
      free (args_info->str_opt_arg); /* free previous argument */
      args_info->str_opt_arg = 0;
    }
  if (args_info->str_opt_orig)
    {
      free (args_info->str_opt_orig); /* free previous argument */
      args_info->str_opt_orig = 0;
    }
  if (args_info->int_opt_orig)
    {
      free (args_info->int_opt_orig); /* free previous argument */
      args_info->int_opt_orig = 0;
    }
  if (args_info->short_opt_orig)
    {
      free (args_info->short_opt_orig); /* free previous argument */
      args_info->short_opt_orig = 0;
    }
  if (args_info->long_opt_orig)
    {
      free (args_info->long_opt_orig); /* free previous argument */
      args_info->long_opt_orig = 0;
    }
  if (args_info->float_opt_orig)
    {
      free (args_info->float_opt_orig); /* free previous argument */
      args_info->float_opt_orig = 0;
    }
  if (args_info->double_opt_orig)
    {
      free (args_info->double_opt_orig); /* free previous argument */
      args_info->double_opt_orig = 0;
    }
  if (args_info->long_double_opt_orig)
    {
      free (args_info->long_double_opt_orig); /* free previous argument */
      args_info->long_double_opt_orig = 0;
    }
  if (args_info->long_long_opt_orig)
    {
      free (args_info->long_long_opt_orig); /* free previous argument */
      args_info->long_long_opt_orig = 0;
    }
  
  for (i = 0; i < args_info->inputs_num; ++i)
    free (args_info->inputs [i]);
  
  if (args_info->inputs_num)
    free (args_info->inputs);
  
  clear_given (args_info);
}

int
my_cmdline_parser_file_save(const char *filename, struct gengetopt_args_info *args_info)
{
  FILE *outfile;
  int i = 0;

  outfile = fopen(filename, "w");

  if (!outfile)
    {
      fprintf (stderr, "%s: cannot open file for writing: %s\n", MY_CMDLINE_PARSER_PACKAGE, filename);
      return EXIT_FAILURE;
    }

  if (args_info->help_given) {
    fprintf(outfile, "%s\n", "help");
  }
  if (args_info->full_help_given) {
    fprintf(outfile, "%s\n", "full-help");
  }
  if (args_info->version_given) {
    fprintf(outfile, "%s\n", "version");
  }
  if (args_info->str_opt_given) {
    if (args_info->str_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "str-opt", args_info->str_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "str-opt");
    }
  }
  if (args_info->int_opt_given) {
    if (args_info->int_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "int-opt", args_info->int_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "int-opt");
    }
  }
  if (args_info->short_opt_given) {
    if (args_info->short_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "short-opt", args_info->short_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "short-opt");
    }
  }
  if (args_info->long_opt_given) {
    if (args_info->long_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "long-opt", args_info->long_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "long-opt");
    }
  }
  if (args_info->float_opt_given) {
    if (args_info->float_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "float-opt", args_info->float_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "float-opt");
    }
  }
  if (args_info->double_opt_given) {
    if (args_info->double_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "double-opt", args_info->double_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "double-opt");
    }
  }
  if (args_info->long_double_opt_given) {
    if (args_info->long_double_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "long-double-opt", args_info->long_double_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "long-double-opt");
    }
  }
  if (args_info->long_long_opt_given) {
    if (args_info->long_long_opt_orig) {
      fprintf(outfile, "%s=\"%s\"\n", "long-long-opt", args_info->long_long_opt_orig);
    } else {
      fprintf(outfile, "%s\n", "long-long-opt");
    }
  }
  if (args_info->func_opt_given) {
    fprintf(outfile, "%s\n", "func-opt");
  }
  if (args_info->hidden_opt_given) {
    fprintf(outfile, "%s\n", "hidden-opt");
  }
  if (args_info->flag_opt_given) {
    fprintf(outfile, "%s\n", "flag-opt");
  }
  
  fclose (outfile);

  i = EXIT_SUCCESS;
  return i;
}

void
my_cmdline_parser_free (struct gengetopt_args_info *args_info)
{
  my_cmdline_parser_release (args_info);
}


/* gengetopt_strdup() */
/* strdup.c replacement of strdup, which is not standard */
char *
gengetopt_strdup (const char *s)
{
  char *result = NULL;
  if (!s)
    return result;

  result = (char*)malloc(strlen(s) + 1);
  if (result == (char*)0)
    return (char*)0;
  strcpy(result, s);
  return result;
}

int
my_cmdline_parser (int argc, char * const *argv, struct gengetopt_args_info *args_info)
{
  return my_cmdline_parser2 (argc, argv, args_info, 0, 1, 1);
}

int
my_cmdline_parser2 (int argc, char * const *argv, struct gengetopt_args_info *args_info, int override, int initialize, int check_required)
{
  int result;

  result = my_cmdline_parser_internal (argc, argv, args_info, override, initialize, check_required, NULL);

  if (result == EXIT_FAILURE)
    {
      my_cmdline_parser_free (args_info);
      exit (EXIT_FAILURE);
    }
  
  return result;
}

int
my_cmdline_parser_required (struct gengetopt_args_info *args_info, const char *prog_name)
{
  int result = EXIT_SUCCESS;

  if (my_cmdline_parser_required2(args_info, prog_name, NULL) > 0)
    result = EXIT_FAILURE;

  if (result == EXIT_FAILURE)
    {
      my_cmdline_parser_free (args_info);
      exit (EXIT_FAILURE);
    }
  
  return result;
}

int
my_cmdline_parser_required2 (struct gengetopt_args_info *args_info, const char *prog_name, const char *additional_error)
{
  int error = 0;

  /* checks for required options */
  if (! args_info->int_opt_given)
    {
      fprintf (stderr, "%s: '--int-opt' ('-i') option required%s\n", prog_name, (additional_error ? additional_error : ""));
      error = 1;
    }
  
  if (! args_info->long_opt_given)
    {
      fprintf (stderr, "%s: '--long-opt' ('-l') option required%s\n", prog_name, (additional_error ? additional_error : ""));
      error = 1;
    }
  
  
  /* checks for dependences among options */

  return error;
}

int
my_cmdline_parser_internal (int argc, char * const *argv, struct gengetopt_args_info *args_info, int override, int initialize, int check_required, const char *additional_error)
{
  int c;	/* Character of the parsed option.  */

  int error = 0;
  struct gengetopt_args_info local_args_info;

  if (initialize)
    my_cmdline_parser_init (args_info);

  my_cmdline_parser_init (&local_args_info);

  optarg = 0;
  optind = 0;
  opterr = 1;
  optopt = '?';

  while (1)
    {
      int option_index = 0;
      char *stop_char;

      static struct option long_options[] = {
        { "help",	0, NULL, 'h' },
        { "full-help",	0, NULL, 0 },
        { "version",	0, NULL, 'V' },
        { "str-opt",	1, NULL, 's' },
        { "int-opt",	1, NULL, 'i' },
        { "short-opt",	1, NULL, 'S' },
        { "long-opt",	1, NULL, 'l' },
        { "float-opt",	1, NULL, 'f' },
        { "double-opt",	1, NULL, 'd' },
        { "long-double-opt",	1, NULL, 'L' },
        { "long-long-opt",	1, NULL, 'y' },
        { "func-opt",	0, NULL, 'F' },
        { "hidden-opt",	0, NULL, 'N' },
        { "flag-opt",	0, NULL, 'x' },
        { NULL,	0, NULL, 0 }
      };

      stop_char = 0;
      c = getopt_long (argc, argv, "hVs:i:S:l:f:d:L:y:FNx", long_options, &option_index);

      if (c == -1) break;	/* Exit from `while (1)' loop.  */

      switch (c)
        {
        case 'h':	/* Print help and exit.  */
          if (local_args_info.help_given)
            {
              fprintf (stderr, "%s: `--help' (`-h') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->help_given && ! override)
            continue;
          local_args_info.help_given = 1;
          args_info->help_given = 1;
          my_cmdline_parser_free (&local_args_info);
          return 0;

        case 'V':	/* Print version and exit.  */
          if (local_args_info.version_given)
            {
              fprintf (stderr, "%s: `--version' (`-V') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->version_given && ! override)
            continue;
          local_args_info.version_given = 1;
          args_info->version_given = 1;
          my_cmdline_parser_free (&local_args_info);
          return 0;

        case 's':	/* A string option.  */
          if (local_args_info.str_opt_given)
            {
              fprintf (stderr, "%s: `--str-opt' (`-s') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->str_opt_given && ! override)
            continue;
          local_args_info.str_opt_given = 1;
          args_info->str_opt_given = 1;
          if (args_info->str_opt_arg)
            free (args_info->str_opt_arg); /* free previous string */
          args_info->str_opt_arg = gengetopt_strdup (optarg);
          if (args_info->str_opt_orig)
            free (args_info->str_opt_orig); /* free previous string */
          args_info->str_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'i':	/* A int option.  */
          if (local_args_info.int_opt_given)
            {
              fprintf (stderr, "%s: `--int-opt' (`-i') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->int_opt_given && ! override)
            continue;
          local_args_info.int_opt_given = 1;
          args_info->int_opt_given = 1;
          args_info->int_opt_arg = strtol (optarg, &stop_char, 0);
          if (!(stop_char && *stop_char == '\0')) {
            fprintf(stderr, "%s: invalid numeric value: %s\n", argv[0], optarg);
            goto failure;
          }
          if (args_info->int_opt_orig)
            free (args_info->int_opt_orig); /* free previous string */
          args_info->int_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'S':	/* A short option.  */
          if (local_args_info.short_opt_given)
            {
              fprintf (stderr, "%s: `--short-opt' (`-S') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->short_opt_given && ! override)
            continue;
          local_args_info.short_opt_given = 1;
          args_info->short_opt_given = 1;
          args_info->short_opt_arg = (short)strtol (optarg, &stop_char, 0);
          if (!(stop_char && *stop_char == '\0')) {
            fprintf(stderr, "%s: invalid numeric value: %s\n", argv[0], optarg);
            goto failure;
          }
          if (args_info->short_opt_orig)
            free (args_info->short_opt_orig); /* free previous string */
          args_info->short_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'l':	/* A long option.  */
          if (local_args_info.long_opt_given)
            {
              fprintf (stderr, "%s: `--long-opt' (`-l') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->long_opt_given && ! override)
            continue;
          local_args_info.long_opt_given = 1;
          args_info->long_opt_given = 1;
          args_info->long_opt_arg = strtol (optarg, &stop_char, 0);
          if (!(stop_char && *stop_char == '\0')) {
            fprintf(stderr, "%s: invalid numeric value: %s\n", argv[0], optarg);
            goto failure;
          }
          if (args_info->long_opt_orig)
            free (args_info->long_opt_orig); /* free previous string */
          args_info->long_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'f':	/* A float option.  */
          if (local_args_info.float_opt_given)
            {
              fprintf (stderr, "%s: `--float-opt' (`-f') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->float_opt_given && ! override)
            continue;
          local_args_info.float_opt_given = 1;
          args_info->float_opt_given = 1;
          args_info->float_opt_arg = (float)strtod (optarg, &stop_char);
          if (!(stop_char && *stop_char == '\0')) {
            fprintf(stderr, "%s: invalid numeric value: %s\n", argv[0], optarg);
            goto failure;
          }
          if (args_info->float_opt_orig)
            free (args_info->float_opt_orig); /* free previous string */
          args_info->float_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'd':	/* A double option.  */
          if (local_args_info.double_opt_given)
            {
              fprintf (stderr, "%s: `--double-opt' (`-d') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->double_opt_given && ! override)
            continue;
          local_args_info.double_opt_given = 1;
          args_info->double_opt_given = 1;
          args_info->double_opt_arg = strtod (optarg, &stop_char);
          if (!(stop_char && *stop_char == '\0')) {
            fprintf(stderr, "%s: invalid numeric value: %s\n", argv[0], optarg);
            goto failure;
          }
          if (args_info->double_opt_orig)
            free (args_info->double_opt_orig); /* free previous string */
          args_info->double_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'L':	/* A long double option.  */
          if (local_args_info.long_double_opt_given)
            {
              fprintf (stderr, "%s: `--long-double-opt' (`-L') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->long_double_opt_given && ! override)
            continue;
          local_args_info.long_double_opt_given = 1;
          args_info->long_double_opt_given = 1;
          args_info->long_double_opt_arg = (long double)strtod (optarg, &stop_char);
          if (!(stop_char && *stop_char == '\0')) {
            fprintf(stderr, "%s: invalid numeric value: %s\n", argv[0], optarg);
            goto failure;
          }
          if (args_info->long_double_opt_orig)
            free (args_info->long_double_opt_orig); /* free previous string */
          args_info->long_double_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'y':	/* A long long option.  */
          if (local_args_info.long_long_opt_given)
            {
              fprintf (stderr, "%s: `--long-long-opt' (`-y') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->long_long_opt_given && ! override)
            continue;
          local_args_info.long_long_opt_given = 1;
          args_info->long_long_opt_given = 1;
          #ifdef HAVE_LONG_LONG
          args_info->long_long_opt_arg = (long long int) strtol (optarg, &stop_char, 0);
          #else
          args_info->long_long_opt_arg = (long) strtol (optarg, &stop_char, 0);
          #endif
          if (!(stop_char && *stop_char == '\0')) {
            fprintf(stderr, "%s: invalid numeric value: %s\n", argv[0], optarg);
            goto failure;
          }
          if (args_info->long_long_opt_orig)
            free (args_info->long_long_opt_orig); /* free previous string */
          args_info->long_long_opt_orig = gengetopt_strdup (optarg);
          break;

        case 'F':	/* A function option.  */
          if (local_args_info.func_opt_given)
            {
              fprintf (stderr, "%s: `--func-opt' (`-F') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->func_opt_given && ! override)
            continue;
          local_args_info.func_opt_given = 1;
          args_info->func_opt_given = 1;
          break;

        case 'N':	/* A hidden option.  */
          if (local_args_info.hidden_opt_given)
            {
              fprintf (stderr, "%s: `--hidden-opt' (`-N') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->hidden_opt_given && ! override)
            continue;
          local_args_info.hidden_opt_given = 1;
          args_info->hidden_opt_given = 1;
          break;

        case 'x':	/* A flag option.  */
          if (local_args_info.flag_opt_given)
            {
              fprintf (stderr, "%s: `--flag-opt' (`-x') option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
              goto failure;
            }
          if (args_info->flag_opt_given && ! override)
            continue;
          local_args_info.flag_opt_given = 1;
          args_info->flag_opt_given = 1;
          args_info->flag_opt_flag = !(args_info->flag_opt_flag);
          break;


        case 0:	/* Long option with no short option */
          /* Print help, including hidden options, and exit.  */
          if (strcmp (long_options[option_index].name, "full-help") == 0)
          {
            if (local_args_info.full_help_given)
              {
                fprintf (stderr, "%s: `--full-help' option given more than once%s\n", argv[0], (additional_error ? additional_error : ""));
                goto failure;
              }
            if (args_info->full_help_given && ! override)
              continue;
            local_args_info.full_help_given = 1;
            args_info->full_help_given = 1;
            my_cmdline_parser_free (&local_args_info);
            return 0;
          }
          

        case '?':	/* Invalid option.  */
          /* `getopt_long' already printed an error message.  */
          goto failure;

        default:	/* bug: option not considered.  */
          fprintf (stderr, "%s: option unknown: %c%s\n", MY_CMDLINE_PARSER_PACKAGE, c, (additional_error ? additional_error : ""));
          abort ();
        } /* switch */
    } /* while */



  if (check_required)
    {
      error += my_cmdline_parser_required2 (args_info, argv[0], additional_error);
    }

  my_cmdline_parser_release (&local_args_info);

  if ( error )
    return (EXIT_FAILURE);

  if (optind < argc)
    {
      int i = 0 ;
      int found_prog_name = 0;
      /* whether program name, i.e., argv[0], is in the remaining args
         (this may happen with some implementations of getopt,
          but surely not with the one included by gengetopt) */

      i = optind;
      while (i < argc)
        if (argv[i++] == argv[0]) {
          found_prog_name = 1;
          break;
        }
      i = 0;

      args_info->inputs_num = argc - optind - found_prog_name;
      args_info->inputs =
        (char **)(malloc ((args_info->inputs_num)*sizeof(char *))) ;
      while (optind < argc)
        if (argv[optind++] != argv[0])
          args_info->inputs[ i++ ] = gengetopt_strdup (argv[optind-1]) ;
    }

  return 0;

failure:
  
  my_cmdline_parser_release (&local_args_info);
  return (EXIT_FAILURE);
}
