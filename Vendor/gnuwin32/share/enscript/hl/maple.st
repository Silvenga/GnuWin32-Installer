/**
 * Name: maple
 * Description: Maple programming language.
 * Author: Manolis Lourakis <lourakis@csd.uch.gr>
 */

/* Maple V rel. 5 keywords taken from keyword and ininames */

/* (build-re '(
and			by			do
done			elif			else
end			fi			for
from			if			in
intersect		local			minus
mod			not			od
option			options			or
proc			quit			read
save			stop			then
to			union			while
ASSERT			RETURN			ERROR
WARNING			break			empty
function		next			restart
remember		builtin			system
operator		arrow			trace
package			Copyright
Catalan			Digits			FAIL
false			gamma			I
infinity		integrate		lasterror
libname			mod			NULL
Order			Pi			printlevel
true			And 			NONNEGATIVE
Not			Or			PLOT
PLOT3D			Point			Range
RootOf			TEXT			algebraic
algext
algfun			algnum			algnumext
anyfunc			anything		arctrig
array			atomic			boolean
complex			complexcons		constant
cubic			dependent		disjcyc
equation		even			evenfunc
expanded		exprseq			facint
float			fraction		freeof
function		hfarray			identical
indexed			indexedfun		infinity
integer			intersect		laurent
linear			list			listlist
literal			logical			mathfunc
matrix			minus			monomial
name			negative		negint
nonneg			nonnegint		nonposint
nothing			numeric			odd
oddfunc			operator		point
polynom			posint			positive
prime			procedure		protected
quadratic		quartic			radalgfun
radalgnum		radext			radfun
radfunext		radical			radnum
radnumext		range			rational
ratpoly			realcons		relation
rgf_seq			scalar			series
set			specfunc		sqrt
square			string			symbol
symmfunc		table			taylor
trig			type			uneval
union			vector
))
*/

mpl_keyword =
/\b(A(SSERT|nd)|C(atalan|opyright)|Digits|ERROR|FAIL|I\
|N(ONNEGATIVE|ULL|ot)|Or(|der)|P(LOT(|3D)|i|oint)|R(ETURN|ange|ootOf)\
|TEXT|WARNING\
|a(lg(e(braic|xt)|fun|num(|ext))|n(d|y(func|thing))|r(ctrig|r(ay|ow))\
|tomic)\
|b(oolean|reak|uiltin|y)|c(o(mplex(|cons)|nstant)|ubic)\
|d(ependent|isjcyc|o(|ne))\
|e(l(if|se)|mpty|nd|quation|ven(|func)|xp(anded|rseq))\
|f(a(cint|lse)|i|loat|or|r(action|eeof|om)|unction())|gamma|hfarray\
|i(dentical|f|n(|dexed(|fun)|finity()|te(g(er|rate)|rsect())))\
|l(a(sterror|urent)|i(bname|near|st(|list)|teral)|o(cal|gical))\
|m(at(hfunc|rix)|inus()|o(d()|nomial))\
|n(ame|e(g(ative|int)|xt)|o(n(neg(|int)|posint)|t(|hing))|umeric)\
|o(d(|d(|func))|p(erator()|tion(|s))|r)\
|p(ackage|o(int|lynom|si(nt|tive))|r(i(me|ntlevel)|o(c(|edure)|tected)))\
|qu(a(dratic|rtic)|it)\
|r(a(d(alg(fun|num)|ext|fun(|ext)|ical|num(|ext))|nge|t(ional|poly))\
|e(a(d|lcons)|lation|member|start)|gf_seq)\
|s(ave|calar|e(ries|t)|pecfunc|q(rt|uare)|t(op|ring)\
|y(m(bol|mfunc)|stem))\
|t(a(ble|ylor)|hen|o|r(ace|ig|ue)|ype)|un(eval|ion())|vector|while)\b/;

/* Maple V rel. 5 functions taken from inert, inifcns and the
 * following packages: DEtools GF GaussInt LREtools Matlab algcurves
 * codegen combinat combstruct diffalg difforms finance genfunc geom3d
 * geometry Groebner group inttrans liesymm linalg logic networks
 * numapprox numtheory orthopoly padic plots plottools powseries
 * process simplex stats student sumtools tensor totorder
 */

/* (build-re '(
abs			AiryAi			AiryAiZeros
AiryBi			AiryBiZeros		AngerJ
argument		bernoulli		BesselI
BesselJ			BesselJZeros		BesselK
BesselY			BesselYZeros		Beta
binomial		ceil			Chi
Ci			conjugate		csgn
dilog			Dirac			Ei
EllipticCE		EllipticCK		EllipticCPi
EllipticE		EllipticF		EllipticK
EllipticModulus		EllipticNome		EllipticPi
erf			erfc			erfi
euler			exp			factorial
floor			frac			FresnelC
Fresnelf		Fresnelg		FresnelS
GAMMA			GaussAGM		HankelH1
HankelH2		harmonic		Heaviside
hypergeom		ilog10			ilog
Im			JacobiAM		JacobiCN
JacobiCD		JacobiCS		JacobiDN
JacobiDC		JacobiDS		JacobiNC
JacobiND		JacobiNS		JacobiSC
JacobiSD		JacobiSN		JacobiTheta1
JacobiTheta2		JacobiTheta3		JacobiTheta4
JacobiZeta		KelvinBer		KelvinBei
KelvinHer		KelvinHei		KelvinKer
KelvinKei		KummerM			KummerU
LegendreP		LegendreQ		LerchPhi
Li			ln			lnGAMMA
log			log10			LommelS1
LommelS2		MeijerG			max
min			pochhammer		polar
polylog			Psi			Re
round			signum			Shi
Si			sqrt			Ssi
StruveH			StruveL			surd
trunc			LambertW		WeberE
WeierstrassP		WeierstrassPPrime	WeierstrassZeta
WeierstrassSigma	WhittakerM		WhittakerW
Zeta			sin			cos
tan			sec			csc
cot			sinh			cosh
tanh			sech			csch
coth			arcsin			arccos
arctan			arcsec			arccsc
arccot			arcsinh			arccosh
arctanh			arcsech			arccsch
arccoth
DEtools			GF			GaussInt
LREtools		Matlab			algcurves
codegen			combinat		combstruct
diffalg			difforms		finance
genfunc			geom3d			geometry
Groebner		group			inttrans
liesymm			linalg			logic
networks		numapprox		numtheory
orthopoly		padic			plots
plottools		powseries		process
simplex			stats			student
sumtools		tensor			totorder
DEplot				DEplot3d			PDEplot
dfieldplot			phaseportrait			generate_ic
hamilton_eqs			poincare			zoom
DEnormal			Dchangevar			PDEchangecoords
autonomous			convertAlg			convertsys
indicialeq			reduceOrder			regularsp
translate			untranslate			varparam
RiemannPsols			abelsol				bernoullisol
chinisol			clairautsol			constcoeffsols
eulersols			exactsol			expsols
genhomosol			kovacicsols			liesol
linearsol			matrixDE			parametricsol
polysols			ratsols				riccatisol
separablesol			DFactor				GCRD
LCLM				adjoint				de2diffop
diffop2de			eigenring			endomorphism_charpoly
exterior_power			formal_sol			gen_exp
integrate_sols			leftdivision			mult
rightdivision			symmetric_power			symmetric_product
buildsol			buildsym			canoni
equinv				eta_k				infgen
intfactor			line_int			odeadvisor
odepde				symgen				symtest
transinv			GF				GIbasis
GIchrem				GIdivisor			GIfacpoly
GIfacset			GIfactor			GIfactors
GIgcd				GIgcdex				GIhermite
GIissqr				GIlcm				GImcmbine
GInearest			GInodiv				GInorm
GInormal			GIorder				GIphi
GIprime				GIquadres			GIquo
GIrem				GIroots				GIsieve
GIsmith				GIsqrfree			GIsqrt
GIunitnormal			REcontent			REcreate
REplot				REprimpart			REreduceorder
REtoDE				REtodelta			REtoproc
constcoeffsol			delta				dispersion
divconq				firstlin			hypergeomsols
polysols			ratpolysols			riccati
shift				chol				closelink
defined				det				dimensions
eig				evalM				fft
getvar				inv				lu
ode45				openlink			qr
setup				setvar				size
square				transpose			Weierstrassform
genus				homogeneous			integral_basis
j_invariant			parametrization			plot_knot
puiseux				singularities			C
fortran				optimize			cost
GRADIENT			HESSIAN				JACOBIAN
horner				makeglobal			makeparam
makeproc			makevoid			dontreturn
packargs			packlocals			swapargs
renamevar			declare				intrep2maple
maple2intrep			prep2trans			split
joinprocs			Chi				bell
binomial			cartprod			character
choose				composition			conjpart
decodepart			encodepart			fibonacci
firstpart			graycode			inttovec
lastpart			multinomial			nextpart
numbcomb			numbcomp			numbpart
numbperm			partition			permute
powerset			prevpart			randcomb
randpart			randperm			stirling1
stirling2			subsets				vectoint
allstructs			count				draw
finished			gfeqns				gfseries
gfsolve				iterstructs			nextstruct
Rosenfeld_Groebner		belongs_to			delta_leader
delta_polynomial		denote				derivatives
differential_ring		differential_sprem		differentiate
equations			field_extension			formal_power_series
greater				inequations			initial
initial_conditions		is_orthonomic			leader
power_series_solution		print_ranking			rank
reduced				reduced_form			rewrite_rules
separant			const				d
defform				form				formpart
mixpar				parity				scalar
scalarpart			simpform			wdegree
wedge				annuity				cashflows
growingannuity			growingperpetuity		levelcoupon
perpetuity			amortization			blackscholes
effectiverate			futurevalue			presentvalue
yieldtomaturity			rgf_charseq			rgf_encode
rgf_expand			rgf_findrecur			rgf_hybrid
rgf_norm			rgf_pfrac			rgf_relate
rgf_sequence			rgf_simp			rgf_term
termscale			dsegment			line
plane				point				segment
sphere				triangle			AreCollinear
AreConjugate			AreCoplanar			HarmonicConjugate
IsOnObject			OnSegment			centroid
coordinates			distance			midpoint
randpoint			xcoord				ycoord
zcoord				AreParallel			ArePerpendicular
DefinedAs			distance			midpoint
AreConcurrent			AreCoplanar			AreParallel
ArePerpendicular		ArePerpendicular		Equation
FindAngle			distance			intersection
parallel			tname				AreParallel
ArePerpendicular		Equation			FindAngle
IsTangent			distance			intersection
parallel			DefinedAs			FindAngle
IsEquilateral			IsRightTriangle			altitude
area				centroid			sides
AreConjugate			ArePerpendicular		Equation
FindAngle			IsTangent			RadicalCenter
RadicalLine			RadicalPlane			TangentPlane
area				center				intersection
polar				pole				powerps
radius				volume				GreatDodecahedron
GreatIcosahedron		GreatStellatedDodecahedron	InRadius
IsRegular			MidRadius			RegularPolyhedron
SmallStellatedDodecahedron	area				center
cube				dodecahedron			faces
hexahedron			icosahedron			incident
octahedron			radius				schlafli
sides				tetrahedron			vertices
volume				IsQuasi				cuboctahedron
icosidodecahedron		schlafli			sides
vertices			Archimedean			GreatRhombicuboctahedron
GreatRhombiicosidodecahedron	IsArchimedean			SmallRhombicuboctahedron
SmallRhombiicosidodecahedron	SnubCube			SnubDodecahedron
TruncatedCuboctahedron		TruncatedDodecahedron		TruncatedHexahedron
TruncatedIcosahedron		TruncatedIcosidodecahedron	TruncatedOctahedron
TruncatedTetrahedron		center				cuboctahedron
faces				icosidodecahedron		incident
radius				schlafli			sides
vertices			HexakisIcosahedron		HexakisOctahedron
PentagonalHexacontahedron	PentagonalIcositetrahedron	PentakisDodecahedron
RhombicDodecahedron		RhombicTriacontahedron		TetrakisHexahedron
TrapezoidalHexecontahedron	TrapezoidalIcositetrahedron	TriakisIcosahedron
TriakisOctahedron		TriakisTetrahedron		center
duality				faces				radius
schlafli			vertices			IsFacetted
IsStellated			center				faces
facet				schlafli			stellate
vertices			GlideReflection			RotatoryReflection
ScrewDisplacement		homology			homothety
inverse				inversion			projection
reflection			rotation			transform
translation			transprod			AreDistinct
detail				form				xname
yname				zname				circle
conic				dsegment			ellipse
hyperbola			line				parabola
point				segment				square
triangle			GergonnePoint			NagelPoint
centroid			orthocenter			EulerLine
ExternalBisector		SimsonLine			altitude
bisector			median				EulerCircle
circumcircle			excircle			incircle
AreConjugate			AreSimilar			IsEquilateral
IsRightTriangle			PedalTriangle			area
medial				method				sides
AreCollinear			AreConcyclic			AreHarmonic
CrossRatio			HorizontalCoord			IsOnCircle
IsOnLine			SensedMagnitude			VerticalCoord
convexhull			coordinates			diameter
distance			projection			randpoint
CrossProduct			OnSegment			midpoint
MakeSquare			diagonal			AreConcurrent
AreParallel			ArePerpendicular		Equation
FindAngle			ParallelLine			PerpenBisector
PerpendicularLine		slope				Appolonius
AreOrthogonal			CircleOfSimilitude		Equation
RadicalAxis			RadicalCenter			TangentLine
area				center				powerpc
radius				similitude			Equation
MajorAxis			MinorAxis			center
foci				Equation			directrix
focus				vertex				Equation
asymptotes			center				foci
vertices			RegularPolygon			RegularStarPolygon
GlideReflection			SpiralRotation			StretchReflection
StretchRotation			dilatation			expansion
homology			homothety			inversion
reciprocation			reflection			rotation
stretch				translation			AreTangent
DefinedAs			HorizontalName			Polar
Pole				VerticalName			detail
form				intersection			projection
tangentpc			termorder			testorder
leadcoeff			leadmon				leadterm
normalf				reduce				inter_reduce
gbasis				pretend_gbasis			gsolve
spoly				univpoly			fglm
is_finite			is_solvable			hilbertdim
hilbertpoly			hilbertseries			DerivedS
LCS				NormalClosure			RandElement
Sylow				areconjugate			center
centralizer			convert				core
cosets				cosrep				derived
grelgroup			groupmember			grouporder
inter				invperm				isabelian
isnormal			issubgroup			mulperms
normalizer			orbit				permgroup
permrep				pres				subgrel
transgrp			type				addtable
fourier				fouriercos			fouriersin
hankel				hilbert				invfourier
invhilbert			invlaplace			invmellin
laplace				mellin				savetable
&^				&mod				Eta
Lie				Lrank				TD
annul				autosimp			close
d				depvars				determine
dvalue				extvars				getcoeff
getform				hasclosure			hook
indepvars			makeforms			mixpar
prolong				reduce				setup
translate			vfix				wcollect
wdegree				wedgeset			wsubs
GramSchmidt			JordanBlock			LUdecomp
QRdecomp			addcol				addrow
adjoint				angle				augment
backsub				band				basis
bezout				blockmatrix			charmat
charpoly			cholesky			col
coldim				colspace			colspan
companion			cond				copyinto
crossprod			curl				definite
delcols				delrows				det
diag				diverge				dotprod
eigenvalues			eigenvectors			entermatrix
equal				exponential			extend
ffgausselim			fibonacci			forwardsub
frobenius			gausselim			gaussjord
geneqns				genmatrix			grad
hadamard			hermite				hessian
hilbert				htranspose			ihermite
indexfunc			innerprod			intbasis
inverse				ismith				issimilar
iszero				jacobian			jordan
kernel				laplacian			leastsqrs
linsolve			matadd				matrix
minor				minpoly				mulcol
multiply			norm				normalize
orthog				permanent			pivot
potential			randmatrix			randvector
rank				references			row
rowdim				rowspace			rowspan
scalarmul			singularvals			smith
stackmatrix			submatrix			subvector
sumbasis			swapcol				swaprow
sylvester			toeplitz			trace
transpose			vandermonde			vecpotent
vectdim				vector				wronskian
bequal				bsimp				canon
MOD2				frominert			toinert
distrib				dual				environ
randbool			satisfy				tautology
&and				&or				&not
&iff				&nor				&nand
&xor				&implies.			acycpoly
addedge				addvertex			adjacency
allpairs			ancestor			arrivals
bicomponents			charpoly			chrompoly
complement			complete			components
connect				connectivity			contract
countcuts			counttrees			cube
cycle				cyclebase			daughter
degreeseq			delete				departures
diameter			dinic				djspantree
dodecahedron			draw				duplicate
edges				ends				eweight
flow				flowpoly			fundcyc
getlabel			girth				graph
graphical			gsimp				gunion
head				icosahedron			incidence
incident			indegree			induce
isplanar			maxdegree			mincut
mindegree			neighbors			new
octahedron			outdegree			path
petersen			random				rank
rankpoly			shortpathtree			show
shrink				span				spanpoly
spantree			tail				tetrahedron
tuttepoly			vdegree				vertices
void				vweight				chebdeg
chebmult			chebpade			chebsort
chebyshev			confracform			hermite_pade
hornerform			infnorm				laurent
minimax				pade				remez
taylor				B				F
GIgcd				J				L
M				bernoulli			bigomega
cfrac				cfracpol			cyclotomic
divisors			euler				factorEQ
factorset			fermat				ifactor
ifactors			imagunit			index
integral_basis			invcfrac			invphi
isolve				isprime				issqrfree
ithprime			jacobi				kronecker
lambda				legendre			mcombine
mersenne			minkowski			mipolys
mlog				mobius				mroot
msqrt				nearestp			nextprime
nthconver			nthdenom			nthnumer
nthpow				order				pdexpand
phi				pprimroot			prevprime
primroot			quadres				rootsunity
safeprime			sigma				sq2factor
sum2sqr				tau				thue
G				H				L
P				T				U
evalp				expansion			function
lcoeffp				orderp				ordp
ratvaluep			rootp				valuep
animate				animate3d			animatecurve
changecoords			complexplot			complexplot3d
conformal			contourplot			contourplot3d
coordplot			coordplot3d			cylinderplot
densityplot			display				display3d
fieldplot			fieldplot3d			gradplot
gradplot3d			implicitplot			implicitplot3d
inequal				listcontplot			listcontplot3d
listdensityplot			listplot			listplot3d
loglogplot			logplot				matrixplot
odeplot				pareto				pointplot
pointplot3d			polarplot			polygonplot
polygonplot3d			polyhedra_supported		polyhedraplot
replot				rootlocus			semilogplot
setoptions			setoptions3d			spacecurve
sparsematrixplot		sphereplot			surfdata
textplot			textplot3d			tubeplot
arc				arrow				circle
cone				cuboid				curve
cutin				cutout				cylinder
disk				dodecahedron			ellipse
ellipticArc			hemisphere			hexahedron
hyperbola			icosahedron			line
octahedron			pieslice			point
polygon				rectangle			semitorus
sphere				tetrahedron			torus
homothety			project				reflect
rotate				scale				stellate
transform			translate			compose
evalpow				inverse				multconst
multiply			negative			powadd
powcos				powcreate			powdiff
powexp				powint				powlog
powpoly				powseries			powsin
powsolve			powsqrt				quotient
reversion			subtract			tpsform
block				exec				fork
kill				pclose				pipe
popen				wait				NONNEGATIVE
basis				convexhull			cterm
define_zero			display				dual
equality			feasible			maximize
minimize			pivot				pivoteqn
pivotvar			ratio				setup
standardize			anova				describe
fit				random				statevalf
statplots			transform			importdata
oneway				coefficientofvariation		count
countmissing			covariance			decile
geometricmean			harmonicmean			kurtosis
linearcorrelation		mean				meandeviation
median				mode				moment
percentile			quadraticmean			quantile
quartile			range				skewness
standarddeviation		sumdata				variance
leastmediansquare		leastsquare			beta
chisquare			fratio				gamma
normald				studentst			cdf
icdf				pdf				dcdf
idcdf				pf				boxplot
histogram			scatterplot			xscale
yscale				zscale				xshift
yshift				zshift				xyexchange
yzexchange			yzexchange			apply
classmark			cumulativefrequency		deletemissing
divideby			frequency			moving
multiapply			scaleweight			split
standardscore			statsort			statvalue
subtractfrom			tally				tallyinto
D				Diff				Doubleint
Int				Limit				Lineint
Point				Product				Sum
Tripleint			changevar			combine
completesquare			distance			equate
extrema				integrand			intercept
intparts			isolate				leftbox
leftsum				makeproc			maximize
middlebox			middlesum			midpoint
minimize			minimize			powsubs
rightbox			rightsum			showtangent
simpson				slope				summand
trapezoid			value				Hypersum
Sumtohyper			extended_gosper			gosper
hyperrecursion			hypersum			hyperterm
simpcomb			sumrecursion			sumtohyper
Christoffel1			Christoffel2			Einstein
display_allGR			displayGR			tensorsGR
Jacobian			Killing_eqns			Levi_Civita
Lie_diff			Ricci				Ricciscalar
Riemann				RiemannF			Weyl
act				table				antisymmetrize
change_basis			commutator			compare
conj				connexF				contract
convertNP			cov_diff			create
d1metric			d2metric			directional_diff
dual				entermetric			exterior_diff
exterior_prod			frame				metric
geodesic_eqns			get_char			get_compts
get_rank			invars				invert
lin_com				lower				npcurve
npspin				partial_diff			permute_indices
petrov				prod				raise
symmetrize			transform			tassume
tis				forget				ordering
init
AFactor			AFactors			AiriAiZeros
AiriBiYZeros		AiryAi				AiryBi
AngerJ			Berlekamp			BesselI
BesselJ			BesselJZeros			BesselK
BesselY			BesselYZeros			Beta
C			CHFARRAY			Chi
Ci			CompSeq				Content
D			DESol				Det
Diff			Dirac				DistDeg
Divide			Ei				Eigenvals
EllipticCE		EllipticCK			EllipticCPi
EllipticE		EllipticF			EllipticK
EllipticModulus		EllipticNome			EllipticPi
Eval			Expand				Expand
FFT			Factor				Factors
FresnelC		FresnelS			Fresnelf
Fresnelg		GAMMA				GaussAGM
Gaussejord		Gausselim			Gcd
Gcdex			HankelH1			HankelH2
Heaviside		Hermite				Im
Interp			Inverse				Irreduc
JacobiAM		JacobiCD			JacobiCN
JacobiCS		JacobiDC			JacobiDN
JacobiDS		JacobiNC			JacobiND
JacobiNS		JacobiSC			JacobiSD
JacobiSN		JacobiTheta1			JacobiTheta2
JacobiTheta3		JacobiTheta4			JacobiZeta
KelvinBei		KelvinBer			KelvinHei
KelvinHer		KelvinKei			KelvinKer
KummerM			KummerU				LambertW
Lcm			LegendreP			LegendreQ
LerchPhi		Li				Linsolve
LommelS1		LommelS2			MOLS
Maple_floats		MatlabMatrix			MeijerG
Normal			Normal				Nullspace
Power			Powmod				Prem
Primitive		Primpart			ProbSplit
Product			Psi				Quo
RESol			Randpoly			Randprime
Ratrecon		Re				Rem
Resultant		RootOf				Roots
SPrem			Searchtext			Shi
Si			Smith				Sqrfree
Ssi			StruveH				StruveL
Sum			Svd				TEXT
WeberE			WeierstrassP			WeierstrassPPrime
WeierstrassSigma	WeierstrassZeta			WhittakerM
WhittakerW		Zeta				abs
add			addcoords			addressof
algebraic		algsubs				alias
allvalues		anames				antisymm
applyop			applyrule			arccos
arccosh			arccot				arccoth
arccsc			arccsch				arcsec
arcsech			arcsin				arcsinh
arctan			arctanh				argument
array			assign				assigned
asspar			assume				asubs
asympt			attribute			bernstein
branches		bspline				cat
ceil			charfcn				chrem
close			close				coeff
coeffs			coeftayl			collect
combine			commutat			comparray
compiletable		compoly				conjugate
content			context				convergs
convert			coords				copy
cos			cosh				cost
cot			coth				csc
csch			csgn				currentdir
dawson			define				degree
denom			depends				diagonal
diff			diffop				dilog
dinterp			assemble			disassemble
discont			discrim				dismantle
divide			dsolve				eliminate
ellipsoid		elliptic_int			entries
eqn			erf				erfc
erfi			eulermac			eval
evala			evalapply			evalb
evalc			evalf				evalfint
evalgf			evalhf				evalm
evaln			evalr				evalrC
exp			expand				expandoff
expandon		extract				factor
factors			fclose				fdiscont
feof			fflush				filepos
fixdiv			float				floor
fnormal			fopen				forget
fortran			fprintf				frac
freeze			fremove				frontend
fscanf			fsolve				galois
gc			gcd				gcdex
genpoly			getenv				harmonic
has			hasfun				hasoption
hastype			heap				hfarray
history			hypergeom			iFFT
icontent		identity			igcd
igcdex			ilcm				ilog
ilog10			implicitdiff			indets
index			indexed				indices
inifcn			ininame				initialcondition
initialize		insert				int
intat			interface			interp
invfunc			invztrans			iostatus
iperfpow		iquo				iratrecon
irem			iroot				irreduc
iscont			isdifferentiable		isolate
ispoly			isqrfree			isqrt
issqr			latex				lattice
lcm			lcoeff				leadterm
length			lexorder			lhs
limit			ln				lnGAMMA
log			log10				lprint
map			map2				match
matrix			max				maximize
maxnorm			maxorder			member
min			minimize			minpoly
modp			modp1				modp2
modpol			mods				msolve
mtaylor			mul				nextprime
nops			norm				normal
nprintf			numboccur			numer
odetest			op				open
optimize		order				parse
patmatch		pclose				pclose
pdesolve		pdetest				pdsolve
piecewise		plot				plot3d
plotsetup		pochhammer			pointto
poisson			polar				polylog
polynom			powmod				prem
prevprime		primpart			print
printf			procbody			procmake
product			proot				property
protect			psqrt				queue
quo			radnormal			radsimp
rand			randomize			randpoly
range			rationalize			ratrecon
readbytes		readdata			readlib
readline		readstat			realroot
recipoly		rem				remove
residue			resultant			rhs
root			roots				round
rsolve			savelib				scanf
searchtext		sec				sech
select			seq				series
setattribute		shake				showprofile
showtime		sign				signum
simplify		sin				singular
sinh			sinterp				smartplot3d
solve			solvefor			sort
sparse			spline				split
splits			sprem				sprintf
sqrfree			sqrt				sscanf
ssystem			stack				string
sturm			sturmseq			subs
subsop			substring			sum
surd			symmdiff			symmetric
syntax			system				table
tan			tanh				testeq
testfloat		thaw				thiele
time			timelimit			translate
traperror		trigsubs			trunc
type			typematch			unames
unapply			unassign			unload
unprotect		userinfo			value
vector			verify				whattype
with			worksheet			writebytes
writedata		writeline			writestat
writeto			zip				ztrans
))
*/

mpl_function =
/\b(&(^|and|i(ff|mplies.)|mod|n(and|o(r|t))|or|xor)\
|A(Factor(|s)|ir(i(AiZeros|BiYZeros)|y(Ai(|Zeros)|Bi(|Zeros)))|ngerJ()\
|ppolonius\
|r(chimedean\
|e(Co(llinear()|n(c(urrent()|yclic)|jugate())|planar())|Distinct\
|Harmonic|Orthogonal|P(arallel()|erpendicular())|Similar|Tangent)))\
|B(|e(rlekamp|ssel(I()|J(|Zeros())|K()|Y(|Zeros()))|ta()))\
|C(|HFARRAY|h(i()|ristoffel(1|2))|i(|rcleOfSimilitude)|o(mpSeq|ntent)\
|ross(Product|Ratio))\
|D(|E(Sol|normal|plot(|3d)|tools)|Factor|changevar|e(finedAs()|rivedS|t)\
|i(ff()|rac()|stDeg|vide)|oubleint)\
|E(i(|genvals|nstein)\
|lliptic(C(E()|K()|Pi())|E()|F()|K()|Modulus()|Nome()|Pi())|quation()\
|ta|uler(Circle|Line)|val|x(pand()|ternalBisector))\
|F(|FT|actor(|s)|indAngle()|resnel(C()|S()|f()|g()))\
|G(|AMMA()|CRD|F()\
|I(basis|chrem|divisor|fac(poly|set|tor(|s))|gcd(|ex)|hermite|issqr|lcm\
|mcmbine|n(earest|o(div|rm(|al)))|order|p(hi|rime)|qu(adres|o)\
|r(em|oots)|s(ieve|mith|qr(free|t))|unitnormal)\
|RADIENT|auss(AGM()|Int|e(jord|lim))|cd(|ex)|ergonnePoint\
|lideReflection()\
|r(amSchmidt\
|eat(Dodecahedron|Icosahedron|Rhombi(cuboctahedron|icosidodecahedron)\
|StellatedDodecahedron)\
|oebner))\
|H(|ESSIAN|a(nkelH(1()|2())|rmonicConjugate)\
|e(aviside()|rmite|xakis(Icosahedron|Octahedron))\
|orizontal(Coord|Name)|ypersum)\
|I(m()|n(Radius|t(|erp)|verse)|rreduc\
|s(Archimedean|Equilateral()|Facetted|On(Circle|Line|Object)|Quasi\
|R(egular|ightTriangle())|Stellated|Tangent()))\
|J(|ACOBIAN\
|acobi(AM()|C(D()|N()|S())|D(C()|N()|S())|N(C()|D()|S())|S(C()|D()|N())\
|Theta(1()|2()|3()|4())|Zeta()|an)\
|ordanBlock)\
|K(elvin(Be(i()|r())|He(i()|r())|Ke(i()|r()))|illing_eqns|ummer(M()|U()))\
|L(|C(LM|S)|REtools|Udecomp|ambertW()|cm\
|e(gendre(P()|Q())|rchPhi()|vi_Civita)|i(|e(|_diff)|mit|n(eint|solve))\
|ommelS(1()|2())|rank)\
|M(|O(D2|LS)|a(jorAxis|keSquare|ple_floats|tlab(|Matrix))|eijerG()\
|i(dRadius|norAxis))\
|N(ONNEGATIVE|agelPoint|ormal(|Closure)|ullspace)|OnSegment()\
|P(|DE(changecoords|plot)|arallelLine\
|e(dalTriangle\
|nta(gonal(Hexacontahedron|Icositetrahedron)|kisDodecahedron)\
|rpen(Bisector|dicularLine))\
|o(int|l(ar|e)|w(er|mod))|r(em|im(itive|part)|o(bSplit|duct()))|si())\
|Q(Rdecomp|uo)\
|R(E(Sol|c(ontent|reate)|p(lot|rimpart)|reduceorder|to(DE|delta|proc))\
|a(dical(Axis|Center()|Line|Plane)|nd(Element|p(oly|rime))|trecon)\
|e(|gular(Poly(gon|hedron)|StarPolygon)|m|sultant)\
|hombic(Dodecahedron|Triacontahedron)|i(cci(|scalar)|emann(|F|Psols))\
|o(ot(Of|s)|senfeld_Groebner|tatoryReflection))\
|S(Prem|crewDisplacement|e(archtext|nsedMagnitude)|hi()|i(|msonLine)\
|m(all(Rhombi(cuboctahedron|icosidodecahedron)|StellatedDodecahedron)\
|ith)\
|nub(Cube|Dodecahedron)|piralRotation|qrfree|si()\
|tr(etchR(eflection|otation)|uve(H()|L()))|um(|tohyper)|vd|ylow)\
|T(|D|EXT|angent(Line|Plane)|etrakisHexahedron\
|r(apezoidal(Hexecontahedron|Icositetrahedron)\
|i(akis(Icosahedron|Octahedron|Tetrahedron)|pleint)\
|uncated(Cuboctahedron|Dodecahedron|Hexahedron|Icos(ahedron|idodecahedron)\
|Octahedron|Tetrahedron)))\
|U|Vertical(Coord|Name)\
|W(e(berE()|ierstrass(P(|Prime())|Sigma()|Zeta()|form)|yl)\
|hittaker(M()|W()))\
|Zeta()\
|a(b(elsol|s())|c(t|ycpoly)\
|d(d(|co(l|ords)|edge|r(essof|ow)|table|vertex)|j(acency|oint()))\
|l(g(curves|ebraic|subs)|ias|l(pairs|structs|values)|titude())\
|mortization\
|n(ames|cestor|gle|imate(|3d|curve)|nu(ity|l)|ova|tisymm(|etrize))\
|pply(|op|rule)\
|r(c(|c(o(s(|h())|t(|h()))|sc(|h()))|s(ec(|h())|in(|h()))|tan(|h()))\
|e(a()|conjugate)|gument()|r(ay|ivals|ow))\
|s(s(emble|ign(|ed)|par|ume)|ubs|ympt(|otes))|ttribute\
|u(gment|to(nomous|simp)))\
|b(a(cksub|nd|sis())|e(l(l|ongs_to)|qual|rn(oulli(|sol)|stein)|ta|zout)\
|i(components|gomega|nomial()|sector)|l(ackscholes|ock(|matrix))\
|oxplot|ranches|s(imp|pline)|uilds(ol|ym))\
|c(a(non(|i)|rtprod|shflows|t)|df|e(il()|nt(er()|r(alizer|oid())))\
|frac(|pol)\
|h(a(nge(_basis|coords|var)|r(acter|fcn|mat|poly()))\
|eb(deg|mult|pade|sort|yshev)|i(nisol|square)|o(l(|esky)|ose)\
|r(em|ompoly))\
|irc(le()|umcircle)|l(a(irautsol|ssmark)|ose(|link))\
|o(degen|ef(f(|icientofvariation|s)|tayl)|l(|dim|lect|spa(ce|n))\
|m(b(in(at|e())|struct)|mutat(|or)\
|p(a(nion|r(e|ray))|iletable|le(ment|te(|square)|xplot(|3d))\
|o(ly|nents|s(e|ition))))\
|n(d|e|f(ormal|racform)|ic|j(|part|ugate())|ne(ct(|ivity)|xF)\
|st(|coeffsol(|s))|t(e(nt|xt)|ourplot(|3d)|ract())\
|ve(r(gs|t(|Alg|NP|sys))|xhull()))\
|ord(inates()|plot(|3d)|s)|py(|into)|re|s(|ets|h()|rep|t())|t(|h())\
|unt(|cuts|missing|trees)|v(_diff|ariance))\
|r(eate|ossprod)|s(c(|h())|gn())|term\
|u(b(e()|o(ctahedron()|id))|mulativefrequency|r(l|rentdir|ve)|t(in|out))\
|y(cl(e(|base)|otomic)|linder(|plot)))\
|d(|1metric|2metric|a(ughter|wson)|cdf\
|e(2diffop|c(ile|lare|odepart)|f(form|in(e(|_zero|d)|ite))|gree(|seq)\
|l(cols|ete(|missing)|rows|ta(|_(leader|polynomial)))\
|n(o(m|te)|sityplot)|p(artures|ends|vars)|riv(atives|ed)|scribe\
|t(|ail()|ermine))\
|fieldplot\
|i(a(g(|onal())|meter())\
|ff(|alg|erentia(l_(ring|sprem)|te)|o(p(|2de)|rms))|l(atation|og())\
|mensions|n(ic|terp)|rect(ional_diff|rix)\
|s(assemble|c(ont|rim)|k|mantle|p(ersion|lay(|3d|GR|_allGR))\
|t(ance()|rib))\
|v(conq|erge|i(de(|by)|sors)))\
|jspantree|o(decahedron()|ntreturn|tprod)|raw()|s(egment()|olve)\
|u(al(|ity)|plicate)|value)\
|e(dges|ffectiverate|ig(|en(ring|v(alues|ectors)))\
|l(iminate|lip(s(e()|oid)|tic(Arc|_int)))\
|n(codepart|d(omorphism_charpoly|s)|t(erm(atrix|etric)|ries)|viron)\
|q(n|u(a(l(|ity)|t(e|ions))|inv))|rf(|c()|i())|ta_k|uler(|mac|sols)\
|val(|M|a(|pply)|b|c|f(|int)|gf|hf|m|n|p(|ow)|r(|C))|weight\
|x(actsol|circle|ec|p(|an(d(|o(ff|n))|sion())|onential|sols)\
|t(e(nd(|ed_gosper)|rior_(diff|p(ower|rod)))|r(act|ema)|vars)))\
|f(ac(e(s()|t)|tor(|EQ|ial|s(|et)))|close|discont|e(asible|of|rmat)\
|f(gausselim|lush|t)|glm\
|i(bonacci()|eld(_extension|plot(|3d))|lepos|n(ance|ished)|rst(lin|part)\
|t|xdiv)\
|lo(at|or()|w(|poly))|normal\
|o(c(i()|us)|pen\
|r(get()|k|m(|al_(power_series|sol)|part)|tran()|wardsub)\
|urier(|cos|sin))\
|printf|r(a(c()|me|tio)|e(eze|move|quency)|o(benius|minert|ntend))\
|s(canf|olve)|u(n(ction|dcyc)|turevalue))\
|g(a(lois|mma|uss(elim|jord))|basis|c(|d(|ex))\
|e(n(_exp|e(qns|rate_ic)|func|homosol|matrix|poly|us)\
|o(desic_eqns|m(3d|etr(icmean|y)))\
|t(_(c(har|ompts)|rank)|coeff|env|form|label|var))\
|f(eqns|s(eries|olve))|irth|osper\
|r(a(d(|plot(|3d))|ph(|ical)|ycode)|e(ater|lgroup)\
|o(up(|member|order)|wing(annuity|perpetuity)))\
|s(imp|olve)|union)\
|h(a(damard|milton_eqs|nkel|rmonic(|mean)|s(|closure|fun|option|type))\
|e(a(d|p)|misphere|rmite(|_pade)|ssian|xahedron())|farray\
|i(lbert(|dim|poly|series)|sto(gram|ry))\
|o(mo(geneous|logy()|thety())|ok|rner(|form))|transpose\
|yper(bola()|geom(|sols)|recursion|sum|term))\
|i(FFT|c(df|o(ntent|s(ahedron()|idodecahedron())))|d(cdf|entity)\
|factor(|s)|gcd(|ex)|hermite|l(cm|og(|10()))\
|m(agunit|p(licit(diff|plot(|3d))|ortdata))\
|n(ci(den(ce|t())|rcle)|d(e(gree|pvars|ts|x(|ed|func))|ic(es|ialeq)|uce)\
|equa(l|tions)|f(gen|norm)\
|i(fcn|name|t(|ial(|_conditions|condition|ize)))|nerprod|sert\
|t(|at|basis\
|e(gra(l_basis()|nd|te_sols)|r(|_reduce|cept|face|p|section()))|factor\
|parts|rep2maple|t(ovec|rans))\
|v(|ars|cfrac|er(s(e()|ion())|t)|f(ourier|unc)|hilbert|laplace|mellin\
|p(erm|hi)|ztrans))\
|ostatus|perfpow|quo|r(atrecon|em|oot|reduc)\
|s(_(finite|orthonomic|solvable)|abelian|cont|differentiable|mith|normal\
|ol(ate()|ve)|p(lanar|oly|rime)|qr(free|t)|s(imilar|qr(|free)|ubgroup)\
|zero)\
|t(erstructs|hprime))\
|j(_invariant|acobi(|an)|o(inprocs|rdan))\
|k(ernel|ill|ovacicsols|ronecker|urtosis)\
|l(a(mbda|plac(e|ian)|stpart|t(ex|tice)|urent)|c(m|oeff(|p))\
|e(a(d(coeff|er|mon|term())|st(mediansquare|sq(rs|uare)))\
|ft(box|division|sum)|gendre|ngth|velcoupon|xorder)\
|hs\
|i(es(ol|ymm)|mit|n(_com|alg|e(|_int|ar(correlation|sol))|solve)\
|st(contplot(|3d)|densityplot|plot(|3d)))\
|n(|GAMMA())|o(g(|10()|ic|logplot|plot)|wer)|print|u)\
|m(a(ke(forms|global|p(aram|roc())|void)|p(|2|le2intrep)\
|t(add|ch|rix(|DE|plot))|x(|degree|imize()|norm|order))\
|combine|e(an(|deviation)|dia(l|n())|llin|mber|rsenne|t(hod|ric))\
|i(d(dle(box|sum)|point())|n(|cut|degree|im(ax|ize())|kowski|or|poly())\
|polys|xpar())\
|log|o(bius|d(e|p(|1|2|ol)|s)|ment|ving)|root|s(olve|qrt)|taylor\
|ul(|col|perms|t(|const|i(apply|nomial|ply()))))\
|n(e(arestp|gative|ighbors|tworks|w|xt(p(art|rime())|struct))\
|o(ps|rm(|al(|d|f|ize(|r))))|p(curve|rintf|spin)\
|th(conver|denom|numer|pow)\
|um(approx|b(com(b|p)|occur|p(art|erm))|er|theory))\
|o(ctahedron()|de(45|advisor|p(de|lot)|test)|neway\
|p(|en(|link)|timize())|r(bit|d(er(|ing|p)|p)|tho(center|g|poly))\
|utdegree)\
|p(a(ck(args|locals)|d(e|ic)\
|r(a(bola|llel()|metri(csol|zation))|eto|ity|se|ti(al_diff|tion))\
|t(h|match))\
|close()|d(e(solve|test|xpand)|f|solve)\
|e(r(centile|m(anent|group|rep|ute(|_indices))|petuity)|t(ersen|rov))\
|f|h(aseportrait|i)|i(e(cewise|slice)|pe|vot(|eqn|var))\
|l(ane|ot(|3d|_knot|s(|etup)|tools))\
|o(chhammer()|i(n(care|t(|plot(|3d)|to))|sson)\
|l(ar(|plot)|e\
|y(gon(|plot(|3d))|hedra(_supported|plot)|log()|nom|sols()))\
|pen|tential\
|w(add|c(os|reate)|diff|e(r(_series_solution|p(c|s)|set)|xp)|int|log|mod\
|poly|s(eries()|in|olve|qrt|ubs)))\
|primroot\
|r(e(m|p2trans|s(|entvalue)|tend_gbasis|vp(art|rime()))\
|i(m(part|root)|nt(|_ranking|f))\
|o(c(body|ess|make)|d(|uct)|ject(|ion())|long|ot|perty|tect))\
|sqrt|uiseux)\
|q(r|u(a(dr(aticmean|es)|ntile|rtile)|eue|o(|tient)))\
|r(a(d(ius()|normal|simp)|ise\
|n(d(|bool|comb|matrix|om(|ize)|p(art|erm|o(int()|ly))|vector)|ge()\
|k(|poly))\
|t(io(|nalize)|polysols|recon|sols|valuep))\
|e(a(d(bytes|data|li(b|ne)|stat)|lroot)|c(ip(oly|rocation)|tangle)\
|duce(|Order|d(|_form))|f(erences|lect(|ion()))|gularsp|m(|ez|ove)\
|namevar|plot|s(idue|ultant)|version|write_rules)\
|gf_(charseq|e(ncode|xpand)|findrecur|hybrid|norm|pfrac|relate\
|s(equence|imp)|term)\
|hs|i(ccati(|sol)|ght(box|division|sum))\
|o(ot(|locus|p|s(|unity))|tat(e|ion())|und()|w(|dim|spa(ce|n)))|solve)\
|s(a(feprime|tisfy|ve(lib|table))\
|c(a(l(ar(|mul|part)|e(|weight))|nf|tterplot)|hlafli())\
|e(archtext|c(|h())|gment()|lect|mi(logplot|torus)|para(blesol|nt)|q\
|ries|t(attribute|options(|3d)|up()|var))\
|h(ake|ift|o(rtpathtree|w(|profile|t(angent|ime)))|rink)\
|i(des()|g(ma|n(|um()))|m(ilitude|p(comb|form|l(ex|ify)|son))\
|n(|gular(|ities|vals)|h()|terp)|ze)\
|kewness|lope()|m(artplot3d|ith)|o(lve(|for)|rt)\
|p(a(cecurve|n(|poly|tree)|rse(|matrixplot))|here(|plot)|li(ne|t(|s))\
|oly|r(em|intf))\
|q(2factor|r(free|t())|uare())|s(canf|ystem)\
|t(a(ck(|matrix)|ndard(deviation|ize|score)|t(evalf|plots|s(|ort)|value))\
|ellate()|irling(1|2)|r(etch|ing)|u(dent(|st)|rm(|seq)))\
|u(b(grel|matrix|s(|ets|op|tring)|tract(|from)|vector)\
|m(|2sqr|basis|data|mand|recursion|to(hyper|ols))|r(d()|fdata))\
|wap(args|col|row)\
|y(lvester|m(gen|m(diff|etri(c(|_p(ower|roduct))|ze))|test)|ntax|stem))\
|t(a(ble()|il|lly(|into)|n(|gentpc|h())|ssume|u(|tology)|ylor)\
|e(nsor(|sGR)|rm(order|scale)|st(eq|float|order)|trahedron()|xtplot(|3d))\
|h(aw|iele|ue)|i(me(|limit)|s)|name|o(eplitz|inert|rus|torder)|psform\
|r(a(ce|ns(form()|grp|inv|lat(e()|ion())|p(ose()|rod))|pe(rror|zoid))\
|i(angle()|gsubs)|unc())\
|u(beplot|ttepoly)|ype(|match))\
|u(n(a(mes|pply|ssign)|ivpoly|load|protect|translate)|serinfo)\
|v(a(lue(|p)|ndermonde|r(iance|param))|degree\
|e(c(potent|t(dim|o(int|r())))|r(ify|t(ex|ices())))|fix|o(id|lume())\
|weight)\
|w(ait|collect|degree()|edge(|set)|hattype|ith|orksheet\
|r(ite(bytes|data|line|stat|to)|onskian)|subs)\
|x(coord|name|s(cale|hift)|yexchange)\
|y(coord|ieldtomaturity|name|s(cale|hift)|zexchange())\
|z(coord|ip|name|oom|s(cale|hift)|trans))\b/;

state mpl_string extends Highlight
{
  /\\\\./ {
    language_print ($0);
  }
  /[\"]/ {
    language_print ($0);
    return;
  }
}

state mpl_unev extends Highlight
{
  /\\\\./ {
    language_print ($0);
  }
  /[\']/ {
    language_print ($0);
    return;
  }
}

state maple extends HighlightEntry
{
  /* Comments */
  /#/ {
    comment_face (true);
    language_print ($0);
    call (eat_one_line);
    comment_face (false);
  }

  /* Assignment */
  /\:=/ {
    keyword_face (true);
    language_print ($0);
    keyword_face (false);
  }

  /* Continuation */
  /\.\./ {
    keyword_face (true);
    language_print ($0);
    keyword_face (false);
  }

  /* Typematch */
  /\:\:/ {
    keyword_face (true);
    language_print ($0);
    keyword_face (false);
  }

  /* Matrix start */
  /\[/ {
    type_face (true);
    language_print ($0);
    type_face (false);
  }

  /* Matrix end */
  /\]/ {
    type_face (true);
    language_print ($0);
    type_face (false);
  }

  /* Function */
  mpl_function {
    type_face (true);
    language_print ($0);
    type_face (false);
  }

  /* Keyword */
  mpl_keyword {
     keyword_face (true);
     language_print($0);
     keyword_face (false);
  }

  /* Function definition */
  /^([a-zA-Z_][a-zA-Z_0-9]*)([ \t]*\:=[ \t]*)(proc)([ \t]*\()/ {
    function_name_face (true);
    language_print ($1);
    function_name_face (false);

    keyword_face (true);
    language_print ($2);
    language_print ($3);
    keyword_face (false);

    language_print ($4);
  }

  /* Strings */
  /* "any number of characters" */
  /[\"]/ {
    string_face (true);
    language_print ($0);
    call (mpl_string);
    string_face (false);
  }

  /* Unevaluated expression */
  /* 'any number of characters' */
  /[\']/ {
    variable_name_face (true);
    language_print ($0);
    call (mpl_unev);
    variable_name_face (false);
  }

  /* Ignore escaped quote marks */
  /\\\"/ {
    language_print ($0);
  }
  /\\\'/ {
    language_print ($0);
  }
}


/*
Local variables:
mode: c
End:
*/
