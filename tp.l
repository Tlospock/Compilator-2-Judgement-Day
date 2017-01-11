Chiffre [0-9]
Entier {Chiffre}+
Lower	[a-z]
Upper	[A-Z]
Lettre	[a-zA-Z]
LC 	({Lettre}|{Chiffre})
Delim   [ \t\n\r]
Symbole [&+\-*/();:,.{}]
BS      \\.
PasBSG [^\\"]
Guill		"\""
Star  		"*"
NotStar		[^*]
NotStarPar      [^*/]

%{
#include <string.h>
#include <strings.h>
#include "tp.h"
#include "tp_y.h"

extern char *strdup(char *);
extern YYSTYPE yylval;
extern int yylineno;
extern int yylex();

int chooseKeywordID()
{
	if (!strcmp(yytext,"var"))	return(VAR);
	if(!strcmp(yytext,"class")) return(CLASS);
	if (!strcmp(yytext,"is"))	return(IS);
	if (!strcmp(yytext,"extends"))	return(EXTENDS);
	if (!strcmp(yytext,"def"))	return(DEF);
	if (!strcmp(yytext,"new"))	return(INST);
	if (!strcmp(yytext,"override"))	return(OVERRIDE);
	if (!strcmp(yytext,"if"))	return(IF);
	if (!strcmp(yytext,"then"))	return(THEN);
	if (!strcmp(yytext,"else"))	return(ELSE);
	if (!strcmp(yytext,"as"))	return(AS);
	yylval.S = strdup(yytext);
	return(ID);
}

%}

%%
{Entier} 	{ yylval.I = atoi(yytext); return(Cste); }
"/*"({NotStar}|{Star}+{NotStarPar})*{Star}*"*/" {}
{Guill}([^"]|{BS})*{Guill}	{ return(ID); }
"+"			{ yylval.C = PLUS; return(ADD); }
"-"			{ yylval.C = MINUS; return(SUB); }
"*"			{ yylval.C = BY; return(MULT); }
"/"			{ yylval.C = DIVI; return(DIV); }
"&"			{ yylval.C = ESPER; return(AndOp); }
{Symbole}	{ return(yytext[0]); }
{Delim}+	{}
":="		{ return(AFF); }
"="			{ yylval.C = EQ; return(RelOp); }
"<>"		{ yylval.C = NE; return(RelOp); }
"<="		{ yylval.C = LE; return(RelOp); }
">="		{ yylval.C = GE; return(RelOp); }
">"			{ yylval.C = GT; return(RelOp); }
"<"			{ yylval.C = LT; return(RelOp); }
{Upper}{LC}*	{ yylval.S = strdup(yytext); return(IDENTCLASS); }
{Lower}{LC}*	{ return chooseKeywordID(); }
%%
