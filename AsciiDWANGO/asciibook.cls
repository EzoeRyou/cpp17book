\ProvidesClass{asciibook}[2015/01/30]
\LoadClassWithOptions{jsbook}



% 1行の文字数および版面の左右空き調整
\setlength\paperheight{210truemm}
\setlength\paperwidth{148truemm}
\setlength{\textwidth}{38zw}
%%
\setlength{\evensidemargin}{-8.4truemm}
\setlength{\oddsidemargin}{-3truemm}

% 1ページの行数を設定
\setlength{\textheight}{35\baselineskip}

% 本文中のヘッダ、フッタ
\def\ps@asciiheadings{%
   \def\@oddfoot{\hfil \thepage}%
   \def\@evenfoot{\thepage \hfil}%
   \def\@evenhead{\small \leftmark \hfil}% UNIXプログラミング環境: \small
   \def\@oddhead{\small \hfil \rightmark}% UNIXプログラミング環境: \small
}

% 前付けのヘッダ、フッタ
\def\ps@frontheadings{%
   \def\@oddfoot{\hfil \thepage}%
   \def\@evenfoot{\thepage \hfil}%
   \def\@evenhead{}%
   \def\@oddhead{}%
}


% 章トビラのヘッダ、フッタの指定
\makeatletter
\renewcommand{\chapter}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \global\@topnum\z@
  \secdef\@chapter\@schapter}
\makeatother

% ヘッダの空き調整
\addtolength{\topmargin}{-55pt}
\addtolength{\headsep}{10pt}

% フッタの空き調整
\setlength\footskip{2.5\baselineskip}
\addtolength{\textheight}{\baselineskip}

% 印刷位置の調整
\advance\hoffset 0.0in
\advance\voffset 0.0in

% 見出しフォントを太ゴシックにする
%\renewcommand{\headfont}{\sffamily\bfseries}
\renewcommand{\headfont}{\sffamily\bfseries\ebseries}

% 章見出しの背景にグラフィックを入れる
\makeatletter
\def\@makechapterhead#1{
	\vbox to 0mm{
	\hbox to 0mm{\includegraphics{title.eps}\hss}
	\vss
	}
	\vbox{
		\vskip 10mm
%%		{\huge\headfont \@chapapp\thechapter\@chappos}
		\hskip 4mm{\Large\headfont \@chapapp\thechapter\@chappos}
		\vskip 5mm
		{\huge\headfont \parbox{130mm}{#1}}
		\vskip 20mm
	}
}

\renewcommand{\section}{%
  \if@slide\clearpage\fi
  \@startsection{section}{1}{\z@}%
  {1.5\Cvs \@plus.5\Cdp \@minus.2\Cdp}%  前アキ
  {.5\Cvs \@plus.3\Cdp}% 後アキ
  {\normalfont\large\headfont\raggedright}}
\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
  {\Cvs \@plus.5\Cdp \@minus.2\Cdp}% 前アキ
%  {.5\Cvs \@plus.3\Cdp}% 後アキ
  {.1\Cvs \@plus.3\Cdp}% 後アキ
  {\normalfont\normalsize\headfont}}
\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
  {\z@}{\z@}%
  {\normalfont\normalsize\sffamily\bfseries}}

\makeatother

% 索引のスタイル
\def\ps@indexfoot{%
  \def\@oddfoot{%
        {\hbox to \fullwidth{\hfil \thepage}}}%
  \let\@oddhead\@empty
  \def\@evenfoot{%
        \hss {\hbox to \fullwidth{\thepage \hfil}}}%
  \let\@evenhead\@empty}
