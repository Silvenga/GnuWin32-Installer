/* main1.cc */
/* we try to use gengetopt generated file in a C++ program */
/* we don't use autoconf and automake vars */

#include <iostream>
#include "stdlib.h"

#include "cmdline1.h"

using std::cout;
using std::endl;

int
main (int argc, char **argv)
{
  gengetopt_args_info args_info;

  cout << "This one is from a C++ program" << endl ;
  cout << "Try to launch me with some options" << endl ;
  cout << "(type sample1 --help for the complete list)" << endl ;
  cout << "For example: ./sample1 *.* --funct-opt" << endl ;

  /* let's call our cmdline parser */
  if (cmdline_parser (argc, argv, &args_info) != 0)
    exit(1) ;

  cout << "Here are the options you passed..." << endl;

  for ( unsigned i = 0 ; i < args_info.inputs_num ; ++i )
    cout << "file: " << args_info.inputs[i] << endl ;

  if ( args_info.funct_opt_given )
    cout << "You chose --funct-opt or -F." << endl ;

  if ( args_info.str_opt_given )
    cout << "You inserted " << args_info.str_opt_arg << " for " <<
      "--str-opt option." << endl ;

  if ( args_info.int_opt_given )
    cout << "This is the integer you input: " << 
      args_info.int_opt_arg << "." << endl;

  if (args_info.flag_opt_given)
    cout << "The flag option was given!" << endl;

  cout << "The flag is " << ( args_info.flag_opt_flag ? "on" : "off" ) <<
    "." << endl ;

  if (args_info.enum_opt_given) {
    cout << "enum-opt value: " << args_info.enum_opt_arg << endl;
    cout << "enum-opt (original specified) value: " 
	 << args_info.enum_opt_orig << endl;
  }

  if (args_info.secret_given)
    cout << "Secret option was specified: " << args_info.secret_arg
	 << endl;

  cout << args_info.def_opt_arg << "! ";

  cout << "Have a nice day! :-)" << endl ;

  cmdline_parser_free (&args_info); /* release allocated memory */

  return 0;
}
