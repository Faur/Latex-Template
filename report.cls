% Packages that must be initialized before the draft call
\RequirePackage[final]{graphicx} %\includegraphics
%\RequirePackage{listings} %Inputting Code
\RequirePackage[l2tabu, orthodox]{nag} %warns about use of obsolete commands

\ProvidesClass{report}
\LoadClassWithOptions{extarticle}
  %extarticle: http://ftp.snt.utwente.nl/pub/software/tex/macros/latex/contrib/extsizes/extsizes.pdf

%%%%%%%%%%%%%%%%%%%%
%%% USER OPTIONS %%%
%%%%%%%%%%%%%%%%%%%%

\RequirePackage{xkeyval} % allows class options of the type lang=danish
\RequirePackage{lmodern}
  %\RequirePackage ~ \usepackage
  % lmoderm: Latin modern, fonts
\RequirePackage{etoolbox}
  %Conditionals, if, else
  \newtoggle{is_danish}
  \newtoggle{is_english}
  \newtoggle{is_DTU}
  \newbool{customauthorheader} % Whether a custom left header is to be used
  \newbool{customcourseheader} % Whether a custom middle header is to be used
  \newbool{coursedefined}

%%% FONT TYPE
\DeclareOption{sans}{
  \renewcommand{\familydefault}{\sfdefault}
}
\DeclareOption{roman}{
  \renewcommand{\familydefault}{\rmdefault}
}

\ExecuteOptions{roman}
  % Set default option

%%% Language
\DeclareOption{_danish}{ \toggletrue{is_danish}}
\DeclareOption{_english}{ \toggletrue{is_english}}
\newcommand{\lang}{\iftoggle{is_danish}{danish}{\iftoggle{is_english}{english}{}}} % returns the chosen language
\DeclareOption{DTU}{ \toggletrue{is_DTU}}

\ProcessOptions\relax
  % Terminate option processing

%%%%%%%%%%%%%%%%
%%% PACKAGES %%%
%%%%%%%%%%%%%%%%

%%% STANDARD WIZARD QUICK START
\usepackage[utf8]{inputenc}
\iftoggle{is_danish}{\usepackage[english, danish]{babel}}{ 
  \iftoggle{is_english}{\usepackage[danish, english]{babel}}{}
} %Preferred language last
\usepackage{amssymb}
\usepackage{mathtools} %>amsmath
\usepackage{amssymb} %useful mathematical symbols

%%% MINIMUM
\usepackage[a4paper, top=4cm, bottom=3cm, left=3cm, right=3cm]{geometry} %Page formatting
  \setlength{\headheight}{14.5pt}
\usepackage[usenames,dvipsnames,svgnames,table]{xcolor} %> color, load early
\usepackage[square, comma, sort]{natbib} %\citep{}, \citet{}
\usepackage{lastpage} %Page counter
\usepackage{fancyhdr} %Format header and footer
\usepackage[fit, breakwords]{truncate} 
\usepackage[hidelinks, final]{hyperref} %Internet links NB: INCLUDE BEFORE cleveref
  % Removing 'final' might make the draft compile faster
\usepackage[\lang]{cleveref} 
\usepackage{float} %H specifier for figures/tables ect
\usepackage[section]{placeins} %\FloatBarrier: empty float holding queue + add this to all sections
\usepackage[margin=0.5cm, labelfont={sc}, font=small]{caption}

%%% REGULAR PACKAGES
\usepackage{microtype} %improves the spacing between words and letters
\usepackage[colorinlistoftodos, obeyFinal]{todonotes} %todo notes
\usepackage[final]{listings} %Inputting Code
\usepackage{siunitx} %\SI
\usepackage{ifdraft} %test draft/final state. Default is final

%%% USEFULL PACKAGES
\usepackage[final]{pdfpages} %Include PDF
\usepackage{enumitem} %Format itemize, enumerate
\usepackage{epstopdf} %Allows EPS graphics
\usepackage[notref, notcite]{showkeys} %Display label in pdf
\usepackage{lipsum} % \lipsum: Create some latin text to test layout and formatting

%\usepackage{enumerate}
%\usepackage{ulem}  
%\usepackage{tikz}
%\usepackage{calc}
%\usepackage{ifthen} % Obsolete! Use etoolbox instead
%\usepackage{physics}
%\usepackage{fixltx2e}
%\usepackage{leftidx}
%\usepackage{setspace}
\usepackage{pdfpages} % Allows inserting pages from external pdf
\usepackage{mathrsfs}
\usepackage{amsbsy}


%%%%%%%%%%%%%%%%%%%%%%%
%%% CUSTOM COMMANDS %%%
%%%%%%%%%%%%%%%%%%%%%%%

%%% PRACTICAL
%info
\newcommand{\info}[1]{ 
\begin{small} \begin{quote}\begin{em} #1 
\end{em}\end{quote}\end{small}}

% underline without added vspace
\newcommand{\ul}[1]{\underline{\smash{#1}}}

% easy links
\newcommand{\www}[3][blue]{\href{#3}{\color{#1}{\ul{#2}}}}

% easy code
\renewcommand{\c}[1]{ \lstinline$#1$} %inline code

% user defined commands

%todos
\definecolor{td_red}{rgb}{1, 0.2, 0.2} % keywords
\newcommand{\tdr}[1]{\todo[inline, color=td_red]{#1}}
\newcommand{\tdo}[1]{\todo[inline, color=Dandelion]{#1}}
\newcommand{\tdb}[1]{\todo[inline, color=CornflowerBlue]{#1}}
\newcommand{\tdg}[1]{\todo[inline, color=LimeGreen]{#1}}
\newcommand{\tdp}[1]{\todo[inline, color=CarnationPink]{#1}}
\newcommand{\tdy}[1]{\todo[inline, color=Yellow]{#1}}

%%%%%%%%%%%%%%%%%%%%
%%% LAYOUT SETUP %%%
%%%%%%%%%%%%%%%%%%%%

\setlength\parindent{0pt} % Remove paragraph indent
\newtoggle{custom_TOC}

%%% META
\newcommand{\course}[1]{\def \course {#1}\booltrue{coursedefined}}
\newcommand{\authorheader}[1]{\def\authorheader{#1}\booltrue{customauthorheader}}
\newcommand{\courseheader}[1]{\def\courseheader{#1}\booltrue{customcourseheader}}
\newcommand{\TOCtitle}[1]{
  \toggletrue{custom_TOC}
  \def\TOCtitle{#1}
}

\newcommand{\TOC}{
  \iftoggle{custom_TOC}{
    \renewcommand*\contentsname{\TOCtitle}
  }{
    \iftoggle{is_danish}{ % === IF
      \renewcommand*\contentsname{Indholdsfortegnelse}
    } { % ===ELSE
      \renewcommand*\contentsname{Table of Contents}
    } %=== END IF
  }
  \tableofcontents
  \thispagestyle{empty}
  \newpage
  \setcounter{page}{1}
}


%%% HEADERS & FOOTERS
\pagestyle{fancy}
\makeatletter
\lhead{\ifbool{customauthorheader}{\authorheader}{\@author}}
\chead{\ifbool{customcourseheader}{\courseheader}{\truncate{200pt}{\course}}}
%\chead{\truncate{250pt}{\course}}
\rhead{\@date}
\lfoot{}
\cfoot{\thepage/\pageref*{LastPage}} %CHANGEABLE
\rfoot{}


%%% PROGRAMMING LANGUAGES
\definecolor{lightlightgray}{gray}{0.95} % background
\definecolor{comment}{rgb}{0.35, 0.6, 0.35}
\definecolor{shpurple}{rgb}{0.5,0,0.35} % keywords

\lstset{ language=C++,
  backgroundcolor=\color{lightlightgray},
  morekeywords={*, factorial, sum, erlang},
  keywordstyle=\color{shpurple}\textbf,
  commentstyle=\color{comment}\textit,
  stringstyle=\color{blue},
  numberstyle=\small\color{gray},  % the style that is used for the line-numbers
%
% Boring default stuff 
  basicstyle=\ttfamily,           % the size of the fonts that are used for the code
  numbers=left,                   % where to put the line-numbers
  stepnumber=1,                   % the step between two line-numbers. If it's 1, each line will be numbered
  numbersep=8pt,                  % how far the line-numbers are from the code
  showspaces=false,               % show spaces adding particular underscores
  showstringspaces=false,         % underline spaces within strings
  showtabs=false,                 % show tabs within strings adding particular underscores
  frame=single,                   % adds a frame around the code
  frame=ltrb,
  rulecolor=\color{black},        % if not set, the frame-color may be changed on line-breaks within not-black text (e.g. commens (green here))
  tabsize=2,                      % sets default tabsize to 2 spaces
  captionpos=b,                   % sets the caption-position to bottom
  breaklines=true,                % sets automatic line breaking
  breakatwhitespace=false,        % sets if automatic breaks should only happen at whitespace
  title=\lstname,                 % show the filename of files included with \lstinputlisting;
  xleftmargin=25pt,
  xrightmargin=25pt,
  aboveskip=10pt,
  belowskip=10pt
}


%%% TITLE PAGE
\renewcommand{\maketitle}{
\input{./appendix/frontpage.tex}
}


\endinput
  % NB: This must be the last command in a class document


