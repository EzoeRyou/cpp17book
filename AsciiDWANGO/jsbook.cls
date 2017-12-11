%%
%% This is file `jsbook.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% jsclasses.dtx  (with options: `book')
%%
%% IMPORTANT NOTICE:
%%
%% For the copyright see the source file.
%%
%% Any modified versions of this file must be renamed
%% with new filenames distinct from jsbook.cls.
%%
%% For distribution of the original source see the terms
%% for copying and modification in the file jsclasses.dtx.
%%
%% This generated file may be distributed as long as the
%% original source files, as listed above, are part of the
%% same distribution. (The sources need not necessarily be
%% in the same archive or directory.)
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\NeedsTeXFormat{pLaTeX2e}
\ProvidesClass{jsbook}
  [2014/02/07 okumura]
\newif\if@restonecol
\newif\if@titlepage
\newif\if@openright
\newif\if@mainmatter \@mainmattertrue
\newif\if@enablejfam \@enablejfamtrue
\DeclareOption{a3paper}{%
  \setlength\paperheight {420mm}%
  \setlength\paperwidth  {297mm}}
\DeclareOption{a4paper}{%
  \setlength\paperheight {297mm}%
  \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}{%
  \setlength\paperheight {210mm}%
  \setlength\paperwidth  {148mm}}
\DeclareOption{a6paper}{%
  \setlength\paperheight {148mm}%
  \setlength\paperwidth  {105mm}}
\DeclareOption{b4paper}{%
  \setlength\paperheight {364mm}%
  \setlength\paperwidth  {257mm}}
\DeclareOption{b5paper}{%
  \setlength\paperheight {257mm}%
  \setlength\paperwidth  {182mm}}
\DeclareOption{b6paper}{%
  \setlength\paperheight {182mm}%
  \setlength\paperwidth  {128mm}}
\DeclareOption{a4j}{%
  \setlength\paperheight {297mm}%
  \setlength\paperwidth  {210mm}}
\DeclareOption{a5j}{%
  \setlength\paperheight {210mm}%
  \setlength\paperwidth  {148mm}}
\DeclareOption{b4j}{%
  \setlength\paperheight {364mm}%
  \setlength\paperwidth  {257mm}}
\DeclareOption{b5j}{%
  \setlength\paperheight {257mm}%
  \setlength\paperwidth  {182mm}}
\DeclareOption{a4var}{%
  \setlength\paperheight {283mm}%
  \setlength\paperwidth  {210mm}}
\DeclareOption{b5var}{%
  \setlength\paperheight {230mm}%
  \setlength\paperwidth  {182mm}}
\DeclareOption{letterpaper}{%
  \setlength\paperheight {11in}%
  \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}{%
  \setlength\paperheight {14in}%
  \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}{%
  \setlength\paperheight {10.5in}%
  \setlength\paperwidth  {7.25in}}
\newif\if@landscape
\@landscapefalse
\DeclareOption{landscape}{\@landscapetrue}
\newif\if@slide
\@slidefalse
\newcommand{\@ptsize}{0}
\DeclareOption{slide}{\@slidetrue\renewcommand{\@ptsize}{26}\@landscapetrue\@titlepagetrue}
\DeclareOption{8pt}{\renewcommand{\@ptsize}{-2}}
\DeclareOption{9pt}{\renewcommand{\@ptsize}{-1}}
\DeclareOption{10pt}{\renewcommand{\@ptsize}{0}}
\DeclareOption{11pt}{\renewcommand{\@ptsize}{1}}
\DeclareOption{12pt}{\renewcommand{\@ptsize}{2}}
\DeclareOption{14pt}{\renewcommand{\@ptsize}{4}}
\DeclareOption{17pt}{\renewcommand{\@ptsize}{7}}
\DeclareOption{20pt}{\renewcommand{\@ptsize}{10}}
\DeclareOption{21pt}{\renewcommand{\@ptsize}{11}}
\DeclareOption{25pt}{\renewcommand{\@ptsize}{15}}
\DeclareOption{30pt}{\renewcommand{\@ptsize}{20}}
\DeclareOption{36pt}{\renewcommand{\@ptsize}{26}}
\DeclareOption{43pt}{\renewcommand{\@ptsize}{33}}
\DeclareOption{12Q}{\renewcommand{\@ptsize}{1200}}
\DeclareOption{14Q}{\renewcommand{\@ptsize}{1400}}
\DeclareOption{10ptj}{\renewcommand{\@ptsize}{1001}}
\DeclareOption{10.5ptj}{\renewcommand{\@ptsize}{1051}}
\DeclareOption{11ptj}{\renewcommand{\@ptsize}{1101}}
\DeclareOption{12ptj}{\renewcommand{\@ptsize}{1201}}
\hour\time \divide\hour by 60\relax
\@tempcnta\hour \multiply\@tempcnta 60\relax
\minute\time \advance\minute-\@tempcnta
\DeclareOption{tombow}{%
  \tombowtrue \tombowdatetrue
  \setlength{\@tombowwidth}{.1\p@}%
  \@bannertoken{%
     \jobname\space(\number\year-\two@digits\month-\two@digits\day
     \space\two@digits\hour:\two@digits\minute)}%
  \maketombowbox}
\DeclareOption{tombo}{%
  \tombowtrue \tombowdatefalse
  \setlength{\@tombowwidth}{.1\p@}%
  \maketombowbox}
\DeclareOption{mentuke}{%
  \tombowtrue \tombowdatefalse
  \setlength{\@tombowwidth}{\z@}%
  \maketombowbox}
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\DeclareOption{twoside}{\@twosidetrue \@mparswitchtrue}
\DeclareOption{vartwoside}{\@twosidetrue \@mparswitchfalse}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{titlepage}{\@titlepagetrue}
\DeclareOption{notitlepage}{\@titlepagefalse}
\DeclareOption{openright}{\@openrighttrue}
\DeclareOption{openany}{\@openrightfalse}
\def\eqnarray{%
   \stepcounter{equation}%
   \def\@currentlabel{\p@equation\theequation}%
   \global\@eqnswtrue
   \m@th
   \global\@eqcnt\z@
   \tabskip\@centering
   \let\\\@eqncr
   $$\everycr{}\halign to\displaywidth\bgroup
       \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
      &\global\@eqcnt\@ne \hfil$\displaystyle{{}##{}}$\hfil
      &\global\@eqcnt\tw@ $\displaystyle{##}$\hfil\tabskip\@centering
      &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss##\egroup
         \tabskip\z@skip
      \cr}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}%
  \def\eqnarray{%
    \stepcounter{equation}%
    \def\@currentlabel{\p@equation\theequation}%
    \global\@eqnswtrue\m@th
    \global\@eqcnt\z@
    \tabskip\mathindent
    \let\\=\@eqncr
    \setlength\abovedisplayskip{\topsep}%
    \ifvmode
      \addtolength\abovedisplayskip{\partopsep}%
    \fi
    \addtolength\abovedisplayskip{\parskip}%
    \setlength\belowdisplayskip{\abovedisplayskip}%
    \setlength\belowdisplayshortskip{\abovedisplayskip}%
    \setlength\abovedisplayshortskip{\abovedisplayskip}%
    $$\everycr{}\halign to\linewidth% $$
    \bgroup
      \hskip\@centering$\displaystyle\tabskip\z@skip{##}$\@eqnsel
      &\global\@eqcnt\@ne \hfil$\displaystyle{{}##{}}$\hfil
      &\global\@eqcnt\tw@
        $\displaystyle{##}$\hfil \tabskip\@centering
      &\global\@eqcnt\thr@@ \hb@xt@\z@\bgroup\hss##\egroup
    \tabskip\z@skip\cr
    }}
\DeclareOption{disablejfam}{\@enablejfamfalse}
\newif\ifdraft
\DeclareOption{draft}{\drafttrue \setlength\overfullrule{5pt}}
\DeclareOption{final}{\draftfalse \setlength\overfullrule{0pt}}
\newif\ifwinjis
\winjisfalse
\newif\ifmingoth
\mingothfalse
\newif\ifjisfont
\jisfontfalse
\newif\if@jsc@uplatex
\@jsc@uplatexfalse
\DeclareOption{mingoth}{\mingothtrue}
\DeclareOption{winjis}{\winjistrue}
\DeclareOption{jis}{\jisfonttrue}
\DeclareOption{uplatex}{\@jsc@uplatextrue\winjisfalse}
\def\jsc@JYn{\if@jsc@uplatex JY2\else JY1\fi}
\def\jsc@JTn{\if@jsc@uplatex JT2\else JT1\fi}
\def\jsc@pfx@{\if@jsc@uplatex u\else \fi}
\newif\ifpapersize
\papersizefalse
\DeclareOption{papersize}{\papersizetrue}
\newif\if@english
\@englishfalse
\DeclareOption{english}{\@englishtrue}
\newif\if@report
\@reportfalse
\DeclareOption{report}{\@reporttrue\@openrightfalse\@twosidefalse\@mparswitchfalse}
\ExecuteOptions{a4paper,twoside,onecolumn,titlepage,openright,final}
\ProcessOptions
\if@slide
  \def\maybeblue{\@ifundefined{ver@color.sty}{}{\color{blue}}}
\fi
\if@landscape
  \setlength\@tempdima  {\paperheight}
  \setlength\paperheight{\paperwidth}
  \setlength\paperwidth {\@tempdima}
\fi
\ifpapersize
  \setlength{\@tempdima}{\paperwidth}
  \setlength{\@tempdimb}{\paperheight}
  \iftombow
    \advance \@tempdima 2in
    \advance \@tempdimb 2in
  \fi
  \AtBeginDvi{\special{papersize=\the\@tempdima,\the\@tempdimb}}
\fi
\if@slide\def\n@baseline{13}\else\def\n@baseline{16}\fi
\def\inv@mag{1}
\ifnum\@ptsize=-2
  \mag 833
  \def\inv@mag{1.20048}
  \def\n@baseline{15}%
\fi
\ifnum\@ptsize=-1
  \mag 913 % formerly 900
  \def\inv@mag{1.09529}
  \def\n@baseline{15}%
\fi
\ifnum\@ptsize=1
  \mag 1095 % formerly 1100
  \def\inv@mag{0.913242}
\fi
\ifnum\@ptsize=2
  \mag 1200
  \def\inv@mag{0.833333}
\fi
\ifnum\@ptsize=4
  \mag 1440
  \def\inv@mag{0.694444}
\fi
\ifnum\@ptsize=7
  \mag 1728
  \def\inv@mag{0.578704}
\fi
\ifnum\@ptsize=10
  \mag 2000
  \def\inv@mag{0.5}
\fi
\ifnum\@ptsize=11
  \mag 2074
  \def\inv@mag{0.48216}
\fi
\ifnum\@ptsize=15
  \mag 2488
  \def\inv@mag{0.401929}
\fi
\ifnum\@ptsize=20
  \mag 2986
  \def\inv@mag{0.334896}
\fi
\ifnum\@ptsize=26
  \mag 3583
  \def\inv@mag{0.279096}
\fi
\ifnum\@ptsize=33
  \mag 4300
  \def\inv@mag{0.232558}
\fi
\ifnum\@ptsize=1200
  \mag 923
  \def\inv@mag{1.0834236}
\fi
\ifnum\@ptsize=1400
  \mag 1077
  \def\inv@mag{0.928505}
\fi
\ifnum\@ptsize=1001
  \mag 1085
  \def\inv@mag{0.921659}
\fi
\ifnum\@ptsize=1051
  \mag 1139
  \def\inv@mag{0.877963}
\fi
\ifnum\@ptsize=1101
  \mag 1194
  \def\inv@mag{0.837521}
\fi
\ifnum\@ptsize=1201
  \mag 1302
  \def\inv@mag{0.768049}
\fi
\setlength\paperwidth{\inv@mag\paperwidth}%
\setlength\paperheight{\inv@mag\paperheight}%
\ifwinjis
  \DeclareFontShape{JY1}{mc}{m}{n}{<-> s * [0.961] winjis}{}
  \DeclareFontShape{JY1}{gt}{m}{n}{<-> s * [0.961] winjisg}{}
  \DeclareFontShape{JT1}{mc}{m}{n}{<-> s * [0.961] winjis-v}{}
  \DeclareFontShape{JT1}{gt}{m}{n}{<-> s * [0.961] winjisg-v}{}
\else
  \ifmingoth
    \DeclareFontShape{\jsc@JYn}{mc}{m}{n}{<-> s * [0.961] \jsc@pfx@ min10}{}
    \DeclareFontShape{\jsc@JYn}{gt}{m}{n}{<-> s * [0.961] \jsc@pfx@ goth10}{}
    \DeclareFontShape{\jsc@JTn}{mc}{m}{n}{<-> s * [0.961] \jsc@pfx@ tmin10}{}
    \DeclareFontShape{\jsc@JTn}{gt}{m}{n}{<-> s * [0.961] \jsc@pfx@ tgoth10}{}
  \else
    \ifjisfont
      \DeclareFontShape{\jsc@JYn}{mc}{m}{n}{<-> s * [0.961] \jsc@pfx@ jis}{}
      \DeclareFontShape{\jsc@JYn}{gt}{m}{n}{<-> s * [0.961] \jsc@pfx@ jisg}{}
      \DeclareFontShape{\jsc@JTn}{mc}{m}{n}{<-> s * [0.961] \jsc@pfx@ tmin10}{}
      \DeclareFontShape{\jsc@JTn}{gt}{m}{n}{<-> s * [0.961] \jsc@pfx@ tgoth10}{}
    \else
      \if@jsc@uplatex
        \DeclareFontShape{JY2}{mc}{m}{n}{<-> s * [0.924690] upjisr-h}{}
        \DeclareFontShape{JY2}{gt}{m}{n}{<-> s * [0.924690] upjisg-h}{}
        \DeclareFontShape{JT2}{mc}{m}{n}{<-> s * [0.924690] upjisr-v}{}
        \DeclareFontShape{JT2}{gt}{m}{n}{<-> s * [0.924690] upjisg-v}{}
      \else
        \DeclareFontShape{\jsc@JYn}{mc}{m}{n}{<-> s * [0.961] \jsc@pfx@ jis}{}
        \DeclareFontShape{\jsc@JYn}{gt}{m}{n}{<-> s * [0.961] \jsc@pfx@ jisg}{}
        \DeclareFontShape{\jsc@JTn}{mc}{m}{n}{<-> s * [0.961] \jsc@pfx@ tmin10}{}
        \DeclareFontShape{\jsc@JTn}{gt}{m}{n}{<-> s * [0.961] \jsc@pfx@ tgoth10}{}
      \fi
    \fi
  \fi
\fi
\DeclareFontShape{\jsc@JYn}{mc}{m}{it}{<->ssub*mc/m/n}{}
\DeclareFontShape{\jsc@JYn}{mc}{m}{sl}{<->ssub*mc/m/n}{}
\DeclareFontShape{\jsc@JYn}{mc}{m}{sc}{<->ssub*mc/m/n}{}
\DeclareFontShape{\jsc@JYn}{gt}{m}{it}{<->ssub*gt/m/n}{}
\DeclareFontShape{\jsc@JYn}{gt}{m}{sl}{<->ssub*gt/m/n}{}
\DeclareFontShape{\jsc@JYn}{mc}{bx}{it}{<->ssub*gt/m/n}{}
\DeclareFontShape{\jsc@JYn}{mc}{bx}{sl}{<->ssub*gt/m/n}{}
\DeclareFontShape{\jsc@JTn}{mc}{m}{it}{<->ssub*mc/m/n}{}
\DeclareFontShape{\jsc@JTn}{mc}{m}{sl}{<->ssub*mc/m/n}{}
\DeclareFontShape{\jsc@JTn}{mc}{m}{sc}{<->ssub*mc/m/n}{}
\DeclareFontShape{\jsc@JTn}{gt}{m}{it}{<->ssub*gt/m/n}{}
\DeclareFontShape{\jsc@JTn}{gt}{m}{sl}{<->ssub*gt/m/n}{}
\DeclareFontShape{\jsc@JTn}{mc}{bx}{it}{<->ssub*gt/m/n}{}
\DeclareFontShape{\jsc@JTn}{mc}{bx}{sl}{<->ssub*gt/m/n}{}
\DeclareRobustCommand\rmfamily
        {\not@math@alphabet\rmfamily\mathrm
         \romanfamily\rmdefault\kanjifamily\mcdefault\selectfont}
\DeclareRobustCommand\sffamily
        {\not@math@alphabet\sffamily\mathsf
         \romanfamily\sfdefault\kanjifamily\gtdefault\selectfont}
\DeclareRobustCommand\ttfamily
        {\not@math@alphabet\ttfamily\mathtt
         \romanfamily\ttdefault\kanjifamily\gtdefault\selectfont}
\def\textmc#1{\relax\ifmmode\hbox\fi{\mcfamily #1}}
\def\textgt#1{\relax\ifmmode\hbox\fi{\gtfamily #1}}
\def\reDeclareMathAlphabet#1#2#3{%
  \edef\@tempa{\expandafter\@gobble\string#2}%
  \edef\@tempb{\expandafter\@gobble\string#3}%
  \edef\@tempc{\string @\expandafter\@gobbletwo\string#2}%
  \ifx\@tempc\@tempa%
    \edef\@tempa{\expandafter\@gobbletwo\string#2}%
    \edef\@tempb{\expandafter\@gobbletwo\string#3}%
  \fi
  \begingroup
    \let\protect\noexpand
    \def\@tempaa{\relax}%
    \expandafter\ifx\csname RDMAorg@\@tempa\endcsname\relax
      \edef\@tempaa{\expandafter\def\expandafter\noexpand%
        \csname RDMAorg@\@tempa\endcsname{%
          \expandafter\noexpand\csname\@tempa\endcsname}}%
    \fi
    \def\@tempbb{\relax}%
    \expandafter\ifx\csname RDMAorg@\@tempb\endcsname\relax
      \edef\@tempbb{\expandafter\def\expandafter\noexpand%
        \csname RDMAorg@\@tempb\endcsname{%
          \expandafter\noexpand\csname\@tempb\endcsname}}%
    \fi
    \edef\@tempc{\@tempaa\@tempbb}%
  \expandafter\endgroup\@tempc%
  \edef#1{\noexpand\protect\expandafter\noexpand\csname%
    \expandafter\@gobble\string#1\space\space\endcsname}%
  \expandafter\edef\csname\expandafter\@gobble\string#1\space\space\endcsname%
    {\noexpand\DualLang@mathalph@bet%
      {\expandafter\noexpand\csname RDMAorg@\@tempa\endcsname}%
      {\expandafter\noexpand\csname RDMAorg@\@tempb\endcsname}%
  }%
}
\@onlypreamble\reDeclareMathAlphabet
\def\DualLang@mathalph@bet#1#2{%
  \relax\ifmmode
    \ifx\math@bgroup\bgroup%     2e normal style     (\mathrm{...})
      \bgroup\let\DualLang@Mfontsw\DLMfontsw@standard
    \else
      \ifx\math@bgroup\relax%    2e two letter style (\rm->\mathrm)
        \let\DualLang@Mfontsw\DLMfontsw@oldstyle
      \else
        \ifx\math@bgroup\@empty% 2.09 oldlfont style ({\mathrm ...})
          \let\DualLang@Mfontsw\DLMfontsw@oldlfont
        \else%                   panic! assume 2e normal style
          \bgroup\let\DualLang@Mfontsw\DLMfontsw@standard
        \fi
      \fi
    \fi
  \else
    \let\DualLang@Mfontsw\@firstoftwo
  \fi
  \DualLang@Mfontsw{#1}{#2}%
}
\def\DLMfontsw@standard#1#2#3{#1{#2{#3}}\egroup}
\def\DLMfontsw@oldstyle#1#2{#1\relax\@fontswitch\relax{#2}}
\def\DLMfontsw@oldlfont#1#2{#1\relax#2\relax}
\if@enablejfam
  \if@compatibility\else
    \DeclareSymbolFont{mincho}{\jsc@JYn}{mc}{m}{n}
    \DeclareSymbolFontAlphabet{\mathmc}{mincho}
    \SetSymbolFont{mincho}{bold}{\jsc@JYn}{gt}{m}{n}
    \jfam\symmincho
    \DeclareMathAlphabet{\mathgt}{\jsc@JYn}{gt}{m}{n}
  \fi
  \AtBeginDocument{%
    \reDeclareMathAlphabet{\mathrm}{\@mathrm}{\@mathmc}
    \reDeclareMathAlphabet{\mathbf}{\@mathbf}{\@mathgt}}
\fi
\prebreakpenalty\jis"2147=10000      % 5000   ’
\postbreakpenalty\jis"2148=10000     % 5000   “
\prebreakpenalty\jis"2149=10000      % 5000   ”
\inhibitxspcode`！=1
\inhibitxspcode`〒=2
\xspcode`+=3
\xspcode`\%=3
\xspcode`^^80=3
\xspcode`^^81=3
\xspcode`^^82=3
\xspcode`^^83=3
\xspcode`^^84=3
\xspcode`^^85=3
\xspcode`^^86=3
\xspcode`^^87=3
\xspcode`^^88=3
\xspcode`^^89=3
\xspcode`^^8a=3
\xspcode`^^8b=3
\xspcode`^^8c=3
\xspcode`^^8d=3
\xspcode`^^8e=3
\xspcode`^^8f=3
\xspcode`^^90=3
\xspcode`^^91=3
\xspcode`^^92=3
\xspcode`^^93=3
\xspcode`^^94=3
\xspcode`^^95=3
\xspcode`^^96=3
\xspcode`^^97=3
\xspcode`^^98=3
\xspcode`^^99=3
\xspcode`^^9a=3
\xspcode`^^9b=3
\xspcode`^^9c=3
\xspcode`^^9d=3
\xspcode`^^9e=3
\xspcode`^^9f=3
\xspcode`^^a0=3
\xspcode`^^a1=3
\xspcode`^^a2=3
\xspcode`^^a3=3
\xspcode`^^a4=3
\xspcode`^^a5=3
\xspcode`^^a6=3
\xspcode`^^a7=3
\xspcode`^^a8=3
\xspcode`^^a9=3
\xspcode`^^aa=3
\xspcode`^^ab=3
\xspcode`^^ac=3
\xspcode`^^ad=3
\xspcode`^^ae=3
\xspcode`^^af=3
\xspcode`^^b0=3
\xspcode`^^b1=3
\xspcode`^^b2=3
\xspcode`^^b3=3
\xspcode`^^b4=3
\xspcode`^^b5=3
\xspcode`^^b6=3
\xspcode`^^b7=3
\xspcode`^^b8=3
\xspcode`^^b9=3
\xspcode`^^ba=3
\xspcode`^^bb=3
\xspcode`^^bc=3
\xspcode`^^bd=3
\xspcode`^^be=3
\xspcode`^^bf=3
\xspcode`^^c0=3
\xspcode`^^c1=3
\xspcode`^^c2=3
\xspcode`^^c3=3
\xspcode`^^c4=3
\xspcode`^^c5=3
\xspcode`^^c6=3
\xspcode`^^c7=3
\xspcode`^^c8=3
\xspcode`^^c9=3
\xspcode`^^ca=3
\xspcode`^^cb=3
\xspcode`^^cc=3
\xspcode`^^cd=3
\xspcode`^^ce=3
\xspcode`^^cf=3
\xspcode`^^d0=3
\xspcode`^^d1=3
\xspcode`^^d2=3
\xspcode`^^d3=3
\xspcode`^^d4=3
\xspcode`^^d5=3
\xspcode`^^d6=3
\xspcode`^^d7=3
\xspcode`^^d8=3
\xspcode`^^d9=3
\xspcode`^^da=3
\xspcode`^^db=3
\xspcode`^^dc=3
\xspcode`^^dd=3
\xspcode`^^de=3
\xspcode`^^df=3
\xspcode`^^e0=3
\xspcode`^^e1=3
\xspcode`^^e2=3
\xspcode`^^e3=3
\xspcode`^^e4=3
\xspcode`^^e5=3
\xspcode`^^e6=3
\xspcode`^^e7=3
\xspcode`^^e8=3
\xspcode`^^e9=3
\xspcode`^^ea=3
\xspcode`^^eb=3
\xspcode`^^ec=3
\xspcode`^^ed=3
\xspcode`^^ee=3
\xspcode`^^ef=3
\xspcode`^^f0=3
\xspcode`^^f1=3
\xspcode`^^f2=3
\xspcode`^^f3=3
\xspcode`^^f4=3
\xspcode`^^f5=3
\xspcode`^^f6=3
\xspcode`^^f7=3
\xspcode`^^f8=3
\xspcode`^^f9=3
\xspcode`^^fa=3
\xspcode`^^fb=3
\xspcode`^^fc=3
\xspcode`^^fd=3
\xspcode`^^fe=3
\xspcode`^^ff=3
\def\@{\spacefactor3000\space}
\def\@setfontsize#1#2#3{%
  \ifx\protect\@typeset@protect
    \let\@currsize#1%
  \fi
  \fontsize{#2}{#3}\selectfont
  \ifdim\parindent>\z@
    \if@english
      \parindent=1em
    \else
      \parindent=1zw
    \fi
  \fi
  \kanjiskip=0zw plus .1zw minus .01zw
  \ifdim\xkanjiskip>\z@
    \if@slide \xkanjiskip=0.1em \else
      \xkanjiskip=0.25em plus 0.15em minus 0.06em
    \fi
  \fi}
\emergencystretch 3zw
\newif\ifnarrowbaselines
\if@english
  \narrowbaselinestrue
\fi
\def\narrowbaselines{%
  \narrowbaselinestrue
  \skip0=\abovedisplayskip
  \skip2=\abovedisplayshortskip
  \skip4=\belowdisplayskip
  \skip6=\belowdisplayshortskip
  \@currsize\selectfont
  \abovedisplayskip=\skip0
  \abovedisplayshortskip=\skip2
  \belowdisplayskip=\skip4
  \belowdisplayshortskip=\skip6\relax}
\def\widebaselines{\narrowbaselinesfalse\@currsize\selectfont}
\renewcommand{\normalsize}{%
  \ifnarrowbaselines
    \@setfontsize\normalsize\@xpt\@xiipt
  \else
    \@setfontsize\normalsize\@xpt{\n@baseline}%
  \fi
  \abovedisplayskip 11\p@ \@plus3\p@ \@minus4\p@
  \abovedisplayshortskip \z@ \@plus3\p@
  \belowdisplayskip 9\p@ \@plus3\p@ \@minus4\p@
  \belowdisplayshortskip \belowdisplayskip
  \let\@listi\@listI}
\normalsize
\setbox0\hbox{\char\euc"A1A1}%
\setlength\Cht{\ht0}
\setlength\Cdp{\dp0}
\setlength\Cwd{\wd0}
\setlength\Cvs{\baselineskip}
\setlength\Chs{\wd0}
\newcommand{\small}{%
  \ifnarrowbaselines
    \@setfontsize\small\@ixpt{11}%
  \else
    \@setfontsize\small\@ixpt{13}%
  \fi
  \abovedisplayskip 9\p@ \@plus3\p@ \@minus4\p@
  \abovedisplayshortskip  \z@ \@plus3\p@
  \belowdisplayskip \abovedisplayskip
  \belowdisplayshortskip \belowdisplayskip
  \def\@listi{\leftmargin\leftmargini
              \topsep \z@
              \parsep \z@
              \itemsep \parsep}}
\newcommand{\footnotesize}{%
  \ifnarrowbaselines
    \@setfontsize\footnotesize\@viiipt{9.5}%
  \else
    \@setfontsize\footnotesize\@viiipt{11}%
  \fi
  \abovedisplayskip 6\p@ \@plus2\p@ \@minus3\p@
  \abovedisplayshortskip  \z@ \@plus2\p@
  \belowdisplayskip \abovedisplayskip
  \belowdisplayshortskip \belowdisplayskip
  \def\@listi{\leftmargin\leftmargini
              \topsep \z@
              \parsep \z@
              \itemsep \parsep}}
\newcommand{\scriptsize}{\@setfontsize\scriptsize\@viipt\@viiipt}
\newcommand{\tiny}{\@setfontsize\tiny\@vpt\@vipt}
\if@twocolumn
  \newcommand{\large}{\@setfontsize\large\@xiipt{\n@baseline}}
\else
  \newcommand{\large}{\@setfontsize\large\@xiipt{17}}
\fi
\newcommand{\Large}{\@setfontsize\Large\@xivpt{21}}
\newcommand{\LARGE}{\@setfontsize\LARGE\@xviipt{25}}
\newcommand{\huge}{\@setfontsize\huge\@xxpt{28}}
\newcommand{\Huge}{\@setfontsize\Huge\@xxvpt{33}}
\newcommand{\HUGE}{\@setfontsize\HUGE{30}{40}}
\everydisplay=\expandafter{\the\everydisplay \narrowbaselines}
\newcommand{\headfont}{\gtfamily\sffamily}
\setlength\columnsep{2zw}
\setlength\columnseprule{0\p@}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\setlength\lineskiplimit{1\p@}
\setlength\normallineskiplimit{1\p@}
\renewcommand{\baselinestretch}{}
\setlength\parskip{0\p@}
\if@slide
  \setlength\parindent{0zw}
\else
  \setlength\parindent{1zw}
\fi
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setlength\topskip{10\p@}
\if@slide
  \setlength\headheight{0\p@}
\else
  \setlength\headheight{2\topskip}
\fi
\if@report
  \setlength\footskip{0.03367\paperheight}
  \ifdim\footskip<\baselineskip
    \setlength\footskip{\baselineskip}
  \fi
\else
  \setlength\footskip{0pt}
\fi
\if@report
  \setlength\headsep{\footskip}
  \addtolength\headsep{-\topskip}
\else
  \setlength\headsep{6mm}
\fi
\setlength\maxdepth{.5\topskip}
\newdimen\fullwidth
\if@report
  \setlength\fullwidth{0.76\paperwidth}
\else
  \setlength\fullwidth{\paperwidth}
  \addtolength\fullwidth{-36mm}
\fi
\if@twocolumn \@tempdima=2zw \else \@tempdima=1zw \fi
\divide\fullwidth\@tempdima \multiply\fullwidth\@tempdima
\setlength\textwidth{\fullwidth}
\if@report \else
  \if@twocolumn \else
    \ifdim \fullwidth>40zw
      \setlength\textwidth{40zw}
    \fi
  \fi
\fi
\if@slide
  \setlength{\textheight}{0.95\paperheight}
\else
  \setlength{\textheight}{0.83\paperheight}
\fi
\addtolength{\textheight}{-\topskip}
\addtolength{\textheight}{-\headsep}
\addtolength{\textheight}{-\footskip}
\addtolength{\textheight}{-\topskip}
\divide\textheight\baselineskip
\multiply\textheight\baselineskip
\addtolength{\textheight}{\topskip}
\addtolength{\textheight}{0.1\p@}
\setlength\marginparsep{\columnsep}
\setlength\marginparpush{\baselineskip}
\setlength{\oddsidemargin}{\paperwidth}
\addtolength{\oddsidemargin}{-\fullwidth}
\setlength{\oddsidemargin}{.5\oddsidemargin}
\iftombow
  \addtolength{\oddsidemargin}{-1in}
\else
  \addtolength{\oddsidemargin}{-\inv@mag in}
\fi
\setlength{\evensidemargin}{\oddsidemargin}
\if@mparswitch
  \addtolength{\evensidemargin}{\fullwidth}
  \addtolength{\evensidemargin}{-\textwidth}
\fi
\setlength\marginparwidth{\paperwidth}
\addtolength\marginparwidth{-\oddsidemargin}
\addtolength\marginparwidth{-\inv@mag in}
\addtolength\marginparwidth{-\textwidth}
\addtolength\marginparwidth{-1cm}
\addtolength\marginparwidth{-\marginparsep}
\@tempdima=1zw
\divide\marginparwidth\@tempdima
\multiply\marginparwidth\@tempdima
\setlength\topmargin{\paperheight}
\addtolength\topmargin{-\textheight}
\if@slide
  \addtolength\topmargin{-\headheight}
\else
  \addtolength\topmargin{-\topskip}
\fi
\addtolength\topmargin{-\headsep}
\addtolength\topmargin{-\footskip}
\setlength\topmargin{0.5\topmargin}
\iftombow
  \addtolength\topmargin{-1in}
\else
  \addtolength\topmargin{-\inv@mag in}
\fi
{\footnotesize\global\setlength\footnotesep{\baselineskip}}
\setlength\footnotesep{0.7\footnotesep}
\setlength{\skip\footins}{16\p@ \@plus 5\p@ \@minus 2\p@}
\setcounter{topnumber}{9}
\renewcommand{\topfraction}{.85}
\setcounter{bottomnumber}{9}
\renewcommand{\bottomfraction}{.8}
\setcounter{totalnumber}{20}
\renewcommand{\textfraction}{.1}
\renewcommand{\floatpagefraction}{.8}
\setcounter{dbltopnumber}{9}
\renewcommand{\dbltopfraction}{.8}
\renewcommand{\dblfloatpagefraction}{.8}
\setlength\floatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\textfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\intextsep   {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\@fptop{0\p@ \@plus 1fil}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
\def\ps@plainfoot{%
  \let\@mkboth\@gobbletwo
  \let\@oddhead\@empty
  \def\@oddfoot{\normalfont\hfil\thepage\hfil}%
  \let\@evenhead\@empty
  \let\@evenfoot\@oddfoot}
\def\ps@plainhead{%
  \let\@mkboth\@gobbletwo
  \let\@oddfoot\@empty
  \let\@evenfoot\@empty
  \def\@evenhead{%
    \if@mparswitch \hss \fi
    %\hbox to \fullwidth{\textbf{\thepage}\hfil}%
    \hbox to \fullwidth{
      %\textbf{\thepage}\hfil
    }%
    \if@mparswitch\else \hss \fi}%
  \def\@oddhead{%
    %\hbox to \fullwidth{\hfil\textbf{\thepage}}\hss}}
    \hbox to \fullwidth{
      %\hfil\textbf{\thepage}
    }\hss}}
\if@report \let\ps@plain\ps@plainfoot \else \let\ps@plain\ps@plainhead \fi
\newif\if@omit@number
\def\ps@headings{%
  \let\@oddfoot\@empty
  \let\@evenfoot\@empty
  \def\@evenhead{%
    \if@mparswitch \hss \fi
    \underline{\hbox to \fullwidth{\autoxspacing
        \textbf{\thepage}\hfil\leftmark}}%
    \if@mparswitch\else \hss \fi}%
  \def\@oddhead{\underline{\hbox to \fullwidth{\autoxspacing
        {\if@twoside\rightmark\else\leftmark\fi}\hfil\textbf{\thepage}}}\hss}%
  \let\@mkboth\markboth
  \def\chaptermark##1{\markboth{%
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \if@omit@number\else
          \@chapapp\thechapter\@chappos\hskip1zw
        \fi
      \fi
    \fi
    ##1}{}}%
  \def\sectionmark##1{\markright{%
    \ifnum \c@secnumdepth >\z@ \thesection \hskip1zw\fi
    ##1}}}%
\def\ps@myheadings{%
  \let\@oddfoot\@empty\let\@evenfoot\@empty
  \def\@evenhead{%
    \if@mparswitch \hss \fi%
    \hbox to \fullwidth{\thepage\hfil\leftmark}%
    \if@mparswitch\else \hss \fi}%
  \def\@oddhead{%
    \hbox to \fullwidth{\rightmark\hfil\thepage}\hss}%
  \let\@mkboth\@gobbletwo
  \let\chaptermark\@gobble
  \let\sectionmark\@gobble
}
\def\plainifnotempty{%
  \ifx \@oddhead \@empty
    \ifx \@oddfoot \@empty
    \else
      \thispagestyle{plainfoot}%
    \fi
  \else
    \thispagestyle{plainhead}%
  \fi}
\if@titlepage
  \newcommand{\maketitle}{%
    \begin{titlepage}%
      \let\footnotesize\small
      \let\footnoterule\relax
      \let\footnote\thanks
      \null\vfil
      \if@slide
        {\footnotesize \@date}%
        \begin{center}
          \mbox{} \\[1zw]
          \large
          {\maybeblue\hrule height0pt depth2pt\relax}\par
          \smallskip
          \@title
          \smallskip
          {\maybeblue\hrule height0pt depth2pt\relax}\par
          \vfill
          {\small \@author}%
        \end{center}
      \else
      \vskip 60\p@
      \begin{center}%
        {\LARGE \@title \par}%
        \vskip 3em%
        {\large
          \lineskip .75em
          \begin{tabular}[t]{c}%
            \@author
          \end{tabular}\par}%
        \vskip 1.5em
        {\large \@date \par}%
      \end{center}%
      \fi
      \par
      \@thanks\vfil\null
    \end{titlepage}%
    \setcounter{footnote}{0}%
    \global\let\thanks\relax
    \global\let\maketitle\relax
    \global\let\@thanks\@empty
    \global\let\@author\@empty
    \global\let\@date\@empty
    \global\let\@title\@empty
    \global\let\title\relax
    \global\let\author\relax
    \global\let\date\relax
    \global\let\and\relax
  }%
\else
  \newcommand{\maketitle}{\par
    \begingroup
      \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
      \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
      \long\def\@makefntext##1{\advance\leftskip 3zw
        \parindent 1zw\noindent
        \llap{\@textsuperscript{\normalfont\@thefnmark}\hskip0.3zw}##1}%
      \if@twocolumn
        \ifnum \col@number=\@ne
          \@maketitle
        \else
          \twocolumn[\@maketitle]%
        \fi
      \else
        \newpage
        \global\@topnum\z@  % Prevents figures from going at top of page.
        \@maketitle
      \fi
      \plainifnotempty
      \@thanks
    \endgroup
    \setcounter{footnote}{0}%
    \global\let\thanks\relax
    \global\let\maketitle\relax
    \global\let\@thanks\@empty
    \global\let\@author\@empty
    \global\let\@date\@empty
    \global\let\@title\@empty
    \global\let\title\relax
    \global\let\author\relax
    \global\let\date\relax
    \global\let\and\relax
  }
  \def\@maketitle{%
    \newpage\null
    \vskip 2em
    \begin{center}%
      \let\footnote\thanks
      {\LARGE \@title \par}%
      \vskip 1.5em
      {\large
        \lineskip .5em
        \begin{tabular}[t]{c}%
          \@author
        \end{tabular}\par}%
      \vskip 1em
      {\large \@date}%
    \end{center}%
    \par\vskip 1.5em
  }
\fi
\def\@startsection#1#2#3#4#5#6{%
  \if@noskipsec \leavevmode \fi
  \par
  \@tempskipa #4\relax
  \if@english \@afterindentfalse \else \@afterindenttrue \fi
  \ifdim \@tempskipa <\z@
    \@tempskipa -\@tempskipa \@afterindentfalse
  \fi
  \if@nobreak
    \everypar{}%
  \else
    \addpenalty\@secpenalty
    \ifdim \@tempskipa >\z@
      \if@slide\else
        \null
        \vspace*{-\baselineskip}%
      \fi
      \vskip\@tempskipa
    \fi
  \fi
  \noindent
  \@ifstar
    {\@ssect{#3}{#4}{#5}{#6}}%
    {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}}
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa<\z@
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}% 目次にフルネームを載せるなら #8
  \else
    \begingroup
      \interlinepenalty \@M % 下から移動
      #6{%
        \@hangfrom{\hskip #3\relax\@svsec}%
        #8\@@par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}% 目次にフルネームを載せるならここは #8
  \fi
  \@xsect{#5}}
\def\@xsect#1{%
  \@tempskipa #1\relax
  \ifdim \@tempskipa<\z@
    \@nobreakfalse
    \global\@noskipsectrue
    \everypar{%
      \if@noskipsec
        \global\@noskipsecfalse
       {\setbox\z@\lastbox}%
        \clubpenalty\@M
        \begingroup \@svsechd \endgroup
        \unskip
        \@tempskipa #1\relax
        \hskip -\@tempskipa
      \else
        \clubpenalty \@clubpenalty
        \everypar{\everyparhook}%
      \fi\everyparhook}%
  \else
    \par \nobreak
    \vskip \@tempskipa
    \@afterheading
  \fi
  \if@slide
    {\vskip-6pt\maybeblue\hrule height0pt depth1pt\vskip7pt\relax}%
  \fi
  \par  % 2000-12-18
  \ignorespaces}
\def\@ssect#1#2#3#4#5{%
  \@tempskipa #3\relax
  \ifdim \@tempskipa<\z@
    \def\@svsechd{#4{\hskip #1\relax #5}}%
  \else
    \begingroup
      #4{%
        \@hangfrom{\hskip #1}%
          \interlinepenalty \@M #5\@@par}%
    \endgroup
  \fi
  \@xsect{#3}}
\newcommand*\chaptermark[1]{}
\setcounter{secnumdepth}{2}
\newcounter{part}
\newcounter{chapter}
\newcounter{section}[chapter]
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]
\renewcommand{\thepart}{\@Roman\c@part}
\renewcommand{\thechapter}{\@arabic\c@chapter}
\renewcommand{\thesection}{\thechapter.\@arabic\c@section}
\renewcommand{\thesubsection}{\thesection.\@arabic\c@subsection}
\renewcommand{\thesubsubsection}{%
   \thesubsection.\@arabic\c@subsubsection}
\renewcommand{\theparagraph}{%
   \thesubsubsection.\@arabic\c@paragraph}
\renewcommand{\thesubparagraph}{%
   \theparagraph.\@arabic\c@subparagraph}
\newcommand{\@chapapp}{\prechaptername}
\newcommand{\@chappos}{\postchaptername}
\newcommand\frontmatter{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse
  \pagenumbering{roman}}
\newcommand\mainmatter{%
    \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}}
\newcommand\backmatter{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse}
\newcommand\part{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \thispagestyle{empty}% 欧文用標準スタイルでは plain
  \if@twocolumn
    \onecolumn
    \@restonecoltrue
  \else
    \@restonecolfalse
  \fi
  \null\vfil
  \secdef\@part\@spart}
\def\@part[#1]#2{%
  \ifnum \c@secnumdepth >-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{%
      \prepartname\thepart\postpartname\hspace{1zw}#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \markboth{}{}%
  {\centering
    \interlinepenalty \@M
    \normalfont
    \ifnum \c@secnumdepth >-2\relax
      \huge\headfont \prepartname\thepart\postpartname
      \par\vskip20\p@
    \fi
    \Huge \headfont #2\par}%
  \@endpart}
\def\@spart#1{{%
    \centering
    \interlinepenalty \@M
    \normalfont
    \Huge \headfont #1\par}%
  \@endpart}
\def\@endpart{\vfil\newpage
%  \if@twoside
%    \null
%    \thispagestyle{empty}%
%    \newpage
%  \fi
  \if@restonecol
    \twocolumn
  \fi}
\newcommand{\chapter}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \plainifnotempty % 元: \thispagestyle{plain}
  \global\@topnum\z@
  \if@english \@afterindentfalse \else \@afterindenttrue \fi
  \secdef
    {\@omit@numberfalse\@chapter}%
    {\@omit@numbertrue\@schapter}}
\def\@chapter[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \refstepcounter{chapter}%
      \typeout{\@chapapp\thechapter\@chappos}%
      \addcontentsline{toc}{chapter}%
        {\protect\numberline
        % {\if@english\thechapter\else\@chapapp\thechapter\@chappos\fi}%
        {\@chapapp\thechapter\@chappos}%
        #1}%
    \else\addcontentsline{toc}{chapter}{#1}\fi
  \else
    \addcontentsline{toc}{chapter}{#1}%
  \fi
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi}
\def\@makechapterhead#1{%
  \vspace*{2\Cvs}% 欧文は50pt
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \huge\headfont \@chapapp\thechapter\@chappos
        \par\nobreak
        \vskip \Cvs % 欧文は20pt
      \fi
    \fi
    \interlinepenalty\@M
    \Huge \headfont #1\par\nobreak
    \vskip 3\Cvs}} % 欧文は40pt
\def\@schapter#1{%
  \chaptermark{#1}%
  \if@twocolumn
    \@topnewpage[\@makeschapterhead{#1}]%
  \else
    \@makeschapterhead{#1}\@afterheading
  \fi}
\def\@makeschapterhead#1{%
  \vspace*{2\Cvs}% 欧文は50pt
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \Huge \headfont #1\par\nobreak
    \vskip 3\Cvs}} % 欧文は40pt
\if@twocolumn
  \newcommand{\section}{%
    \@startsection{section}{1}{\z@}%
    {0.6\Cvs}{0.4\Cvs}%
    {\normalfont\large\headfont\raggedright}}
\else
  \newcommand{\section}{%
    \if@slide\clearpage\fi
    \@startsection{section}{1}{\z@}%
    {\Cvs \@plus.5\Cdp \@minus.2\Cdp}% 前アキ
    {.5\Cvs \@plus.3\Cdp}% 後アキ
    {\normalfont\Large\headfont\raggedright}}
\fi
\if@twocolumn
  \newcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
    {\z@}{\z@}%
    {\normalfont\normalsize\headfont}}
\else
  \newcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
    {\Cvs \@plus.5\Cdp \@minus.2\Cdp}% 前アキ
    {.5\Cvs \@plus.3\Cdp}% 後アキ
    {\normalfont\large\headfont}}
\fi
\if@twocolumn
  \newcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
    {\z@}{\z@}%
    {\normalfont\normalsize\headfont}}
\else
  \newcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
    {\Cvs \@plus.5\Cdp \@minus.2\Cdp}%
    {\z@}%
    {\normalfont\normalsize\headfont}}
\fi
\if@twocolumn
  \newcommand{\paragraph}{\@startsection{paragraph}{4}{\z@}%
    {\z@}{-1zw}% 改行せず 1zw のアキ
    {\normalfont\normalsize\headfont ■}}
\else
  \newcommand{\paragraph}{\@startsection{paragraph}{4}{\z@}%
    {0.5\Cvs \@plus.5\Cdp \@minus.2\Cdp}%
    {-1zw}% 改行せず 1zw のアキ
    {\normalfont\normalsize\headfont ■}}
\fi
\newcommand{\subparagraph}{\@startsection{subparagraph}{5}{\z@}%
   {\z@}{-1zw}%
   {\normalfont\normalsize\headfont}}
\if@slide
  \setlength\leftmargini{1zw}
\else
  \if@twocolumn
    \setlength\leftmargini{2zw}
  \else
    \setlength\leftmargini{3zw}
  \fi
\fi
\if@slide
  \setlength\leftmarginii {1zw}
  \setlength\leftmarginiii{1zw}
  \setlength\leftmarginiv {1zw}
  \setlength\leftmarginv  {1zw}
  \setlength\leftmarginvi {1zw}
\else
  \setlength\leftmarginii {2zw}
  \setlength\leftmarginiii{2zw}
  \setlength\leftmarginiv {2zw}
  \setlength\leftmarginv  {1zw}
  \setlength\leftmarginvi {1zw}
\fi
\setlength  \labelsep  {0.5zw} % .5em
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\setlength\partopsep{\z@} % {2\p@ \@plus 1\p@ \@minus 1\p@}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\def\@listi{\leftmargin\leftmargini
  \parsep \z@
  \topsep 0.5\baselineskip
  \itemsep \z@ \relax}
\let\@listI\@listi
\@listi
\def\@listii{\leftmargin\leftmarginii
  \labelwidth\leftmarginii \advance\labelwidth-\labelsep
  \topsep \z@
  \parsep \z@
  \itemsep\parsep}
\def\@listiii{\leftmargin\leftmarginiii
  \labelwidth\leftmarginiii \advance\labelwidth-\labelsep
  \topsep \z@
  \parsep \z@
  \itemsep\parsep}
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}
\renewcommand{\theenumi}{\@arabic\c@enumi}
\renewcommand{\theenumii}{\@alph\c@enumii}
\renewcommand{\theenumiii}{\@roman\c@enumiii}
\renewcommand{\theenumiv}{\@Alph\c@enumiv}
\newcommand{\labelenumi}{\theenumi.}
\newcommand{\labelenumii}{\inhibitglue（\theenumii）\inhibitglue}
\newcommand{\labelenumiii}{\theenumiii.}
\newcommand{\labelenumiv}{\theenumiv.}
\renewcommand{\p@enumii}{\theenumi}
\renewcommand{\p@enumiii}{\theenumi\inhibitglue（\theenumii）}
\renewcommand{\p@enumiv}{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}{%
  \list{}{%
    \labelwidth=\leftmargin
    \labelsep=1zw
    \advance \labelwidth by -\labelsep
    \let \makelabel=\descriptionlabel}}{\endlist}
\newcommand*\descriptionlabel[1]{\normalfont\headfont #1\hfil}
\newenvironment{abstract}{%
  \begin{list}{}{%
    \listparindent=1zw
    \itemindent=\listparindent
    \rightmargin=0pt
    \leftmargin=5zw}\item[]}{\end{list}\vspace{\baselineskip}}
\newenvironment{verse}{%
  \let \\=\@centercr
  \list{}{%
    \itemsep \z@
    \itemindent -2zw % 元: -1.5em
    \listparindent\itemindent
    \rightmargin \z@
    \advance\leftmargin 2zw}% 元: 1.5em
  \item\relax}{\endlist}
\newenvironment{quotation}{%
  \list{}{%
    \listparindent\parindent
    \itemindent\listparindent
    \rightmargin \z@}%
  \item\relax}{\endlist}
\newenvironment{quote}%
  {\list{}{\rightmargin\z@}\item\relax}{\endlist}
\def\@begintheorem#1#2{\trivlist\labelsep=1zw
   \item[\hskip \labelsep{\headfont #1\ #2}]}
\def\@opargbegintheorem#1#2#3{\trivlist\labelsep=1zw
      \item[\hskip \labelsep{\headfont #1\ #2（#3）}]}
\newenvironment{titlepage}{%
    \cleardoublepage
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse\newpage
    \fi
    \thispagestyle{empty}%
    \setcounter{page}\@ne
  }%
  {\if@restonecol\twocolumn \else \newpage \fi
    \if@twoside\else
      \setcounter{page}\@ne
    \fi}
\newcommand{\appendix}{\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\@chappos{}%
  \gdef\thechapter{\@Alph\c@chapter}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\@addtoreset{equation}{chapter}
\renewcommand\theequation
  {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@equation}
\newcounter{figure}[chapter]
\renewcommand \thefigure
     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\nobreak\thefigure}
\newenvironment{figure}%
               {\@float{figure}}%
               {\end@float}
\newenvironment{figure*}%
               {\@dblfloat{figure}}%
               {\end@dblfloat}
\newcounter{table}[chapter]
\renewcommand \thetable
     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\nobreak\thetable}
\newenvironment{table}%
               {\@float{table}}%
               {\end@float}
\newenvironment{table*}%
               {\@dblfloat{table}}%
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{5\p@} % 元: 10\p@
\setlength\belowcaptionskip{5\p@} % 元: 0\p@
\long\def\@makecaption#1#2{{\small
  \advance\leftskip .0628\linewidth
  \advance\rightskip .0628\linewidth
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1\hskip1zw\relax #2}%
  \ifdim \wd\@tempboxa <\hsize \centering \fi
  #1\hskip1zw\relax #2\par
  \vskip\belowcaptionskip}}
\DeclareOldFontCommand{\mc}{\normalfont\mcfamily}{\mathmc}
\DeclareOldFontCommand{\gt}{\normalfont\gtfamily}{\mathgt}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*{\cal}{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*{\mit}{\@fontswitch\relax\mathnormal}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{1}
\newdimen\js@tocl@width
\newcommand{\tableofcontents}{%
  \settowidth\js@tocl@width{\headfont\prechaptername\postchaptername}%
  \settowidth\@tempdima{\headfont\appendixname}%
  \ifdim\js@tocl@width<\@tempdima \setlength\js@tocl@width{\@tempdima}\fi
  \ifdim\js@tocl@width<2zw \divide\js@tocl@width by 2 \advance\js@tocl@width 1zw\fi
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{\contentsname}%
  \@mkboth{\contentsname}{}%
  \@starttoc{toc}%
  \if@restonecol\twocolumn\fi
}
\newcommand*{\l@part}[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \addvspace{2.25em \@plus\p@}%
    \begingroup
      \parindent \z@
      \rightskip \@tocrmarg
      \parfillskip -\rightskip
      {\leavevmode
        \large \headfont
        \setlength\@lnumwidth{4zw}%
        #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
      \nobreak
    \global\@nobreaktrue
    \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi}
\newcommand*{\l@chapter}[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \addvspace{1.0em \@plus\p@}
    \begingroup
      \parindent\z@
      \rightskip\@tocrmarg
      \parfillskip-\rightskip
      \leavevmode\headfont
      % \if@english\setlength\@lnumwidth{5.5em}\else\setlength\@lnumwidth{4.683zw}\fi
      \setlength\@lnumwidth{\js@tocl@width}\advance\@lnumwidth 2.683zw
      \advance\leftskip\@lnumwidth \hskip-\leftskip
      #1\nobreak\hfil\nobreak\hbox to\@pnumwidth{\hss#2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
 % \newcommand*{\l@section}{\@dottedtocline{1}{1zw}{3.683zw}}
\newcommand*{\l@section}{%
          \@tempdima\js@tocl@width \advance\@tempdima -1zw
          \@dottedtocline{1}{\@tempdima}{3.683zw}}
\newcommand*{\l@subsection}{%
          \@tempdima\js@tocl@width \advance\@tempdima 2.683zw
          \@dottedtocline{2}{\@tempdima}{3.5zw}}
\newcommand*{\l@subsubsection}{%
          \@tempdima\js@tocl@width \advance\@tempdima 6.183zw
          \@dottedtocline{3}{\@tempdima}{4.5zw}}
\newcommand*{\l@paragraph}{%
          \@tempdima\js@tocl@width \advance\@tempdima 10.683zw
          \@dottedtocline{4}{\@tempdima}{5.5zw}}
\newcommand*{\l@subparagraph}{%
          \@tempdima\js@tocl@width \advance\@tempdima 16.183zw
          \@dottedtocline{5}{\@tempdima}{6.5zw}}
\newdimen\@lnumwidth
\def\numberline#1{\hb@xt@\@lnumwidth{#1\hfil}\hspace{0pt}}
\def\@dottedtocline#1#2#3#4#5{\ifnum #1>\c@tocdepth \else
  \vskip \z@ \@plus.2\p@
  {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
    \parindent #2\relax\@afterindenttrue
   \interlinepenalty\@M
   \leavevmode
   \@lnumwidth #3\relax
   \advance\leftskip \@lnumwidth \null\nobreak\hskip -\leftskip
    {#4}\nobreak
    \leaders\hbox{$\m@th \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
       mu$}\hfill \nobreak\hb@xt@\@pnumwidth{%
         \hfil\normalfont \normalcolor #5}\par}\fi}
\newcommand{\listoffigures}{%
  \if@twocolumn\@restonecoltrue\onecolumn
  \else\@restonecolfalse\fi
  \chapter*{\listfigurename}%
  \@mkboth{\listfigurename}{}%
  \@starttoc{lof}%
  \if@restonecol\twocolumn\fi
}
\newcommand*{\l@figure}{\@dottedtocline{1}{1zw}{3.683zw}}
\newcommand{\listoftables}{%
  \if@twocolumn\@restonecoltrue\onecolumn
  \else\@restonecolfalse\fi
  \chapter*{\listtablename}%
  \@mkboth{\listtablename}{}%
  \@starttoc{lot}%
  \if@restonecol\twocolumn\fi
}
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{2zw}
\newenvironment{thebibliography}[1]{%
  \global\let\presectionname\relax
  \global\let\postsectionname\relax
  \chapter*{\bibname}\@mkboth{\bibname}{}%
  \addcontentsline{toc}{chapter}{\bibname}%
   \list{\@biblabel{\@arabic\c@enumiv}}%
        {\settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \@openbib@code
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}}%
   \sloppy
   \clubpenalty4000
   \@clubpenalty\clubpenalty
   \widowpenalty4000%
   \sfcode`\.\@m}
  {\def\@noitemerr
    {\@latex@warning{Empty `thebibliography' environment}}%
   \endlist}
\newcommand{\newblock}{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty
\newenvironment{theindex}{% 索引を3段組で出力する環境
    \if@twocolumn
      \onecolumn\@restonecolfalse
    \else
      \clearpage\@restonecoltrue
    \fi
    \columnseprule.4pt \columnsep 2zw
    \ifx\multicols\@undefined
      \twocolumn[\@makeschapterhead{\indexname}%
      \addcontentsline{toc}{chapter}{\indexname}]%
    \else
      \ifdim\textwidth<\fullwidth
        \setlength{\evensidemargin}{\oddsidemargin}
        \setlength{\textwidth}{\fullwidth}
        \setlength{\linewidth}{\fullwidth}
        \begin{multicols}{3}[\chapter*{\indexname}%
        \addcontentsline{toc}{chapter}{\indexname}]%
      \else
        \begin{multicols}{2}[\chapter*{\indexname}%
        \addcontentsline{toc}{chapter}{\indexname}]%
      \fi
    \fi
    \@mkboth{\indexname}{}%
%    \plainifnotempty % \thispagestyle{plain}
    \parindent\z@
    \parskip\z@ \@plus .3\p@\relax
    \let\item\@idxitem
    \raggedright
    \footnotesize\narrowbaselines
  }{
    \ifx\multicols\@undefined
      \if@restonecol\onecolumn\fi
    \else
      \end{multicols}
    \fi
    \clearpage
  }
\newcommand{\@idxitem}{\par\hangindent 4zw} % 元 40pt
\newcommand{\subitem}{\@idxitem \hspace*{2zw}} % 元 20pt
\newcommand{\subsubitem}{\@idxitem \hspace*{3zw}} % 元 30pt
\newcommand{\indexspace}{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\newcommand\seename{\if@english see\else →\fi}
\newcommand\alsoname{\if@english see also\else →\fi}
\let\footnotes@ve=\footnote
\def\footnote{\inhibitglue\footnotes@ve}
\let\footnotemarks@ve=\footnotemark
\def\footnotemark{\inhibitglue\footnotemarks@ve}
\renewcommand\@makefnmark{\hbox{}\hbox{%
  \ifydir \@textsuperscript{\normalfont\@thefnmark}%
  \else\hbox{\yoko\@textsuperscript{\normalfont\@thefnmark}}\fi}\hbox{}}
\def\thefootnote{\ifnum\c@footnote>\z@\leavevmode\lower.5ex\hbox{*}\@arabic\c@footnote\fi}
\renewcommand{\footnoterule}{%
  \kern-3\p@
  \hrule width .4\columnwidth
  \kern 2.6\p@}
\@addtoreset{footnote}{chapter}
\long\def\@footnotetext{%
  \insert\footins\bgroup
    \normalfont\footnotesize
    \interlinepenalty\interfootnotelinepenalty
    \splittopskip\footnotesep
    \splitmaxdepth \dp\strutbox \floatingpenalty \@MM
    \hsize\columnwidth \@parboxrestore
    \protected@edef\@currentlabel{%
       \csname p@footnote\endcsname\@thefnmark
    }%
    \color@begingroup
      \@makefntext{%
        \rule\z@\footnotesep\ignorespaces}%
      \futurelet\next\fo@t}
\def\fo@t{\ifcat\bgroup\noexpand\next \let\next\f@@t
                                \else \let\next\f@t\fi \next}
\def\f@@t{\bgroup\aftergroup\@foot\let\next}
\def\f@t#1{#1\@foot}
\def\@foot{\@finalstrut\strutbox\color@endgroup\egroup}
\newcommand\@makefntext[1]{%
  \advance\leftskip 3zw
  \parindent 1zw
  \noindent
  \llap{\@makefnmark\hskip0.3zw}#1}
\def\@inhibitglue{%
  \futurelet\@let@token\@@inhibitglue}
\def\@@inhibitglue{%
  \ifx\@let@token「
    \inhibitglue
  \else
    \ifx\@let@token（
      \inhibitglue
    \else
      \ifx\@let@token『
        \inhibitglue
      \else
        \ifx\@let@token［
          \inhibitglue
        \fi
      \fi
    \fi
  \fi}
\let\everyparhook=\@inhibitglue
\AtBeginDocument{\everypar{\everyparhook}}
\def\@doendpe{%
  \@endpetrue
  \def\par{%
    \@restorepar\everypar{\everyparhook}\par\@endpefalse}%
  \everypar{{\setbox\z@\lastbox}\everypar{\everyparhook}\@endpefalse\everyparhook}}
\def\@item[#1]{%
  \if@noparitem
    \@donoparitem
  \else
    \if@inlabel
      \indent \par
    \fi
    \ifhmode
      \unskip\unskip \par
    \fi
    \if@newlist
      \if@nobreak
        \@nbitem
      \else
        \addpenalty\@beginparpenalty
        \addvspace\@topsep
        \addvspace{-\parskip}%
      \fi
    \else
      \addpenalty\@itempenalty
      \addvspace\itemsep
    \fi
    \global\@inlabeltrue
  \fi
  \everypar{%
    \@minipagefalse
    \global\@newlistfalse
    \if@inlabel
      \global\@inlabelfalse
      {\setbox\z@\lastbox
       \ifvoid\z@
         \kern-\itemindent
       \fi}%
      \box\@labels
      \penalty\z@
    \fi
    \if@nobreak
      \@nobreakfalse
      \clubpenalty \@M
    \else
      \clubpenalty \@clubpenalty
      \everypar{\everyparhook}%
    \fi\everyparhook}%
  \if@noitemarg
    \@noitemargfalse
    \if@nmbrlist
      \refstepcounter\@listctr
    \fi
  \fi
  \sbox\@tempboxa{\makelabel{#1}}%
  \global\setbox\@labels\hbox{%
    \unhbox\@labels
    \hskip \itemindent
    \hskip -\labelwidth
    \hskip -\labelsep
    \ifdim \wd\@tempboxa >\labelwidth
      \box\@tempboxa
    \else
      \hbox to\labelwidth {\unhbox\@tempboxa}%
    \fi
    \hskip \labelsep}%
  \ignorespaces}
\def\@afterheading{%
  \@nobreaktrue
  \everypar{%
    \if@nobreak
      \@nobreakfalse
      \clubpenalty \@M
      \if@afterindent \else
        {\setbox\z@\lastbox}%
      \fi
    \else
      \clubpenalty \@clubpenalty
      \everypar{\everyparhook}%
    \fi\everyparhook}}
\def\@gnewline #1{%
  \ifvmode
    \@nolnerr
  \else
    \unskip \reserved@e {\reserved@f#1}\nobreak \hfil \break \null
    \inhibitglue \ignorespaces
  \fi}
\def\小#1{\hbox{$\m@th$%
  \csname S@\f@size\endcsname
  \fontsize\sf@size\z@
  \math@fontsfalse\selectfont
  #1}}
\def\上小#1{{\sbox\z@ T\vbox to\ht0{\小{#1}\vss}}}
\def\cmrTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    T\kern-.25em\lower.5ex\hbox{E}\kern-.125emX\@
  \else
    T\kern-.1667em\lower.5ex\hbox{E}\kern-.125emX\@
  \fi}
\def\cmrLaTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    L\kern-.32em\上小{A}\kern-.22em\cmrTeX
  \else
    L\kern-.36em\上小{A}\kern-.15em\cmrTeX
  \fi}
\def\sfTeX{T\kern-.1em\lower.4ex\hbox{E}\kern-.07emX\@}
\def\sfLaTeX{L\kern-.25em\上小{A}\kern-.08em\sfTeX}
\def\ptmTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    T\kern-.12em\lower.37ex\hbox{E}\kern-.02emX\@
  \else
    T\kern-.07em\lower.37ex\hbox{E}\kern-.05emX\@
  \fi}
\def\ptmLaTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    L\kern-.2em\上小{A}\kern-.1em\ptmTeX
  \else
    L\kern-.3em\上小{A}\kern-.1em\ptmTeX
  \fi}
\def\pncTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    T\kern-.2em\lower.5ex\hbox{E}\kern-.08emX\@
  \else
    T\kern-.13em\lower.5ex\hbox{E}\kern-.13emX\@
  \fi}
\def\pncLaTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    L\kern-.3em\上小{A}\kern-.1em\pncTeX
  \else
    L\kern-.3em\上小{A}\kern-.1em\pncTeX
  \fi}
\def\pplTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    T\kern-.17em\lower.32ex\hbox{E}\kern-.15emX\@
  \else
    T\kern-.12em\lower.34ex\hbox{E}\kern-.1emX\@
  \fi}
\def\pplLaTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    L\kern-.27em\上小{A}\kern-.12em\pplTeX
  \else
    L\kern-.3em\上小{A}\kern-.15em\pplTeX
  \fi}
\def\ugmTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    T\kern-.1em\lower.32ex\hbox{E}\kern-.06emX\@
  \else
    T\kern-.12em\lower.34ex\hbox{E}\kern-.1emX\@
  \fi}
\def\ugmLaTeX{%
  \ifdim \fontdimen\@ne\font >\z@
    L\kern-.2em\上小{A}\kern-.13em\ugmTeX
  \else
    L\kern-.3em\上小{A}\kern-.13em\ugmTeX
  \fi}
\DeclareRobustCommand{\TeX}{%
  \def\@tempa{cmr}%
  \ifx\f@family\@tempa\cmrTeX
  \else
    \def\@tempa{ptm}%
    \ifx\f@family\@tempa\ptmTeX
    \else
      \def\@tempa{txr}%
      \ifx\f@family\@tempa\ptmTeX
      \else
        \def\@tempa{pnc}%
        \ifx\f@family\@tempa\pncTeX
        \else
          \def\@tempa{ppl}%
          \ifx\f@family\@tempa\pplTeX
          \else
            \def\@tempa{ugm}%
            \ifx\f@family\@tempa\ugmTeX
            \else\sfTeX
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi}

\DeclareRobustCommand{\LaTeX}{%
  \def\@tempa{cmr}%
  \ifx\f@family\@tempa\cmrLaTeX
  \else
    \def\@tempa{ptm}%
    \ifx\f@family\@tempa\ptmLaTeX
    \else
      \def\@tempa{txr}%
      \ifx\f@family\@tempa\ptmLaTeX
      \else
        \def\@tempa{pnc}%
        \ifx\f@family\@tempa\pncLaTeX
        \else
          \def\@tempa{ppl}%
          \ifx\f@family\@tempa\pplLaTeX
          \else
            \def\@tempa{ugm}%
            \ifx\f@family\@tempa\ugmLaTeX
            \else\sfLaTeX
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi}
\DeclareRobustCommand{\LaTeXe}{$\mbox{%
  \if b\expandafter\@car\f@series\@nil\boldmath\fi
  \LaTeX\kern.15em2\raisebox{-.37ex}{$\textstyle\varepsilon$}}$}
\def\pTeX{p\kern-.05em\TeX}
\def\pLaTeX{p\LaTeX}
\def\pLaTeXe{p\LaTeXe}
\def\AmSTeX{\protect\AmS-\protect\TeX{}}
\DeclareRobustCommand{\BibTeX}{B\kern-.05em\小{I\kern-.025em B}%
  \ifx\f@family\cmr\kern-.08em\else\kern-.15em\fi\TeX}
\DeclareRobustCommand{\SliTeX}{%
  S\kern-.06emL\kern-.18em\上小{I}\kern -.03em\TeX}
\let\ltx@ifnextchar\@ifnextchar
\def\ProvidesFile#1{%
  \begingroup
    \catcode`\ 10 %
    \ifnum \endlinechar<256 %
      \ifnum \endlinechar>\m@ne
        \catcode\endlinechar 10 %
      \fi
    \fi
    \@makeother\/%
    \@makeother\&%
    \ltx@ifnextchar[{\@providesfile{#1}}{\@providesfile{#1}[]}}
\newcommand{\prepartname}{\if@english Part~\else 第\fi}
\newcommand{\postpartname}{\if@english\else 部\fi}
\newcommand{\prechaptername}{\if@english Chapter~\else 第\fi}
\newcommand{\postchaptername}{\if@english\else 章\fi}
\newcommand{\presectionname}{}%  第
\newcommand{\postsectionname}{}% 節
\newcommand{\contentsname}{\if@english Contents\else 目次\fi}
\newcommand{\listfigurename}{\if@english List of Figures\else 図目次\fi}
\newcommand{\listtablename}{\if@english List of Tables\else 表目次\fi}
\newcommand{\refname}{\if@english References\else 参考文献\fi}
\newcommand{\bibname}{\if@english Bibliography\else 参考文献\fi}
\newcommand{\indexname}{\if@english Index\else 索引\fi}
\newcommand{\figurename}{\if@english Fig.~\else 図\fi}
\newcommand{\tablename}{\if@english Table~\else 表\fi}
\newcommand{\appendixname}{\if@english \else 付録\fi}
\newif\if西暦 \西暦true
\def\西暦{\西暦true}
\def\和暦{\西暦false}
\newcount\heisei \heisei\year \advance\heisei-1988\relax
\def\today{%
  \if@english
    \ifcase\month\or
      January\or February\or March\or April\or May\or June\or
      July\or August\or September\or October\or November\or December\fi
      \space\number\day, \number\year
  \else
    \if西暦
      \number\year 年
      \number\month 月
      \number\day 日
    \else
      平成\number\heisei 年
      \number\month 月
      \number\day 日
    \fi
  \fi}
\hyphenation{ado-be post-script ghost-script phe-nom-e-no-log-i-cal man-u-script}
\if@report \pagestyle{plain} \else \pagestyle{headings} \fi
\pagenumbering{arabic}
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
  \raggedbottom
\fi
\if@slide
  \renewcommand\kanjifamilydefault{\gtdefault}
  \renewcommand\familydefault{\sfdefault}
  \raggedright
  \xkanjiskip=0.1em\relax
\fi
\endinput
%%
%% End of file `jsbook.cls'.
