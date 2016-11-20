/* code modified Sept 1999 to produce bar charts as well as pies
 * Copyright (C) 1999 Chris Elliott ( cje2@york.ac.uk ) and Bernhard Reiter 
 * GNU public licence still applies
 * -X labels X axis of bar chart -Y labels Y axis of chart
 * 
 * v0.05 bug with -Y often giving a seg fault traced to fault on optarg list
 * v0.1 -r adius and -d istance options control size in  bar chart
 */

/* Bernhard Reiter 	Fri Oct 10 20:07:12 MET DST 1997
 * $Id: piechart.c,v 1.11 1999/04/03 10:26:32 breiter Exp $
 *
 * Copyright (C) 1997,1998 by Bernhard Reiter 
 * 
 *    This program is free software; you can redistribute it and/or
 *   modify it under the terms of the GNU General Public License
 *   as published by the Free Software Foundation; either version 2
 *   of the License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *	
 *	Creates bar or piechart, must be linked with a libplot library
 *	reads ascii input file from stdin.
 *
 *	format: one slice per line. every trailing tab and space will
 *		be ignored. The string after the last tab or space is
 *		will be scanned as value. The beginnign is the label-text.
 *		Empty lines and lines starting with "#" are ignored
 *
 *	TODO: many improvements possible.
 *		- make stuff more dynamic (input linelength and max # of slices)
 *		- better handling of progname
 *		- move much stuff into command line options
 *		e.g.	
 *			+ fonts
 *			+ rotation of the pie
 *		- use getopt_long
 *		- make better assumptions on how to place the labels
 *		- add printing percentage numbers and values;as options
 *		- special handling of very small slices
 *		- make multi line labels possible
 *		- multi-line titles?
 *		- does every system have strdup(), strncpy()?
 *		- 
 *		...
 *
 *	THANKS: To "Martin J. Evans" <martin@mjedev.demon.co.uk>
 *		for pointing out that some systems do not terminate
 *		the target string after strncpy().
 *		
 *		Jan-Oliver Wagner <jwagner@usf.uni-osnabrueck.de>
 *		created first version ito work with gnuplotutils-2.2.
 */

#include <stdio.h>
#include <plot.h>

#define min(X, Y)  ((X) < (Y) ? (X) : (Y))
#define max(X, Y)  ((X) > (Y) ? (X) : (Y))


#define VERSION "0.91 "
void print_version(FILE *file)
{
             fprintf(file,"ascii_chart version " VERSION "\n"); 
             fprintf(file,"Copyright (C) 1998, 1999 by Bernhard Reiter & Chris Elliott. \n"
             	    "The GNU GENERAL PUBLIC LICENSE applies. "
             	    	"Absolutly No Warranty!\n");
#ifdef DEBUG
             fprintf(file,"compiled with option: DEBUG\n"); 
#endif
}

/*
 * $Log: piechart.c,v $
 * Revision 1.11  1999/04/03  10:26:32  breiter
 * adapted to plotutils-2.2: added pl_ to all function calls
 * adjusted help text
 * more return values are checked now, as the function provide more of them
 * end circle and middle point are only drawn if LINEWIDTH is not default
 * changed constant name LINEWIDTH_LINES -> LINEWIDTH
 * end circle and middle point LINEWIDTH is multiplied with a factor(~1.2) now
 * extra external variables for getopt() are commented out
 *
 * Revision 1.10  1998/07/28  13:41:54  breiter
 * - Terminating strncpy()ed string now. Thanks to "Martin J. Evans"
 * for reporting this problem.
 * - Removed hard limit on label-size.
 * - Changed inputline buffersize to a new constant defined as LINE_BUFSIZ.
 * - Cleaned up some comments.
 * version number incremented to 0.8
 *
 * Revision 1.9  1998/07/07  23:44:26  breiter
 * added -C option for specifing colors
 * version number is 0.7 now.
 *
 * Revision 1.8  1998/07/07  17:04:40  breiter
 * major improvements:
 * - more structure: moves code into functions: process_arguments(),read_stdin()
 * - new scanning -> multi word labels are possible now
 * - two new options: -r radius and -d text distance
 * - errmsgs and usage are printed to stderr now, but to stdout, wenn requested
 * - fixed debug output typo
 *
 * Revision 1.7  1998/01/31  16:13:02  breiter
 * changed fill() -> filltype() as fill() is only temporarily supported
 *
 * Revision 1.6  1998/01/31  16:05:40  breiter
 * using a path to draw one slice now. This is far simpler.
 * No need for LINEWIDTH_FILL anymore.
 *
 * Revision 1.5  1998/01/30  16:06:37  breiter
 * adapted for use with libplot from plotutils-2.0
 * added +T display-type commandline option therefore.
 *
 * Revision 1.4  1997/10/11  17:19:14  breiter
 * cosmetic changes. version information enhanced.
 *
 * Revision 1.3  1997/10/11  16:31:56  breiter
 * version information enhanced.
 *
 * Revision 1.2  1997/10/11  16:09:15  breiter
 * bug fixes. small improvements. userspace is always square now.
 *
 * Revision 1.1  1997/10/11  15:07:27  breiter
 * Initial revision
 *
 */

#include <stdlib.h>
#include <math.h>
#include <string.h> 	/* for strdup() */
     
/* this program used getopt and relys on that it is included in the 
 * stdlib. I wanted to use getopt_long from Gnu, but it is not included
 * in the clib i have here. So it is still left TODO.
 */

/*******************************************************************************
 * Configurations -- change, what you like
 * 	If time permits some stuff could be influenced by command line options
 ******************************************************************************/

/*	Color in which the separating lines and the circle are drawn
 */
#define LINECOLOR "black"

/* LINEWIDTH is for the separating lines and the arcs
 * if closing circle and middle point will be drawn, a factor will be applied
 * -1 means default ; 0.02 might be a usefull value
 */
#define LINEWIDTH -1

/* Some hardcoded limits:
 * the max number of slices (^=MAXSLICES).
 * LINE_BUFSIZ is the maxmumlength of input-lines.
 *(You see, how lasy i was. I was not using some object orientated language
 *	like objective-c and left all the neat dynamic string handling for
 *	the interested hacker and or some version in the future.)
 */
#define MAXSLICES 65
#define LINE_BUFSIZ 256

/* if an input line starts with this character, it is ignored.		*/
#define COMMENTCHAR '#'

/* Colors the slices are getting filled with.
 * the color names are feed into the libplot functions.
 * The plotutils distribution contains a file doc/colors.txt which lists the
 * recogized names.
 *
 * if the nullpointer is reached the color pointer is resetted starting
 * with the first color again.
 */
char *colortable[MAXSLICES] = {  /* colors changed by chris */
   "red",  "blue",   "green", "yellow", 
 "firebrick",  "aliceblue","greenyellow",  "wheat",
NULL
};


/*******************************************************************************
 * Beware: This following code is for hackers only.
 * 	( Yeah, it is not THAT bad, you can risk a look, if you know some C ..)
 ******************************************************************************/

/* Program structure outline:
 *	- get all options 
 *	- read all input data (only from stdin so far)
 *	- print
 *		+ init stuff
 *		+ print title
 *		+ print color part for slices
 *		+ print separating lines and circle
 *		+ print labels
 *		+ clean up stuff
 */


/* A nice structure, we will fill some of it, when we read the input.
 */
struct slice {
	char *text;		/* label for the slice			*/
	double value;		/* value for the slice			*/
};

/* one global variable. It is needed everywhere..				*/
char * progname; 		/*  for printing errors out		*/


/* declarations of functions defined after main()			
 */
void process_arguments(int argc, char **argv, 
	char **display_type, char ** title, char ** xtext, char ** ytext,
	int * isPie, double *radius, double *text_distance, char *colortable[]);
void read_stdin(int *n_slices, struct slice *slices[MAXSLICES]);


/* Attention: Main Progam to be started.... :)				*/

int main(int argc, char **argv)
{
char * title=NULL;		/* Title of the chart			*/
   char * xtext=NULL;		/* X axis Title of the chart			*/
   char * mytext=NULL;		/* Y axis Title of the chart			*/
int return_value;		/* return value for libplot calls.	*/
char *display_type = "meta";	/* default libplot output format 	*/
int handle;			/* handle for open plotter		*/

struct slice *slices[MAXSLICES];/* the array of slices			*/
int n_slices=0;			/* number of slices in slices[]	;)	*/
int t;				/* loop var(s) 				*/
double slice_max, sum;		/* max and sum of all slice values chris		*/
int neg_flag  ;   
                                /* check all values > 0 chris */
double radius=0.8;		/* radius of the circle in plot coords	*/
double text_distance=0;		/* distance of text from circle		*/
int isPie = 0 ;                 /* switch mode; chris */ 

double text_space  ;   
   
/* vars for ymax */
   char buffer [55] ;    
   double ymax ;
    int ystep ;
    int nf [4] = { 2,5,2,0 };
    int n = 1 ;
    ymax = 1.0 ;
    ystep = 0 ;
    
    
process_arguments(argc,argv,
	&display_type,&title,&xtext,&mytext,&isPie,&radius,&text_distance,colortable);

read_stdin(&n_slices,slices);

/* Let us find the sum and  max and check for negative values */
/* code added to by chris */   
sum = 0 ;
slice_max=1.;
neg_flag = 0 ;   
   
for(t=0;t<n_slices;t++)
     {
     sum+=slices[t]->value;
     slice_max = max (slice_max,slices[t]->value) ;
     if ( slices [t]->value < 0 ) neg_flag ++ ;	
     }

if ( neg_flag )
     {
     fprintf(stderr,"Some data were apparently less than zero. \nThis version of the program does not plot negative values.\n");
     exit(1);
     }
/* initialising one plot session	*/
				/* specify type of plotter		*/
handle=pl_newpl(display_type, NULL, stdout, stderr);
if(handle<0)
{   fprintf(stderr,"The plotter could not be created.\n");
    exit(1);
}

return_value=pl_selectpl(handle);          
if(return_value<0)
{   fprintf(stderr,"The plotter does not exist or could not be selected.\n");
    exit(1);
}

return_value= pl_openpl();
if(return_value<0)
{   fprintf(stderr,"The selected plotter could not be opened!\n");
    exit(1);
}

/* now decide to plot bar or pie */
if ( isPie ) 
     {
				/* creating your user coordinates	*/
if(title)
	return_value= pl_fspace(-1.4,-1.4,1.4,1.4);
else
	return_value= pl_fspace(-1.2,-1.2,1.2,1.2);
if(return_value)
{	fprintf(stderr,"fspace returned %d!\n",return_value);	}


/* we should be ready to plot pie, now! */



				/* i like to think in degrees. 		*/
#define X(radius,angle) (cos(angle)*(radius))
#define Y(radius,angle) (sin(angle)*(radius))

#define RAD(angle) (((angle)/180.)*M_PI)

#define XY(radius,angle) (X((radius),RAD(angle))),(Y((radius),RAD(angle)))

/* plot title if there is one */
if(title&&*title)
{
	pl_fmove(0,radius+text_distance+0.2);
	pl_alabel('c','b',title);
}

pl_pencolorname(LINECOLOR);

/* and now for the slices		*/
{
    double distance,angle=0;
    char **color=colortable;
    double r=radius;			/*the radius of the slice circle*/

    pl_savestate();
    pl_joinmod("round");

				/* drawing the slices			*/
    
    pl_filltype(1);
    pl_flinewidth(LINEWIDTH);
    pl_pencolorname(LINECOLOR);
    for(t=0;t<n_slices;t++)
				/* draw one path for every slice 	*/
    {
    	distance=(slices[t]->value/sum)*360.;
    	pl_fillcolorname(*color);
				
	pl_fmove(0,0);		/* start at center..			*/
	pl_fcont(XY(r,angle));	
    	if(distance>179)
    	{			/* we need to draw a semicircle first 	*/
				/* we have to be sure to draw 
				   counterclockwise (180 wouldn`t work 
				   in all cases)			*/
	    pl_farc(0,0,XY(r,angle),XY(r,angle+179)); 
	    angle+=179;	
	    distance-=179;
    	}
	pl_farc(0,0,XY(r,angle),XY(r,angle+distance));
	pl_fcont(0,0);		/* return to center			*/
	pl_endpath();		/* not really necessary, but intuitive	*/
	
	angle+=distance;	/* log fraction of circle already drawn	*/
				 
	color++; 		/* next color for next slice 		*/
	if(!*color) color=colortable;/* start over if all colors used 	*/
    }

    				/* the closing circle and middle point  */
				/* only, if LINEWIDTH!=default	*/
    if(LINEWIDTH!=-1)
    {
				/* add %5 to compensate for arc obstrution*/
    	pl_flinewidth(LINEWIDTH*1.2);

	pl_filltype(0);
	pl_fcircle(0.,0.,r);	

	pl_colorname(LINECOLOR);
	pl_filltype(1);
	pl_fpoint(0,0);	
    }
   					
    pl_restorestate();
}

/* and now for the text		*/
{
    double distance,angle=0,place;
    double r=radius+text_distance;/* radius of circle where text is placed*/
    char h,v;
    pl_savestate();

    for(t=0;t<n_slices;t++) 
    {
    	distance=(slices[t]->value/sum)*360.;
    				/* let us calculate the position ...	*/
	place=angle+0.5*distance;
				/* and the alignment			*/
	if(place<180)
		v='b';
	else
		v='t';
	if(place<90 || place>270)
		h='l';
	else
		h='r';
				/* plot now!				*/
	pl_fmove(XY(r,place));
	pl_alabel(h,v,slices[t]->text);
	
	angle+=distance;
    }
   					
    pl_restorestate();
}


	
     } /* end of is Pie */
else 
     {  /* next part plots bars , chris */
	if(title || xtext || mytext)
	  {
	     text_space = -2.0 - text_distance ;
	  }
	else
	  {
	     text_space = -1.0 - text_distance ;	     
	  }
     /* x0, y0, x1 y1 but it has to be square for the fonts*/
	return_value= pl_fspace(text_space / radius, 
				text_space / radius, 
				(10.0 - text_space) / radius, 
				(10.0 - text_space) / radius );
if(return_value)
{	fprintf(stderr,"fspace returned %d!\n",return_value);	}


/* we should be ready to plot bars, now! */


 
/* plot title if there is one */
if(title&&*title)
{
        pl_ffontsize (0.5);
        pl_fmove( 5, 11 ) ;
	pl_alabel('c','c',title); /* cnetered */
}
/* plot X axis title if there is one */
if(xtext&&*xtext)
{
        pl_ffontsize (0.5);
        pl_fmove( 5, 0.7 * text_space ) ;
	pl_alabel('c','c',xtext); /* cnetered */
}
/* plot Y axis title if there is one */
if(mytext&&*mytext)
{
        pl_ffontsize (0.5);
        pl_fmove( 0.8 * text_space, 6 ) ;
        pl_ftextangle (90);
	pl_alabel('c','c',mytext); 
        pl_ftextangle (0); 
}
/* find y max */
    
    while ( ymax < slice_max )
       {
	  ymax = ymax * nf [n] ;
	  n ++ ;
	  if ( nf[n] ) n = 0 ;
       }
    pl_line ( 0,0,0, 10.0 *  ymax / slice_max  );
/* plot Y axis */
    while ( ystep < ymax ) 
     {
    pl_fline ( -0.3, 10 * (double) ystep/ slice_max ,0.0, 10 * ystep / slice_max );
    pl_fmove ( 0.3 * text_space , 10 * (double) ystep / slice_max  );
    sprintf ( buffer, "%d", ystep );
    pl_alabel ( 'r','c', buffer );	
    ystep = ystep + ymax / 10;
    if (ystep < 1 ) ystep ++ ;
     }  


     pl_pencolorname(LINECOLOR);

/* and now for the bars		*/
{

    char **color=colortable;

    pl_savestate();
    pl_joinmod("round");
    
    pl_filltype(1);
    pl_flinewidth(LINEWIDTH);
    pl_pencolorname(LINECOLOR);
    for(t=0;t<n_slices;t++)

    {
    	pl_fillcolorname(*color);
        pl_fbox (10.0 * (double)(t)/(double)(n_slices),
		 0,
		 10.0 * (double)(t+1)/(double)(n_slices),
		 10 * slices[t]->value/slice_max );
	color++; 		/* next color for next slice 		*/
	if(!*color) color=colortable;/* start over if all colors used 	*/
    } /* end of for each slice */

    pl_restorestate();
}

/* and now for the text		*/
{
    char just ;
    just = 'c';
   
    pl_savestate();
    pl_ffontsize (0.4);
    if (n_slices > 5)
     {
	pl_ftextangle (90); /* degrees */
	just = 'r' ;
     }
    for(t=0;t<n_slices;t++) 
    {
/* plot now!				*/
	pl_fmove(10.0 * (double)(t+0.5)/(double)(n_slices),
		 0.3 * text_space );
	pl_alabel(just, 'c' ,slices[t]->text);
    }
    pl_restorestate();
}
     } /* end of is ! Pie */

				/* end a plot sesssion			*/
return_value= pl_closepl();
if(return_value<0)
{ 	fprintf(stderr,"The plotter could not be closed.\n");
	/* no exit, because we try to delete the plotter 		*/
}
				
/* need to select a different plotter in order to deleter our		*/
return_value=pl_selectpl(0);
if(return_value<0)
{   fprintf(stderr,"Default Plotter could not be selected!\n");
}

return_value=pl_deletepl (handle);/* clean up by deleting used plotter	*/
if(return_value<0)
{   fprintf(stderr,"Selected Plotter could not be deleted!\n");
}

			
return 0;
}


/************************************************************************
 * functions
 */
 
void process_arguments(	int argc, char **argv, 
	char **display_type, char ** title, char ** xtext, char ** ytext,
	int * isPie, double *radius, double *text_distance,char *colortable[])
{
/* well, we do not have the gnu getopt long here. :-( 
 * so i use getopt for now
 */
          int c;		
          extern char *optarg;
	  /* optint,opterr,optopt relate to getopt(),see manpage*/
	  /* but we do not use them so far			*/
          /* extern int optind,opterr,optopt; */ 
          int errflg = 0;
          int show_usage=0;
          int show_version=0;
	  int specified_display_type=0;
	  char **help;	/* will help splitting the colornames	*/
	  char * arg;	/* one string argument			*/
*isPie = 0 ; /* ie do a bar chart */
progname=argv[0];	/* fill the only global variable	*/

          while ((c = getopt(argc, argv, "Vt:T:r:d:C:h:X:Y:P")) != EOF)
               switch (c) {
/* chris did some debugging here */
		case 't':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
		  
		  if (*title)
                         errflg++;
                    else
                         *title=strdup(optarg);
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
		case 'X':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
                    if (*xtext)
                         errflg++;
                    else
                         *xtext=strdup(optarg);
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
		case 'Y':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
                    if (*ytext)
                         errflg++;
                    else
                         *ytext=strdup(optarg);
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
		  
               case 'T':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
                    if (specified_display_type)
                         errflg++;
                    else {
		    	specified_display_type++;
	  	        *display_type = strdup(optarg);
		    }
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
	       case 'P':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
	       	    *isPie = 1 ;
/* ie try to plot as pie chart */	       	       	
#ifdef DEBUG
		fprintf(stderr," OK \n");
#endif		  
		  break;

		case 'r':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
	       	    *radius=atof(optarg);
	       	    if(*radius<0.1||*radius>1.2)
		    	errflg++;
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
		    
	       case 'd':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
	       	    *text_distance=atof(optarg);
	       	    if(*text_distance<(-2.0)||*text_distance>1.2)
		    	errflg++;
			/* we have a second check after processing all options*/
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
		    
	       case 'C':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
	       	    help=colortable;
		    arg=strdup(optarg);
		    *help++=strtok(arg,",\0");
		    if(!*help)
		    	errflg++;
		    else
		    	while((*(help++)=strtok(NULL,",\0")));
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
		    
               case 'V':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
                    if (show_version)
                         errflg++;
                    else
                         show_version++;
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
               case 'h':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
                    if (show_usage)
                         errflg++;
                    else
                         show_usage++;
#ifdef DEBUG
		  fprintf (stderr, "OK \n");
#endif		  
		  break;
               case '?':
#ifdef DEBUG
		fprintf(stderr,"Reading switch %c arg %s ", c, optarg);		  
#endif		  
                    errflg++;
               }
	       			/* check if text_distance is reasonable	*/
	  if(*text_distance< (-*radius)) errflg++;
	  if (! (*isPie) ) *radius = sqrt ( *radius ) ; /* for bar charts only */
                                           /* or else the size gets too small to see */
          if (errflg) { 
               fprintf(stderr, "parameters were bad!\n");
               show_usage++;
          }
          if(show_version)
          {
             print_version(stdout); 
             exit(1);
          }
          if(show_usage)
          {	FILE *f=stdout;
	  	if(errflg)
             		f=stderr;
		else 	f=stdout;
	     print_version(f);
		
             fprintf(f,"usage: %s [options]\n",progname); 
             fprintf(f,"\t the stdin is read once.\n");
             fprintf(f,"\t options are:\n"\
                    "\t\t-P Use Pie rather than Bar chart ( not -X -Y )\n"\
             	    "\t\t-t Title\tset \"Title\" as chart title\n"\
             	    "\t\t-X XTitle\tset \"XTitle\" as barchart X axis title\n"\
                    "\t\t-Y YTitle\tset \"YTitle\" as barchart Y axis title\n"\
             	    "\t\t-T Display-Type\tone of "\
		    	"X, ps, fig, hpgl, tek, meta, ai, pnm, gif\n"\
		    "\t\t\t\t(or whatever your libplot version supports)\n"\
		    "\t\t\t\t(meta is the default)\n"\
                    "\t\t-r size of chart\tfloat out of [0.1;1.2] default:0.8\n"\
                    "\t\t-d textdistance around chart \tfloat out of "\
                        "[-radius;1.2] default:0.0\n"\
		    "\t\t-C colornames\tcomma separated list of colornames\n"\
		    "\t\t\t\t(see valid names in color.txt of plotutils doc.)\n"\
             	    "\t\t-h\t\tprint this help and exit\n"\
             	    "\t\t-V\t\tprint version and exit\n"\
             	    );
             
             exit(1);
          }

/* Everything is fine with the options now ... */
}


void read_stdin(int *n_slices, struct slice *slices[MAXSLICES])
{
char line [LINE_BUFSIZ];		/* input line buffer			*/

/* So, let us read the standardinput */
while( !(feof(stdin) || ferror(stdin)) )
{
char *c; 			/* string return from fgets		*/
struct slice * aslice;		/* freshly filled slice-structure	*/
int r;				/* help variable for scanning		*/
char *s,*t;			/* help variables for scanning		*/

	c=fgets(line,LINE_BUFSIZ,stdin);
	if(!c) continue;	/* encountered error of eof		*/
	if(line[strlen(line)-1]!='\n')
	{
		fprintf(stderr,"line was too long!\n");
		exit(2);
	}
				/* strip newline */
	line[strlen(line)-1]='\0';
				/* strip carridge return, if there is one*/
	if(line[strlen(line)-1]=='\r') 
		line[strlen(line)-1]='\0';
	
				/* Skip empty lines or lines beginning  
				 * with COMMENTCHAR			*/
	if(!(line[0]==COMMENTCHAR || !(line) || strlen(line)==0))
	{
#ifdef DEBUG
		fprintf(stderr,"Scanning line: %s\n",line);
#endif
		aslice=malloc(sizeof(struct slice));
		if(!aslice)
			perror(progname),exit(10);
			
			
				/* scanning the last part
				 * after a tab or space as number	*/
				 
				/* delete trailing tabs and spaces	*/
		r=strlen(line);
		while(r>0 && (line[r-1]==' ' || line[r-1]=='\t') )
			line[r---1]='\0';
				/* scan for last tab or space		*/
		s=strrchr(line,' ');
		t=strrchr(line,'\t');
		s=(s>t?s:t);	/* which is the last white-space?	*/
			
				/*use full string,if no whitespace found
				else copy text up to whitespace
				and get enough memory			*/
		if(s==NULL) 
		{
			if(!(aslice->text=malloc(1))) 
				perror(progname),exit(10);
			aslice->text[0]='\0'; 
			s=line;
		} else
		{	
			if(!(aslice->text=malloc(strlen(line)-strlen(s)+1))) 
				perror(progname),exit(10);
			strncpy(aslice->text,line, strlen(line)-strlen(s));
				/*some systems don`t terminate target 
				string in strncpy, so we have to do it	*/
			aslice->text[strlen(line)-strlen(s)]='\0';
		}
		
				/* scan last string for number		*/
		r=sscanf(s,"%lf",&aslice->value);
		if(r!=1)
			fprintf(stderr,"number in line couldn`t be scanned\n"),
				exit(8);
		
		if(*n_slices>=MAXSLICES)
			fprintf(stderr,"too many slices\n"),exit(8);
			
		slices[(*n_slices)++]=aslice;
	}
}

if(ferror(stdin))
{
	perror(progname);
	exit(5);
}

#ifdef DEBUG
fprintf(stderr,"Read %d slices!\n",*n_slices);
#endif 
}
