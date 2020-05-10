# Stata 新命令：wmtreg——回归结果的输出

> 作者：王美庭  
> Email: wangmeiting92@gmail.com

## 摘要

本文主要介绍了个人编写的可将回归结果输出至 Stata 界面、Word 以及 LaTeX 的`wmtreg`命令。

## 目录

- **摘要**
- **一、引言**
- **二、命令的安装**
- **三、语法与选项**
- **四、实例**
- **五、输出效果展示**

## 一、引言

本文介绍的`wmtreg`的命令，可以将回归结果输出至 Stata 界面、Word 的 .rtf 文件和 LaTeX 的.tex 文件。基于`esttab`内核，`wmtreg`不仅具有了`esttab`的优点，同时也简化了书写语法。

本文阐述的`wmtreg`命令，和已经或即将推出`wmtsum`、`wmttest`、`wmtcorr`和`wmtmat`命令，都可以通过`append`选项成为一个整体，将输出结果集中于一个 Word 或 LaTeX 文件中。关于以上系列命令更多的优点，可参见[「Stata 新命令：wmtsum——描述性统计表格的输出」](https://mp.weixin.qq.com/s/oLgXf0KTgoePOnN1mJUllA)。

## 二、命令的安装

`wmtreg`命令以及本人其他命令的代码都将托管于 GitHub 上，以使得同学们可以随时下载安装这些命令。

首先你需要有`github`命令，如果没有，可参见[「Stata 新命令：wmtsum——描述性统计表格的输出」](https://mp.weixin.qq.com/s/oLgXf0KTgoePOnN1mJUllA)进行安装。

然后你就可以运行以下命令安装最新的`wmtreg`命令及其帮助文件了：

```stata
github install Meiting-Wang/wmtreg
```

当然，你也可以`github search`一下，也能找到`wmtreg`命令安装的入口：

```stata
github search wmtreg
```

或许，你还想一下子找到`wmtsum`、`wmttest`、`wmtcorr`、`wmtreg`以及`wmtmat`所有命令在 GitHub 的安装入口，那么你可以：

```stata
github search wmt
```

## 三、语法与选项

**命令语法**：

```stata
wmtreg [est_store_names] [using filename] [, options]
```

> - `est_store_names`: 输入要报告的回归模型，默认导入所有已经储存好的回归模型
> - `using`: 可以将结果输出至 Word（ .rtf 文件）和 LaTeX（ .tex 文件）

**选项（options）**：

- 一般选项
  - `drop(varlist)`：不报告指定变量的回归系数
  - `keep(varlist)`：只报告指定变量的回归系数
  - `order(varlist)`：设定处于表格最顶端的变量
  - `varlabels(matchlist)`：更改所报告表格中变量的名称
  - `b(fmt)`：报告普通的回归系数
  - `beta(fmt)`：报告标准化的回归系数
  - `se(fmt)`: 在回归系数下方报告标准误
  - `t(fmt)`: 在回归系数下方报告 t 值
  - `p(fmt)`: 在回归系数下方报告 p 值
  - `onlyb`: 只报告回归系数，而不报告 se、t、p 值
  - `staraux`: 将显著性星号标注下 se、t 或 p 值上(`* p<0.1, ** p<0.05, *** p<0.01`)
  - `nostar`: 不报告星号
  - `indicates(string)`: 不报告指定变量的回归系数，换之以 Yes 或 No 表示变量存在或不存在
  - `scalars(string)`: 可填入**r2**、**ar2**、**pr2**、**aic**、**F**、**ll**和**N**，默认为**r2**和**N**。同时我们也可以为每一个写入的变量设置数值格式，如`r2(%9.2f)`
  - `nonumbers`: 不报告每个回归模型的序列号
  - `nomtitles`: 不报告每个回归模型的名称
  - `mtitles(string)`: 设置每一个回归模型的名称。另外，关键字**depvars**表示每个回归模型的名称将用因变量代替，**esn**表示每个回归模型的名称将用其在 Stata 内存中的模型储存名代替。
  - `title(string)`: 设置表格的标题，**Regression result**为默认值。
  - `mgroups(string)`: 为回归模型设置分组，并附之以指定的组名，如`mgroups(2 2 A B)`表示前两个回归为组别 A，后两个回归为组别 B
  - `replace`：将结果输出至 Word 或 LaTeX 时，替换已有的文件
  - `append`：将结果输出至 Word 或 LaTeX 时，可附加在已经存在的文件中
- LaTeX 专有选项
  - `alignment()`：设置 LaTeX 表格的列对齐格式，可输入`math`或`dot`，`math`设置列格式为居中对齐的数学格式（自动添加宏包`booktabs`和`array`），`dot`表示小数点对齐的数学格式（自动添加宏包`booktabs`、`array`和`dcolumn`）。默认为`math`
  - `page()`：可添加用户额外需要的宏包

> - 以上其中的一些选项可以缩写，详情可以在安装完命令后`help wmtreg`

## 四、实例

```stata
* 回归结果输出实例
clear all
sysuse auto.dta, clear
gen lprice = ln(price)
tab rep78, gen(rep78_num)
drop rep78_num1

reg lprice mpg headroom
est store m1
reg lprice mpg trunk headroom
est store m2
reg lprice mpg trunk headroom rep78_num*
est store m3
reg lprice mpg trunk headroom foreign rep78_num*
est store m4

wmtreg //报告所有已经储存的回归结果
wmtreg m1 m2 m3 m4 //报告指定的回归结果
wmtreg m?, drop(_cons) //不报告常数项
wmtreg m?, keep(mpg headroom trunk) //只报告指定变量的回归系数
wmtreg m?, order(foreign mpg) //将变量foreign和mpg置于报告变量的最上方
wmtreg m?, varl(mpg mpgtest trunk trunktest) //将变量mpg和trunk的展示名称改为mpgtest和trunktest
wmtreg m?, b(%9.2f) se(%9.3f) //设定回归系数的格式，且默认下在系数的下方报告系数的标准误
wmtreg m?, ind("rep78=rep78_num*" "foreign=foreign") //不报告foreign与rep78_num*系列变量的回归系数，换之以Yes或No的形式表示其否在回归中出现
wmtreg m?, s(r2(%9.3f) F N(%9.0fc)) //报告指定的scalars，并设定其数值格式
wmtreg m?, mg(Group1 Group2 2 2) //设置前两个回归为组别group1，后两个回归为组别group2
wmtreg m? using Myfile.rtf, replace //将回归结果导出至Word
wmtreg m? using Myfile.tex, replace //将回归结果导出至LaTeX
wmtreg m? using Myfile.tex, replace a(dot) //将回归结果导出至LaTeX，并将其列表格设置为小数点对齐
```

> 以上所有实例都可以在`help wmtreg`中直接运行。  
> ![image](https://user-images.githubusercontent.com/42256486/81492187-81fa4b00-92c8-11ea-874f-6026a289a382.png)

## 五、输出效果展示

- **Stata**

```stata
wmtreg m1 m2 m3 m4
```

```stata
Regression result
--------------------------------------------------------------
                 (1)          (2)          (3)          (4)
              lprice       lprice       lprice       lprice
--------------------------------------------------------------
mpg           -0.036***    -0.030***    -0.036***    -0.038***
             (0.008)      (0.008)      (0.009)      (0.009)
headroom      -0.052       -0.116*      -0.105       -0.096
             (0.052)      (0.063)      (0.064)      (0.064)
trunk                       0.025*       0.024*       0.028*
                          (0.014)      (0.014)      (0.014)
rep78_num2                               0.122        0.079
                                       (0.275)      (0.272)
rep78_num3                               0.164        0.099
                                       (0.255)      (0.254)
rep78_num4                               0.287        0.152
                                       (0.257)      (0.264)
rep78_num5                               0.437        0.256
                                       (0.269)      (0.283)
foreign                                               0.207*
                                                    (0.117)
_cons          9.573***     9.278***     9.172***     9.148***
             (0.271)      (0.314)      (0.355)      (0.349)
--------------------------------------------------------------
R-sq           0.252        0.284        0.349        0.381
N                 74           74           69           69
--------------------------------------------------------------
Standard errors in parentheses
* p<0.1, ** p<0.05, *** p<0.01
```

```stata
wmtreg m?, ind("rep78=rep78_num*" "foreign=foreign")
```

```stata
Regression result
--------------------------------------------------------------
                 (1)          (2)          (3)          (4)
              lprice       lprice       lprice       lprice
--------------------------------------------------------------
mpg           -0.036***    -0.030***    -0.036***    -0.038***
             (0.008)      (0.008)      (0.009)      (0.009)
headroom      -0.052       -0.116*      -0.105       -0.096
             (0.052)      (0.063)      (0.064)      (0.064)
trunk                       0.025*       0.024*       0.028*
                          (0.014)      (0.014)      (0.014)
_cons          9.573***     9.278***     9.172***     9.148***
             (0.271)      (0.314)      (0.355)      (0.349)
rep78             No           No          Yes          Yes
foreign           No           No           No          Yes
--------------------------------------------------------------
R-sq           0.252        0.284        0.349        0.381
N                 74           74           69           69
--------------------------------------------------------------
Standard errors in parentheses
* p<0.1, ** p<0.05, *** p<0.01
```

- **Word**

```stata
wmtreg m? using Myfile.rtf, replace
```

![image](https://user-images.githubusercontent.com/42256486/81492189-86266880-92c8-11ea-9cba-b8533511f275.png)

- **LaTeX**

```stata
wmtreg m? using Myfile.tex, replace
```

![image](https://user-images.githubusercontent.com/42256486/81492192-89b9ef80-92c8-11ea-8b43-ff02238fd118.png)

```stata
wmtreg m? using Myfile.tex, replace mg(Group1 Group2 2 2)
```

![image](https://user-images.githubusercontent.com/42256486/81492195-8e7ea380-92c8-11ea-8c9e-a8f84e3acd66.png)

```stata
wmtreg m? using Myfile.tex, replace a(dot)
```

![image](https://user-images.githubusercontent.com/42256486/81492198-92122a80-92c8-11ea-9411-efaa0da76410.png)

> 在将结果输出至 Word 或 LaTeX 时，Stata 界面上也会呈现对应的结果，以方便查看。
