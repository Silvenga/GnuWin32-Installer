/* This C program, h-demo.c, when compiled and linked with GNU libplot,
   will emit to standard output a sample page illustrating many of the
   Hershey fonts.  The file will be in portable metafile format.  It may be
   translated to other formats, or viewed in an X window, with the `plot'
   utility.  The sample page is taken from Allen Hershey's 1972 article in
   Computer Graphics and Image Processing (vol. 1, no. 4, pp. 373-385).

   Compile and link with: 

       gcc h-demo.c -lplot -lXaw -lXmu -lXt -lXext -lX11 -lm

   or, in recent versions of the X Window System,

       gcc h-demo.c -lplot -lXaw -lXmu -lXt -lSM -lICE -lXext -lX11 -lm

   To translate the sample page to Postscript, you would do 
   `a.out | plot -T ps > page.ps'.  To display the page in an 
   X Window, you would do `a.out | plot -T X', etc.  

   The above compilation instructions assume that your linker will be able
   to find libplot and the X Window System libraries.  You may need to
   include such options as -L/usr/local/lib and -L/usr/X11/lib to ensure
   this.  Also, the linking options may differ if you are using Motif.
   If you are using a C compiler other than gcc, consult your system
   administrator.
   
   (The -DNO_CONST_SUPPORT option may need to be used if the C compiler,
   like the version of `cc' supplied with SunOS 4.1.x, is so old that it
   does not understand the `const' type qualifier.  If compiling under
   SunOS 4.1.x, you may also need to specify the `-static' option, to work
   around problems with undefined symbols in the SunOS X libraries.)

   If you have any trouble running the demo after compiling it, be sure
   your LD_LIBRARY_PATH environment variable includes the directory in
   which libplot is stored.  This only applies on systems in which libplot
   is implemented as a shared library that is linked at run time. */

#include <stdio.h> 
#include <plot.h>

#ifdef M_SQRT1_2
#undef M_SQRT1_2
#endif
#define M_SQRT1_2   (0.70710678118654752440) /* 1/sqrt(2) */

#define NUM_DEMO_WORDS 34
struct hershey_word 
{
  char *word;
  char *fontname;
  double m[6];
  char just;
};

#define CART (9.0/21.0)		/* `cartographic' size */
#define INDEXICAL (13.0/21.0)	/* `indexical' size */

#define LLX -3800.0
#define LLY -3450.0
#define URX 3800.0
#define URY 4150.0

#define BASE_FONTSIZE 220.0

struct hershey_word demo_word[NUM_DEMO_WORDS] = 
{
  {"Invitation", "HersheyScript-Bold", 
     { 1., 0., 0., 1., -3125., 3980. }, 'l' },
  {"ECONOMY", "HersheySans",           
     { 1., 0., 0., 1., -3125., 3340. }, 'l'},
  {"CARTOGRAPHY", "HersheySans",       
     { CART, 0., 0., CART, -3125., 2700. }, 'l'},
  {"Gramma", "HersheySerifSymbol",    
     { 1., 0., 0., 1., -3125., 2060. }, 'l'},
  {"\347\322\301\306\311\313\301", "HersheyCyrillic",       
     { 1., 0., 0., 1., -3125., 1420. }, 'l'},

  {"COMMUNICATION", "HersheySans-Bold", 
     { 1., 0., 0., 1., 0., 3980. }, 'c'},
  {"VERSATILITY", "HersheySerif-Italic",
     { 1., 0., 0., 1., 0., 3340. }, 'c'},
  {"Standardization", "HersheySerif",   
     { 1., 0., 0., 1., 0., 2700. }, 'c'},
  {"Sumbolon", "HersheySerifSymbol",  
     { INDEXICAL, 0., 0., INDEXICAL, 0., 2060. }, 'c'},
  {"\363\354\357\366\356\357\363\364\370", "HersheyCyrillic",      
     { 1., 0., 0., 1., 0., 1420. }, 'c'},

  {"Publication", "HersheyScript-Bold", 
     { 1., 0., 0., 1., 3125., 3980. }, 'r'},
  {"Quality", "HersheyGothicEnglish",  
     { 1., 0., 0., 1., 3125., 3340. }, 'r'},
  {"TYPOGRAPHY", "HersheySans",         
     { CART, 0., 0., CART, 3125., 2700. }, 'r'},
  {"AriJmo\\s-", "HersheySerifSymbol",    
     { 1., 0., 0., 1., 3125., 2060. }, 'r'},
  {"\346\317\316\305\324\311\313\301", "HersheyCyrillic",       
     { 1., 0., 0., 1., 3125., 1420. }, 'r'},

  {"EXTENSION", "HersheySans", 
     { 17./7., 0., 0., 2./7., 0., 780. }, 'c'},
  {"CONDENSATION", "HersheySans", 
     { 5./7., 0., 0., 17./7., 0., -20. }, 'c'},
  {"Rotation", "HersheySans", 
     { M_SQRT1_2, M_SQRT1_2, -M_SQRT1_2, M_SQRT1_2, -2880., -20. }, 'l'},
  {"ROTATION", "HersheySans", 
     { M_SQRT1_2, -M_SQRT1_2, M_SQRT1_2, M_SQRT1_2, 2880., -20. }, 'r'},

  {"Syllabary", "HersheySerif",           
     { 1., 0., 0., 1., -3125., -780. }, 'l'},
  {"Art", "HersheyGothicEnglish",        
     { 1., 0., 0., 1., -3125., -1420. }, 'l'},
  {"Meteorology", "HersheySerif-Italic",  
     { INDEXICAL, 0., 0., INDEXICAL, -3125., -2060.}, 'l'},
  {"CHEMISTRY", "HersheySerif",           
     { 1., 0., 0., 1., -3125., -2700.}, 'l'},
  {"Analysis", "HersheySerif-BoldItalic", 
     { 1., 0., 0., 1., -3125., -3340.}, 'l'},

  {"LEXIKON", "HersheySerifSymbol-Bold",      
     { 1., 0., 0., 1., 0., -780.}, 'c'},
  {"\\#J3d71\\#J463b", "HersheySerif",      
     { 1./.7, 0., 0., 1./.7, 0., -1420.}, 'c'},
  {"Wissenschaft", "HersheyGothicGerman",
     { 1., 0., 0., 1., 0., -2060.}, 'c'},
  {"Electronics", "HersheySerif-Italic",  
     { 1., 0., 0., 1., 0., -2700.}, 'c'},
  {"COMPUTATION", "HersheySerif-Bold",    
     { 1., 0., 0., 1., 0., -3340.}, 'c'},

  {"Alphabet", "HersheySerif",            
     { 1., 0., 0., 1., 3125., -780.}, 'r'},
  {"Music", "HersheyGothicItalian",      
     { 1., 0., 0., 1., 3125., -1420.}, 'r'},
  {"Astronomy", "HersheySerif",           
     { INDEXICAL, 0., 0., INDEXICAL, 3125., -2060.}, 'r'},
  {"MATHEMATICS", "HersheySerif",         
     { 1., 0., 0., 1., 3125., -2700.}, 'r'},
  {"Program", "HersheySerif-BoldItalic",  
     { 1., 0., 0., 1., 3125., -3340.}, 'r'},
};

int
main()
{
  plPlotter *plotter;
  plPlotterParams *plotter_params;
  int i;

  /* set Plotter parameters */
  plotter_params = pl_newplparams ();
  pl_setplparam (plotter_params, "META_PORTABLE", "yes");

  /* create a Metafile Plotter with the specified parameters */
  if ((plotter = pl_newpl_r ("meta", stdin, stdout, stderr,
			     plotter_params)) == NULL)
    {
      fprintf (stderr, "Couldn't create Plotter\n");
      return 1;
    }
  
  /* open it, set up user coordinate system */
  pl_openpl_r (plotter);
  pl_erase_r (plotter);
  pl_fspace_r (plotter, LLX, LLY, URX, URY);

  /* loop through words, each time saving and restoring graphics state */
  for (i = 0; i < NUM_DEMO_WORDS; i++)
    {
      pl_savestate_r (plotter);
      pl_fontname_r (plotter, demo_word[i].fontname);
      pl_fconcat_r (plotter,
		    demo_word[i].m[0], demo_word[i].m[1], 
		    demo_word[i].m[2], demo_word[i].m[3],
		    demo_word[i].m[4], demo_word[i].m[5]);
      pl_ffontsize_r (plotter, BASE_FONTSIZE);
      pl_fmove_r (plotter, 0.0, 0.0);
      pl_alabel_r (plotter, demo_word[i].just, 'c', demo_word[i].word);
      pl_restorestate_r (plotter);
    }

  /* close and delete Plotter */
  pl_closepl_r (plotter);
  if (pl_deletepl_r (plotter) < 0)
    {
      fprintf (stderr, "Couldn't delete Plotter\n");
      return 1;
    }
  return 0;
}
