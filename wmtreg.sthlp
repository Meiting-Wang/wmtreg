{smcl}

{* -----------------------------title------------------------------------ *}{...}
{p 0 17 2}
{bf:[W-4] wmtreg} {hline 2} output regression result to Stata interface, Word as well as LaTeX. The source code can be gained in {browse "https://github.com/Meiting-Wang/wmtreg":github}.


{* -----------------------------Syntax------------------------------------ *}{...}
{title:Syntax}

{p 8 8 2}
{bf:wmtreg} [{it:est_store_names}] [using {it:filename}] [, {it:options}]

{p 4 4 2}
where the subcommands can be :

{p2colset 5 28 32 2}{...}
{p2col :{it:subcommand}}Description{p_end}
{p2line}
{p2col :{opt est_store_names}}Enter the name of the stored regression result, supporting wildcards(*?). Import all stored regression results by default{p_end}
{p2col :{opt {help using}}}output the result to Word with .rtf file or LaTeX with .tex file{p_end}
{p2line}
{p2colreset}{...}


{* -----------------------------Contents------------------------------------ *}{...}
{title:Contents}

{p 4 4 2}
{help wmtreg##Description:Description}{break}
{help wmtreg##Options:Options}{break}
{help wmtreg##Examples:Examples}{break}
{help wmtreg##Author:Author}{break}
{help wmtreg##Also_see:Also see}{break}


{* -----------------------------Description------------------------------------ *}{...}
{marker Description}{title:Description}

{p 4 4 2}
{bf:wmtreg}, based on esttab, can output Regression result to Stata interface, Word as well as LaTeX. User can use this command easily due to its simple syntax. It is worth noting that this command can only be used in version 15.1 or later.

{p 4 4 2}
Users can also append the output from {bf:wmtreg} to a existed word or LaTeX document,
which is more likely to be generated by {help wmtsum}, {help wmttest}, {help wmtcorr} and {help wmtmat}.


{* -----------------------------Options------------------------------------ *}{...}
{marker Options}{title:Options}

{p2colset 5 29 33 2}{...}
{p2col :{it:option}}Description{p_end}
{p2line}
{p2col :For all}{p_end}
{p2col :{space 2}{opth d:rop(varlist)}}Do not report specified variables{p_end}
{p2col :{space 2}{opth k:eep(varlist)}}Report specified variables only{p_end}
{p2col :{space 2}{opth o:rder(varlist)}}Place specified variables at the top of the table{p_end}
{p2col :{space 2}{opt varl:abels(matchlist)}}Change the display name of the variable in the table{p_end}
{p2col :{space 2}{bf:b(}{it:{help format:fmt}}{bf:)}}Report ordinary regression coefficients{p_end}
{p2col :{space 2}{bf:beta(}{it:{help format:fmt}}{bf:)}}Report standardized regression coefficients{p_end}
{p2col :{space 2}{bf:se(}{it:{help format:fmt}}{bf:)}}Report the standard error below the regression coefficient{p_end}
{p2col :{space 2}{bf:t(}{it:{help format:fmt}}{bf:)}}Report the t-value below the regression coefficient{p_end}
{p2col :{space 2}{bf:p(}{it:{help format:fmt}}{bf:)}}Report the p-value below the regression coefficient{p_end}
{p2col :{space 2}{opt onlyb}}Report the regression coefficient only{p_end}
{p2col :{space 2}{opt staraux}}Set the star on the standard error or t-value or p-value{p_end}
{p2col :{space 2}{opt nostar}}Do not report the star{p_end}
{p2col :{space 2}{opth ind:icate(strings:string)}}Do not report the coefficient of variables, just show whether these variables exist using Yes or No{p_end}
{p2col :{space 2}{opth s:calars(strings:string)}}{bf:r2}, {bf:ar2}, {bf:pr2}, {bf:aic}, {bf:bic}, {bf:F}, {bf:ll} and {bf:N} are permitted, {bf:r2} and {bf:N} as the default. all of these scalars can be set the format like this: r2(%9.3f){p_end}
{p2col :{space 2}{opt nonum:bers}}Do not report the serial number of each regression or estimation{p_end}
{p2col :{space 2}{opt nomt:itles}}Do not report the title of each regression or estimation{p_end}
{p2col :{space 2}{opth mt:itles(strings:string)}}Customize mtitles. Besides, dependent variables as mtitles in {bf:depvars} and names of regression models as mtitles in {bf:esn}, {bf:depvars} as the default.{p_end}
{p2col :{space 2}{opth ti:tle(strings:string)}}Set the title for the table, {bf:Regression result} as the default{p_end}
{p2col :{space 2}{opth mg:roups(strings:string)}}Set up grouping and set group names for these regression models{p_end}
{p2col :{space 2}{opt replace}}Replace a file if it already exists{p_end}
{p2col :{space 2}{opt append}}Append the result to a already existed file{p_end}

{p2col :For LaTeX only}{p_end}
{p2col :{space 2}{opth a:lignment(strings:string)}}Format the table columns in LaTeX, but it will not have influence on the Stata interface. {bf:math} or {bf:dot} can be included, {bf:math} as the default{p_end}
{p2col :{space 2}{bf:page(}{it:{help strings:string}}{bf:)}}Set the extra package for the LaTeX. Don't need to care about the package of booktabs, array and dcolumn, because option {bf:alignment} will deal with it automatically{p_end}
{p2line}
{p2colreset}{...}


{* -----------------------------Examples------------------------------------ *}{...}
{marker Examples}{title:Examples}

{p 4 4 2}Setup{p_end}
{p 8 8 2}. {stata sysuse auto.dta, clear}{break}
. {stata gen lprice = ln(price)}{break}
. {stata tab rep78, gen(rep78_num)}{break}
. {stata drop rep78_num1}{break}
. {stata reg lprice mpg headroom}{break}
. {stata est store m1}{break}
. {stata reg lprice mpg trunk headroom}{break}
. {stata est store m2}{break}
. {stata reg lprice mpg trunk headroom rep78_num*}{break}
. {stata est store m3}{break}
. {stata reg lprice mpg trunk headroom foreign rep78_num*}{break}
. {stata est store m4}{p_end}

{p 4 4 2}Report all saved regression results{p_end}
{p 8 8 2}. {stata wmtreg}{p_end}

{p 4 4 2}Report specified regression results{p_end}
{p 8 8 2}. {stata wmtreg m1 m2 m3 m4}{p_end}

{p 4 4 2}Do not report constant terms{p_end}
{p 8 8 2}. {stata wmtreg m?, drop(_cons)}{p_end}

{p 4 4 2}Only report regression coefficients of specified variables{p_end}
{p 8 8 2}. {stata wmtreg m?, keep(mpg headroom trunk)}{p_end}

{p 4 4 2}Place specified variables at the top of the table{p_end}
{p 8 8 2}. {stata wmtreg m?, order(foreign mpg)}{p_end}

{p 4 4 2}Change the display name of the variable in the table{p_end}
{p 8 8 2}. {stata wmtreg m?, varl(mpg mpgtest trunk trunktest)}{p_end}

{p 4 4 2}Set the format of regression coefficients and standard errors{p_end}
{p 8 8 2}. {stata wmtreg m?, b(%9.2f) se(%9.3f)}{p_end}

{p 4 4 2}Set the indication for the rep78_num* and foreign{p_end}
{p 8 8 2}. {stata wmtreg m?, ind("rep78=rep78_num*" "foreign=foreign")}{p_end}

{p 4 4 2}Report the specified scalars and customize its numeric format{p_end}
{p 8 8 2}. {stata wmtreg m?, s(r2(%9.3f) F N(%9.0fc))}{p_end}

{p 4 4 2}Set up grouping and set group names for these regression models{p_end}
{p 8 8 2}. {stata wmtreg m?, mg(Group1 Group2 2 2)}{p_end}

{p 4 4 2}Output the result to a .rtf file{p_end}
{p 8 8 2}. {stata wmtreg m? using Myfile.rtf, replace}{p_end}

{p 4 4 2}Output the result to a .tex file{p_end}
{p 8 8 2}. {stata wmtreg m? using Myfile.tex, replace}{p_end}

{p 4 4 2}Format table column in LaTeX to decimal point alignment{p_end}
{p 8 8 2}. {stata wmtreg m? using Myfile.tex, replace a(dot)}{p_end}


{* -----------------------------Author------------------------------------ *}{...}
{marker Author}{title:Author}

{p 4 4 2}
Meiting Wang{break}
School of Economics, South-Central University for Nationalities{break}
Wuhan, China{break}
wangmeiting92@gmail.com


{* -----------------------------Also see------------------------------------ *}{...}
{marker Also_see}{title:Also see}

{space 4}{help esttab}(already installed)   {col 40}{stata ssc install estout:install esttab}(to install)
{space 4}{help wmtsum}(already installed)   {col 40}{stata github install Meiting-Wang/wmtsum:install wmtsum}(to install)
{space 4}{help wmttest}(already installed)  {col 40}{stata github install Meiting-Wang/wmttest:install wmttest}(to install)
{space 4}{help wmtcorr}(already installed)  {col 40}{stata github install Meiting-Wang/wmtcorr:install wmtcorr}(to install)
{space 4}{help wmtmat}(already installed)   {col 40}{stata github install Meiting-Wang/wmtmat:install wmtmat}(to install)
