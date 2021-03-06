%{

/**
 * @file
 * @section Description
 *
 * This is a Flex file used for lexical analysis of SQL statements. You will
 * notice SQL keywords, operators, and constant expressions i.e. strings,
 * integers, and floating point numbers. This file is used with the parser
 * generated using the sql.y file.
 */


#define YY_NO_INPUT
#define _XOPEN_SOURCE 500
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "node.h"
#include "sql.tab.h"
%}

%option always-interactive
%option noyywrap
%option nounput

%%


 /* ignore whitespace */
[ \t\n]            ;

 /* case insensitive keywords */
(?i:select)		{ return TSELECT; }
(?i:from)		{ return TFROM; }
(?i:where)		{ return TWHERE; }
(?i:as)			{ return TAS; }

(?i:and)		{ return TAND; }
(?i:or)			{ return TOR; }

 /* parses strings such as column names and table names, not used for string
  * constants */
[a-zA-Z][a-zA-Z0-9]*    {
    int n = strlen(yytext) + 1;
    yylval.s = malloc(n);
    if(yylval.s)
        strcpy(yylval.s, yytext);
    return TSTRING;
}

 /* integer values */
\-?[0-9]+        {
    yylval.i = atoi(yytext);
    return TINT;
}

 /* floating point */
\-?[0-9]+\.[0-9]+ {
    yylval.f = atof(yytext);
    return TFLOAT;
}

 /* comparison operators */
"="		return TCEQ;
"!="	return TCNE;
"<"		return TCLT;
"<="	return TCLE;
">"		return TCGT;
">="	return TCGE;

 /* math operators */
"+"		return TPLUS;
"-"		return TMINUS;
"*"		return TMUL;
"/"		return TDIV;

 /* syntax extras */
","		return TCOMMA;
"("		return TLP;
")"		return TRP;

%%


