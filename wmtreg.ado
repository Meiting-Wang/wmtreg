* Description: output regression result to Stata interface, Word and LaTeX
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: wangmeiting92@gmail.com
* Created on May 8, 2020


program define wmtreg
version 15.1

syntax [anything] [using/] [, ///
	replace append Drop(string) Keep(string) Order(string) VARLabels(string asis) B ///
	Bfmt(string) BETA BETAfmt(string) SE SEfmt(string) T Tfmt(string) P Pfmt(string) ONLYB ///
	STARAUX NOSTAR INDicate(string asis) Scalars(string) NONUMbers NOMTitles ///
	MTitles(string asis) TItle(string) MGroups(string asis) Alignment(string) PAGE(string)]


*--------设置默认格式------------
*Stata界面显示和Word输出默认格式
local N_default_fmt "%11.0f"
local others_default_fmt "%11.3f"

*LaTeX默认输出格式
local N_default_la_fmt "%11.0fc"
local others_default_la_fmt "%11.3fc"

*scalars()内部语句默认值
if "`scalars'" == "" {
	local scalars "r2 N"
}

*---------程序不合规时的报错-----------
if ("`replace'`append'"!="")&("`using'"=="") {
	dis "{error:replace or append can't appear when you don't need to output result to a file.}"
	exit
}

if ("`replace'"!="")&("`append'"!="") {
	dis "{error:replace and append cannot appear at the same time.}"
	exit
}

if ("`drop'"!="")&("`keep'"!="") {
	dis "{error:drop and keep cannot appear at the same time.}"
	exit
}

if ("`b'`bfmt'"!="")&("`beta'`betafmt'"!="") {
	dis "{error:b and beta cannot appear at the same time.}"
	exit
}

if ("`se'`sefmt'"!="")&("`t'`tfmt'"!="") {
	dis "{error:se and t cannot appear at the same time.}"
	exit
}
if ("`se'`sefmt'"!="")&("`p'`pfmt'"!="") {
	dis "{error:se and p cannot appear at the same time.}"
	exit
}
if ("`t'`tfmt'"!="")&("`p'`pfmt'"!="") {
	dis "{error:t and p cannot appear at the same time.}"
	exit
}

if ("`onlyb'"!="")&("`se'`sefmt'"!="") {
	dis "{error:onlyb and se cannot appear at the same time.}"
	exit
}
if ("`onlyb'"!="")&("`t'`tfmt'"!="") {
	dis "{error:onlyb and t cannot appear at the same time.}"
	exit
}
if ("`onlyb'"!="")&("`p'`pfmt'"!="") {
	dis "{error:onlyb and p cannot appear at the same time.}"
	exit
}

if ("`staraux'"!="")&("`onlyb'"!="") {
	dis "{error:staraux and onlyb cannot appear at the same time.}"
	exit
}

if ("`staraux'"!="")&("`nostar'"!="") {
	dis "{error:staraux and nostar cannot appear at the same time.}"
	exit
}

if ("`nomtitles'"!="")&(`"`mtitles'"'!="") {
	dis "{error:nomtitles and mtitles() cannot appear at the same time.}"
	exit
}

if (~ustrregexm("`using'",".tex"))&("`alignment'`page'"!="") { 
	dis "{error:alignment and page can only be used in the LaTeX output.}"
	exit
}

*---------前期语句处理----------
*普通选项语句的处理
qui est dir `anything'
local anything "`r(names)'"
local anything_num: word count `anything'
//如果`anything'为空，则导入所有储存好的估计结果名称；在输入名称时支持通配符*?


if "`using'" != "" {
	local us_ing "using `using'"
}

if "`title'" == "" {
	local title "Regression result"
}

*drop、keep、order语句构建
if "`drop'" != "" {
	local st_dko "drop(`drop') "
}
else if "`keep'" != "" {
	local st_dko "keep(`keep') "
}
if "`order'" != "" {
	local st_dko "`st_dko'order(`order')"
}

*varlabels语句构建
if `"`varlabels'"' != "" {
	local varl_st `"varlabels(`varlabels')"'
}

*b、beta、se、t、p、onlyb选项语句构建
if "`beta'`betafmt'" != "" {
	local b_coef "beta"
}
else {
	local b_coef "b"
} //默认显示b

if "`t'`tfmt'" != "" {
	local se_coef "t"
}
else if "`p'`pfmt'" != "" {
	local se_coef "p"
}
else {
	local se_coef "se"
} //默认显示se

if "`onlyb'" != "" {
	if ustrregexm("``b_coef'fmt'", "\d") {
		local st_bstpo "`b_coef'(``b_coef'fmt') not"
		local st_la_bstpo "`b_coef'(``b_coef'fmt') not"
	} //b自定义fmt
	else {
		local st_bstpo "`b_coef'(`others_default_fmt') not"
		local st_la_bstpo "`b_coef'(`others_default_la_fmt') not"
	} //b默认fmt
}
else {
	if ustrregexm("``b_coef'fmt'", "\d") {
		local st_bstpo "`b_coef'(``b_coef'fmt') "
		local st_la_bstpo "`b_coef'(``b_coef'fmt') "
	} //b自定义fmt
	else {
		local st_bstpo "`b_coef'(`others_default_fmt') "
		local st_la_bstpo "`b_coef'(`others_default_la_fmt') "
	} //b默认fmt
	if ustrregexm("``se_coef'fmt'", "\d") {
		local st_bstpo "`st_bstpo'`se_coef'(``se_coef'fmt')"
		local st_la_bstpo "`st_la_bstpo'`se_coef'(``se_coef'fmt')"
	} //se类自定义fmt
	else {
		local st_bstpo "`st_bstpo'`se_coef'(`others_default_fmt')"
		local st_la_bstpo "`st_la_bstpo'`se_coef'(`others_default_la_fmt')"
	} //se类默认fmt
}

*star语句构建
if "`nostar'" != "" {
	local st_star "`nostar'"
}
else if "`staraux'" != "" {
	local st_star "`staraux' star(* 0.1 ** 0.05 *** 0.01)"
}
else {
	local st_star "star(* 0.1 ** 0.05 *** 0.01)"
} //star的默认格式

*indicate语句构建
if `"`indicate'"' != "" {
	local st_ind `"indicate(`indicate')"'
	local st_ind_la `"indicate(`indicate',labels(\multicolumn{1}{c}{Yes} \multicolumn{1}{c}{No}))"'
}

*scalars()语句构建
//`scalars'的预处理1——将不必要的空格用"-"填充
tokenize "`scalars'", parse("()")
local scalars ""
local i = 1
while "``i''" != "" {
	if (mod(`i'+1,4)==0) {
		local `i' = ustrregexra("``i''"," ","-")
	}
	if (mod(`i',4)==0) {
		local `i' "``i'' "
	}
	local scalars "`scalars'``i''"
	local `i' "" //置空`i'
	local i = `i' + 1
}
local scalars = ustrtrim("`scalars'")

//`scalars'的预处理2——将"r2 ar2 pr2 aic bic"与"F、ll、N"分开
tokenize "`scalars'"
local i = 1
local st_r2 ""
local st_F ""
while "``i''" != "" {
	local `i' = ustrregexra("``i''","-+","")
	if ustrregexm("``i''", "(r2)|(ar2)|(pr2)|(aic)|(bic)") {
		local st_r2 "`st_r2'``i'' "
	}
	else if ustrregexm("``i''", "(F)|(ll)|(N)") {
		local st_F "`st_F'``i'' "
	}
	else {
		local `i' = ustrregexra("``i''","\(.*","")
		dis "{error:``i'' isn't one of the scalars.}"
		exit
	}
	local `i' "" //置空`i'
	local i = `i' + 1
}
local st_r2 = ustrtrim("`st_r2'")
local st_F = ustrtrim("`st_F'")

//`scalars'的正式处理1——st_r2
tokenize "`st_r2'"
local i = 1
local st_r2_formal ""
local st_r2_formal_la ""
while "``i''" != "" {
	if ustrregexm("``i''", "\(") {
		local st_r2_formal "`st_r2_formal'``i'' "
		local st_r2_formal_la "`st_r2_formal_la'``i'' "
	}
	else {
		local st_r2_formal "`st_r2_formal'``i''(`others_default_fmt') "
		local st_r2_formal_la "`st_r2_formal_la'``i''(`others_default_la_fmt') "
	}
	local `i' "" //置空`i'
	local i = `i' + 1
}
local st_r2_formal = ustrtrim("`st_r2_formal'")
local st_r2_formal_la = ustrtrim("`st_r2_formal_la'")

//`scalars'的正式处理2——st_F
local F_1 "F"
local F_2 "ll"
local F_3 "N"

tokenize "`st_F'"
local i = 1
local st_F_pure ""     //esttab中scalars()语句
local st_F_fmt ""      //esttab中sfmt()语句(Stata界面和Word)
local st_F_fmt_la ""   //esttab中sfmt()语句(LaTeX)
while "``i''" != "" {
	if ustrregexm("``i''", "N") {
		local default_fmt "`N_default_fmt'"
		local default_la_fmt "`N_default_la_fmt'"
	}
	else {
		local default_fmt "`others_default_fmt'"
		local default_la_fmt "`others_default_la_fmt'"
	}
	local j = 1
	while "`F_`j''" != "" {
		if ustrregexm("``i''", "`F_`j''") {
			local st_F_pure "`st_F_pure'`F_`j'' "
			if ustrregexm("``i''", "\d") {
				local fmt = ustrregexrf("``i''",".*\(","") //将左括号及之前的内容移除
				local fmt = ustrregexrf("`fmt'","\)","") //将右括号移除
				local st_F_fmt "`st_F_fmt'`fmt' "
				local st_F_fmt_la "`st_F_fmt_la'`fmt' "
			}
			else {
				local st_F_fmt "`st_F_fmt'`default_fmt' "
				local st_F_fmt_la "`st_F_fmt_la'`default_la_fmt' "
			}
		}
		local j = `j' + 1
	}
	local `i' "" //置空`i'
	local i = `i' + 1
}
local st_F_pure = ustrtrim("`st_F_pure'")
local st_F_fmt = ustrtrim("`st_F_fmt'")
local st_F_fmt_la = ustrtrim("`st_F_fmt_la'")
if "`st_F'" != "" {
	local st_F_pure "scalars(`st_F_pure')"
	local st_F_fmt "sfmt(`st_F_fmt')"
	local st_F_fmt_la "sfmt(`st_F_fmt_la')"
}

*mtitles语句的构建
if "`nomtitles'" != "" {
	local st_mt "`nomtitles'"
}
else if (`"`mtitles'"'=="depvars")|(`"`mtitles'"'=="") {
	local st_mt "depvars"
} //默认值
else if `"`mtitles'"' == "esn" {
	local st_mt "mtitles(`anything')"
}
else {
	//`mtitles'语句初步处理(可将"A1 A2" F "C1 C2" B处理成A1-A2 F C1-C2 B，以计算其组数)
	local mtitles = ustrregexra(`"`mtitles'"',"\s+","-")
	local mtitles = ustrregexra(`"`mtitles'"',`"""',"(")
	tokenize "`mtitles'", p("(")
	if "`1'" == "(" {
		local i = 1
		local mtitles ""
		while "``i''" != "" {
			if mod(`i'+2,4)==0 {
				local mtitles "`mtitles'``i'' "
			}
			else {
				local `i' = ustrregexra("``i''","(\()|(-)"," ")
				local mtitles "`mtitles'``i'' "
			}
			local `i' "" //置空`i'
			local i = `i' + 1
		}
	}
	else {
		local i = 1
		local mtitles ""
		while "``i''" != "" {
			if mod(`i'+1,4)==0 {
				local mtitles "`mtitles'``i'' "
			}
			else {
				local `i' = ustrregexra("``i''","(\()|(-)"," ")
				local mtitles "`mtitles'``i'' "
			}
			local `i' "" //置空`i'
			local i = `i' + 1
		}
	}
	//`mtitles'语句正式处理：生成esttab中的mtitles()语句
	local mtitles_num: word count `mtitles'
	if `mtitles_num' != `anything_num' {
		dis "{error:the number of mtitles can't match the number of models}"
		exit
	}
	tokenize "`mtitles'"
	local i = 1
	local mtitles ""
	while "``i''" != "" {
		if ustrregexm("``i''", "-") {
			local `i' = ustrtrim(ustrregexra("``i''","-"," "))
			local `i' `""``i''""'
		}
		local mtitles `"`mtitles'``i'' "'
		local `i' "" //置空`i'
		local i = `i' + 1
	}
	local mtitles = ustrtrim(`"`mtitles'"')
	local st_mt `"mtitles(`mtitles')"'
} //自定义值

*mgroups()语句构建
if `"`mgroups'"' != "" {
	//`mgroups'语句初步处理(可将"A1 A2" F "C1 C2" B 2 1 1 3 处理成 A1-A2 F C1-C2 B 2 1 1 3)
	local mgroups = ustrregexra(`"`mgroups'"',"\s+","-")
	local mgroups = ustrregexra(`"`mgroups'"',`"""',"(")
	tokenize "`mgroups'", p("(")
	if "`1'" == "(" {
		local i = 1
		local mgroups ""
		while "``i''" != "" {
			if mod(`i'+2,4)==0 {
				local mgroups "`mgroups'``i'' "
			}
			else {
				local `i' = ustrregexra("``i''","(\()|(-)"," ")
				local mgroups "`mgroups'``i'' "
			}
			local `i' "" //置空`i'
			local i = `i' + 1
		}
	}
	else {
		local i = 1
		local mgroups ""
		while "``i''" != "" {
			if mod(`i'+1,4)==0 {
				local mgroups "`mgroups'``i'' "
			}
			else {
				local `i' = ustrregexra("``i''","(\()|(-)"," ")
				local mgroups "`mgroups'``i'' "
			}
			local `i' "" //置空`i'
			local i = `i' + 1
		}
	}
	
	//`mgroups'语句正式处理：生成esttab中的mgroups()语句
	local mg_element_num: word count `mgroups'
	local mg_element_half_num = `mg_element_num'/2
	if mod(`mg_element_num',2) {
		dis "{error:the number of group names can't match the number of digits in mgroups().}"
		exit
	}
	tokenize "`mgroups'"
	local i = 1
	local st_mg_name ""
	local st_mg_pattern ""
	local num_total = 0
	while "``i''" != "" {
		if `i' <= `mg_element_half_num' {
			if ustrregexm("``i''", "-") {
				local `i' = ustrtrim(ustrregexra("``i''","-"," "))
				local `i' `""``i''""'
			}			
			local st_mg_name `"`st_mg_name'``i'' "'
		}
		else {
			if ~ustrregexm("``i''", "\b\d\b") {
				dis "{error:the number of columns should be an integer between 1 and 5.}"
				exit
			}
			else if (``i''==0)|(``i''>5) {
				dis "{error:the number of columns should be an integer between 1 and 5.}"
				exit
			}
			if ``i'' == 1 {
				local st_mg_sub_pattern "1"
			}
			else if ``i'' == 2 {
				local st_mg_sub_pattern "1 0"
			}
			else if ``i'' == 3 {
				local st_mg_sub_pattern "1 0 0"
			}
			else if ``i'' == 4 {
				local st_mg_sub_pattern "1 0 0 0"
			}
			else {
				local st_mg_sub_pattern "1 0 0 0 0"
			}
			local num_total = `num_total' + ``i''
			local st_mg_pattern "`st_mg_pattern'`st_mg_sub_pattern' "
		}
		local `i' "" //置空`i'
		local i = `i' + 1
	}
	local st_mg_name = ustrtrim(`"`st_mg_name'"')
	local st_mg_pattern = ustrtrim(`"`st_mg_pattern'"')
	
	if `num_total' != `anything_num' {
		dis "{error:total number of columns needed in the mgroups() can't match the number of models.}"
		exit
	}	
	local st_mg `"mgroups(`st_mg_name', pattern(`st_mg_pattern'))"'
	local st_mg_la `"mgroups(`st_mg_name', pattern(`st_mg_pattern') span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span}))"'
}

*构建esttab中alignment()和page()内部的语句(LaTeX输出专属)
if "`alignment'" == "" {
	local alignment "math"
} //设置默认下的alignment

if "`page'" != "" {
	local page ",`page'"
}

if "`alignment'" == "math" {
	local page "array`page'"
	local alignment ">{$}c<{$}"
}
else {
	local page "array,dcolumn`page'"
	local alignment "D{.}{.}{-1}"
}
//加上array宏包可使得表格线之间的衔接没有空缺


*---------------------主程序--------------------------------
/*
前面已经构建好的语句如下：
1. drop、keep、order语句构建
	(1) st_dko: 通用
2. varlabels语句构建
	(1) varl_st: 通用
3. b、beta、se、t、p、onlyb选项语句构建
	(1) st_bstpo: Stata界面和Word
	(2) st_la_bstpo: LaTeX
4. star语句构建
	(1) st_star: 通用
5. indicate语句构建
	(1) st_ind: Stata界面和Word
	(2) st_ind_la: LaTeX
6. scalars()语句构建
	(1) st_r2_formal: Stata界面和Word
	(2) st_r2_formal_la: LaTeX
	(3) st_F_pure: 通用
	(4) st_F_fmt: Stata界面和Word
	(5) st_F_fmt_la: LaTeX
7. mtitles语句构建
	(1) st_mt: 通用
8. mgroups语句构建
	(1) st_mg: Stata界面和Word
	(2) st_mg_la: LaTeX
*/
esttab `anything', compress ///
	nogaps noobs `st_dko' `varl_st' `st_bstpo' `st_star' `st_ind' `st_r2_formal' ///
	`st_F_pure' `st_F_fmt' `st_mt' `nonumbers' title(`title') `st_mg' //Stata 界面显示
if ustrregexm("`us_ing'",".rtf") {
	esttab `anything' `us_ing', compress `replace'`append' ///
		nogaps noobs `st_dko' `varl_st' `st_bstpo' `st_star' `st_ind' `st_r2_formal' ///
		`st_F_pure' `st_F_fmt' `st_mt' `nonumbers' title(`title') `st_mg'
} //Word 显示
if ustrregexm("`us_ing'",".tex") { 
	esttab `anything' `us_ing', compress `replace'`append' ///
		nogaps noobs `st_dko' `varl_st' `st_la_bstpo' `st_star' `st_ind_la' `st_r2_formal_la' ///
		`st_F_pure' `st_F_fmt_la' `st_mt' `nonumbers' title(`title') `st_mg_la' ///
		booktabs width(\hsize) page(`page') alignment(`alignment')
} //LaTeX 显示
end
