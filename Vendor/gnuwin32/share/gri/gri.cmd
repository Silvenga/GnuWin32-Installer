#         gri - scientific graphic program (version 2.12.10)
#              GPL Copyright 1991-2004 Dan E. Kelley.
#
# NOTE: The linkages to `extern "C"' routines makes use a list of C 
# functions defined in the file tags.hh.


`assert .condition. ["message"]'
The condition may be a variable, a synonym, or an RPN expression.  If
this condition is true (i.e. evaluates to a non-zero number), do
nothing.  If the condition is false, the program will terminate with
an error condition (in unix, it will terminate with a non-zero exit
code).

Before termination, a message will be printed, the form of which
depends on the optional `"msg"' string.

If no `"msg"' string is given, the the printed message will
indicate the name of the command-file and the line at which the assert
command was encountered.

If a `"msg"' string is given, and if it ends in a newline
(`"\\n"'), then this string is printed.

If a `"msg"' string is given, and if it does not end in `"\\n"',
then the string is printed along with an indication of the location in
the command-file.

(Perl users will recognize this as being patterned on the `"die"'
command.)
{
    extern "C" bool assertCmd(void);
}

`cd [\pathname]'
If a pathname specified, change to that directory.  Normal unix
filenames are used, according to the C-shell convention; thus 
`cd ~/src' and `cd $HOME/src' are equivalent.  You may specify relative
pathnames as in `cd ../sister_directory'.

   If no \pathname directory path specified, go to the home directory,
exactly as `cd ~' and `cd $HOME' do.
{
    extern "C" bool cdCmd(void);
}

`close [\filename]'
If no filename is specified, close the most recently opened data-file;
otherwise close indicated file.
{
    extern "C" bool closeCmd(void);
}

`convert columns to grid [neighbor | {objective|boxcar .xr. .yr. [.n. .e.]} | {barnes [.xr. .yr. .gamma. .iter.]}]'

Various forms exist:
     `convert columns to grid'
     `convert columns to grid neighbor'
     `convert columns to grid boxcar    [.xr. .yr. [.n. .e.]]'
     `convert columns to grid objective [.xr. .yr. [.n. .e.]]'
     `convert columns to grid barnes    [.xr. .yr. .gamma. .iter.]'

   All these commands ``grid'' columnar (x,y,z) data.  That is, they fill 
up a grid based on some form of interpolation of the possibly randomly
spaced columnar data.  There are many methods in existence for doing
this, and Gri implements several of them as alternatives.

   The grid will have been defined by commands such as `set x grid',
`set y grid', `read grid x' and `read grid y'.  As of version 2.1.9,
Gri does not require a grid to have been pre-defined; it will create a
regular 20 by 20 grid, spanning the range of x and y data, as a
default.  This is a good starting point in many cases.

*`neighbor' method*
     Very fast but very limited.

*`boxcar' method*
     Slower but a lot better.  Still, this can produce noisy contours
     if the data are not densely and uniformly ditributed through
     domain.

*`objective' method*
     Somewhat slower than `boxcar', but produces better fields since the
     averaging function is smooth.

*`barnes' method*
     Somewhat slower than `objective', but only by a constant factor
     (that is, independent of number of data).  This produces by far
     the best results, since the smoothing function has variable
     spatial scale.  This is the default method if no method is
     supplied.

   All except the `neighbor' method may take optional arguments to
define the x and y scales of the smoothing function (called `.xr.' and
`.yr.').  (The barnes method has two other optional arguments - see
below.)  If you do not supply these arguments, Gri will make a
reasonable choice and inform you of its decision.  Many users find that
it's best to `convert columns to grid' with no additional parameters as
a first step, to get advice on values to use for the optional
parameters.

   The default `.xr.' and `.yr.' are calculated by determining the span
in x and in y directions, and dividing each by the square root of the
number of data points.  These numbers are then multiplied by the square
root of 2.  The method is as proposed by S. E. Koch and M.  DesJardins
and P. J. Kocin, 1983.  "An interactive Barnes objective map anlaysis
scheme for use with satellite and conventional data,", J. Climate Appl.
Met., vol 22, p. 1487-1503.

   If `.xr.' and `.yr.' were supplied but negative, then Gri interprets
this as an instruction to modify the default values, described in last
paragraph, by multiplying by the absolute values of the negative
numbers given, instead of muliplying by square root of 2.

   If the `chatty' option is turned on, then Gri will print out 
the values of (dx,dy) that it has calculated; this gives you some
guidance for supplying your own values of `(.xr.,.yr.)' if you 
choose to supply them yourself.  It is also a good idea to let 
these parameters be a guide for your grid spacing; for
example, Koch et al., 1983, suggest using grid spacing of 0.3 to 0.5
times (dx,dy).

   And now, the details ...

   * *"Neighbor" method* The `convert columns to grid neighbor' method
     is useful for (x,y,z) data which are already gridded (i.e., for
     which x and y take only values which lie on the grid), or nearly
     gridded.  The (x,y,z) data are scanned from start to finish. For
     each data point, the nearest grid point is found.  Nearness is
     measured as Cartesian distance, with scale factor given by the
     distance between the first and second grid points.  In other
     words, distance is given by D=sqrt(dx*dx+dy*dy) where dx is ratio
     of distance from data point to nearest grid point, in x-units,
     divided by the difference between the first two elements of the
     x-grid, and dy is similarly defined.  Once the grid point nearest
     the data point is determined, Gri adds the z-value to a list of
     possible values to store in the grid.  Once the entire data set
     has been scanned, Gri then goes back to each grid point, and
     chooses the z-value of the data point that was nearest to the grid
     point - that is, it stores the z value of the (x,y,z) data triplet
     which has minimal D value.  Note that this scheme is independent
     of the order of the data within the columns.

     The `neighbor' method is useful when the data are already
     pre-gridded, meaning that the (x,y,z) triplets have x and y values
     which are already aligned with the grid.  *Computational cost:* For
     `P' data points, `X' x-grid points, and `Y' y-grid points, the
     method calculation cost is proportional to `P*[log2(X)+log2(Y)]'
     where `log2' is logarithm base 2.  As discussed below, this is
     often several orders of magnitude lower than the other methods of
     gridding.

   * *"Objective" method* In the `objective' method, a smoothing
     technique known as objective mapping is applied.  It is
     essentially a variable-size smoothing filter of approximately
     Gaussian shape (it is method "two" of Levy and Brown [1986 J.
     Geophysical Res. vol 91, p 5153-5158]) The parameters `.xr.' and
     `.yr.' give the width of the filter.

     With the optional additional parameters `.n.' and `.e.' are
     specified, then grid values will be assigned the missing value if
     there are fewer than `.n.' (x,y,f) data in the neighborhood of the
     gridpoint, even after enlarging the neighborhood by widening and
     heightening by root(2) up to `.e.' times.  (The enlargement is only
     done if fewer than `.n.' points are found.)  If these parameters
     are not specified in the command, then values `.n.'=5 and `.e.'=1
     are assumed.  The special case where `.e.' is negative tells Gri
     to *always* fill in each grid point, by extending the neighborhood
     to enclose the entire dataset if necessary.

     *Computational cost:* For `P' data points, `X' x-grid points, and
     `Y' y-grid points, the method calculation cost is proportional to
     `P*X*Y'.  Given that `X' and `Y' are determined by the requirement
     for smoothness of contours and the size of the graph, they are
     more or less fixed for all applications.  They are often in the
     range of 20 or so - on 10 cm wide graph, this yields a contour
     footprint of 1/2 cm, which is often small enough to yield smooth
     contours.  Therefore, the computational cost scales linearly with
     the number of data points.  Compared to the "neighborhood" method,
     this is more costly by a factor of `X*Y/log_2(X)/log_2(Y)' which is
     normally in the range from 20 to 50.

   * *"Boxcar" method* In the `boxcar' method, the grid points are
     derived from simple averages calculated in rectangles `.xr.' wide
     and `.yr.' tall, centred on the gridpoints.  The `.n.' and `.e.'
     parameters have similar meanings as in the "objective" method.

     *Computational cost:* Roughly same as `objective' method described
     above.

   * *"Barnes" method* This is the default scheme.

     The Barnes algorithm is applied.  If no parameters are specified,
     `.xr.' and `.yr.' are determined as above, with `.gamma.' set to
     0.5, and `.iter.' set to 2 so that two iterations are done.  On
     successive iterations, the smoothing lengthscales `.xr' and `.yr'
     are each reduced by multiplying by the square root of `.gamma.'.
     Smaller `.gamma.' values yield better resolution of small-scale
     features on successive iterations.  Koch et al., 1983, recommend
     using a `.gamma.' value in the range 0.2 to 1, with two iterations.

     Provided that all the grid points are close enough to at least some
     column data, the entire grid is filled.  But if `.xr.' and `.yr.'
     are too small, the weighting function can fall to zero, since it
     is exponential in the sum of the squares of the x-distance/`.xr.'
     and the y-distance/`.yr.'; in that case missing values result at
     those grid points.  On a 32 bit computer, the weighting function
     will fall to zero when x-distance/`.xr.'  and y-distance/`.yr.'
     are less than about 15 to 20.

     If weights have been read in, then these values are applied in 
     addition to the distance-based weighting.  (The normalization
     means that weights for two data points of e.g. 1 and 2 will 
     yield the same result as if the weights had been given as 
     10 and 20.)

     The computational cost is proportional to `P*P+P*X*Y)'.  For large
     datasets, the first term (which results from the necessity to
     interpolate not only to the grid points but also to the data
     points) overwhelms the second term.  For example, `X' and `Y' are
     normally less than approximately 20.  This value is common because
     on a graph with a 10 cm axis, this yields a contour footprint of
     1/2 cm, which is normally fine enough to get smooth contours.
     Therefore, if there are more than 400 data points, the `P*P' term
     exceeds the `P*X*Y' term.  A data set may well have thousands of
     data points, and in this case the computational cost is
     approximately `P*P'.  This is, therefore, a "order n-squared"
     algorithm, and it is therefore, by it's very nature, slow.  The
     other methods, "neighbor", "objective" and "boxcar" are "order n"
     algorithms, so that "barnes" is much more costly for large data
     sets.  As an example, for a dataset with a `P' of 1000, and with
     `X' and `Y' of 20, "barnes' is slower than "neighbor" by a factor
     of about 100.  (The ratio increases to 300 for 5000 points.)
     Compared to "objective" and "boxcar," however, "barnes" is slower
     by a factor of 13 for 5000 data points and 26 for 10000 data
     points.  For most practical purposes, therefore, the many
     advantages of "barnes" over "objective" and "boxcar" far outweigh
     the additional computational cost.  On the other hand, the very
     swift "neighbor" method,is only suitable for very particular types
     of data sets.

     References: (1) Section 3.6 in Roger Daley, 1991, "Atmospheric data
     analysis," Cambridge Press, New York. (2) S. E. Koch and M.
     DesJardins and P. J. Kocin, 1983.  "An interactive Barnes
     objective map anlaysis scheme for use with satellite and
     conventional data,", J. Climate Appl.  Met., vol 22, p. 1487-1503.

   The Barnes algorithm is as follows:

   The gridded field is estimated iteratively.  Successive iterations
retain largescale features from previous iterations, while adding
details at smaller scales.

   The first estimate of the gridded field, here denoted `G_(ij)^0'
(the superscript indicating the order of the iteration) is given by a
weighted sum of the input data, with `z_k' denoting the k-th `z' value.

                     sum_1^n W_(ijk)^0 z_k
     G_(ij)^(0) = ----------------------
                     sum_1^n W_(ijk)0

where the notation `sum_1^n' means to sum the elements for the `k'
index ranging from 1 to `n'.

   The weights `W_(ijk)^0' are defined in terms of a Guassian function
decaying with distance from observation point to grid point:

                     (      (x_k - X_i)^2           (y_k - Y_j)^2    )
     W_(ijk)^0 = exp (  -  ---------------    -    ---------------   )
                     (         L_x^2                    L_y^2        )

Here `L_x' and `L_y' are lengths which define the smallest `(x,y)'
scales over which the gridded field will have significant variations
(for details of the spectral response see Koch et al. 1983).

Note: if the user has supplied weights, then these are applied in addition
to the distance-based weights.  That is, `w_i W_(ijk)' is used instead
of `W_(ijk)'.

   The second iteration derives a grid `G_(ij)^1' in terms of the first
grid `G_(ij)^0' and "analysis values" `f_k^0' calculated at the
`(x_k,y_k)' using a formula analogous to that above.  (Interpolation
based on the first estimate of the grid `G_(ij)^0' can also be used to
calculate `f_k^0', with equivalent results for a grid of sufficiently
fine mesh.)  In this iteration, however, the weighted average is based
on the difference between the data and the gridded field, so that no
further adjustment of the gridded field is done in regions where it is
already close to through the observed values.  The second estimate of
the gridded field is given by

                             sum_1^n W_(ijk)^1 (f_k - f_k^0)
     G_(ij)^1 = G_(ij)^0  +  -------------------------------
                                    sum_1^n W_(ijk)^1

where the weights `w_(ik,1)' are defined by analogy with `W_(ik)^0'
except that `L_x' and `L_y' are replaced by `gamma^(1/2)L_x' and
`gamma^(1/2)L_y'.  The nondimensional parameter `gamma' (`0<gamma<1')
controls the degree to which the focus is improved on the second
iteration.  Just as the weighting function forced the gridded field to
be smooth over scales smaller than `L_x' and `L_y' on the first
iteration, so it forces the second estimate of the gridded field to be
smooth over the smaller scales `gamma^(1/2)L_x' and `gamma^(1/2)L_y'.

   The first iteration yields a gridded field which represents the
observations over scales larger than `(L_x,L_y)', while successive
iterations fill in details at smaller scales, without greatly modifying
the larger scale field.

   In principle, the iterative process may be continued an arbitrary
number of times, each time reducing the scale of variation in the
gridded field by the factor `gamma^(1/2)'.  Koch et al. 1983 suggest
that there is little utility in performing more than two iterations,
providing an appropriate choice of the focussing parameter `gamma' has
been made.  Thus the gridding procedure defines a gridded field based
on three tunable parameters: `(L_x,L_y,gamma)'.
{
    extern "C" bool convert_columns_to_gridCmd(void);
}

`convert columns to spline [.gamma.] [.xmin. .xmax. .xinc.]'
   Fit a normal or taut interpolating spline, y=y(x), through the (x,y)
data.  Then subsample this spline to get a new set of (x,y) data.  If
the spline x-values, `.xmin.', etc, are not specified, the spline
ranges from the smallest x-value with legitimate data to the largest
one, with 200 steps in between.

   The parameter `.gamma.' determines the type of spline used.  If
`.gamma.' is not specified, or is given as zero, a standard
interpolating spline is used.  A knot appears at each x location, with
cubic polynomials spanning the space between the knots.  If `.gamma.'
lies between 0 and 6, a taut spline is used; this tends to have fewer
wiggles than a normal spline.  If `.gamma.'  lies in the range 0 to 3,
a taut spline is used, with the possible insertion of knots between
interior x pairs.  The value 2.5 is used commonly.  If `.gamma.' lies
in the range 3 to 6, extra knots are permitted in the x pairs at the
ends of the domain.  A value of 5.5 is used commonly.

   *Reference* Chapter 16 of Carl de Boar, 1987. "A Practical Guide to
Splines" Springer-Verlag.
{
    extern "C" bool convert_columns_to_splineCmd(void);
}

`convert grid to columns'
Create column data from grid data.  Each non-missing gridpoint is
translated into a single (x,y,f) triplet.  If column data already exist,
then they are first erased.  This command is useful in changing the grid
configuration, perhaps from a non-uniform grid to a uniform grid.  In
the following example, a new grid with x=(0, 0.05, 0.1, ..., 0.1) and
y=(10, 11, ..., 20) is created.  The default gridding method (`convert
columns to grid') is used here, but of course one is free to adjust the
method as usual.
     # ... read/create grid
     convert grid to columns
     delete grid
     set x grid  0  1 0.05
     set y grid 10 20 1
     convert columns to grid
{
    extern "C" bool convert_grid_to_columnsCmd(void);
}

`convert grid to image [size .width. .height.] [box .xleft. .ybottom. .xright. .ytop.]'
With no options specified, convert grid to a 128x128 image, using an
image range as previously set by `set image range'.  The image will
only be defined for those patches of the region which are spanned by
four neighboring non-missing grid data.  For example, isolated
non-missing grid values will not translate into non-missing pixels.  The
reason for this is that individual pixel values for the image are
determined by interpolating using the four corners of the grid nearest
the pixel.  The interpolation formula is f(x,y)=a+bx+cy+dxy.

   With the `size' options `.width.' and `.height.' specified, they set
the number of rectanglular patches in the image.

   With the `box' options specified, they set the bounding box for the
image.  Otherwise, by default, the image spans the same bounding box as
the grid as set by `set x grid' and `set y grid'.

   Normally, missing values in the grid are translated to white in the
image.  You may control the color of missing values with the `set image
missing value color to'... command.
{
    extern "C" bool convert_grid_to_imageCmd(void);
}

`convert image to grid'
Convert image to grid, using current graylevel/colorlevel mapping.  If
the image is in color, the grid values will represent the result of
mapping the colors to grayscale in the standard way (Foley and VanDam,
1984). [BUG: as of 1.063, the colorscale is ignored completely, and I'm
not sure what happens.] The image data are interpolated onto the grid
using a nearest-neighbor substitution.  This command insists that the
image x/y grids have already been defined.
{
    extern "C" bool convert_image_to_gridCmd(void);
}

`create columns from function'
Plot a function of x which is defined in synonym \function.

     ENVIRONMENT
     \function = function to plot.
     \xmin     = minimum x value
     \xmax     = minimum x value
     \xinc     = increment in x values
     
     EXAMPLE
     \function = "cos(x)"
     \xmin     = "0"
     \xmax     = "2 * 3.14"
     \xinc     = "0.1"
     create columns from function
     draw curve
     quit

NOTE: This only works on machines which have the `awk' command
available at the commandline.  This means most unix machines and some
vax machines, but probably no Macintoshes.
{
    if {rpn "\\xmin" defined}
        .must_clean_up_xmin. = 0
    else
        \xmin = "0"
        .must_clean_up_xmin. = 1
    end if
    if {rpn "\\xmax" defined}
        .must_clean_up_xmax. = 0
    else
        \xmax = "1"
        .must_clean_up_xmax. = 1
    end if
    if {rpn "\\xinc" defined}
        .must_clean_up_xinc. = 0
    else
        \xinc = "0.1"
        .must_clean_up_xinc. = 1
    end if
    if {"\.system." == "unix"}
        system awk           \
            'BEGIN {for(x = \xmin; x <= \xmax; x += \xinc) {print (x, \function)} \
            } '                 \
            > tmp
    else if {"\.system." == "vax"}
        system awk/COMMANDS =\
            "BEGIN { for (x = \xmin; x <= \xmax; x += \xinc) {print (x, \function)} \
            } "                 \
            /OUTPUT=TMP NL:
    end if
    open tmp
    read columns x y
    close tmp
    if {"\.system." == "unix"}
	system rm tmp
    else if {"\.system." == "vax"}
        system DELETE TMP.*;*
    end if
    if .must_clean_up_xmin.
        delete \xmin
    end if
    if .must_clean_up_xmax.
        delete \xmax
    end if
    if .must_clean_up_xinc.
        delete \xinc
    end if
    delete .must_clean_up_xmin.
    delete .must_clean_up_xmax.
    delete .must_clean_up_xinc.
}

`create image grayscale banded .band.'
Make a banded grayscale with in units of .band. pixel values each. 
Thus, pixel values 0 to (.band. - 1) on the image will map to 0, while
values from .band. to (2 * .band. - 1) will map to .band., etc.  For
example, .band. = 2 gives grayscale = (0 0 2 2 4 4 6 6 ... 252 252 254
254).
{
    if {rpn \.words. 5 ==}
        \band = "\.word4"
    else
        show "ERROR: Require 4 words, but got \.words. words."
        show traceback
        quit
    end if
    system awk 'BEGIN        \
        {                       \
        for (i = 0; i < 256; i++) \
        {                       \
        printf ("%d ", \band * int (i / \band)) \
        }                       \
        printf ("\n")           \
        }'                      \
        > GRAYSCALE.TMP
    open GRAYSCALE.TMP
    read image grayscale
    close
    system rm GRAYSCALE.TMP
    delete \band
}

`create image greyscale banded .band.'
Alternate spelling of grayscale.
{
    if {rpn \.words. 5 ==}
        \band = "\.word4"
    else
        show "ERROR:  Require 4 words, but got \.words. words."
        show traceback
        quit
    end if
    system awk 'BEGIN        \
        {                       \
        for (i = 0; i < 256; i++) \
        {                       \
        printf ("%d ", \band * int (i / \band)) \
        }                       \
        printf ("\n")           \
        }'                      \
        > GRAYSCALE.TMP
    open GRAYSCALE.TMP
    read image grayscale
    close
    system rm GRAYSCALE.TMP
    delete \band
}

`debug [.n.] | [clipped values in draw commands] | off'
With no optional parameters, sets the value of `..debug..' to 1. 
(Normally, `..debug..' is 0.)  You may use `..debug..' in if
statements, etc.  Note that `..debug..' is also set to 1 when gri is
invoked with the commandline switch `-d'.

   With `.n.' specified, `..debug..' is set to `.n.'; a value of zero
for `.n.' turns debugging off, while 1 turns it on.  Higher values may
be used for deeper debugging, if you choose:

     if \{rpn ..debug.. 2 <}
       # Code to do if ..debug.. is greater than 2.
     end if

Note that you can assign to `..debug..' as you can to any other
variable; `debug .n.' is equivalent to `..debug.. = .n.'.

   With the `clipped' option, Gri prints any clipped data encountered
during any `draw ...' commands, EXCEPT in the case of `postscript'
clipping, where no check is possible.  (Note that `..debug..' is not
affected.)

   All these forms of debugging are cancelled by `debug off'.
{
    extern "C" bool debugCmd(void);
}

`delete {.variable. | \synonym [...]} | columns [{randomly .fraction.}|{where missing}] | grid | {[x|y] scale}'
Delete some item or characteristic.

 `delete .variable.'
     Delete definition of variable `.variable.', making it undefined.

 `delete \synonym'
     Delete definition of synonym `\synonym', making it undefined.

 `delete columns'
     Delete column data.

 `delete columns randomly .fraction.' Randomly select fraction
     `.fraction.' of the non-missing column data, and designate them
     as being missing.

 `delete grid'
     Delete grid data.

 `delete scale'
     Delete scales for both x and y, so next `read columns' will set
     it.

 `delete x scale'
     Delete scales for x, so next `read columns' will set it.

 `delete y scale'
     Delete scales for y, so next `read columns' will set it.
{
    extern "C" bool deleteCmd(void);
}

`differentiate {x|y wrt index|y|x} | {grid wrt x|y}'
Differentiate column data or grid data.  Only the `x' and `y' columns
may be differentiated.  They may be differentiated either with respect
to ("wrt") the index (forming a first difference) or with respect to
the other column.  The derivative is done with the backwards-difference
algorithm.  Grid data may differentiated with respect to `x' direction
or `y' direction.  Grid differentiation is done with a centred
difference, with endpoints being assigned the derivative of the
neighboring interior point (so that the second derivative is zero at
the edges of the grid).
{
    extern "C" bool differentiateCmd(void);
}

`draw arc [filled] .xc_cm. .yc_cm. .r_cm. .angle_1. .angle_2.'
Draw an "arc", that is, a portion of a circle.  The center of the
circle is at the coordinate (`.xc_cm.', `.yc_cm.'), and the circle
radius is `.r_cm.', all three quantities being in cm on the page, _not_
in user-units.  The arc starts at angle `.angle_1.', measured in
degrees counterclockwise from a horizontal line, and extends to angle
`.angle_2.', in the same units.

If the keyword `filled' is present, the arc is filled with the
current color.  Otherwise it is drawn with the current "curve"
linewidth.
{
    extern "C" bool draw_arcCmd(void);
}

`draw arrow from .x0. .y0. to .x1. .y1. [cm]'
With no optional parameters, draw an arrow from (`.x0.', `.y0.') to
(`.x1.', `.y1.'), where coordinates are in user units.  The arrow head
will be at (`.x1.', `.y1.'), and its size is as set by most recent
call to `set arrow size'.  With the `cm' keyword present, the
coordinates are in centimetres on the page.  NOTE: This will not cause
auto-drawing of axes.
{
    extern "C" bool draw_arrow_from_toCmd(void);
}

`draw arrows'
Draw a vector field consisting of arrows emanating from the coordinates
stored in the (x, y) columns.  The lengths and orientations of the
arrows are stored in the (u, v) columns, and the scale for the (u,v)
columns is set by `set u scale' and `set v scale'.  SEE ALSO: (1) To
set arrow size, use `set arrow size'.  (2) To get a single arrow, for
labelling plots, etc, use the `draw arrow from .x0. .y0.  to .x1. .y1.
[cm]' command.
{
    extern "C" bool draw_arrowsCmd(void);
}

`draw axes if needed'
Draw axes frame if required.  Used within gri commands that auto-draw
axes.  NOTE: this should only be done by developers.
{
    extern "C" bool draw_axes_if_needed(void);
}

`draw axes [.style.|frame|none]'
With no style (`.style.') specified, draw x-y axes frame labelled at
left and bottom. The value of `.style.' determines the style of axes:

 `.style. = 0'
     Draw x-y axes frame labelled at left and bottom

 `.style. = 1'
     Draw axes without tics at top and right

 `.style. = 2'
     Draw axes frame with no tics or labels

   With the keyword `frame' specified, draw axes frame with no tics or
labels (just like `.style.' = 2).

   With the keyword `none' specified, prevent Gri from automatically
drawing axes when drawing curves.
{
    extern "C" bool draw_axesCmd(void);
}

`draw border box [.xleft. .ybottom. .xright. .ytop. .width_cm. .brightness.]'
Draw gray box, as decoration or alignment key for pastup. The box, with
outer lower left corner at (`.xleft.', `.ybottom.') and outer upper right
corner at (`.xright'., `.ytop.') - both coordinates being in centimetres
on the page - is drawn with thickness `.width_cm.' and with graylevel
`.brightness.' (0 for black; 1 for white).  The gray line is drawn
inside the box.  After drawing the gray line, a thin black line is
drawn along the outside edge.

   If the geometry is not specified with `.xleft.' and the other
parameters, then a reasonable margin is used around the present axes
area, and the defaults (`.border.' = 0.2, `.brightness.' = 0.75) are
used.

   NOTE: This command does not cause auto-drawing of axes.
{
    if {rpn \.words. 3 ==}
	.xleft. = {rpn ..xmargin.. "M" width  5 * -}
	.ybottom. = {rpn ..ymargin.. "M" ascent 6 * -}
	.xright. = {rpn ..xmargin.. ..xsize.. + "M" width 2.0 * +}
	.ytop. = {rpn ..ymargin.. ..ysize.. + "M" width 2.0 * +}
	.width_cm. = 0.2
	.brightness. = 0.75
    else if {rpn \.words. 9 ==}
	.xleft. = \.word3.
	.ybottom. = \.word4.
	.xright. = \.word5.
	.ytop. = \.word6.
	.width_cm. = \.word7.
	.brightness. = \.word8.
    else
	show "ERROR:  Require 3 or 9 words, but got \.words. words."
	show traceback
	quit
    end if
    #
    # Save old values of things that will be changed.
    .old_graylevel. = ..graylevel..
    .old_linewidth. = ..linewidth..
    set graylevel .brightness.
    set line width {rpn .width_cm. cmtopt}
    .tmp. = {rpn  .ybottom. ..linewidth.. 2 / pttocm +}
    draw line from .xleft.  .tmp. to .xright.  .tmp. cm # lower edge
    .tmp. = {rpn  .xleft. ..linewidth.. 2 / pttocm +}
    draw line from  .tmp. .ybottom. to  .tmp. .ytop. cm # left edge
    .tmp. = {rpn  .ytop. ..linewidth.. 2 / pttocm -}
    draw line from .xleft.  .tmp. to .xright.  .tmp. cm # upper edge
    .tmp. = {rpn  .xright. ..linewidth.. 2 / pttocm -}
    draw line from  .tmp. .ybottom. to  .tmp. .ytop. cm # right edge
    #
    # Draw thin black border.
    set line width 0.25
    set graylevel black
    draw box .xleft. .ybottom. .xright. .ytop. cm
    #
    # Return to old values.
    set line width .old_linewidth.
    set graylevel .old_graylevel.
    #
    # Clean up local storage.
    delete .tmp.
    delete .old_graylevel.
    delete .old_linewidth.
    delete .brightness.
    delete .width_cm.
    delete .xleft.
    delete .ybottom.
    delete .xright.
    delete .ytop.
}

`draw box filled .xleft. .ybottom. .xright. .ytop. [cm|pt]'
Draw filled box spanning indicated range, with lower-left corner at
(`.xleft.', `.ybottom.') and upper-right corner at (`.xright.', `.ytop.').
The corners are specified in user coordinates, unless the optional
`cm' or 'pt' keyword is present, in which case they are in centimetres
or points on the page.  An error will result if you specify user
coordinates but they aren't defined yet.

   No checking is done on the rectangle; for example, there is no
requirement that `.xleft.' be to the left of `.xright.' in your
coordinate system.

   NOTE: if the box is specified in user units, this command will cause
auto-drawing of axes, but not if the box is specified in cm or
pt units.
{
    extern "C" bool draw_box_filledCmd(void);
}

`draw box .xleft. .ybottom. .xright. .ytop. [cm|pt]'
Draw box spanning indicated range, with lower-left corner at
(`.xleft.', `.ybottom.') and upper-right corner at (`.xright.', `.ytop.').

   The corners are specified in user coordinates, unless the optional
`cm' or `pt' keyword is present, in which case they are in centimetres
or points on the page.  An error will result if you specify user
coordinates but they aren't defined yet.

   No checking is done on the rectangle; for example, there is no
requirement that `.xleft.' be to the left of `.xright.' in your
coordinate system.
{
    extern "C" bool draw_boxCmd(void);
}

`draw circle with radius .r_cm. at .x_cm. .y_cm.'
Draw circle of specified radius (in cm) at the specified location (in
cm on the page).
{
    extern "C" bool draw_circleCmd(void);
}

`draw contour [{.value. [unlabelled|{labelled "\label"}]} | {.min. .max. .inc. [.inc_unlabelled.] [unlabelled]}]'
This command draws contours based on the "grid" data previously read in
by a `read grid data' command or created by gridding column data
with a `create grid from columns' command.  If the grid data don't
exist, or if the x and y locations of the grid points do not exist (see
`set x grid', `set y grid', `read grid x' and `read grid y'), Gri will
complain.

   With no optional parameters, draw labelled contours at an interval
that is picked automatically based on the range of the data.

   With a single numerical value (`.value.'), draw the indicated
contour.  With the addition of `labelled "\label"', put the indicated
label instead of a numeric label.  This can be useful, say, for using
scientific notation instead of computer notation for exponents.  For
example, you might do something like `draw contour 1e-5 labelled
"10$^\{-5}$"' or maybe `draw contour 1e-5 labelled "critical value"'.

   With (`.min.', `.max.' and `.inc.') given, draw contours for z(x,y)
= `.min.', z(x,y) = `.min. + .inc.', z(x,y) = `.min. + 2*.inc.', ...,
z(x,y) = `.max.'

   With the additional value `.inc_unlabelled.' specified, extra
unlabelled contours are drawn at this finer interval.

   With the optional parameter `unlabelled' at the end of any form of
this command (except the `labelled "\label"' variation, of course),
Gri will not label the contour(s).

   *Hint:* It can be effective to draw contours at a certain interval
with labels, and a thicker pen, e.g.
     set line width rapidograph 3x0
     draw contour -2 5 1 0.25
     set line width rapidograph 1
     draw contour -2 5 1
{
    extern "C" bool draw_contourCmd(void);
}

`draw curve overlying'
Like `draw curve', except that before drawing, the area underneath the
curve (+/- one linewidth) is whited out.  This clarifies graphs where
curves overly other curves or the axes.  SEE ALSO: `draw curve'.
{
    state save
    set dash off
    set color white
    set line width {rpn ..linewidth.. 3 *}
    draw curve                  # clean space underneath
    state restore    
    draw curve                  # draw actual curve
}

`draw curve filled [to {.y. y} | {.x. x}]'
The form `draw curve filled ...' draws filled curves.  If `to .value.'
is not specified, fill the region defined by the x-y points using the
current paint colour (see `set graylevel').  To complete the shape, an
extra line is drawn from the first and last point.

   The form `draw curve filled to .y. y' fills the region between y(x)
and y = `.y.'; do not connect the first and last points as in the case
where `to .yvalue.' is not specified.

   The form `draw curve filled to .x. x' fills the region between x(y)
and x = `.x.'
{
    extern "C" bool draw_curveCmd(void);
}

`draw curve'
Draws a curve connecting the points (x,y), which have been read in by a
command like `read columns x y'.  Line segments are drawn between all
(x,y) points, except: (1) no line segments are drawn to any missing
data (see `set missing value'), and (2) if clipping is turned on
(see `set clip on'), no line segments are drawn outside the clipping
region.  SEE ALSO: `draw curve overlying'
{
    extern "C" bool draw_curveCmd(void);
}

`draw essay "text"|reset'
Draw indicated text on the page.  Succeeding calls draw text further
and further down the page, starting at the top.

   The current font size is used; to alter this, do `set font size'
before calling `draw essay'.

   When `reset' is present instead of text, the drawing position is
reset to the top of the page.  Use this after a `new page' command to
ensure that the next text lines will appear at the top of the page as
expected.  EXAMPLE:

     set font size 2 cm
     draw essay "Line 1, at top of page"
     draw essay "Line 2, below top line"
{
    # Check for proper format, and give error message if not.
    if {rpn \.words. 3 ==}
        # Check to see if this is the first call; if so, initialize location.
        if {"\.word2." == "reset"}
            # Reset .top_of_page. and return.
            if ..landscape..
                .top_of_page. = {rpn 8.5 2.54 * 1 -}
            else
                .top_of_page. = {rpn 11. 2.54 * 1 -}
            end if
            return
        end if
        # Last word is not `reset', so draw it.
        if {rpn ".top_of_page." defined !}
            # 
            if ..landscape..
                .top_of_page. = {rpn 8.5 2.54 * 1 -}
            else
                .top_of_page. = {rpn 11. 2.54 * 1 -}
            end if
        end if
        .top_of_page. -= {rpn ..fontsize.. pttocm 1.5 *}
        draw label "\.word2." at 1 .top_of_page. cm
    else
        show "ERROR:  Require 3 words, but got \.words. words."
        show traceback
        quit
    end if
}

`draw gri logo .x_cm. .y_cm. .height_cm. .style. \fgcolor \bgcolor'
.style.    style
=======    ===================
   0       stroke curve
   1       fill with color \fgcolor, no background
   2       fill with color \fgcolor it in tight box of color \bgcolor
   3       as 2 but in square box
   4       draw in \fgcolor on top of shifted copy in \bgcolor
{
    extern "C" bool draw_gri_logoCmd(void);
}

`draw grid'
Draw plus-signs at locations where grid data are non-missing.
{
    extern "C" bool draw_gridCmd(void);
}

`draw image palette [axisleft|axisright|axistop|axisbottom] [left .left. right .right. [increment .inc.]] [box .xleft_cm. .ybottom_cm. .xright_cm. .ytop_cm.]'
With no optional parameters, draw palette for image, placed above the
current top showing values ranging from `.min_value.' to `.max_value.'
as given in `set image range'.

Optional keywords (`axisleft', etc) control the orientation of the
palette, the default being `axisbottom'.

The optional parameters `.left.' and `.right.' may be used to specify
the range to be drawn in the palette.  If the additional optional
parameter `.inc.' is present, it specifies the interval between tics
on the scale; if not present, the tics are at increments of 2 *
(`.right.' - `.left'.).  (If `.inc.' has the wrong sign, it will be
corrected without warning.)

   When the optional `box' parameters are present, they prescribe the
bounding box to contain the palette.  The units are centimetres on the
page.  If these parameters are not present, the box will be drawn above
the image plot.

   HINT: It is a good idea to make the palette range `.left.' to
`.right.' extend a little beyond the range of full white and full
black, since otherwise neither pure white nor pure black will appear in
the colorbar.  For example:
     set image grayscale black 0 white 1 increment 0.1
     draw image palette left -0.1 right 1.1 increment 0.1
{
    extern "C" bool draw_image_paletteCmd(void);
}

`draw image grayscale [left .left. right .right. [increment .inc.]] [box .xleft_cm. .ybottom_cm. .xright_cm. .ytop_cm.]'
Old name for `draw image palette'
{
    extern "C" bool draw_image_paletteCmd(void);
}

`draw image histogram [box .xleft_cm. .ybottom_cm. .xright_cm. .ytop_cm.]'
With no optional parameters, draw histogram of all unmasked parts of
the image, placing it above the current top of the plot.

   When the `box' options are present, they specify the box (in
centimetre coordinates on the page) in which the histogram plot is to
be done.
{
    extern "C" bool draw_image_histogramCmd(void);
}

`draw image'
Draw black/white image made by `convert grid to image' or by `read
image'.
{
    extern "C" bool draw_imageCmd(void);
}

#* @param .P_sigma. = reference pressure for density @default 0dbar
#* @param .P_theta. = reference pressure for temperature @default 0dbar
`draw isopycnal [unlabelled] .density. [.P_sigma. [.P_theta.]]'

   Draw isopycnal curve for a temperature-salinity diagram.  This curve
is the locus of temperature and salinity values which yield seawater of
the indicated density, at the indicated pressure.  The UNESCO equation
of state is used.

   For the results to make sense, the x-axis should be salinity and the
y-axis should be either in-situ temperature or potential temperature.

   The `.density.' unit is kg/m^3.  If the supplied value exceeds 100
it will be taken to indicate the actual density; otherwise it will be
taken to indicate density minus 1000 kg/m^3.  (Thus, 1020 and 20 each
correspond to an actual density of 1020 kg/m^3.)

   The reference pressure for density, `.P_sigma.', is in decibars
(roughly corresponding to meters of water depth).  If no value is
supplied, a pressure of 0 dbar (i.e. atmospheric pressure) is used.

   The reference pressure for theta, `.P_theta.', is in decibars, and
defaults to zero (i.e. atmospheric pressure) if not supplied.  This
option is used if the y-axis is potential temperature referenced to a
pressure other than the surface.  Normally the potential temperature is,
however, referenced to the surface, so that specifying a value for
`.P_theta.' is uncommon.

   By default, labels will be drawn on the isopycnal curve; this may be
prevented by supplying the keyword `unlabelled'.  If labels are drawn,
they will be of order 1000, or of order 10 to 30, according to the
value of `.density.' supplied (see above).  The label format defaults
to "%g" in the C-language format notation, and may be controlled by
`set contour format'.  The label position may be controlled by `set
contour label position' command (bug: only non-centered style works).
Setting label position is useful if labels collide with data points.
Labels are drawn in the whiteunder mode, so they can white-out data
below.  For this reason it is common to draw data points after drawing
isopycnals.

   If the y-axis is in-situ temperature, the command should be called
without specifying `.P_sigma.', or, equivalently, with `.P_sigma.' = 0.
That is, the resultant curve will correspond to the (S,T) solution to
the equation
     .density. = RHO(S, T, 0)
where `RHO=RHO(S,T,p' is the UNESCO equation of state for seawater.
This is a curve of constant sigma_T.

   If the y-axis is potential temperature referenced to the surface,
`.P_theta.' should not be specified, or should be specified to be zero.
The resultant curve corresponds to a constant value of potential
density referenced to pressure `.P_sigma.', i.e. the (S,theta) solution
to the equation
     .density. = RHO(S, theta, .P_sigma.)
For example, with `.P_sigma.=0' (the default), the result is a curve
of constant sigma_theta.

   If the y-axis is potential temperature referenced to some pressure
other than that at the surface, `.P_theta.' should be supplied.  The
resultant curve will be the (S,theta) solution to the equation
     .density. = RHO(S, T', .P_sigma.)
where
     T'=THETA(S, theta, .P_theta., .P_sigma.)
where `THETA=THETA(S,T,P,Pref)' is the UNESCO formula for potential
temperature of a water-parcel moved to a reference pressure of `Pref'.
Note that `theta', potential temperature referenced to 
pressure `.P_theta.', is the variable assumed to exist on
the y-axis.
{
    extern "C" bool draw_isopycnalCmd(void);
}

`draw isospice .spice. [unlabelled]'
Draw an iso-spice line for a "TS" diagram, using (S, T) data stored in
files in a subdirectory named `iso-spice0' in a directory named by the
environment variable `GRI_EOS_DIR'.  You must set this environment
variable yourself, in the normal unix way.  If `GRI_EOS_DIR' is not
defined, Gri looks in the directory `/data/po/ocean/EOS/iso0';
of course, this will work only for people on the same machine as the
author.

   Only certain iso-spice lines are stored in these files, so only
certain values of `.spice.' are allowed.  They are 21.75, 22.00, 22.25,
..., 30.75.  You must supply `.density.' in exactly this format (with 2
decimal places), or else Gri will not find the appropriate TS file, and
will give a "can't open file" error.  NB: isopycnals ranging from about
23.00 to 26.00 cross a TS diagram spanning 34<S<36 and 0<T<10.

   The line is labelled at the right with the density value, unless
the `unlabelled' option is given.

   Clipping should be on when drawing iso-spice lines.  A warning will
be given if the isospice line does not intersect the clipping region.

   EXAMPLE
     set clip on
     draw isospice line 27.00
     draw isospice line 27.50 unlabelled
{
    if {rpn \.words. 3 > \.words. 4 < |}
        show "ERROR:  Require 3 or 4 words, but got \.words. words."
        show traceback
        quit
    end if                      # don't have 3 or 4 words
    get env \gri_eos_dir GRI_EOS_DIR
    if {rpn "\gri_eos_dir" "" ==} 
	\eos_file = "/data/po/ocean/EOS/iso-spice0/spice0_\.word2."
    else
	\eos_file = "\gri_eos_dir/iso-spice0/spice0_\.word2."
    end if
    if ..trace..
        show "Plotting iso-spice lines in \eos_file"
    end if                      # ..trace..
    open \eos_file
    read columns x y
    close
    if ..num_col_data..
        draw curve
        if {rpn \.words. 4 ==}
            if {"\.word3." == "unlabelled"}
                # no label
            else                # improper final word
                show "ERROR:  Bad 4th word \"\.word3.\"; expecting \"labelled\""
                show traceback
                quit
            end if              # improper final word
        else                    # not 4 words
            if {rpn ..xlast.. ..xright.. - ..ylast.. ..ytop.. - >}
                # Put label above.
                draw label "\.word2." at \
                    {rpn ..xlast.. xusertocm "\.word2." width 0.35 * -} \
                    {rpn ..ytop.. yusertocm ..fontsize.. pttocm 0.7 * +} cm
            else                # label at right
                # Put label to right.
                draw label "\.word2." at \
                    {rpn ..xright.. xusertocm ..fontsize.. pttocm 0.7 * +} \
                    {rpn ..ylast.. yusertocm  ..fontsize.. pttocm 0.4 * -} cm
            end if              # label at right
        end if
    else                        # iso-spice not in region
        show "WARNING from `draw isospice ...': iso-spice \.word2. not in clip region."
    end if                      # iso-spice not in region
    delete \gri_eos_dir \eos_file
}

`draw label boxed "\string" at .xleft. .ybottom. [cm]'
Draw boxed label for plot, located with lower-left corner at indicated
(x,y) position (specified in user units, or in cm on the page).  The
current font size and pen color are used.  The geometry derives from
the current font size, with the label being centered within the box.
{
    if {rpn "\.word4." "at" !=}
        show "ERROR: Fifth word must be \"at\", not \"\.word4.\""
        show traceback
        quit
    end if 
    new .x. .y.
    new .draw_boxed_labelR.
    new .draw_boxed_labelG.
    new .draw_boxed_labelB.
    .draw_boxed_labelR. = ..red..
    .draw_boxed_labelG. = ..green..
    .draw_boxed_labelB. = ..blue..
    if {rpn \.words. 7 ==}
        .x. = {rpn \.word5. xusertocm}
        .y. = {rpn \.word6. yusertocm}
    else if {rpn \.words. 8 ==}
        if {rpn "\.word7." "cm" !=}
            show "ERROR: Require 7th word to be `cm'"
            show traceback
            quit
        end if
        .x. = \.word5.
        .y. = \.word6.
    else
        show "ERROR: Require 7 or 8 words, but got \.words. words."
        show traceback
        quit
    end if
    # Coordinates now in cm
    .draw_boxed_label_offset. = {rpn ..linewidth.. pttocm 4 *}
    draw box filled             \
        {rpn .x. .draw_boxed_label_offset. +} \
        {rpn .y. .draw_boxed_label_offset. -} \
        {rpn .x. "MM\.word3." width + .draw_boxed_label_offset. +} \
        {rpn .y. "M" ascent 2 * + .draw_boxed_label_offset. -} cm
    set color white
    draw box filled             \
        .x.                     \
        .y.                     \
        {rpn .x. "MM\.word3." width +} \
        {rpn .y. "M" ascent 2 * +} cm
    set color rgb .draw_boxed_labelR. .draw_boxed_labelG. .draw_boxed_labelB.
    draw box                    \
        .x.                     \
        .y.                     \
        {rpn .x. "MM\.word3." width +} \
        {rpn .y. "M" ascent 2 * +} cm
    draw label "\.word3." at    \
        {rpn .x. "M" width +}   \
        {rpn .y. "M" ascent 0.5 * +} cm
    delete .x. .y.
    delete .draw_boxed_labelR.
    delete .draw_boxed_labelG.
    delete .draw_boxed_labelB.
}

`draw label whiteunder "\string" at .xleft. .ybottom. [cm]'
Draw label for plot, located with lower-left corner at indicated
(x,y) position (specified in user units or in cm on the page).
Whiteout is used to clean up the area under the label.  BUGS:
Cannot handle angled text; doesn't check for super/subscripts.
{
    if {rpn "\.word4." "at" !=}
        show "ERROR: Fifth word must be \"at\", not \"\.word4.\""
        show traceback
        quit
    end if 
    new .x. .y.  .space. .oldR. .oldG. .oldB.
    .oldR. = ..red..
    .oldG. = ..green..
    .oldB. = ..blue..
    if {rpn \.words. 7 ==}
        .x. = {rpn \.word5. xusertocm}
        .y. = {rpn \.word6. yusertocm}
    else if {rpn \.words. 8 ==}
        if {rpn "\.word7." "cm" !=}
            show "ERROR: Require 7th word to be `cm'"
            show traceback
            quit
        end if
        .x. = \.word5.
        .y. = \.word6.
    else
        show "ERROR: Require 7 or 8 words, but got \.words. words."
        show traceback
        quit
    end if
    # Coordinates now in cm.  Next, white out a box under the
    # text (and .space. centimetres beyond text), then draw label.
    .space. = 0.1               # cm
    set color white
    draw box filled             \
        {rpn .x. .space. -}     \
        {rpn .y. .space. -}     \
        {rpn .x. "\.word3." width + .space. +} \
        {rpn .y. "M" ascent + .space. + } cm
    set color rgb .oldR. .oldG. .oldB.
    draw label "\.word3." at .x. .y. cm
    delete .x. .y.  .space. .oldR. .oldG. .oldB.
}

`draw label for last curve "label"'
Draw a label for the last curve drawn, using the `..xlast..' and
`..ylast..' built-in variables.
{
    if {rpn \.words. 6 ==}
        draw label "\.word5." at\
            {rpn ..xlast.. xusertocm "M" width 0.5 * +} \
            {rpn ..ylast.. yusertocm "M" ascent 0.5 * -} cm
    else
        show "ERROR:  Require 6 words, but got \.words. words."
        show traceback
        quit
    end if
}

`draw label "\string" [centered|rightjustified] at .x. .y. [cm|pt] [rotated .deg.]'
With no optional parameters, draw string at given location in USER
units.

   With the `cm' or `pt' keyword is present, the location is in
centimetres or points on the page.

   With the `rotated' keyword present, the angle in degrees from the
horizontal, measured positive in the counterclockwise direction, is
given.

   With the keyword `centered' present, the text is centered at the
given location; similarly the keyword `rightjustified' makes the text
end at the given location.
{
    extern "C" bool draw_labelCmd(void);
}

`draw line from .x0. .y0. to .x1. .y1. [cm|pt]'
With no optional parameters, draw a line from (`.x0.', `.y0.') to
(`.x1.', `.y1'.), where coordinates are in user units.  With the `cm'
or 'pt' keyword present, the coordinates are in centimetres or
points on the page. 
NOTE: This will not cause auto-drawing of axes.
{
    extern "C" bool draw_line_from_toCmd(void);
}

`draw line legend "label" at .x. .y. [cm] [length .cm.]'
Draw a legend identifying the current line type with the given label. 
A short horizontal line is drawn starting at the location (`.x.',
`.y.'), which may be specified in centimetres or, the default, in user
coordinates.  The line length is normally 1 cm, but this length can be
set by the last option.  The indicated label string is drawn 0.25 cm
to the right of the line.

   SEE ALSO `draw symbol legend ...'.

   EXAMPLE (of keeping track of the desired location for the legend)

     .offset. = 1			# cm to offset legends
     # ... get salinity data
     set line width 0.25
     draw curve
     draw line legend "Salinity" at .x. .y.
     # ... get temperature data
     set line width 1.0
     set dash 0.45 0.05
     draw curve
     .y. += .offset.
     draw line legend "Temperature" at .x. .y.
{
    # Check for too few or too many words.
    if {rpn \.words. 7 >}
        show "ERROR:  Require 7 or more words, but got \.words. words."
        show traceback
        quit
    end if
    if {rpn \.words. 10 <}
        show "ERROR:  Require 10 or fewer words, but got \.words. words."
        show traceback
        quit
    end if
    .tmp_len. = 1               # cm
    if {rpn \.words. 9 ==}
        .tmp_len. = \.word8.
    else if {rpn \.words. 10 ==}
        .tmp_len. = \.word9.
    end if
    if {"\.word7." == "cm"}
        # Position given in centimetres.
        draw line from          \
            \.word5.            \
            \.word6.            \
            to                  \
            {rpn \.word5. .tmp_len. +} \
            \.word6.            \
            cm
        draw label "\.word3." at\
            {rpn \.word5. .tmp_len. + 0.25 +} \
            {rpn \.word6. ..fontsize.. pttocm 0.4 * -} \
            cm
    else
        # Position given in user units.
        draw line from          \
            \.word5.            \
            \.word6.            \
            to                  \
            {rpn \.word5. xusertocm .tmp_len. + xcmtouser} \
            \.word6.
        draw label "\.word3." at\
            {rpn \.word5. xusertocm .tmp_len. + 0.25 + xcmtouser} \
            {rpn \.word6. yusertocm ..fontsize.. pttocm 0.4 * - ycmtouser}
    end if
}

`draw lines {vertically .left. .right. .inc.} | {horizontally .bottom. .top. .inc.}'
Draw several lines, either vertically or horizontally.  This can be
useful in drawing gridlines for axes, etc.  The following example shows
how to draw thin gray lines extending from the labelled tics on the x
axis (ie, at 0, 0.1, 0.2, ... 1):

     set x axis 0 1 0.1 0.05
     set y axis 10 20 10
     draw axes
     set graylevel 0.75
     set line width 0.5
     draw lines vertically 0 1 0.1
     set graylevel black
{
    extern "C" bool draw_linesCmd(void);
}

`draw patches .width. .height. [cm]'
With the optional `cm' keyword not present, draw column data z(x,y) as
gray patches according to the grayscale as set by most recent `set
image grayscale'.  The patches are aligned along the horizontal, and
have the indicated size in user units.

   With the optional keyword `cm' is present, the patch size is
specified in centimetres.
{
    extern "C" bool draw_patchesCmd(void);
}

`draw polygon [filled] .x0. .y0. .x1. .y1. .x2. .y2. [...]'
Draw a polygon connecting the indicated points, specified in user
units.  The last point is joined to the first by a line segment.  At
least two points must be specified.  If the `filled' keyword is
present, the polygon is filled with the current pen color.
{
    extern "C" bool draw_polygonCmd(void);
}

`draw regression line [clipped]'
Fit a regression line to column data, of the form
    `y = ..coeff0.. + ..coeff1.. * x'
(exporting `..coeff0..' and `..coeff1..' as global variables) and draw this line on the plot, for the range `..xleft.. <= 
x <= ..xright..'  on the x-axis.

Fit and draw a regression line to column data, of the form
    `y = ..coeff0.. + ..coeff1.. * x'
(exporting `..coeff0..', `..coeff0_sig..', `..coeff1..' and
`..coeff1_sig..'  as global variables; see `regress').

Normally, the line is not clipped to the axes frame, but it will be if the
keyword 'clipped' is given.

HINT: to label the plot you might do the following:

     sprintf \label "y = %f + %f * x. R$^2$=%f" ..coeff0.. ..coeff1.. ..R2..
     draw title "The linear fit is \label"

SEE ALSO: `regress'
{
    regress y vs x
    new .clipped. .xl. .xr. .yl. .yr.
    if {rpn \.words. 4 ==}
	if {rpn "\.word3." "clipped" ==}
	    .clipped. = 1
	else
	    show "ERROR: 4-th word must be 'clipped', not '\.word3.'"
	    show traceback
	    quit
	end if
    else 
	.clipped. = 0
    end if
    .xl. = ..xleft..
    .xr. = ..xright..
    .yl. = {rpn .xl. ..coeff1.. * ..coeff0.. +}
    .yr. = {rpn .xr. ..coeff1.. * ..coeff0.. +}
    if .clipped.
	if {rpn .yl. ..ybottom.. > }
	    .yl. = ..ybottom..
	    .xl. = {rpn .yl. ..coeff0.. - ..coeff1.. /}
	end if
	if {rpn .yl. ..ytop.. < }
	    .yl. = ..ytop..
	    .xl. = {rpn .yl. ..coeff0.. - ..coeff1.. /}
	end if
	if {rpn .yr. ..ytop.. < }
	    .yr. = ..ytop..
	    .xr. = {rpn .yr. ..coeff0.. - ..coeff1.. /}
	end if
	if {rpn .yr. ..ybottom.. > }
	    .yr. = ..ybottom..
	    .xr. = {rpn .yr. ..coeff0.. - ..coeff1.. /}
	end if
    end if
    draw line from .xl. .yl. to .xr. .yr.
    draw axes if needed
    delete .clipped. .xl. .xr. .yl. .yr.
}

`draw symbol legend \symbol_name "label" at .x. .y. [cm]'
Draw indicated symbol at indicated location, with the indicated label
beside it.  The label is drawn one M-space to the right of the symbol,
vertically centered on the indicated `.y.' location.
{
    # Note kludge in y position, because ascent is inaccurate as
    # of version 1.17 anyway
    if {rpn \.words. 8 ==}
        draw symbol \.word3. at \.word6. \.word7.
        draw label "\.word4." at\
            {rpn \.word6. xusertocm "M" width +} \
            {rpn \.word7. yusertocm "M" ascent 0.7 * 2 / -} cm
    else if {rpn \.words. 9 ==}
        if {rpn "\.word8." "cm" ==}
            draw symbol \.word3. at \.word6. \.word7. cm
            draw label "\.word4." at \
                {rpn \.word6. "M" width +} \
                {rpn \.word7. "M" ascent 0.7 * 2 / -} cm
        else
            show "ERROR:  Can't understand [\.word8.]; expecting [cm]"
            show traceback
            quit
        end if
    else
        show "ERROR:  Require 8 or 9 words, not \.words. as given."
        show traceback
        quit
    end if
}

`draw symbol [.code.|\name [at .x. .y. [cm|pt]] [graylevel z]|[color [hue z|.h.] [brightness z|.b.] [saturation z|.s.]]]'
The "at" form `draw symbol .code.|\name at .x. .y. [cm|pt]' draws a
single symbol at the named location.

The non-"at" form draws symbols at the (x,y) data.  If a z-column has
been read with `read columns', then it's value codes the symbol to
draw, according to the table below.  (The value of z is first rounded
to the nearest integer.)  If no z-column has been read, the symbol X
is drawn at each datum.

   With the optional numerical/name code specified, then the symbol of
that number or name is drawn at each (x,y) datum, whether or not a
z-column exists.  The numerical/name codes are:

      # name                description
     -- ----                -----------
      0 plus                +
      1 times               x
      2 box                 box
      3 circ                circle
      4 diamond             diamond
      5 triangleup          triangle with base at bottom
      6 triangleright       triangle with base at left
      7 triangledown        triangle with base at top
      8 triangleleft        triangle with base at right
      9 asterisk            *
     10 star                star of David
     11 filledbox           filled box
     12 bullet              filled circle
     13 filleddiamond       filled diamond
     14 filledtriangleup    filled triangleup
     15 filledtriangleright filled triangleright
     16 filledtriangledown  filled triangledown
     17 filledtriangleleft  filled triangleleft

   With the optional `graylevel z' fields specified, the graylevel is
given by the `z` column (0=black, 1=white).

   With the optional `color' field specified, the color is specified,
either directly in the command (the `hue .h.' form) or in the z
column.  For more information on color, refer to the `set color hsb
...' command.

   Examples: both `draw symbol bullet color' and `draw symbol bullet
color hue z' draw bullets whose hue is given by the value in the z
column.  The hue (or the color, in other words) blends smoothly across
the spectrum as the numerical value ranges from 0 to 1.  The value
0yields red, 1/3 yields green, 2/3 yields blue, etc.  If the
`brightness' and the `saturation' are not specified, they both default
to the value 1, which yields pure, bright colors.

   Example: `draw symbol bullet color hue 0.333 brightness 1
saturation 1' draws green dots.
{
    extern "C" bool draw_symbolCmd(void);
}

`draw time stamp [fontsize .points. [at .x_cm. .y_cm. cm [with angle .deg.]]]'
Draw the command-file name, PostScript file name, and time, at the top
of graph.  Normally, the timestamp is drawn at the top of the page, in
a fontsize of 10 points.  But the user can specify the fontsize, and
additionally the location (in cm) and additionally the angle measured
in degrees anticlockwise from the horizontal.

   NOTE: If you want to have the plot in landscape mode on the page,
make sure that you do `set page landscape' before `draw time stamp.'
{
    new .old_fontsize.
    .old_fontsize. = ..fontsize..
    if {rpn \.words. 3 ==}
        # Just `draw time stamp'
        set font size 10
        if ..landscape..
            draw label "Gri-\.version. \.wd./\.command_file. (\.time.)" at \
                1.5 20.6 cm
        else
            draw label "Gri-\.version. \.wd./\.command_file. (\.time.)" at \
                1.5 27.0 cm
        end if
    else if {rpn \.words. 5 ==}
        # `draw time stamp fontsize .points.'
        #     0    1     2        3        4
        set font size \.word4.
        if ..landscape..
            draw label "Gri-\.version. \.wd./\.command_file. (\.time.)" at \
                1.5 20.6 cm
        else
            draw label "Gri-\.version. \.wd./\.command_file. (\.time.)" at \
                1.5 27.0 cm
        end if
    else if {rpn \.words. 9 ==}
        # `draw time stamp fontsize .points. at .x_cm. .y_cm. cm'
        #     0    1     2        3        4  5      6      7  8
        set font size \.word4.
        draw label "Gri-\.version. \.wd./\.command_file. (\.time.)" at \
            \.word6. \.word7. cm
    else if {rpn \.words. 12 ==}
        # `draw time stamp fontsize .points. at .x_cm. .y_cm. cm with angle .deg.'
        #     0    1     2        3        4  5      6      7  8    9    10    11
        set font size \.word4.
        draw label "Gri-\.version. \.wd./\.command_file. (\.time.)" at \
            \.word6. \.word7. cm rotated \.word11.
    else 
        show "ERROR:  Require 3, 5, 9 or 12 words, but got \.words. words."
        show traceback
        quit
    end if
    set font size .old_fontsize.
    delete .old_fontsize.
}

`draw title "\string"'
Draw the indicated string above the plot.
{
    extern "C" bool draw_titleCmd(void);
}

`draw values [.dx. .dy.] [\format] [separation .xcm. .ycm.]'
Draw values of `z' column, at corresponding (`x', `y') locations.  If
the `separation' keyword is present, the distance between successive
points is checked, and points are skipped unless the x and y
separations exceed than the indicated distances.

 `draw values'
     Draw the values of `z(x,y)', positioned 1/2 M-space to the right
     of `(x,y)' and vertically centred on `y'.  The values are written
     in a good general format known as `%g', in C terminology.

 `draw values %.2f'
     Draw values of `z(x,y)' positioned as described above, but using
     the indicated format string.  This format string specifies that 2
     numbers be used after the decimal place, and that floating point
     should be used.  See any C manual for format codes.

 `draw values .dx. .dy.'
     Print values of `z(x,y)' at indicated offset vector
     (`.dx.',`.dy.'), measured in centimeters, from the values of
     `(x,y)' at which the data are defined.

 `draw values .dx. .dy. %.3f'
     Print values of `z(x,y)' at indicated distance from `(x,y)',
     indicated format.
{
    extern "C" bool draw_valuesCmd(void);
}

`draw x axis [at bottom|top|{.y. [cm]} [lower|upper]]'
Draw an x axis, optionally at a specified location and of a specified
style.

 `draw x axis'
     Draw a lower x axis (ie, one with the numbers below the line) at
     the bottom of the box defined by `set y axis'.

 `draw x axis at bottom'
     Draw a lower x axis (ie, one with the numbers below the line) at
     the bottom of the box defined by `set y axis'.

 `draw x axis at top'
     Draw an upper x axis (ie, one with the numbers above the line) at
     the top of the box defined by `set y axis' (or above any existing
     stacked x axes there)

 `draw x axis at .y.'
     Draw a lower x axis at indicated value of `.y.'.

 `draw x axis at .y. upper'
     Draw an upper x axis at indicated value of .y.
{
    extern "C" bool draw_x_axisCmd(void);
}

`draw x box plot at .y. [size .cm.]'
Draw Tukey box plots (which give a summary of histogram properties).
Box plots were invented by Tukey for eda (exploratory data analysis).
The centre of the box is the median.  The box edges show the first
quartile (q1) and the third quartile (q3).  The distance from q3 to q1
is called the inter-quartile range.  The whiskers (i.e., the lines with
crosses at the end) extend from q1 and q3 to the furthest data points
which are still within a distance of 1.5 inter-quartile ranges from q1
and q3.  Beyond the whiskers, all outliers are shown: open circles are
used for data within a distance of 3 inter-quartile ranges beyond q1 and
q3, and in closed circles beyond that.

 `draw x box plot at .y.'
     Draw Tukey's box plot, spreading in the x direction, centered at
     y=`.y.' and of default width 0.5 cm.

 `draw x box plot at .y. size .cm.'
     Draw Tukey's box plot, spreading in the x direction, centered at
     y=`.y.' and of width `.cm.' centimetres.
{
    extern "C" bool draw_x_box_plotCmd(void);
}

`draw y axis [at left|right|{.x. cm} [left|right]]'
Draw a y axis, optionally at a specified location and of a specified
style.

 `draw y axis'
     Draw a left-hand-side y axis (ie, one with the numbers to the
     left of the line) at left of box defined by `set x axis'

 `draw y axis at left'
     Draw a left-hand-side y axis (ie, one with the numbers to the
     left of the line) at left of box defined by `set x axis'.

 `draw y axis at right'
     Draw a right-hand-side y axis (ie, one with the numbers to the
     right of the line) at right of box defined by `set x axis'.

 `draw y axis at .x.'
     Draw a left-hand-side y axis (ie, one with the numbers to the
     left of the line) at indicated value of `.x.'

 `draw y axis at .x. right'
     Draw a right-hand-side y axis (ie, one with the numbers to the
     right of the line) at indicated value of `.x.'
{
    extern "C" bool draw_y_axisCmd(void);
}

`draw y box plot at .x. [size .cm]'
Draw Tukey box plots (which give summary of histogram properties).

 `draw y box plot at .x.'
     Draw Tukey's box plot, spreading in the y direction, centered at
     x=`.x.' and of default width 0.5 cm.

 `draw y box plot at .x. size .cm.'
     Draw Tukey's box plot, spreading in the y direction, centered at
     x=`.x.' and of width `.cm.' centimetres.
{
    extern "C" bool draw_y_box_plotCmd(void);
}

`draw zero line [horizontally|vertically]'
Draw lines corresponding to x=0 or y=0.

 `draw zero line'
     Draw line y=0 if it's within axes.

 `draw zero line horizontally'
     Draw line y=0 if it's within axes.

 `draw zero line vertically'
     Draw line x=0 if it's within axes.
{
    extern "C" bool draw_zero_lineCmd(void);
}

`end group ["\name"]'
Ene a group, i.e. a collection of graphical objects.  
(NOT IMPLEMENTED YET.  SYNTAX MAY CHANGE.)
{
    extern "C" bool end_groupCmd(void);
}

`expecting version .n.'
Show a list of incompatibilites since the named version.  This protects
you from being clobbered by changes made to Gri, since you will be
assured of being warned of these changes.  For example, if you are doing
a lot of work with version 2.1.0, but want to move up to a higher
version, you would include the line `expecting version 2.0100' in all
your commandfiles.  Once you are sure that your commandfile will not be
affected by the newer version, you should change the version that is
expected.

   Note: As of October 1996, Gri version numbers have been in the form
`a.b.c'.  Numerical version numbers are created by the formula
`a + b/100 + c/10000'.  For example, version `2.1.0' has a numerical
value of `2.0100'.
{
    extern "C" bool expectingCmd(void);
}

`filter column x|y|z|u|v recursively .a0. .a1. ... .b0. .b1. ...'
     Filter indicated column, using a two-pass recursive filter.  The
     first pass runs from the start to the end, while the second pass
     runs from the end to the start; in this way, the phase shift
     inherent in this type of filter is removed entirely.  The
     coefficients are used in the following formula (demonstrated on
     the `x' column):
    x_new[i] = b[0] * x[i] + b[1] * x[i-1]     + b[2] * x[i-2]     + ...
                           - a[1] * x_new[i-1] - a[2] * x_new[i-2] - ...

          Thus, for example, setting `a[i]' = 0 results in a simple
     backwards-looking moving-average filter applied in two passes. 
     The real power of this type of filter, however, comes when
     non-zero `a[i]' coefficients are given, thus adding recursion
     (i.e., `x_new[i]' depends on `x_new[i-...]').  See any standard
     reference on digital filters for an explanation.  You might find
     that the Matlab command `butter' an easy way to design filter
     coefficients.  Here are some examples:

          # Filter x column with simple 2-point moving average.
          filter column x recursively 0 0 0.5 0.5
          
          # Use filter designed with the Matlab command butter(2,0.1),
          # which creates a 2nd order lowpass butterworth filter, with a cutoff
          # frequency of 0.1 (in units which have a frequency of 1 corresponding
          # to one-half the sampling rate).
          filter column x recursively 1 -1.561 0.6414   0.0201 0.0402 0.0201
{
    extern "C" bool filter_columnCmd(void);
}

`filter grid rows|columns recursively .a0. .a1. ... .b0. .b1. ...'
Apply recursive filter (see `filter column ... recursively' for
meaning of this filter) to the individual rows or columns of the grid
data.  For example, `filter grid columns recursively 0 0 .5 .5'
applies a 2-point moving average filter across the columns, smoothing
the grid in the x-direction.
{
    extern "C" bool filter_gridCmd(void);
}

`filter image highpass|lowpass'
 `filter image highpass'
     Remove low-wavenumber components from image (ie, sharpen edges). 
     Do this by subtracting a Laplacian smoothed version of the image.

 `filter image lowpass'
     Remove high-wavenumber components from image (ie, smooth shapes).
      Do this by Laplacian smoothing.
{
    extern "C" bool filter_imageCmd(void);
}

`flip grid|image x|y'
Flip image by relecting it about a horizontal or vertical centerline.

 `flip grid x'
     Flip grid so right-hand side becomes left-hand side.

 `flip grid y'
     Flip grid so bottom side becomes top side.

 `flip image x'
     Flip image so right-hand side becomes left-hand side.

 `flip image y'
     Flip image so bottom side becomes top side.
{
    extern "C" bool flipCmd(void);
}

`get env \result \environment_variable'
Get the value of an "environment variable" from the operating system,
and store the result in the indicated synonym.  This makes most sense on
unix systems (hence the name, patterned after the unix command
`getenv').  This command can be useful in making gri programs resistant
to changes in data-file locations.  Suppose, for example, there is a
file called `data', normally in a local directory called `Bravo'.  The
line `open Bravo/data' will fail if the Bravo directory is moved.  But
if the name of the datafile is stored in an environment variable,
`DIR_BRAVO' say, then the gri program will work no matter where the
Bravo data are moved, so long as an appropriate environment variable is
modified when the data are moved.  Example:
     get env \dir DIR_BRAVO
     if \{rpn "\dir" "" ==}
         show "Cannot determine location of the Bravo data, which should"
         show "be stored in the environment-variable DIR_BRAVO.  You should"
         show "do something like"
         show "    export DIR_BRAVO='/users/dek/kelley/data/Bravo/'"
         show "in your ~/.environment file"
         quit
     end if
     open \dir/data
     ...
{
    extern "C" bool get_envCmd(void);
}

`get options "LIST" [keep]'
{
    extern "C" bool get_optionsCmd(void);
}

`group ["\name"]'
Start a group, i.e. a collection of graphical objects.  
(NOT IMPLEMENTED YET.  SYNTAX MAY CHANGE.)
{
    extern "C" bool groupCmd(void);
}

`heal columns|{grid along x|y}'
   The `heal' command heals over gaps in either columnar or gridded
data.  This is done by linear interpolation across the missing-value
gaps.

   * `heal columns'

     Fill in missing values in x, y, z, ... columns, by linear
     interpolation to neighboring valid data.  All gaps in the data
     will get replaced by a linear function of index which matches the
     data at the indices just before and just after the gap.  For
     example, if the y data were like
          111
          3
          -9
          -9
          -9
          7
          333

     where `-9' is the missing-value code, then they would get replace
     by
          111
          3
          4
          5
          6
          7
          333
     Notes: (1) This is done *independently* for all existing columns.
     (2) Gaps at the start and end of the columns are not filled in.


   * `heal grid along x'

     Scan in the x direction, filling in missing values by linearly
     interpolation.  Since this uses the the x-grid, you must first
     have done `read grid x' or `set x grid'.

   * `heal grid along y'

     Scan in the y direction, filling in missing values by linearly
     interpolation.  Since this uses the the y-grid, you must first
     have done `read grid y' or `set y grid'.
{
    extern "C" bool healCmd(void);
}

`help [*|command_name|{- topic}]'
Give help on a command or topic.

 `help'
     Print a general help message.

 `help *'
     Prints complete help info.

 `help command_name'
     Prints help on the command whose name begins with the string
     `command_name'.  The string may be several words long; e.g. 
     `help set' or `help set x axis'.

 `help - topic_name'
     The minus sign tells Gri that the string to follow it is a topic,
     not a command.  Topics Gri knows about are listed by the one-word
     `help' request.
{
    extern "C" bool helpCmd(void);
}

`if {[!] .flag.}|\flag|{{"string1" == "string2"}}'
Control program flow.  The `if' block is ended with a line containing
`end if'.  Optional `else' and `else if' blocks are allowed.  Note
that RPN expressions are allowed, and a special form of string
comparison is allowed, as in the examples below.

     if .flag.
       # List of Gri commands to be done if .flag. is 1.
       # This list may extend across any number of lines.
     end if

If the variable `.flag.' is not equal to 0, do the code between the
`if' line and the `end if' line.

     if .flag.
       # Commands done if .flag. is 1
     else
       # Commands done if .flag. is 0
     end if

If the variable `.flag.' is not equal to 0, do the code between the
`if' line and the `else' line.  If `.flag.' is equal to 0, do the code
between the `else' line and the `end if' line.

     if ! .flag.
       # Commands done if .flag. is 0
     end if

If the variable `.flag.' is equal to 0, do the code between the `if'
line and the `end if' line.

     if \{rpn .flag. 10 <}
       # Commands done if 10 is less than .flag.
     end if

If the variable `.flag.' is less than 10, do the code between the `if'
line and the `end if' line.

     if \smooth
       # Commands done if \smooth is 1
     else
       # Commands done if \smooth is 0
     end if

If the number stored in the synonym `\smooth' is not equal to 0, do
the code between the `if' line and the `else' line.  If the synonym
stores a representation of a number not equal to zero, do the `else'
part.  If the synonym contains text that does not decode to a number,
generate error message.

     if \{"\item" == "Temperature"}
       # Commands done if the synonym \item is equal to the
       # indicated text string.
     end if

If the synonym `\item' has the value `Temperature' stored in it, do
the indicated code.

     if \{rpn "\item" "Temperature" ==}
       # Commands done if the synonym \item is equal to the
       # indicated text string.
     end if

As above, but using the `rpn' calculator.
{
    extern "C" bool null;
}

`ignore last .n.'
Ignores last `.n.' lines read by `read columns'.
{
    extern "C" bool ignoreCmd(void);
}

`input \ps_filename [.xcm. .ycm. [.xmag. .ymag. [.rot_deg.]]]'
Input the named PostScript file directly into the Gri output PostScript
file.  (If the filename has punctuation, insert it in double quotes,
e.g. `input "../thefile"'.)  If no options are specified, the file is
input at normal scale, with normal margins.  (Aside to PostScript
programmers: the named file is sandwiched between `gsave' and
`grestore' commands.)  If `.xcm.' and `.ycm.' are specified, then the
origin is moved to the named location first.  If, in addition, `.xmag.'
and `.ymag.' are specified, then these are used as scale factors after
translation.  Finally, if `.rot_deg.' is specified in addition, then
the indicated counterclockwise rotation is applied after translation
and scaling.  Hint: if the results look wrong, the first thing to do is
to think carefully about the order of the (translation, scaling,
rotation) operations.
{
    extern "C" bool inputCmd(void);
}

`insert \filename'
Insert instructions in named file into current file.  This is useful as
a way of sharing global information between several Gri programs.  On
unix systems, if a full filename is specified (i.e., a filename
beginning with slash or period), then that particular file will be used.
For filenames beginning with a letter or number, though, Gri will search
for the file in the list of directories stored in your `GRIINPUTS'
environment variable, or in the list (`.', `/usr/local/lib/gri') if
that environment variable is not set.
{
    extern "C" bool insertCmd(void);
}

`interpolate x|y grid to ...'
The forms are
     interpolate x grid to .left. .right. .inc.|\{/.cols.}
     interpolate y grid to .bottom. .top. .inc.|\{/.rows.}

Transform grid by interpolating between existing grid data, according to
a new x or y grid specified in the manner of `set x grid' and `set y
grid'.  Note that the new grid is neccessarily regular, while the first
grid needn't have been.  The data of the new grid are constructed by
interpolation, using the same interpolation algorithm as the `convert
grid to image' command.
{
    extern "C" bool interpolateCmd(void);
}

`list \command-syntax'
List the source of a gri command.  Often this is just the name of a C
function internal to gri (try `list list' for an example), but when
the command is written in the gri programming language the source will
be more understandable (try `list set panel').
{
    extern "C" bool listCmd(void);
}

`ls [\file_specification]'
List files in current directory.  (The current directory can be printed
by the gri command `pwd' and can be set by the gri command `cd'.)  `ls
\file_specification' lists files in current directory which match the
file specification.  Normal unix file specification options are
understood.
{
    extern "C" bool lsCmd(void);
}

`mask image [to {uservalue .u.}|{imagevalue .i.}]'
Examine both the image and the mask pixel by pixel.  For any pixels
which have a mask value of 1 (which indicates an invalid region of the
image), change the image value.  If no `to' phrase is present, change
the image value to 0 in pixel units.  If the `to uservalue .u.' phrase
is present, change the pixel to hold the imagevalue that corresponds to
this uservalue (see `set image range' command for a discussion of this
correspondance).  If the `to imagevalue .i.', change the pixel to hold
that imagevalue (in range 0 to 255 inclusive for 8-bit images).
{
    extern "C" bool maskCmd(void);
}

`new page'
Finish the present page, and start a new page.  All settings (of
linewidth, axes, landscape/portrait, etc.) and data are retained
on the new page. 
{
    extern "C" bool new_pageCmd(void);
}

`new postscript file \name'
Finish the present Postscript file, and start a new page with
the given name.  All settings (of linewidth, axes, landscape/portrait,
etc.) and data are retained on the new file.
{
    extern "C" bool new_postscript_fileCmd(void);
}

`new .variable_name.|\synonym_name [.variable_name.|\synonym_name [...]]'
Set aside storage for new version of the named variable(s) and/or
synonym(s).  Any number of variables and synonyms may be specified.  If
a given variable/synonym already exists, this will create a new version
of it, and future assignments will be stored in this new version
*without* affecting the pre-existing version.  If the variable/synonym
is `delete'ed, the new version is deleted, making the old, unaltered,
version accessible again.

   This command is used mostly for temporary use, to prevent clashing
with existing values.  Suppose you want to change the font size inside
a new command or an if block.  Then you might do the following, where
the variable `.tmp.' is used to store the old font size.  Note that the
use of the `new/delete' statements prevents the assignment to the
local version of the variable `.tmp.' from affecting the value known
outside the `if' block, if in fact `.tmp.' happened to exist outside
the block.

     set font size 10
     draw label "This is in fontsize 10, before modification" at 10 2 cm
     if .want_title.
       new .tmp.                             # Get storage
       .tmp. = ..fontsize..                  # Save old size
       set font size 22                      # Set new size
       draw label "This is in fontsize 22" at 10 5 cm
       set font size .tmp.                   # Restore old size
       delete .tmp.				# Clean up
     end if
     draw label "This is in fontsize 10, after modification" at 10 8 cm
{
    extern "C" bool newCmd(void);
}

`open {\filename}|{"system command|"} {[binary [uchar|int|float|double|16bit]]}|{netCDF}'
   Possibilities are:
     `open \filename'
     `open \filename          binary [uchar|int|float|double]'
     `open \filename          netCDF'
     `open "SYSTEM-COMMAND |" [binary [uchar|int|float|double]]'

The first three forms work on data files.  Use double-quotes around
filenames with punctuation in them (e.g. `open "../data"').  Files may
be ascii (the default), binary or - on systems with the `netCDF'
libraries installed - in the `netCDF' format.  The `SYSTEM-COMMAND'
form is used to work on a temporary file created by a system command.

   Several binary file types are allowed.  The keywords `uchar', etc,
can be used to specify the type of data in the file.  If no keyword is
given, Gri assumes that images use `unsigned char' (8 bits), columns
use `float' (32 bits), and that grids use `float' (32 bits).

   In the `SYSTEM-COMMAND' form, the indicated system command is
performed, with the output being inserted into a temporary file.  Future
`read', `close', etc, commands apply to to this temporary file.  (The
temporary file is automaticaly deleted by Gri, but if Gri fails for
some reason you should scan `/usr/tmp/' for files that you own.)  For
example
     open "cat a.dat | awk '\{$1, $2 * 22}' |"
     read columns x y
gets awk to multiply the y column by 22.  The ability to
use system commands in `open' statements lets you use familiar system
tools like `head', `sed', `awk', `perl', etc, to work on your data.
For example, if you store your data in compressed form, and do not wish
to have temporary files sitting around, you might wish to do something
like
     open "zcat myfile.dat.Z | "

   Files may be opened across the WWW (world-wide web).  Here is a
replacement for example1.gri:
     open "lynx -dump http://www.phys.ocean.dal.ca/~kelley/gri/examples/example1.dat | tail +2 |"
     read columns x y
     draw curve
     draw title "Example 1"
Note: the `tail +2' removes the initial blank line that lynx
generates.

   For complicated data manipulation, a system tool like `awk' or
`perl' is ideal.  For example, suppose x and y data are stored in
Hour.minutesecond format, e.g. 12.2133 means hour 12, minute 21, second
33.  Gri doesn't read HMS format, but gawk can be told to:
     open "cat datafile.HMS |        \
         awk '\{                   \
         split($1, hms, \".\");      \
         h = hms[1];                 \
         m = int(hms[2] / 100);      \
         s = hms[2] - 100 * m;       \
         x = h + m / 60 + s / 3600;  \
         split($2, hms, \".\");      \
         h = hms[1];                 \
         m = int(hms[2] / 100);      \
         s = hms[2] - 100 * m;       \
         y = h + m / 60 + s / 3600;  \
         print(x,y)                  \
         }' | "
         read columns x y

{
    extern "C" bool openCmd(void);
}

`postscript \string'
Write the indicated string to the PostScript output file, after
substitution of synonyms if there are any.  Example:
     \angle = "45"
     \page_width = "8.5"
     postscript gsave \page_width 72 mul 0 translate \angle rotate
     # ... other code to do stuff
     postscript grestore

   Here is how to draw an image palette vertically instead of
horizontally:
     \originX = "3"          # cm
     \originY = "10"         # cm
     \angle = "90"           # degrees counterclockwise
     postscript gsave \originX 28.35 mul \originY 28.35 mul translate \angle rotate
     draw image palette box 0 0 10 1 # this is at user's origin
     postscript grestore

   NOTE: the `postscript' command is *very* dangerous, and should
normally only be used by developers.  Most of the code concerning this
is in the file `doline.cc'; look for the string `postscriptCmd' to find
the relevant code.
{
    extern "C" bool postscriptCmd(void);
}

`pwd'
Print current directory (which can be set by `cd').
{
    extern "C" bool pwdCmd(void);
}

`query \synonym|.variable ["\prompt" [("\default"|.default)]]'
Ask the user for the value of a variable (number) or synonym (text
string).  Gri recognizes the type of the item being asked for, either a
variable or synonym, by the presence of a dot or backslash in the second
word of the command line.  If a prompt string is given (in quotes), then
this string is shown to the user.  If a default is given (in
parentheses), then it will be displayed also, and if the user types
carriage-return, then that item will be assigned to the variable or
synonym.  If the default has more than one item, then Gri considers this
a restrictive list of possibilities, and will demand that the answer be
in that list, going into an infinite query loop until an item from the
list (or carriage-return, meaning take first item) is found.  The items
in the list are to be separated by spaces, not commas or any other
non-whitespace characters.

   NOTE: The `-y' command-line option bypasses all query commands,
fooling Gri into thinking that the user typed a carriage-return to all
questions.  Thus the defaults, if they exist, are selected.
{
    extern "C" bool queryCmd(void);
}

`quit [.exit_status.]'
Exits the gri program.  If an exit status (`.exit_status.') is
specified, then Gri returns this value, rounded to the nearest integer,
as the "exit status" (a concept meaningful mostly in the unix
environment).
{
    extern "C" bool quitCmd(void);
}

`read colornames from RGB {"/usr/lib/X11/rgb.txt" | \filename}'
Read colornames from named file, which is in the X11 format.  This
format has 4 or more columns, the first three giving the red, green
and blue values in the range 0 to 255, and the last columns giving the
colorname (which may have more than one word).  You can create colors
yourself or read an X11 color file.  In many cases you will want to
`read colornames from RGB "/usr/lib/X11/rgb.txt"'.  Full filenames
must be used; the '~' syntax is not permitted.  Once you have read in
a colorname table, the named colors may be used as builtin colors (see
also `set color').  To view the colors available on your particular
system, use the Unix command `xcolors' or `excolors'; to see the RGB
values for all colors on your system, use the `showrgb' Unix command.
To view the names and RGB values of the colors Gri knows, including
builtin ones and ones from `read colornames', use `show colornames'.
{
    extern "C" bool read_colornamesCmd(void);
}

`read columns ...'
Read numbers into columns.  These columns have predefined meanings and
names.  For example, `read columns x y' instructs Gri to read data
into columns called `x' and `y'; it is these data that Gri will use if
you tell it to `draw curve'.  Other columns are: `z', used for
contouring a function `z=z(x,y)'; `weight', used for weighting data
points; `u' and `v', used for arrow (vector) plots.

If the keyword `appending' is given as the last word on the `read
    columns' line, then the new data will be appended to any existing
    columnar data; otherwise they will overwrite any existing data.
    
    * `read columns x y' Read `x' in column 1, `y' in column 2 until
    blank-line found.  Only the first tow numbers on each line will be
    read; any extra numbers (or words) on the line will be ignored.
    
    * `read columns * y * * x' Read `x' in column 5, `y' in column 2.
    The `*' character is a spacer.  It instructs Gri to skip the
    first, third, and fourth words on the data line.  These words need
    not be numbers.  This example illustrates a general mechanism of
    using the `*' character to skip over unwanted items in the data
    file.  Note that there is no need to supply `*' characters for
    trailing extraneous words; Gri will skip them anywary.  Finally,
    note that any order of `x' and `y' (and the other columns; see
    below) is allowed.
    
    * `read columns y=2 x=5' or `read columns x=5 y=2' As above; read
    `x' in column 5 and `y' in column 2.  The column number may be
    specified in this manner for all the named column variables.  No
    spaces are allowed before or after the `=' sign.  The first column
    is called column 1.  Whether this format is used or the `*' format
    is a matter of choice, except that numbered format also permits
    using a given number to fill several variables (e.g. `read columns
    x=1 y=2 u=1 v=2').
    
    * `read columns x="netCDF name" ...' If the file is a `netCDF' file,
    opened by e.g.  `open myfile.nc netCDF', then the `netCDF'
    variables for the columns, e.g.
    open latlon.nc netCDF
    read columns x="longitude" y="latitude"
    Note: the data *must* be stored as the `netCDF' "float" type.
    
    * `read columns y' Read `y' in column 1.  Since `x' is not read from
    the file, it will be assigned the default values `x' = (0,1,2,
    `..num_col_data..'); that is, it will have the same number of
    elements as `y'.
    
    * `read columns * y z * x' Read `x' in column 5, `y' in column 2,
    and `z' in column 3.  The `z' column is used for contouring.
    
    * `read columns x y u v' Read `x' and `y' in first two columns, and
    the "arrow" data `u' and `v' as third and fourth columns.
    
    * `read columns .rows. x y' Read `.rows.' rows of column data.
    
    NOTE FOR BINARY FILES: For ascii files, Gri will proceed to a new
    line after it has read the items requested; it skips any words
    appearing on the data line after the last object of interest.  Thus
    `read columns x y' will read the first two columns and ignore any other
    columns that might be present.  But for binary files, Gri has no way of
    knowing how to "skip" to the next line (see `skip' command), so you
    will have to flesh out the `read columns' command with as many spacers
    as are present in your data.  For example, if you have four numbers in
    each data record and want to interpret the first two as `x' and `y',
    you would use `read columns x y * *' to read the data.
    
    RETURN VALUE: Sets `\.return_value' 
    to `N rows N non-missing N inside-clip-region'
{
    extern "C" bool read_columnsCmd(void);
}

`read grid {x [.rows.|{="name"}]}|{y [.cols.]{="name"}}|{data {[spacers] [.rows. .cols.] [spacers] [bycolumns]}|{="name"}}'

"Read grid" commands read grid characteristics.  (The "grid" is the
object that is contoured.)

For normal ascii or binary files, the commands to read the grid's
x-locations, y-locations and data are:
`read grid x [.rows.]'
`read grid y [.rows.]'
`read grid data [spacers] [.rows. .cols.] [spacers] [bycolumns]'

For `netCDF' files, the commands are as follows (note that it is not
possible to specify the number of data to read, nor to read the grid by
columns).
`read grid x = "variable name"'
`read grid y = "variable name"'
`read grid data = "variable name"'
The data *must* be stored as the `netCDF' "float" type.  The ordering
of the y-grid data is the same as if they were read from a normal file:
the first number is considered to be at the top of the plot.

Details of the non-netCDF commands:
* `read grid x [.cols.]' Read the `x' locations of the grid points,
one number per line.  If `.cols.' is supplied, then that many
values will be read; otherwise, reading will stop at end-of-file
or blank-line.

* `read grid y [.rows.]' As above, but for y grid;  `.rows.' is the
number of rows.  The first number to be read corresponds to the
location of the *top* edge of the grid.  Thus, if you were to view
the column of numbers with a text editor, they would be oriented
the same way as the corresponding elements will appear on the page.

* `read grid data [.rows. .cols.]' Read data for a grid having
`.rows.' and `.cols.' columns.  (If `.rows.' and `.cols.' are not
supplied, but the grid already exists, then those pre-existing
values are used.  If they are specified here, then they are
checked for consistency with the pre-existing values if they
exist.) Gri will read `.rows.' lines, each containing `.cols.'
numbers.  (Extra information in the file can be skipped; see
discussion of the `*' keyword below.)  Gri will interpret the
first line it reads as the grid data corresponding to a value of y
equal to `y[.rows.]'.  Thus, file should be arranged like this:
f(x[1], y[.rows.])  f(x[2], y[.rows.]) ...  f(x[.cols.], y[.rows.])
.
.
.
f(x[1], y[3])      f(x[2], y[3])     ...     f(x[.cols], y[3])
f(x[1], y[2])      f(x[2], y[2])     ...     f(x[.cols], y[2])
f(x[1], y[1])      f(x[2], y[1])     ...     f(x[.cols], y[1])

* `read grid data [.rows. .cols.] bycolumns' As above, but the
`bycolumns' keyword tells Gri to read the data one column at a
time, instead of one row at a time.  Each line is expected to
contain `.rows.' numbers (as opposed to `.cols.' numbers, as in
the format where the `bycolumns' keyword is not present).  (Extra
information in the file can be skipped; see discussion of the `*'
keyword below).  The first line of the data file contains the
first column of the gridded data, corresponding to x equal to
`x[1]').  The file should look like this:
f(x[1], y[1])       f(x[1], y[2])    ...     f(x[1], y[.cols.])
f(x[2], y[1])       f(x[2], y[2])    ...     f(x[2], y[.cols.])
f(x[3], y[1])       f(x[3], y[2])    ...     f(x[3], y[.cols.])
.
.
.
f(x[.rows.],y[1])  f(x[.rows], y[2])  ...  f(x[.rows.], y[.cols.])

* `read grid data * * [.rows. .cols.]' As `read grid data .rows.
.cols.' except that the first two words on each line are skipped.
As usual, trailing extraneous numbers are also skipped.

The following example illustrates how to use these together.
read grid x 3      --- results in the grid locations
1
4                          1       2        3        4        5
5                        0 *-------------------------*--------*
10 |                         |        |
read grid y 3           20 *-------------------------*--------*
0                       30 |                         |        |
20                      40 *-------------------------*--------*
40

read grid data 3 3 --- fills in the grid as follows
9  1  2
3  4  5                    1       2        3        4        5
6  7  8                  0 9-------------------------1--------2
10 |                         |        |
20 3-------------------------4--------5
30 |                         |        |
40 6-------------------------7--------8

SEE ALSO:
`set x grid', `set y grid'
RETURN CODES:
`read grid x' sets `\.return_value to `N cols'
`read grid y' sets `\.return_value' to `N rows'
`read grid data' sets `\.return_value to `N rows N cols'
{
    extern "C" bool read_gridCmd(void);
}

`read image colorscale [rgb|hsb]'
Read colorscale for image, from 256 lines each containing values for
Red, Green, and Blue (or Hue, Saturation and Brightness), separated by
whitespace.  The values are expected to be in the range 0 to 1, and are
clipped to these limits if not.

For hints on how to create such an input file, see `read image
grayscale'.  If the example given there has the following code instead,
open "awk 'BEGIN \{                                  \
    for(i=0;i<256;i++) \{                               \
    print((i - 50)/50, 1, 1)                         \
    }                                                 \
    }' |"
read image colorscale hsb
then a full-color spectrum running from red at 10C to magenta at 15C is
achieved.
{
    extern "C" bool read_image_colorscaleCmd(void);
}

`read image grayscale'
Read grayscale for image for image, from 256 lines each containing a
single value.  The values are expected to be in the range 0 to 1, and
are clipped to these limits if not.  For 8-bit images, Gri multiplies
these values by 255, and uses this list for the grayscale mapping.  Such
a list is created by `write image grayscale'.

As an example, the code fragment
set image range 5 30.5
set image grayscale black 10 white 15
is equivalent to
set image range 5 30.5
open "awk 'BEGIN\{for(i=0;i<256;i++) print(1-(i-50)/50)}' |"
read image grayscale
close

because the image formula is
Temperature = 5C + 0.1C * pixelvalue

where the pixelvalue ranges from 0 to 255.  Therefore, a temperature of
10C is a pixelvalue of 50, and 15C is 100.  To get a grayscale ranging
between these values, therefore, we create a linear function which maps
the 50th pixelvalue into grayvalue 1, and the 100th pixelvalue into
grayvalue 0.  That is what the awk line does; to see the actual numbers,
you could insert the line `write image grayscale to TMP' and look at the
file `TMP' (bear in mind that Gri will clip the values to the range 0
to 1).

Sometimes you will have a file, say named `map.dat', with RGB
numbers in the range 0-255, rather than 0-1 as Gri requires.  To read
them, use the operating system to convert the numbers for you:
open "cat map.dat | awk '\{print(($1+$2+$3)/3/255)}' |"
read image grayscale
close
{
    extern "C" bool read_image_grayscaleCmd(void);
}

`read image greyscale'
Alternate spelling of grayscale
{
    extern "C" bool read_image_grayscaleCmd(void);
}

`read image mask rasterfile'
Read image mask.  The mask is associated with the image read in by
the `read image' command in the following way.  When computing image
histograms, Gri ignores any pixels in the image for which the
corresponding pixel in the mask is set to `1'.  The image size is
specified in the rasterfile file itself, so it is not specified.
{
    extern "C" bool read_image_mask_rasterfileCmd(void);
}

`read image mask .rows. .cols.'
Read image mask.  The mask is associated with the image read in by the
` read image' command in the following way.  When computing image
histograms, Gri ignores any pixels in the image for which the
corresponding pixel in the mask is set to `1'. The file must
contain `.rows.*.cols.' binary data.  Pixel order is the same as
for images.
{
    extern "C" bool read_image_maskCmd(void);
}

`read image pgm [box .xleft. .ybottom. .xright. .ytop.]'
Read image in pgm (portable graymap) format.  The image range must have
previously have been set by `set image range'.  The image width and
height are specified in the image file itself.  Both ascii and binary
PGM formats are supported (that is, files with magic characters of P2
and P5).

When the `box' option is specified, the geometry of the image, in
user coordinates, is specified in terms of the cartesian coordinates of
the lower-left corner (`.xleft.', `.ybottom.') and upper-right corner
(`.xright.', `.ytop.').  If the `box' option is not specified, this
geometry can be specified with either `read grid x' or `set x grid',
plus either `read grid y' or `set y grid'.
{
    extern "C" bool read_image_pgmCmd(void);
}

`read image rasterfile [box .xleft. .ybottom. .xright. .ytop.]'
Read image in Sun rasterfile format.  The image range must have
previously have been set by `set image range'.  The image width and
height are specified in the rasterfile file itself.

When the `box' option is specified, the geometry of the image, in
user coordinates, is specified in terms of the cartesian coordinates of
the lower-left corner (`.xleft.', `.ybottom.') and upper-right corner
(`.xright.', `.ytop.').  If the `box' option is not specified, this
geometry can be specified with either `read grid x' or `set x grid',
plus either `read grid y' or `set y grid'.
{
    extern "C" bool read_image_rasterfileCmd(void);
}

`read image .rows. .cols. [box .xleft. .ybottom. .xright. .ytop.] [bycolumns]'
With no options specified (`read image .rows. .cols.'), read binary
data defining an `image'.  The image range must have previously have
been set by `set image range'.  The data are as written as "unsigned
char" format in C.

When the `box' option is specified, the geometry of the image, in
user coordinates, is specified in terms of the cartesian coordinates of
the lower-left corner (`.xleft.', `.ybottom.') and upper-right corner
(`.xright.', `.ytop.').  If the `box' option is not specified, this
geometry can be specified with either `read x grid' or `set x grid',
plus either `read y grid' or `set y grid'.

With the `bycolumns' keyword present, the image is read sweeping
from top-to-bottom, then left-to-right, instead of the user order.
{
    extern "C" bool read_imageCmd(void);
}

`read from \filename'
Cause future `read' commands to read from the indicated file.  If that
file is not open, an error message will result.  Use `read from
\filename' to shuffle reading between several open files.
{
    extern "C" bool read_from_filenameCmd(void);
}

`read line [raw] \synonym'
Read the next line of the datafile (or commandfile) and then store the
next line of datafile into the named synonym.  Normally, comments are
removed from the line first, but if the keyword "raw" is present, then
comments are retained.
{
    extern "C" bool read_lineCmd(void);
}

`read [raw] [* [*...]] \synonym|{.variable. [.variable. ...]}'
As the same command without the "raw" keyword, except that
in this instance comments are not removed from the line before
reading.

If the optional `raw' keyword is not present, comments are first
trimmed from the data line.  If `raw' is present, however, any
comments are retained on the line.
{
    extern "C" bool read_synonym_or_variableCmd(void);
}

`read [* [*...]] \synonym|{.variable. [.variable. ...]}'
Read whitespace-separated words from datafile, assigning to any number
of synonyms or variables as indicated.  The token `*' indicates that
the word in the datafile should be skipped.  As usual, the datafile may
be embedded in the commandfile.

If the input file is in the netCDF format, the indicated item will be
    read.  For example, `read \time:_MissingValue' reads the missing value
    for the variable called `time' (you might follow this by a line like
    `.missing. = \time:_MissingValue').  Similarly, `read \location' stores
    the value of the global attribute called `location' into the variable
    named `\location'.
{
    extern "C" bool read_synonym_or_variableCmd(void);
}

`regress {y vs x [linear]}|{x vs y [linear]}'

Perform linear regression of `y' as a function of `x' or `x' as a
function of `y'.
 

   * `regress y vs x' Linear regression of y vs x. Several quantities
     are reported and also saved into builtin variables.  The intercept
     is defined as `..coeff0..', it's 95 percent confidence limit is
     defined as `..coeff0_sig..'.  Thus the confidence range is
     `..coeff0..-..coeff0_sig..' to `..coeff0..+..coeff0_sig..'.
     Similarly the slope and confidence limit are stored in
     `..coeff1..' and `..coeff1_sig..'

     The squared correlation coefficient is stored in `..R2..'.

     Historical note' prior to version 2.1.15, a different meaning was
     attached to `..coeff0_sig..' and `..coeff1_sig..'; they used 
     be defined as standard error, without having been multiplied by
     the appropriate student-t coefficient.
 
   * `regress x vs y' Linear regression of x vs y; for notation see
     above.
 
   * `regress y vs x linear' Linear regression of y vs x; for notation
     see above.
 
   * `regress x vs y linear' Linear regression of x vs y; for notation
     see above.

SEE ALSO `draw regression line'
{
    extern "C" bool regressCmd(void);
}

`reorder columns randomly|{ascending in x|y|z}|{descending in x|y|z}'
Reorder the columns in various ways.  

In the `randomly' style, the column data are shuffled randomly by
index, retaining the correspondance between a given x and y.  This is
useful with `draw symbol' using colored dots -- it prevents the
overpainting of one dot on another from biasing the color field to
values that happened to occur near the end of the column data.  If you
prefer the overpainting to be done in random order, use this command to
reorder the columns randomly.  The random number is selected using the
system `rand' call, with the seed being provided by the PID
(process ID) of the job.

The `ascending' and `descending' styles do what you'd expect.
{
    extern "C" bool reorder_columnsCmd(void);
}

`rpnfunction \name "action"'
Create a new keyword for use in RPN expressions.  Inside any RPN
expression which follows this line, the word `name' will be substituted
with the indicated replacement words.

For example, the following shows the definition and use of a
function which computes the sine of twice an angle, by multiplying
whatever is on the stack by `2', and then taking the sine of the result.

rpnfunction sin2 2 * sin
show "expect the number 1 to follow: " \{rpn 45 sin2}

NOTE: The replacement words will have any synonyms in them
translated first, unless they start with an underscore followed by a
double backslash.  Similarly, variables are substituted unless they
start with an underscore.  These exceptions are to allow the use of
the `defined' operator.
{
    extern "C" bool rpnfunctionCmd(void);
}

`rescale'
Re-determine the scales for the x and y axes.  Typically used after a
column math operation, when you want the new data to be auto-scaled.
(Note: this is not the default action after column mathematics, since
Gri lets users add offsets, etc, without altering the axes scales.)
{
    extern "C" bool rescaleCmd(void);
}

`resize x for maps'
Resize the axes frame region in such a way that geographical objects
appear in correct proportions.  This assumes that y is degrees latitude
and x is degrees latitude.

`resize x for maps'
Resize the plot width for maps, assuming that x represents
longitude and y represents latitude.  Before using this, you must
have defined scales for both x and y, and a size for y (ie, you
must have done `set x axis ...', `set y axis ...' and `set y
size'); this command sets the x size, thus eliminating `set x
size.' The result is that, at the central latitude (y), a
centimetre on the page will correspond to an equal distance on
the earth, in both the north-south and east-west directions.
{
    set x size {rpn ..ysize.. ..xright.. ..xleft.. - * \
	..ybottom.. ..ytop.. - /\
	..ybottom.. ..ytop.. +  2 / cos * abs} 
}

`resize y for maps'
Resize the axes frame region in such a way that geographical objects
appear in correct proportions.  This assumes that y is degrees latitude
and x is degrees latitude.

`resize y for maps'
Resize the plot height for maps, assuming that x represents
longitude and y represents latitude.  Before using this, you must
have defined scales for both x and y, and a size for x (ie, you
must have done `set x axis ...', `set y axis ...' and `set x
size'); this command sets the y size, thus eliminating `set y
size.' The result is that, at the central latitude (y), a
centimetre on the page will correspond to an equal distance on
the earth, in both the north-south and east-west directions.  SEE
ALSO `resize x for maps' command.
{
    set y size {rpn ..xsize.. ..ybottom.. ..ytop.. - * \
	..xright.. ..xleft.. - /\
	..ybottom.. ..ytop.. +  2 / cos / abs} 
}

`return'
Return early from a user-defined function or an `insert' file.  Or, in
the main gri program, do the same thing as `quit'.
{
    show "ERROR in `return' -- should not get here in gri.cmd"
    show traceback
    quit
}

`rewind [filename]'
Rewind a data-file to the beginning.  If no filename is given, this 
is done for the currently active file; otherwise the named
file is rewound.
{
    extern "C" bool rewindCmd(void);
}

#* @param .style. = style of axes @default 0
`set axes style .style. | {offset [.dist_cm.]} | rectangular | none | default'
Tell Gri how you want axes to look.

`set axes style 0'
Set axes to be rectangular, with an x-y axes frame labelled at
the left and bottom.

`set axes style 1'
As style `0' but only put tics on the lower and left axes.

`set axes style 2'
As style `0' but without labels or tics on any axis, i.e. just an axis frame.

Set axes to be rectangular, with an x-y frame without tics or
numbers on any side.

`set axes style offset [.dist_cm.]'
Set axes so that the actual x and y axes will be drawn with a
space separating them from the data area.  The space, if not set
by the `.distance_cm.' option, will be equal to the current tic
size (see `set tic size').  This command can be used together
with any other `set axes style' command.  It applies to both the
`draw axes' command and with any `draw x|y axis' command in which
the axis location is not explicitly given.

`set axes style rectangular'
Set axes to be rectangular, with an x-y axes frame labelled at
the left and bottom.

`set axes style none'
Tell gri not to bother drawing axes before drawing curves, etc.

`set axes style default'
Same as `set axes style 0', and with `offset' turned off.
{
    extern "C" bool set_axes_styleCmd(void);
}

#* @param .size. arrowhead half-width @unit cm @default 0.2
`set arrow size .size.|{as .num. percent of length}|default'
Set the arrowsize (which is stored in the builtin variable
`..arrowsize..').

`set arrow size .size.'
Set the arrow size (ie, half-width of the arrowhead) to `.size.'
centimetres.

`set arrow size as .num. percent of length'
Set the arrow size to be the indicated percentage of arrow
length, as in "HWP" in the singles ads.  (As a flag to this,
`..arrowsize..' is set to the negative of the fractional size
measured in percent.) 

`set arrow size default'
Set the arrow size to the default of 0.2 cm.
{
    extern "C" bool set_arrow_sizeCmd(void);
}

#* @param .type. 0 for 3-strokes, 1 for outline, 2 for filled swept-back @default 0
`set arrow type .which.'
Set type of arrow.  `.which.'=0 yields the default arrows, drawn with
three line strokes, `.which.'=1 yields outline arrows, and `.which.'=2
yields swept-back filled arrows.
{
    extern "C" bool set_arrow_typeCmd(void);
}

`set beep on|off'
The command `set beep on' makes gri beep on errors and `query'.  `set
beep off' turns this beeping off.
{
    extern "C" bool set_beepCmd(void);
}

`set bounding box .xleft. .ybottom. .xright. .ytop. [cm|pt]'
Set the PostScript bounding box for graph to indicated value.  The
bounding box is used by some programs to determine the region of the
page on which marks have been made.  For example, LaTeX uses the
bounding box to decide how to position figures in documents.

   Normally, the bounding box is computed automatically (unless the
`-no_bounding_box' commandline option has been specified.  But 
if `set bounding box' is done, the automatically computed value
is ignored and the given box is used instead.  Use this if Gri 
makes mistakes in its automatic selection of bounding box.

   The coordinates of the bounding box may be specified in (1) user
coordinates, as defined *at the moment* the command is executed, or (2)
in points on the page, measured from an origin at the lower-left (72
point per inch), or (3) in centimeters on the page.  Which coordinate
system is used depends on the last keyword - use `pt' for points, `cm'
for centimeters, and nothing at all for user-units.

   The most common use is in points, since that is how many other
application packages, e.g. LaTeX and dvips, specify the bounding box.

   If the box is specified in the user units, the user units in effect
*at the moment* of executing the `set bounding box' command are used.
This must be born in mind if the coordinate system is changing during
the execution of the program, e.g.  if margins are changing or the x
and y axes are changing.  For this reason it often makes sense to put
this command at the end of the commandfile.
{
    extern "C" bool set_bounding_boxCmd(void);
}

`set clip [postscript] {on [.xleft. .xright. .ybottom. .ytop.]}|{to curve}|off'
Control clipping of following drawing commands.

`set clip on'
Don't plot data outside axes.

`set clip on .xleft. .xright. .ybottom. .ytop.'
Don't plot data outside indicated box.

`set clip off'
Plot all data, whether in axes or not.

`set clip to curve'
Set clip to the curve, as would be drawn by a `draw curve filled'
command, i.e. to the polygon constructed by running along the xy
points, in order, followed by a final segment from the last point back
to the first point.  This is a "postscript" clip, as explained in the
next item.

`set clip postscript on .xleft. .xright. .ybottom. .ytop.'
Turn PostScript clipping on.  This will prevent *any* drawing
outside the named box.  Note that it will also prevent axis
drawing, so the recommended procedure is something like

draw axes
set clip postscript on 10 20 0 1
draw curve
set clip postscript off

`set clip postscript off'
Turn PostScript clipping off.  SEE ALSO: `set input data window'
command.
{
    extern "C" bool set_clipCmd(void);
}

`set color \name|{rgb .red. .green. .blue.}|{hsb .hue. .saturation. .brightness.}'

Set the color of the "pen" used for drawing lines and text.  Normally
lines and text are drawn in the same color, but the text color can be
specified independently if desired (see `set font color') this might
be useful to get contour lines of one color and labels of another.

In the `set colour \name' style, set the drawing color to the
indicated name, either from the builtin list (`white', `LightGray',
`darkslategray', `black', `red', `brown', `tan', `orange', `yellow',
`green', `ForestGreen', `cyan', `blue', `skyblue', `magenta'), or from
a list created by `read colornames'.  In the latter case, if the
colorname has more than one word in it, use quotes, e.g. `set color
"ghost white"'.

In the `set colour rgb ...' style, set the individual color
components as indicated.  The numbers `.red.', `.green.' and `.blue.'
range from 0 (for no contribution of that color component to the final
color) to 1 (for maximal contribution).  Values less than 0 are
clipped to 0; values greater than 1 are clipped to 1.  EXAMPLES:
set color rgb 0   0   0		# black
set color rgb 1   1   1		# white
set color rgb 1   0   0		# bright red
set color rgb 0.5 0   0		# dark red (only 50 percent)
set color rgb 0   1   0		# pure green
set color rgb 1   1   0		# yellow: red + green

In the `set colour hsb ...' style, set the individual color
components as indicated.  The numbers `.hue.', `.saturation.' and
`.brightness.' range from 0 to 1.  The color, represented by .hue.,
ranges from 0 for pure red, through 1/3 for pure green, and 2/3 for
pure blue, and back to 1 again for pure red. The purity of the color,
represented by .saturation., ranges from 0 (none of the hue is
visible) to 1 (the maximal amount is present).  The brightness of the
color, represented by `.brightness.', ranges from 0 (black) to 1
(maximal brigntness).  Values less than 0 are clipped to 0; values
greater than 1 are clipped to 1.  EXAMPLES:

set color hsb 0    1   1	# pure, bright red
set color hsb 0    1 0.5	# half black, half red
set color hsb .333 1   1	# pure, bright green
{
    extern "C" bool set_colorCmd(void);
}

`set colour \name|{rgb .red. .green. .blue.}|{hsb .hue. .saturation. .brightness.}'
Alternate spelling of 'color'.
{
    extern "C" bool set_colorCmd(void);
}

`set colorname \\name {rgb .red. .green. .blue.}|{hsb .hue. .saturation. .brightness.}'
Create a colorname with the indicated color.  The color components
range from 0 to 1, and will be clipped to these values if they are
outside this range.  EXAMPLE (borrowing a color from /usr/lib/X11/rgb.txt):

  set colorname peachpuff rgb 1 \{rpn 218 255 /} \{rpn 185 255 /}
  draw box filled 2 2 3 3 cm
{
    extern "C" bool set_colornameCmd(void);
}


#* @param \style for contour format @default %g
`set contour format \style|default'
Normally, Gri draws the numeric labels of contour using a format code
called `%g' in the "C" language.  You may specify any other "long"
format using this command.  For example, `set contour format %.1f'
tells Gri to use one decimal place in the numbers, and also to prefer
the "float" notation to the exponential notation.  `set contour format
default' resets to the default `%f' format.  You may use quotes around
the format if you need to, to make the item be a single word
(e.g. `set contour format "%.1f m/s"').
{
    extern "C" bool set_contour_formatCmd(void);
}

`set contour label for lines exceeding .x. cm'
Make it so contour lines shorter than `.x.' centimeters will not be
labelled.
{
    extern "C" bool set_contour_labelCmd(void);    
}

`set contour label position {.start_cm. .between_cm.}|centered|default'
By default, contour labels are drawn at the location where contours
start (e.g., the boundary), and then at a uniform distance along the
contour.  By default, this uniform distance is the average dimension of
the plotting area inside the axes.  If `.start_cm.' and `.between_cm.'
are specified, the first label is drawn at a distance `.start_cm.'
from the start of the contour, and thereafter at a separation of
`.between_cm.'.

If the `centered' option is used, then the contour labels are
centered along the length of the line.
{
    extern "C" bool set_contour_labelCmd(void);
}

`set contour labels rotated|horizontal|whiteunder|nowhiteunder'
The first two options control whether contour labels are rotated to line
up with the contour lines, or whether they are horizontal (the default).

The second two options control whether the region under contour
labels is whited out before drawing the label.  The default is
`whiteunder', which has the visual effect of the label having been
drawn on a piece of paper and then pasted on.  This can look jarring
when the material under the contour is an image.  When `nowhiteunder'
is specified, the contour line is broken to make space for the text,
but no whiting out is done.
{
    extern "C" bool set_contour_labelsCmd(void);
}

#* @param .type. style of dash to use (range 0 to 15) @default 2 -> 0.4 cm dashes and 0.1 cm blanks
`set dash [.type.|{.dash_cm. .blank_cm. ...}|off]'
Control dash-style for following `draw curve' and `draw line' commands.

* `set dash' Set to dashed line (0.4cm dashes, 0.1cm blanks).

* `set dash .type.' Set to indicated pre-defined dashed line, according
to table:
.n. dash/cm blank/cm
0        -        -   ... (Solid line)
1      0.2      0.1
2      0.4      0.1
3      0.6      0.1
4      0.8      0.1
5      1.0      0.1
10      w        w
11      w        2w
12      w        3w
13      w        4w
14      w        5w
15      w        6w
Where `w' is written, it indicates the current linewidth.  Thus,
types 10 through 15 give square-dotted lines.

* `set dash .dash_cm. .blank_cm. .dash_cm. .blank_cm. ...' Set to
indicated dashed line.  The series of lengths `.dash_cm.' and
`.blank_cm.' give the lengths of dash and blank portions (measured
in centimeters).  Any number of dash/blank lengths may be given.
For example, `set dash 0.5 0.1 0.1 0.1' looks good.

* `set dash off' Turn dashing off, setting to a solid line.
{
    extern "C" bool set_dashCmd(void);
}

`set environment'
Set environment (graylevel, axis length, etc) so that following
plotting commands will make use of anything set by either a `set'
command or by direct manipulation of builtin variables like
`..xsize..', etc.  NOTE: this should *only* be done by developers.
{
    extern "C" bool set_environmentCmd(void);
}

`set error action to core dump'
Make Gri dump core when any error is found, to facilitate debugging.
{
    extern "C" bool set_error_actionCmd(void);
}

`set flag \name [off]'
Set the indicated flag to YES.  The name of the flag is contained in a
single word, e.g. `set flag dan_28sep_test'.  The action of the flags
may change with time and is undocumented.  This command is provided to
enable selected users (e.g., the developer himself) to use test
features of Gri before they are frozen into a fixed syntax and action.
The keyword `off' turns the indicated flag off.  NOTE: this should
*only* be done by developers.

FLAG            DATE   ACTION
jinyu1       29sep94  'convert columns to grid' outputs (x,y,z,z_predicted)
emulate_gre   9jun97  'E' format on axes yields scientific notation
kelley1      17jun97  for kelley only - quit contour trace if hit nonlegit
kelley2      17jun97  for kelley only - print out tons of info as trace contour
{
    extern "C" bool set_flagCmd(void);
}

`set font color \name|{rgb .red. .green. .blue.}|{hsb .hue. .saturation. .brightness.}'
The syntax is the same as `set color', except that this applies to
text only.  By default, text is drawn in the same color as lines, so
text color is changed as line color is changed (e.g. by using the `set
color' or `set graylevel' commands)).  However, once `set font color'
is used in a Gri program, the font thereafter maintains a separate
color from the lines.
{
    extern "C" bool set_font_colorCmd(void);
}

`set font colour \name|{rgb .red. .green. .blue.}|{hsb .hue. .saturation. .brightness.}'
Alternate spelling of 'color'.
{
    extern "C" bool set_font_colorCmd(void);
}

`set font encoding PostscriptStandard | isolatin1'
Permits one to control the so-called ``font encoding'' used in text.
The default font encoding is ISO-Latin-1, which is best for English and
other European languages.

If the so-called `Postscript Standard'' font encoding is required, this command
permits changing the encoding.

Note: few users will ever need this command.  If you don't even know
what ``font encoding'' is about, ignore this command!
{
    extern "C" bool set_font_encodingCmd(void);
}

#* @param .size. of font @unit point @default 12 @variable ..fontsize..
`set font size {.size. [cm]}|default'
Set the size of the font for drawing of text.

`set font size .size.'
Set font size to `.size.' points.  (A point is 1/72 of an inch, or
1/28 of a centimetre.)

`set font size .size. cm'
Set font size to `.size.' centimetres.

`set font size default'
Set font size to default = 12 pts.
{
    extern "C" bool set_font_sizeCmd(void);
}

#* @param \fontname of font @default Helvetica
`set font to \fontname'
Set font to named style.  Note that the backslash is *not* to be
written, but here merely means that this word has several alternatives.
For example, one might say `set font to Courier'.  The allowed
fontnames are: `Courier', a typewriter font; `Helvetica', a sans-serif
font commonly used in drafting scientific graphs; `HelveticaBold', a
bold version of Helvetica; `Times' (also called `TimesRoman'), a font
used in most newspapers; `Palatino' (also called `PalatinoRoman'),
similar to Times, but somewhat more elegant; `ZapfChancery', a font
akin to the TeX caligraphic font; `Symbol', included for completeness,
is a mathematical font in which "a" becomes $\alpha$ of the math mode,
etc.  For reference on these fonts see any book on PostScript.  The
default font is `Helvetica'.
{
    extern "C" bool set_font_toCmd(void);
}

#* @param .brightness. of ink with 0 for black and 1 for white @default 0=black
`set graylevel .brightness.|white|black'
Set graylevel for lines to indicated numerical value between 0=black and
1=white, or to the named color.

Note: if your diagram is to be reproduced by a journal, it is
unlikely that the reproduction will be able to distinguish between any
two graylevels which differ by less than 0.2.  Also, graylevels less
than 0.2 may appear as pure black, while those of 0.8 or more may
appear as pure white.  These guidelines are as specified by American
Geophysical Union (publishers of J. Geophysical Res.), as of 1997.
{
    extern "C" bool set_graylevelCmd(void);
}

`set greylevel .brightness.|white|black'
Alternate spelling of graylevel.
{
    extern "C" bool set_graylevelCmd(void);
}

`set grid missing {above|below .intercept. .slope.}|{inside curve}'

The style
`set grid missing above|below .intercept. .slope'
sets grid to missing value for all points above/below the line defined
by
y = .intercept. + .slope. * x
The style
`set grid missing inside curve'
sets the grid to the missing value throughout an area described by the
curve last read in with `read columns'.  This is useful for e.g.
excluding land areas while contouring ocean properties.  The curve may
contain several "islands," each tracing (clockwise) a region inside of
which the grid is to considered missing.  If the first point in an
island doesn't match the last, then an imaginary line is assumed which
connects them.  Multiple islands may be separated by missing-value
codes.
{
    extern "C" bool set_grid_missingCmd(void);	
}

`set ignore initial newline [off]'
Make Gri ignore a newline if it occurs as the first character of the
next data file.  This is used for files made by FORTRAN programs on
VAX/VMS computers.
{
    extern "C" bool set_ignore_initial_newlineCmd(void);
}

`set ignore error eof'
Stop Gri from considering that to encounter an end of file in future
`read' commands consitutes an error; Gri will simply warn about future
EOFs.
{
    extern "C" bool set_ignoreCmd(void);
}

`set image colorscale ...'
set image colorscale hsb .h. .s. .b. .im_value. hsb .h. .s. .b. .im_value. [increment .im_value.]

set image colorscale rgb .r. .g. .b. .im_value. rgb .r. .g. .b. .im_value. [increment .im_value.]

set image colorscale \name .im_value. \name .im_value. [increment .im_value.]

Set colorscale mapping for image, using HSB (hue, saturation,
brightness) specification, RGB (red, green, blue) color specification,
or named colors.  The image range must have previously have been set by
`set image range', so that the `.im_value.' values will have meaning. 
Two pairs of (color, image-value) are given, and possibly an increment.
Normally the colors are smoothly blended between the endpoints, but if
an increment is supplied, the colors are quantized. The HSB method
allows creation of spectral palettes, while the other two methods
create simple blending between the two endpoints.

EG: To get a spectrum ranging between pure red (H=0) for image value
of -10.0, and pure blue (H=2/3) for image value of 10.0, do this:
set image colorscale hsb 0 1 1 -10.0 hsb .66666 1 1 10.0

EG: To get a scale running from pure red (at image-value 10.0) into
pure blue (at image-value 25.1), but with the colors blending
intuitively in between (i.e., blending as paint might), use `rgb' color
specification, as follows:
set image colorscale rgb 1 0 0 10.0 rgb     0 0 1 25.1

EG: To get a quantized blend between the X11 colors `skyblue' at
image value of 0 and `tan' at image value of 20, and with steps at
image values incrementing by 5, do this:
set image colorscale skyblue 0 tan 20 increment 5
Note that the traversal is through RGB space, so it is intuitive,
not spectral.  See `set color' for a list of X11 colors known to Gri.
{
    extern "C" bool set_image_colorscaleCmd(void);
}

`set image colourscale ...'
Alternate spelling of colorscale.
{
    extern "C" bool set_image_colorscaleCmd(void);
}

`set image grayscale using histogram [black .bl. white .wh.]'
Create a grayscale mapping using linearized cumulative histogram
enhancement.  The image range must have previously have been set by
`set image range'.

This creates maximal contrast in each range of graylevels, and is
useful for tracing subtle features between different images (for
example, it makes it easier to trace fronts between successive satellite
images).  The entire histogram is expanded, from the smallest value in
the image to the largest.

With no options specified, the histogram is done from 0 in the image
to 255 in the image.  If the black/white options are specified, the
histogram is done between these values.
{
    extern "C" bool set_image_grayscale_using_histogram(void);
}

`set image greyscale using histogram [black .bl. white .wh.]'
Alternate spelling of grayscale
{
    extern "C" bool set_image_grayscale_using_histogramCmd(void);
}

`set image grayscale [black .bl. white .wh. [increment .inc.]]'
With no optional parameters, create a grayscale mapping for the current
image, scaling it from black for the mininum value in the image to white
for the maximum value.  The image range must have previously have been
set by `set image range'.

The optional parameters `.wh.' and `.bl.' specify the values to be
drawn in white and black in the image, with smooth linear blending in
between.

Normally the blending from white to black is smooth (linear), but if
the additional optional parameter `.inc.' is specified, the blending is
quantized, jumping to darker values at (`.wh.' + `.inc.'), (`.wh.' + 2*
`.inc.'), etc.  (The sign of `.inc.' will be altered, if necessary, to
ensure that (`.wh.' + `.inc.') is between `.wh.' and `.inc.'.)  The
colour switches to pure white at the value `.wh.', and remains pure
white everywhere on the "white" side of this value.  Similarly, the
transition to pure black occurs at the value `.bl.'.  In other words,
neither pure white nor pure black is present inside the interval from
`.wh.' to `.bl.'.  Therefore, when drawing grayscales with the `draw
image palette' command, you might want to extend the range by one
increment so as to get an example of both pure white and pure black.
.w. = 0
.b. = 1
.i. = 0.2
set image grayscale white .w. black .b. increment .i.
draw image palette left \{rpn .w. .i. -} right \{rpn .b. .i. +} increment .i.
{
    extern "C" bool set_image_grayscaleCmd(void);
}

`set image greyscale [black .bl. white .wh. [increment .inc.]]'
Alternate spelling of grayscale.
{
    extern "C" bool set_image_grayscaleCmd(void);
}

`set image missing value color to white|black|{graylevel .brightness.}{rgb .red. .green. .blue.}'
Set the color of "missing" pixels (white by default).  The image range
must have previously have been set by `set image range'.  Pixels with
missing values can result from creating images from grids which have
missing values; see the `convert grid to image' command.  The
`.brightness.' parameter in the `graylevel' style ranges from 0 for
black to 1 for white.  The `rgb' parameter allows specification in colour.
{
    extern "C" bool set_image_missingCmd(void);
}

`set image missing value colour to white|black|{graylevel .brightness.}'
Alternate spelling of color.
{
    extern "C" bool set_image_missingCmd(void);
}

`set image range .min_value. .max_value.'
Specify maximum possible range of values that images can hold, in
user units.  Gri needs to know this because it stores images in a
limited format capable of holding only 256 distinct values.  Unlike
some other programs, Gri encourages (forces) the user to specify things
in terms of user-units, not image-units.  This has the advantage of
working regardless of the number of bits per pixel.  Thus, for example,
`set image grayscale', `set image colorscale', `draw image grayscale',
etc, all use *user* units.

When an image is created by `convert grid to image', values outside
the range spanned by `.0value.' and `.255value.' are clipped.  (There
is no need, however, for `.0value.' to be less than `.255value.'.)
This clipping discards information, so make sure the range you give is
larger than the range of data in the grid.

EXAMPLE: consider a satellite image in which an internal value of 0
is meant to correspond to 0 degrees Celsius, and an internal value of
255 corresponds to 25.5 degrees.  (This is a common scale.)  Then Gri
command `set image range 0 25.5' would establish the required range.
If this range were combined with a linear grayscale mapping (see `set
    image grayscale'), the resultant granularity in the internal
    representation of the user values would be (25.5-0)/255 or 0.1 degrees
    Celsius; temperature variations from pixel to pixel which were less than
    0.1 degrees would be lost.
    
    All other image commands *require* that the range has been set.
    Thus, all these commands fail unless `set image range' has been done:
    `draw image', `draw image palette', `read image', `convert grid to
    image', `set image grayscale', and `set image colorscale'.
    
    NOTE: If a range already exists when `set image range' is used, then
    the settings are altered.  Thoughtless usage can therefore lead to
    confusing results.  (The situation is like setting an axis scale,
    plotting a curve with no axes, then altering the scale and plotting the
    new axes.  It's legal but not necessarily smart.)
{
    extern "C" bool set_image_rangeCmd(void);
}

`set input data window x|y {.min. .max.}|off'
Create a data window for following `read' statements.

`set input data window x .min. .max.'
For future reading commands, ignore all data with x < `.min.' or 
x > `.max.' The data not in the interval will not be read in at all. 
This will hold until `set data window x off' is done, in which
case all data will be read in.

`set input data window x off'
Return to normal conditions, in which all data are read in.

`set input data window y .min. .max.'
Analogous to command for x.

`set input data window y off'
Analagous to command for x.

EXAMPLE: To set the input data window as the current x axis plus a
border of 5 centimetres to left and right, do the following:

set input data window x \{rpn ..xleft..  xusertocm 5 - xcmtouser} \
    \{rpn ..xright.. xusertocm 5 + xcmtouser}

SEE ALSO `set clip' command.
{
    extern "C" bool set_input_data_windowCmd(void);
}

`set input data separator TAB|default'

Set the separator between data items.  The `default' method is to
assume that data items are separated by one or more spaces or tabs,
and also to ignore any spaces or tabs at the start of a data line.

In the TAB method the data are assumed to be separated by a SINGLE tab
character.  (Multiple tabs will result in null values being assigned
to items -- almost certainly not what you want!)  Also, initial spaces
and tabs on lines are NOT skipped.

Use the TAB method only after thinking carefully about the above,
since the assignment of null values is problematic.
{
    extern "C" bool set_input_data_separatorCmd(void);
}

`set line cap .type.'
Set the type of ends (caps) of lines.  Use `.type.' of value 0 for
square ends, cut off precisely at the end of line, or 1 for round ends
which overhang half the line width, or 2 for square ends which overhang
half the line width.  The selected style is used for the ends of line
segments, as well as at corners.  In PostScript parlance, therefore,
this command sets both the linecap and the linejoin parameters.

This command only applies to lines drawn with `draw curve', `draw
line' and `draw polygon'.  Axes are always drawn with a line cap of 0.
{
    extern "C" bool set_line_capCmd(void);
}

`set line join .type.'

Set the type of intersection of lines.  Use `.type.' of value 0 for
mitered joins (pointy ends that may extend beyond the data points), a
value of 1 for rounded ends (the default), or a value of 2 for
bevelled (squared-off) ends.  See the `setlinejoin' command in any
text on the PostScript language for more information.

This command only applies to lines drawn with `draw curve', `draw
line' and `draw polygon'.  Axes are always drawn with a line join of 0.
{
    extern "C" bool set_line_joinCmd(void);
}

#* @param .width_pt. @unit point @default 0.709 @variable ..linewidth..
`set line width [axis|symbol|all] .width_pt.|{rapidograph \name}|default'

Set the width of lines used to draw curves (default), axes, symbols, or
all of the above.  The width may be set to a value specified in points
(conversion: 72 pt = 1 inch), to a named rapidograph width, or to the
default value.  The initial default values are: 0.709pt (or rapidograph
3x0) for curves; 0.369pt (or rapidograph 6x0) for axes; 0.369pt (or
rapidograph 6x0) for symbols.

   The rapidograph settings match the standard set of widths used in
technical fountain pens.  The table below gives width names along with
the width in points and centimetres, as given in the specifications
supplied with Rapidograph technical fountain pens.  Names marked by the
symbol `*' are in sequence increasing by the factor root(2).  Texts on
technical drawing often suggest using linewidths in the ratio of 2 or
root(2).  On many printers, the variation in width from root(2) increase
is too subtle to see, so the factor-of-2 rule may be preferable.  To get
sizes in a sequence doubling in width, pick from the list (`6x0',
`3x0', `1', `3.5' `7').  To get a sequence increasing in width by
root(2), pick from the list (`6x0', `4x0', `3x0', `0', `1', `2.5',
`3.5', `6', `7').  The eye can distinguish curves with linewidths
differing by a factor of root(2) if the image is of high quality, but a
factor of 2 is usually better.  Similarly, for overhead projections and
projected slides, one would do well to use linewidths differing by a
factor of 4.

   This is the list of `rapidograph' linewidths:

      Name      pt    cm
      ====    =====  =====
    *  6x0    0.369  0.013
    *  4x0    0.510  0.018
    *  3x0    0.709  0.025
        00    0.850  0.03
    *    0    0.992  0.035
    *    1    1.417  0.05
         2    1.701  0.06
    *    2.5  1.984  0.07
         3    2.268  0.08
    *    3.5  2.835  0.1
         4    3.402  0.12
    *    6    3.969  0.14
    *    7    5.669  0.2
{
    extern "C" bool set_line_widthCmd(void);
}

#* @param .value. to be considered missing @default 1.0e22 @variable ..missingvalue..
`set missing value .value.'
Set missing-value code (stored in the builtin variable
`..missingvalue..' and builtin synonym `\.missingvalue..') to
`.value.', which mean that data within 0.1 percent of this value are
ignored.  The initial default is 1.0e22.
{
    extern "C" bool set_missing_valueCmd(void);
}

`set postscript filename "\string"'
Set name of PostScript file, over-riding the present name.
{
    extern "C" bool set_postscript_filenameCmd(void);
}

`set page size letter|legal|folio|tabloid|A0|A1|A2|A3|A4|A5'
Prevent bounding box from extending outside the indicated page domain.
{
    extern "C" bool set_page_sizeCmd(void);
}

`set page portrait|landscape|{factor .mag.}|{translate .xcm. .ycm.}'
Control orientation or scaling of what is drawn on the paper.

* `set page portrait' Print graph normally (default).

* `set page landscape' Print graph sideways.

* `set page factor .mag.' Scale everything to be drawn on the paper
by the indicated magnification factor.  This *must* be called
before any drawing commands.

* `set page translate .xcm. .ycm.' Translate everything to be drawn
on the paper by the indicated x/y distances.  This *must* be
called before any drawing commands.

*Note*: The order of the factor/translate commands matters, so you
may need to experiment.  For example,
    set page translate 2 1
    set page factor 0.5
moves anything that would have been drawn at the lower-left corner of
the paper onto the point 2cm from the left side and 1cm from the bottom
side of the paper, and then applies the multiplication factor.
Reversing the order gives quite different results.  PostScript gurus
should note that the following two commands are inserted into the
PostScript file:
    56.900000 28.450000 translate
    0.500000 0.500000 scale
{
    extern "C" bool set_pageCmd(void);
}

`set panel .row. .col.'
Establish geometry for the panel in the indicated row and column.  The
bottom row has .row. = 1, and the leftmost column has .col. = 1.  This
must be used only after using `set panels .row. .col. .dx_cm. .dy_cm.'
{
    if {rpn \.words. 4 !=}
	show "ERROR: `\.proper_usage.' needs 3 words"
	quit 1
    end if
    new .row. .col.
    .row. = \.word2.
    .col. = \.word3.
    set x margin {rpn .col. 1 - .panel_xsize. .panel_dx. + * .panel_xmargin. +}
    set y margin {rpn .row. 1 - .panel_ysize. .panel_dy. + * .panel_ymargin. +}
    set x size .panel_xsize.
    set y size .panel_ysize.
    delete .row. .col.
}

`set panels .rows. .cols. [.dx_cm. .dy_cm.]'
Set up for multipanel plots, with spacing .dx_cm. between the columns
and .dy_cm. between the rows.  If the spacings are not supplied, 2cm
is used.  The panels fill the rectangle which would otherwise contain
the single axis frame, as set by `set x size' and `set x margin', etc.

The global variables .panel_dx., .panel_dy., .panel_xmargin.,
.panel_ymargin., .panel_xsize., and .panel_ysize are created, to be used
by later calls to `set panel'.

EXAMPLE 
# Draw 2 panels across, 3 up the page.

# The Panel interiors will be in region cornered
# by (2,2), (12,22) cm
set x margin 2
set y margin 2
set x size 10
set y size 20
set panels 2 3

# Create dummy scale
set x axis 0 1
set y axis 0 1

# Draw blank axes
set panel 1 1
draw axes
set panel 1 2
draw axes
set panel 1 3
draw axes
set panel 2 1
draw axes
set panel 2 2
draw axes
set panel 2 3
draw axes

SEE ALSO `set panel .row. .col.'
{
    # creates globals 
    #  .panel_dx.      .panel_dy.
    #  .panel_xmargin. .panel_ymargin.
    #  .panel_xsize.   .panel_ysize.
    if {rpn \.words. 4 ==}
	.panel_dx. = 2
	.panel_dy. = 2
    else if {rpn \.words. 6 ==}
	.panel_dx. = \.word4.
	.panel_dy. = \.word5.
    else
	show "ERROR: `\.proper_usage.' needs 5 words"
	quit 1
    end if
    new .rows. .cols.		# local storage
    .rows. = \.word2.
    .cols. = \.word3.
    if {rpn .panel_dx. 0 >}
	show "ERROR: `\.proper_usage.' needs .dx. to be non-negative"
	quit 1
    end if
    if {rpn .panel_dy. 0 >}
	show "ERROR: `\.proper_usage.' needs .dy. to be non-negative"
	quit 1
    end if
    .panel_xmargin. = ..xmargin..
    .panel_ymargin. = ..ymargin..
    .panel_xsize.   = {rpn ..xsize.. .panel_dx. .cols. 1 - * - .cols. /}
    .panel_ysize.   = {rpn ..ysize.. .panel_dy. .rows. 1 - * - .rows. /}
    delete .rows. .cols.
}

#* @param \path for data or command files @default "."
`set path to "\path"|default for data|commands'
Set directory path for finding data files or command files.
The default is ".", the current directory.
{
    extern "C" bool set_pathCmd(void);
}

#* @param .diameter_cm. diameter size of symbols @unit cm @default 0.1
`set symbol size .diameter_cm.|default'
Control the size (diameter) of symbols drawn by `draw symbol' command.

`set symbol size .diameter_cm.'
Make symbol size (diameter) be `.diameter_cm.' centimeters.

`set symbol size default'
Set to default diameter of 0.1 cm.
{
    extern "C" bool set_symbol_sizeCmd(void);
}

#* @param $.size. of axes tics @unit cm @default 0.2
`set tic size .size.|default'
Control size of tics on axes.

`set tic size .size.'
Set tic size to `.size.' centimetres.

`set tic size default'
Set tic size to default of 0.2 cm
{
    extern "C" bool set_tic_sizeCmd(void);
}

`set tics in|out'
Make axis tics point inward or outward.  The default is outward.
{
    extern "C" bool set_ticsCmd(void);
}

`set trace [on|off]'
Control printing of command lines as they are processed.

`set trace'
Make Gri print command lines as they are processed.

`set trace on'
Same as `set trace'.

`set trace off'
Prevent printing command lines (default).
{
    extern "C" bool set_traceCmd(void);
}

`set transparency .transparency.'
Set the transparency of drawn items, 0 for opaque and 1 for invisibly faint.
{
    extern "C" bool set_transparencyCmd(void);
}

`set u scale .cm_per_unit.|{as x}'
Set scale for x-component of arrows.

`set u scale .cm_per_unit.'
Set scale for `u' component of arrows.

`set u scale as x'
Set scale for u component of arrows to be the same as the x-scale. 
Equivalent to `set u scale as \{rpn ..xsize.. ..xright.. ..xleft.. 
- /}'.

NOTE: this only works if the x-scale is LINEAR (see `set x type').
{
    extern "C" bool set_u_scaleCmd(void);
}

`set v scale .cm_per_unit.|{as y}'
Set scale for y-component of arrows.

`set v scale .cm_per_unit.'
Set scale for `v' component of arrows.

`set v scale as y'
Set scale for v component of arrows to be the same as the y-scale. 
Equivalent to `set v scale as \{rpn ..ysize.. ..ytop.. ..ybottom.. 
- /}'.

NOTE: this only works if the y-scale is LINEAR (see `set y type').
{
    extern "C" bool set_v_scaleCmd(void);
}

`set x axis top|bottom|increasing|decreasing|{.left. .right. [.incBig. [.incSml.]]}|{labels [add] .pos. "label" [...]}|{labels automatic}||unknown'
Control various things about the x axis.

`set x axis top'
Make next x-axis to be drawn have labels above the axis.

`set x axis bottom'
Make next x-axis to be drawn have labels below the axis.

`set x axis increasing'
Make next x-axis to be drawn have numeric labels increasing to the
right.  This applies only if autoscaling is done; otherwise, the
supplied values (`.left. .right. [.incBig.  [.incSml.]]') are
used.

`set x axis decreasing'
ke next x-axis to be drawn have numeric labels decreasing to the
right.  This applies only if autoscaling is done; otherwise, the
supplied values (`.left. .right. [.incBig.  [.incSml.]]') are
used.

`set x axis unknown'
Make Gri forget any existing scale for the x axis, whether set by
another `set x axis' command or automatically, during reading of data.
This is essentially a synonym for `delete x scale'.

`set x axis .left. .right.'
Make x-axis range from `.left.' to `.right.'

`set x axis .left. .right. .incBig.'
Make x-axis range from `.left.' to `.right.', with labelled
increments at `.incBig.' Note: In the case of log axes, and
provided that `set x type log' has been called previously, the
`.incBig.' parameter has a different meaning: it is the interval,
in decades, between numbered labels; the default is 1.

`set x axis .left .right. .incBig. .incSml.'
Make x-axis range from `.left.' to `.right.', with labelled increments
at `.incBig.', and small tics at `.incSml.'  NOTE: if the axis is
logarithmic, the value of `.incSml.' takes on a special meaning: if it
is positive then small tics are put at values 2, 3, 4, etc. between
the decades, but if `.incSml.' is negative then no such small tics are
used. 

`set x axis labels [add] .position. "label" [.position. "label" [...]]'
Override the automatic labelling at axis tics, and instead put the
indicated labels at the indicated x values.  For example, a
day-of-week axis can be created by the code:
    set x axis 0 7 1
    set x axis labels 0.5 "Mon" 1.5 "Tue" 2.5 "Wed" \
		      3.5 "Thu" 4.5 "Fri" 5.5 "Sat" \
		      6.5 "Sun"
The command replaces any existing labels, unless the `add' keyword is
present, in which case the new label information is appended to any
existing information.

`set x axis labels automatic'
Return to automatically-generated axis labels, undoing the command of
the previous item.
{
    extern "C" bool set_x_axisCmd(void);
}

#* @param \format for axis numbers in C notation @default %g
`set x format \format|default|off'
Set format for numbers on x axis.  The format is specified in the manner
of the "C" programming language.  The "C" formats (i.e., `%f',
`%e' and `%g') are permitted.  For example, `set x format %.1f'
tells Gri to use 1 decimal place, and to prefer the "float" notation to
the exponential notation.  The form `set x format off' tells Gri not to
write numbers on the axis.  To get spaces in your format, enclose the
format string in double-quotes, e.g., you might use `set x format
"%.0f$\circ$ W"' for a map, or `set x format "%f "' to make the
numbers appear to the left of their normal location.

The default format is `%lg'.
{
    extern "C" bool set_x_formatCmd(void);
}

`set x grid .left. .right. .inc.|{/.cols.}'
Create x-grid for contour or image.

`set x grid .left. .right. .inc.'
Create x-grid ranging from the value `.left.' at the left to
`.right.' at the right, stepping by an increment of `.inc.'.

`set x grid .left. .right. /.cols.'
Create x-grid with `.cols.' points, ranging from the value `.left.'
at the left to `.right.' at the right.
{
    extern "C" bool set_x_gridCmd(void);
}

#* @param .size. of x margin @unit cm @default 6 @variable ..xmargin..
`set x margin {[bigger|smaller] .size.} | default'
Control x margin, that is, the space between the left-hand side of the
page and the left-hand side of the plotting area.  (Note that axis
labels are drawn inside the margin; the margin extends to the axis
line, not to the labels.)

`set x margin .size.'
Set left margin to `.size.' cm.  It is permissible to have
negative margins, with the expected effect. 

`set x margin bigger .size.'
Increases left margin by `.size.' cm.

`set x margin smaller .size.'
Decreases left margin by `.size.' cm.

`set x margin default'
Set left margin to default = 6 cm.
{
    extern "C" bool set_x_marginCmd(void);
}

#* @param \name of x axis @default ""
`set x name "\name"|default'
Set name of x-axis to the indicated string.  An empty string
(`set x name ""') causes the x axis to be unlabelled.  
The `default' is `"x"'.
{
    extern "C" bool set_x_nameCmd(void);
}

#* @param .width_cm. of axis @unit cm @default 10 @variable ..xsize..
`set x size .width_cm.|default'
Set the width of the plotting area.  This does not include axis labels,
only the interior part of the plot.

`set x size .width_cm.'
Set width of x-axis in centimeters.

`set x size default'
Set width of x-axis to default = 10 cm.
{
    extern "C" bool set_x_sizeCmd(void);
}

`set x type linear|log|{map E|W|N|S}'
Control transformation function mapping user units to centimetres on the
page.

* `set x type linear' Set to linear axis.

* `set x type log' Set to log axis.  To avoid clashes in the linear
to log transform, this command should precede the creation of an
axis scale, either explicitly through the `set x axis .left.
.right. ...' command or implicitly through the `read columns'
command.

* `set x type map E|W|N|S' Set to be a map.  This means that whole
numbers on the axis will have a degree sign written after them
(and then the letter `E', etc) and that numbers which are
multiples of 1/60 will be written in degree-minute format, and
that similarly numbers which are divisible by 1/3600 will be in
degree-minute-second format.  If none of these things apply, the
axis labels will be written in decimal degrees.  Note that this
command overrides any format set by `set x format'.

BUG: this only has an effect if the axis is not already of type
`log'.

SEE ALSO: `set map projection', to set to non-rectangular axes for
various map projections.
{
    extern "C" bool set_x_typeCmd(void);
}

`set y axis left|right|increasing|decreasing|{.bottom. .top. [.incBig. [.incSml.]]}|{labels [add] .pos. "label" [...]}|{labels automatic}|{name vertical|horizontal}|unknown'
Control various things about the y axis.
`set y axis left'
Make next y-axis to be drawn have labels to the left of the axis.

`set y axis right'
Make next y-axis to be drawn have labels to the right of the axis.

`set y axis increasing'
Make next y-axis to be drawn have numeric labels increasing up
the page.  This applies only if autoscaling is done; otherwise,
the supplied values (`.left. .right. [.incBig.  [.incSml.]]') are
used.

`set y axis decreasing'
Make next y-axis to be drawn have numeric labels decreasing up
the page.  This applies only if autoscaling is done; otherwise,
the supplied values (`.left. .right. [.incBig.  [.incSml.]]') are
used.

`set y axis unknown' Make Gri forget any existing scale for the y
axis, whether set by another `set y axis' command or
automatically, during reading of data.  This is essentially a
synonym for `delete y scale'.

`set y axis .bottom. .top.'
Make y-axis range from `.bottom.' to `.top.'

`set y axis .bottom. .top. .incBig.'
Make y-axis range from `.bottom.' to `.top.', with labelled
increments at `.incBig.'

`set y axis .bottom. .top. .incBig. .incSml.'
Make y-axis range from `.bottom.' to `.top.', with labelled
increments at `.incBig.', and small tics at `.incSml.'  NOTE: if the
axis is logarithmic, the value of `.incSml.' takes on a special
meaning: if it is positive then small tics are put at values 2, 3, 4,
etc. between the decades, but if `.incSml.' is negative then no such
small tics are used. 

`set y axis labels [add] .position. "label" [.position. "label" [...]]'
Override the automatic labelling at axis tics, and instead put the
indicated labels at the indicated y values.  For example, a
day-of-week axis can be created by the code:
    set y axis 0 1 0.5
    set y axis labels 0.25 "Weak" 0.75 "Strong"
The command replaces any existing labels, unless the `add' keyword is
present, in which case the new label information is appended to any
existing information.

`set y axis labels automatic'
Return to automatically-generated axis labels, undoing the command of
the previous item.

`set y axis name vertical'
Cause future y axes to be drawn with the name aligned vertically (the default).

`set y axis name horizontal'
Cause future y axes to be drawn with the name aligned horizontally.
{
    extern "C" bool set_y_axisCmd(void);
}

#* @param \format for axis numbers in C notation @default %g
`set y format \format|default|off'
Set format for numbers on y axis.  The format is specified in the manner
of the "C" programming language.  The "C" formats (i.e., `%f',
`%e' and `%g') are permitted.  For example, `set y format %.1f'
tells Gri to use 1 decimal place, and to prefer the "float" notation to
the exponential notation.  The form `set y format off' tells Gri not to
write numbers on the axis.  To get spaces in your format, enclose the
format string in double-quotes, e.g., you might use `set y format
"%.0f$\circ$ N"' for a map, or `set y format "   %f"' to make the
numbers appear to the right of their normal location.

The default format is `%lg'.
{
    extern "C" bool set_y_formatCmd(void);
}

`set y grid .bottom. .top. .inc.|{/.rows.}'
Create y-grid for contour or image.

`set y grid .bottom. .top. .inc.'
Create y-grid ranging from the value `.bottom.' at the bottom to
`.top.' at the top, stepping by an increment of `.inc.'.

`set y grid .bottom. .top. /.rows.'
Create y-grid with `.rows.' points, ranging from the value
`.bottom.' at the bottom to `.top.' at the top.
{
    extern "C" bool set_y_gridCmd(void);
}

#* @param .size. of y margin @unit cm @default 6 @variable ..ymargin..
`set y margin {[bigger|smaller] .size.} | default'
Control y margin, that is, the space between the bottom side of the
page and the bottom of the plotting area.  (Note that axis labels are
drawn inside the margin; the margin extends to the axis line, not to
the labels.)

`set y margin .size.'
Set bottom margin to `.size.' centimeters.  It is permissible to
have negative margins, with the expected effect.

`set y margin bigger .size.'
Increases bottom margin by `.size.' centimeters.

`set y margin smaller .size.'
Decreases bottom margin by `.size.' centimeters.

`set y margin default'
Set bottom margin to default = 6 cm.
{
    extern "C" bool set_y_marginCmd(void);
}

#* @param \name of y axis @default "y"
`set y name "\name"|default'
Set name of y-axis to the indicated string.  An empty string
(`set y name ""') causes the y axis to be unlabelled.  
The `default' is `"y"'.
{
    extern "C" bool set_y_nameCmd(void);
}

#* @param .height_cm. of y axis @unit cm @default 10 @variable ..ysize..
`set y size .height_cm.|default'
Set the width of the plotting area.  This does not include axis labels,
only the interior part of the plot.

`set y size .height_cm.'
Set height of y-axis in centimeters.

`set y size default'
Set width of y-axis to default = 10 cm.
{
    extern "C" bool set_y_sizeCmd(void);
}

`set y type linear|log|{map N|S|E|W}'
Control transformation function mapping user units to centimetres on the
page.

* `set y type linear' Set to linear axis.

* `set y type log' Set to log axis.  To avoid clashes in the linear
to log transform, this command should precede the creation of an
axis scale, either explicitly through the `set y axis .left.
.right. ...' command or implicitly through the `read columns'
command.

* `set y type map N|S|E|W' Set to be a map.  This means that whole
numbers on the axis will have a degree sign written after them
(and then the letter `N', etc), and that numbers which are
multiples of 1/60 will be written in degree-minute format, and
that similarly numbers which are divisible by 1/3600 will be in
degree-minute-second format.  If none of these things apply, the
axis labels will be written in decimal degrees.  Note that this
command overrides any format set by `set y format'.

BUG: this only has an effect if the axis is not already of type
`log'.

SEE ALSO: `set map projection', to set to non-rectangular axes for
various map projections.
{
    extern "C" bool set_y_typeCmd(void);
}

`set z missing above|below .intercept. .slope.'
Set `z' column to be missing whenever the associated `y' and `x'
columns are above/below the line defined by
y = .intercept. + .slope. * x
{
    extern "C" bool set_z_missingCmd(void);
}

`set "..."'
{
    extern "C" bool setCmd(void);
}

`show all'
Show lots of information about plot.
{
    extern "C" bool show_allCmd(void);
}

`show axes'
Show information about axes.
{
    extern "C" bool show_axesCmd(void);
}

`show color'
Show the current pen color used for lines and text.  This is not to be
confused with image color, which is independent.
{
    extern "C" bool show_colorCmd(void);
}

`show colornames'
Show all colors known by name, as defined by `read colornames' command and
also the builtin colors defined automatically (e.g. `white', `black',
`red', etc).
{
    extern "C" bool show_colornamesCmd(void);
}

`show columns [statistics]'
 `show columns'
     Show x, y, z, u, v column data.

 `show columns statistics'
     Show means, std devs, etc for columns.
{
    extern "C" bool show_columnsCmd(void);
}

`show flags'
Show values of all flags.  (Developers only.)
{
    extern "C" bool show_flagsCmd(void);
}
`show grid [mask]'
Show grid data (used for contouring), or show the grid mask (1 if data
are acceptable for contouring, or 0 if contours will not extend into
this region).
{
    extern "C" bool show_gridCmd(void);
}

`show hint of the day'
Show a Gri hint for today, randomly selected from a list of hints
maintained on the Gri WWW site.  Hints are cached, so that today's
your hint will only be dowloaded once, and stored in your
~/.gri-hint-cache file. 
{
    extern "C" bool show_hintCmd(void);
}

`show image'
Show information about image, such as a histogram of values, and,
if the image is small enough, the actual data.
{
    extern "C" bool show_imageCmd(void);
}

`show license'
Show license, allowing copying of Gri
{
    extern "C" bool show_licenseCmd(void);
}

`show misc'
Show miscellaneous information about the plot, the data, etc.
{
    extern "C" bool show_miscCmd(void);
}

`show next line'
Show next line of data-file.
{
    extern "C" bool show_next_lineCmd(void);
}

`show traceback'
Show traceback (i.e., the tree of commands being done at this
instant).
{
    extern "C" bool show_tracebackCmd(void);
}

`show stopwatch'
Show elapsed time since first call to this command in the given Gri program.
{
    extern "C" bool show_stopwatchCmd(void);
}

`show synonyms'
Show values of all synonyms, whether built-in or user-defined.
{
    extern "C" bool show_synonymsCmd(void);
}

`show time'
Show the current time.
{
    extern "C" bool show_timeCmd(void);
}

`show variables'
Show values of all variables, whether built-in or user-defined.
{
    extern "C" bool show_variablesCmd(void);
}

`show .value. | {rpn ...} | "\text" [.value.|{rpn ...}|text [...]]'
 `show .value.'
     Show value of indicated variable.

 `show \{rpn ...}'
     Show result of computing indicated expression.

 `show "some text"'
     Print the indicated string.

 `show "time=" .time. "; depth=" .depth.'
     Print strings and values as indicated.  If the last item is
     ellipses (three dots with no spaces between them), then no
     newline is printed; this makes the next `show' statement print on
     the same line.
{
    extern "C" bool show_expression_or_stringCmd(void);
}

`skip [forward|backward] [.n.]'
 `skip'
     For ascii files, skip forward 1 line in the data file.  For binary
     files, skip forward 1 byte.

 `skip backward'
     For ascii files, skip backward 1 line in the data file.  For
     binary files, skip backward 1 byte.

 `skip .n.'
 `skip forward .n.'
     For ascii files, skip forward `.n.' lines in the data file.  For
     binary files, skip forward `.n.' bytes.

 `skip backward .n.'
     For ascii files, skip backward `.n.' lines in the data file.  For
     binary files, skip backward `.n.' bytes.
{
    extern "C" bool skipCmd(void);
}

`sleep .sec.'
   Cause Gri to sleep for the indicated number of seconds, which should
be a positive integer.  This command is ignored if `.sec.' is zero or
negative, and the value of `.sec.' is first rounded to the nearest
integer.

   Normally, this command is used only be the developer, as a way to
slow down Gri execution, to allow easier monitoring for debugging
purposes.  Beware: it is tricky to kill a sleeping job!
{
    extern "C" bool sleepCmd(void);
}

`smooth {x [.n.]} | {y [.n.]} | {grid data [.f.|{along x|y}]}'
   All these smoothing commands ignore the *location* of the data.  For
equispaced data these algorithms have the standard interpretation in
terms of digital filters.  For non-equispaced data, the interpretation
is up to the user.

   The `smooth x' command does smoothing by the following formula
     x[i-1]   x[i]   x[i+1]
     ------ + ---- + ------
       4       2       4

   The `smooth x .n.' command does boxcar smoothing using centred
boxcars `.n.' points wide.

   The `smooth y' command does the same as `smooth x', but on the `y'
column.

   There are several methods of smoothing grid data.  Note that isolated
missing values are filled in by each method.  (Let the author know if
you'd like that `feature' to be an option.)

   The `smooth grid data' command smooths gridded data, by weighted
average in a plus-shaped window about each gridpoint.  The smoothing
algorithm replaces each interior gridpoint value `z[i][j]' by
     z[i][j]   z[i-1][j] + z[i+1][j] + z[i][j-1] + z[i][j+1]
     ------- + ---------------------------------------------
        2                          8

Points along the edges are smoothed by the same formula, after
inventing image points outside the domain by planar extrapolation.

   The `smooth grid data .f.' command performs partial smoothing.  A
temporary fully-smoothed grid `zSMOOTH[i][h]' is constructed as above,
and a linear combination of this grid and the original grid is used as
the replacement grid:
     z[i][j] = (1-f) * z[i][j] + f * zSMOOTH[i][j]

where `f' is the value indicated on the command line.  Thus, `smooth
grid data 0' performs no smoothing at all, while `smooth grid data 1'
is equivalent to `smooth grid data'.

   The `smooth grid data along x' command smooths the grid data along
`x' (i.e., horizontally), by replacing each value `z[i][j]' with the
value
     z[i][j]   z[i-1][j] + z[i+1][j]
     ------- + ---------------------
        2                4

Points along the edges are smoothed by the same formula, after
inventing image points outside the domain by linear extrapolation.

   The `smooth grid data along y' command does the same thing as
`smooth grid data along x', but the smoothing is along `y'.

   SEE ALSO: `filter', a generalization of `smooth x|y' which allows
for more sophisticated filters.
{
    extern "C" bool smoothCmd(void);
}

`source \filename'
Insert instructions in named file into current file.  This is useful as
a way of sharing global information between several Gri programs.  On
unix systems, if a full filename is specified (i.e., a filename
beginning with slash or period), then that particular file will be used.
{
    extern "C" bool sourceCmd(void);
}

`sprintf \synonym "format" .variable. [.variable. [...]]'
Write numbers into a synonym (text string).  This is useful for
labelling plots.

`sprintf \out "a = %f b = %.2f" .a. .b.' - Create a synonym called
`\out', and print the values of the variables `.a.' and `.b.' into it.
 If `.a.' = 1 and `.b.' = 0.112, then `\out' will be `"a = 1 b = 0.11"'

   Formatting codes are as in the C programming language, eg:

     %.2f  -- Use floating point notation with 2 decimal places.
     %9.2f -- As above, but specify the number to occupy 9 characters.
     %e    -- Use exponential notation.

   WARNING: Variables are stored in the "double" storage type of the
"C" programming language, so "long" formats must be used in `sprintf'.
{
    extern "C" bool sprintfCmd(void);
}

`state save|restore|display'
The `save' operation pushes a record of the graphics state (pen and
font characteristics, margins, axis lengths, min/max/inc values on axes,
etc) onto a stack.  The `restore' operation replaces the present state with
whatever is on top of the stack, and then pops the stack.  Use
the `display' operation to see some of the state properties.

The `state' command is useful for temporary changes of axis
properties, etc.

BUG: only line characteristics (width, color) and font characteristics
(font, size, color) are saved so far.  In fact, the full list of what
should be saved has not yet been finalized by the author.
{
    extern "C" bool stateCmd(void);
}

`superuser'
Allow extra debugging information and commands.  Normally, this command
and the corresponding commandline flag -superuser are only used by
programmers altering the Gri source.

These are the flags and their meanings:
1       Print cmdline before/after substituting synonyms
2       Print cmdline before/after substituting rpn expressions
4       Print all new commands as they are being defined
8       Print system commands and `open "...|"' commands before they
        are passed to the system
Note that all flags are equal to 2 raised to an integer power.  Since
the flag values are detected by a bitwise OR, you can combine glags by
adding; thus specifying a flag of 5 yields flags 1 and 4 together.
{
    extern "C" bool superuserCmd(void);
}

`system \system-command'
Tell the operating system to perform the indicated action.  Whatever
string follows the word `system' is passed directly to the operating
system, *after* substitution of synonyms if any exist.  Note that `rpn'
expressions are not evaluated, and variable values are not substituted
before passing the string to the operating system.  The exit status is
stored in the builtin variable `..exit_status..'.

   There are two ways to use the system:
   * *Assign output to synonym*: The form `\synonym = system ...' does
     the system command and then inserts the output from that command
     into the indicated synonym.)

   * *Just run a command*: The command `system ls' will list the files
     in the current directory.

   For long commands, there are two approaches, the second preferred:
   * *Use continuation lines*: String a lot of information onto one
     effective system line, using the `\' line-continuation character
     at the ends of lines.  The problem is that it's very easy to lose
     one of these backslashes.  The next method is better.

   * *Here-is syntax* The here-is syntax of many unix shells is also
     provided.  If the system command contains the characters `<<'
     followed by a word (with no space between!) then Gri will issue a
     system command which includes not only this line but also all
     succeeding lines, until a line is found which matches the
     indicated word precisely (with no leading space allowed).  The `<<
     "WORD"' syntax is also supported, meaning that the operating
     system is being told not to mess with the dollar-signs - needed in
     perl.

     *Note:* Be carefull using this inside a new-command.  Gri
     Recognizes the end of the body of a new-command by a line with `}'
     in the *first column*, and no non-white characters thereafter.  If
     you system command happens to use a line with a curly brace (as in
     a loop in perl, for example), you must put whitespace before the
     brace.  This won't affect the system command, but it will let Gri
     correctly realize that this is *not* the end of the new-command.
     For more information on new-commands.

     *Caution:* Before sending the string to the system, Gri first
     translates any synonyms present.  Be careful with this, since
     system commands calling awk, etc, very often use backslashes for
     the newline character `\n' within strings.  If you have a synonym
     whose name starts with `\n', you can get a conflict.  For example,
     the awk command `print "foo\nbar";' should print a line with `foo'
     on it, followed by a line with `bar' on it, but it will instead
     print a single line with `fooMISTAKE', if you had previously
     defined a synonym as `\nbar = "MISTAKE"'.  One way to avoid this
     mistake is to make sure any `\n' characters appear at the end of
     strings, and then simply avoid having a synonym named `\n'.

     Here is a Perl example.
          \message = "Foo bar"
          system perl <<"EOF"
          $a = 100;
          print "foo bar is \message, and a is $a\nQ: was a 100?\n";
          print "BETTER: foo bar is \message, and a is $a\n";
          print "Q: was a 100?\n";
          EOF

     which, written more safely (partially avoiding the string `\n'), is
          \message = "Foo bar"
          system perl <<"EOF"
          $a = 100;
          print "foo bar is \message, and a is $a\n";
          print "Q: was a 100?\n";
          EOF

     Here is an Awk example.  Note that the commandline flags `-f -' are
     required to force awk to take commands from standard input.  Note
     also the absence of a final newline in the string; Awk does not
     require one, while Perl does.  (Finally, as usual, note that the
     synonym `awk' is being used instead of `awk', to ensure
     portability.)
          \message = "Foo bar"
          system awk -f - <<"EOF"
          BEGIN \{
          a = 100;
          print "foobar is \message, and a is ", a, "\nQ: was a 100?";
          }
          EOF

     which, written more safely (avoiding the string `\n'), is
          \message = "Foo bar"
          system awk -f - <<"EOF"
          BEGIN\{
          a = 100;
          print "foobar is \message, and a is ", a;
          print "Q: was a 100?";
          }
          EOF

   *Some more examples*:
   * To get the first 10 lines of a file called `foo.dat' inserted into
     another file called `bar.dat', you might do the following.  Only
     the first method works; the second will fail because `.n.' will not
     be translated before passing to the operating system.
          \num = "-10"
          system head \num foo.dat > bar.dat
          # Following fails since .num. will not be translated
          .num. = -10
          system head .num. foo.dat > bar.dat

   * Issue a unix command to get a listing of files in the current
     working directory, and pipe them into the `more' system command.
          system ls -l *c | more

   * Store the date and time into a synonym, and use it in a title:
          \time = system date
          ...
          draw title "Plotted at time \time"

   * Use `awk' to prepare a two-column table of x, ranging from 0 to 1
     in steps of 0.1, and sin(x).  The table is stored in a file whose
     suffix is the process ID of the Gri job.  This file is then
     opened, and the data plotted.  Finally, a system command is issued
     to remove the temporary file.
          system awk 'BEGIN \{ \
              for (x=0; x<1; x+=0.1) \{ \
                printf("%f %f\n", x, sin(x)) \
              } \
            }'  > tmp.\.pid.
          open tmp.\.pid.
          read columns x y
          close
          system rm tmp.\.pid.
          draw curve
          quit


     NOTE Under unix, this command calls the Bourne shell, not the
     C-shell that is often used interactively.  For many simple uses,
     the only difference from normal interactive use will be that `~'
     is not expanded to the home directory.  For example, you'd do
          system awk -f $HOME/foo/bar/cmd.gawk

     instead of the
          system awk -f ~/foo/bar/cmd.gawk

     that you might expect from interactive C-shell usage.


RETURN VALUE: Sets `\.return_value' to system status, `N status'
{
    extern "C" bool systemCmd(void);
}

`while .test.|{rpn ...}'
Perform statements in loop while the value of `.test.' or the RPN
expression is nonzero.  The end of the loop designated by a line
containing the words `end while'. The value `.test.' may be an RPN
expression.  To leave the loop prematurely, use a `break' statement.
Upon encountering a `break' statement, Gri jumps to the line
immediately following the loop.  If the `-chatty' option is nonzero, a
notification is printed every 1000 passes through the loop, as a
debugging measure to catch unintended infinite loops.


*Examples*:

   * Loop forever, printing a message over and over.
          while 1
            show "DANGER: This loop goes on forever. You need a break statement!"
          end while

   * Repeatedly read two numbers, and plot a bullet at the indicated
     location.  If (or, hopefully, "when") the end of the file is
     encountered, break out of the loop; otherwise continue plotting
     forever.
          while 1
            read .x. .y.
            if ..eof..
              break
            end if
            draw symbol bullet at .x. .y.
          end while

   * Loop 10 times, printing the values of `.i.' as they range 0, 1,
     ..., 9.  After exiting from the loop, `.i.' will equal 10.  Be
     *careful* to use the correct RPN greater-than test to avoid an
     infinite loop.
          .i. = 0
          while \{rpn .i. 10 >}
            show .i.
            .i. += 1
          end while
{
    extern "C" bool whileCmd(void);
}

`write columns to \filename'
Append data columns to the end of the indicated file.
{
    extern "C" bool writeCmd(void);
}

`write contour .value. to \filename'
As corresponding `draw contour' command, but don't actually draw the
contours; instead, write to the indicated file, starting at the EOF of
the file if it is nonempty (thus, appending to the end of the file.)
The first line of output is a header line, containing two numbers: the
contour value and the missing value.  Then the xy pairs are written a
line at a time, with missing values being used to indicate ends of
segments.  A blank line is written after the last data pair.  For
example, if the contour contained two closed regions, Gri would output
a pair of missing values as one of the xy pairs, to denote the
separation of the two curves.  You could read and plot the output as
in this example
    write contour 10 to contour.out
    write contour 20 to contour.out
    open contour.out
    read .contour_value. .missing.
    set missing value .missing.
    read columns x y
    draw curve
{
    extern "C" bool writeCmd(void);
}

`write grid to \filename [bycolumns]'
Append grid to the end of the named file.  Storage is in `%f' format,
and is in normal image order.  If the keyword `bycolumns' is present,
then the grid is transposed first, in such a way that `read grid data
bycolumns' performed on that file will read back the original grid
data.
{
    extern "C" bool writeCmd(void);
}

`write image colorscale to \filename'
Append image colorscale transform to the end of the named file.
Storage is a series of 256 lines, each containing 3 numbers (for Red,
Green and Blue) in the range 0 to 1.  The file is suitable for reading
with the `read image colorscale' command.
*/ 
{
    extern "C" bool writeCmd(void);
}

`write image grayscale to \filename'
Append image grayscale transform to the end of the named file.
Storage is a series of 256 lines, each containing a number in the
range 0 to 1.  The file is suitable for reading with the `read image
grayscale' command.
*/ 
{
    extern "C" bool writeCmd(void);
}

`write image greyscale to \filename'
Alternate spelling of grayscale
{
    extern "C" bool writeCmd(void);
}

`write image mask [pgm|rasterfile] to \filename'
 `write image mask to mask.dat'
     Append image mask to the end of the named file. Storage is by
     unsigned-char, and is in normal image order.  There is no header.

 `write image mask rasterfile to mask.dat'
     Append image mask to the end of the named file, in Sun Rasterfile
     format. 

 `write image mask pgm to mask.dat'
     Append image mask to the end of the named file, in PGM 'rawbits'
     format. 
{
    extern "C" bool writeCmd(void);
}

`write image [pgm|rasterfile] to \filename'
 `write image to image.dat'
     Append image to the end of the named file.  Storage is by
     unsigned-char, and is in normal image order.   There is no
     header. 

 `write image rasterfile to image.dat'
     Append image to the end of the named file, in Sun Rasterfile
     format.

 `write image pgm to image.dat'
     Append image to the end of the named file, in PGM 'rawbits'
     format.
{
    extern "C" bool writeCmd(void);
}

`unlink \filename'
Delete a filename and possibly the file to which it refers.  On
non-unix machines, this simply means to delete the file.  On unix
machines, the action is more subtle.  The unix OS permits several
processes to use a given file at once.  Therefore, `unlink' doesn't
immediately remove the file, but instead waits until other processes
are done with it.  Most users will never realize the difference,
however, and it is safe to think of `unlink' as simply removing the
file.  To learn more, type `man unlink' in a unix shell.

   A common use of `unlink' is to remove files that were created with
the `tmpname' facility, e.g.
     \tmp = tmpname
     # do some system commands to put data into this file
     open \tmp
     read columns x y
     draw curve
     unlink \tmp
{
    extern "C" bool unlinkCmd(void);
}

`?draw axes exploded'
Fragment to draw the xy axes at left and bottom, offset 0.2 cm from a
simple axis frame.
{
    draw axes frame		# Draw frame
    draw x axis at {rpn ..ymargin.. 0.2 -} cm lower # X axis below frame
    draw y axis at {rpn ..xmargin.. 0.2 -} cm left # Y axis left of frame
}

`?contour xyz data'
Fragment to read xyz data (from a file called "file.dat"), then
interpolate these xyz data onto a uniform grid (of size 30x30, chosen to
span the data), and then draw contours (at levels selected by autoscaling
the data).  For reference, dots are also drawn at the data locations.

Adjustments: filename, grid characteristics, method/details of converting
columns to grid.
{
    open input.dat		# You'll want to change the filename
    read columns x y z		# Can read in any order, e.g '... y x z'
    close			# Close this file
    set x grid ..xleft.. ..xright.. / 30 # Spans data, 30 wide
    set y grid ..ybottom.. ..ytop.. / 30 # Spans data, 30 high
    convert columns to grid	# Uses default "objective" method
    draw contour		# Levels selected automatically
    draw symbol bullet		# Put dots at data locations
}

`?set axes'
{
    set x margin 2		# 2cm at left of axis frame
    set x margin 2		# 2cm at left of axis frame
    set x size 12		# Axis frame 12cm wide
    set y size 12		# Axis frame 12cm high
    set x name "x"		# Name of x axis
    set y name "y"		# Name of y axis
}

`?draw image BW raster'
Fragment to read/draw a Sun rasterfile image in BW, blown up to full size
on (portrait orientation) 8.5x11 paper.  No axes are drawn.  A palette is
drawn, assuming that the limits of the image value are 0 and 1.

Main adjustable parameters marked with '*' in comment.
{
    \file = "A.rs"		# * filename
    .min. = 0			# * lowest possible value
    .max. = 1			# * largest possible value
    set image range .min. .max.
    open \file binary
    read image rasterfile	
    # ALTERNATIVE:
    #   read image pgm
    close
    .margin. = 1		# * margin space in cm
    set x margin .margin.
    set y margin .margin.
    set x axis 0 ..image_width.. ..image_width..
    set y axis 0 ..image_height.. ..image_height..
    set font size 10		# * font size
    set x size {rpn 8.5 2.54 * .margin. 2 * -}
    set y size {rpn ..xsize.. ..image_width.. / ..image_height.. *}
    # Want 2cm for palette
    .left_over. = {rpn 11 2.54 * ..ysize.. - .margin. 2 * -}
    if {rpn .left_over. 2 >}
	set y size {rpn 11 2.54 * .margin. 2 * - 2 -}
	set x size {rpn ..ysize.. ..image_height.. / ..image_width.. *}
    end if
    draw axes none
    draw image
    draw image palette left .min. right .max. box \
	{rpn ..xmargin..} \
	{rpn ..ymargin.. ..ysize.. + 1.0 +} \
	{rpn ..xmargin.. ..xsize.. +} \
	{rpn ..ymargin.. ..ysize.. + 2.0 +}
}

rpnfunction e 2.7182818284590452354
rpnfunction pi 3.14159265358979323846

# The following assume stack containing four numbers, 'x0 y0 x1 y',
# and return the slope and intercept of the line joining the points.
rpnfunction linear_slope     exch roll_right - roll_right exch - /

rpnfunction linear_intercept exch dup roll_left roll_left roll_left dup roll_right - roll_right exch - / roll_left * -


# /----------------------------------------------------------------\
# |The following material is for the benefit of the Emacs gri mode |
# \----------------------------------------------------------------/
#
# @variable ..R2..                    squared correlation coefficient (defined if regression has been done)
# @variable ..coeff0..                intercept in linear regression (defined if regression has been done)
# @variable ..coeff0_sig..            95% C.I. on intercept in linear regression (defined if regression has been done)
# @variable ..coeff1..                slope in linear regression (defined if regression has been done)
# @variable ..coeff1_sig..            95% C.I. on slope in linear regression (defined if regression has been done)
# @variable ..num_col_data..          number of column data
# @variable ..num_col_data_missing..  number of missing column data
# @variable ..arrowsize..             size of arrow heads @unit cm @default 0.2
# @variable ..batch..                 is Gri in batch mode? @default 0
# @variable ..debug..                 debugging flag @default 0
# @variable ..fontsize..              size of font @unit point @default 12
# @variable ..graylevel..             graylevel of pen (0 means black) @default 0
# @variable ..linewidth..             width of curves @unit point @default 0.709
# @variable ..linewidthaxis..         width of axis lines @unit point @default 0.369
# @variable ..linewidthsymbol..       width of symbol lines @unit point @default 0.369
# @variable ..missingvalue..          missing value @default 1e+22
# @variable ..symbolsize..            size of symbols @unit point @default 0.1
# @variable ..superuser..             superuser flag @default 0
# @variable ..trace..                 are executed commands printed? @default 0
# @variable ..tic_direction..         direction of tics (0 means out and 1 means in) @default 0
# @variable ..tic_size..              size of tic marks @unit cm @default 0.2
# @variable ..xmargin..               margin to left of axis area @unit cm @default 6
# @variable ..xsize..                 width of axis area @unit cm @default 10
# @variable ..ymargin..               margin below axis area @unit cm @default 6
# @variable ..ysize..                 height of axis area @unit cm @default 10
# @variable ..red..                   red-ness of pen (0 to 1) @default 0
# @variable ..blue..                  blue-ness of pen (0 to 1) @default 0
# @variable ..green..                 green-ness of pen (0 to 1) @default 0
# @variable ..exit_status..           exit status used for OS @default 0
# @variable ..xleft..                 x-value at left of axis area @default 0
# @variable ..xright..                x-value at right of axis area @default 10
# @variable ..ybottom..               y-value at bottom of axis area @default 0
# @variable ..ytop..                  y-value at top of axis area @default 10
# @variable ..use_default_for_query.. use default for query statements? (0 or 1) @default 0
# @variable ..words_in_dataline..     number of words in data line @default 0
# @variable ..eof..                   at end of data file yet? (0 or 1) @default 0
# @variable ..landscape..             is the graph in landscape mode? (0 or 1) @default 0
# @variable ..publication..           use publication quality? (0 or 1) @default 0
# @variable ..xlast..                 last value of x column @default 0
# @variable ..ylast..                 last value of y column @default 0
# @variable ..image_width..           pixel width of image @default 0
# @variable ..image_height..          pixel height of image @default 0
# @variable \.missingvalue. missing value code @default "1e22"
# @variable \.return_value. return value from last command
# @variable \.version. version of gri being used
# @variable \.pid. process id of this job
# @variable \.wd. present working directory
# @variable \.time. day, date and time
# @variable \.user. name of user who started this job
# @variable \.host. name of computer on which job is running
# @variable \.system. name of operating system
# @variable \.home. name of this users home directory
# @variable \.lib_dir. directory that holds gri library files
# @variable \.command_file. name of command file for this job
# @variable \.readfrom_file. name of file being read for data
# @variable \.ps_file. name of PostScript file being created
# @variable \.path_data. directory path for finding data @default "."
# @variable \.path_commands. directory path for finding commands @default "."

# BEGIN deprecated commands
# @deprecated 2.10.0 `set y axis label horizontal|vertical'
# END   deprecated commands
