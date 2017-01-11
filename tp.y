/* les tokens ici sont ceux supposes etre renvoyes par l'analyseur lexical
 * Doit donc etre en coherence avec tp.l
 * Ces tokens sont traduites en constantes entieres dans tp_y.h qui est
 * importe par tp.l
 * Bison ecrase le contenu de tp_y.h a partir de la description de la ligne
 * suivante. C'est donc cette ligne qu'il faut adapter si besoin, pas tp_y.h !
 */

/* voir la definition de YYSTYPE dans main.h
 * S et C sont des etiquettes de variantes dans le type union YYSTYPE
 */

/* attention: NEW est defini dans tp.h Utilisez un autre token */
%token IS CLASS VAR EXTENDS DEF OVERRIDE RETURN AS IF THEN ELSE AFF INST ADD SUB MULT DIV
%token<S> ID IDENTCLASS
%token<I> Cste
%token<C> RelOp AndOp

/* indications de precedence (en ordre croissant) et d'associativite. Les
 * operateurs sur une meme ligne (separes par un espace) ont la meme priorite.
 */
%right AFF
%nonassoc RelOp
%left ADD SUB
%left MULT DIV
%left AndOp
%left UNARY
%left '.'



%{
#include "tp.h"
#include "tp_y.h"

extern int yylex();
extern void yyerror(char *);
%}

%%
/* Grammaire Projet Compilation */

/*
* IDENTTYPE => ID: type (Integer, String)
* IDENTCLASS : Commence par une majuscule
* ID : nom var/classe/methode
* AFF : ':='
* IS :'is'
* CLASS : 'class'
* EXTENDS : 'extends
* OVERRIDE : 'override'
* AS : 'as'
* DEF : 'def'
* RelOp : 'comparaison'
* VAR : 'var'
* RETURN : 'return'
* INST : 'new'
*/

prog : listClassDecl bloc
;

listClassDecl : classDecl listClassDecl
|
;

classDecl : CLASS IDENTCLASS '(' listParameter ')' herite constructor  IS '{' corpsClasse '}'
;

listParameter : subListParam {$$=$1;}
| /*ε*/ {$$=NULL;}
;

subListParam : parameter {$$=$1;}
| parameter',' subListParam {$$=makeTree(LIST, 2, $1, $3);}
;

parameter : ID ':' IDENTCLASS 
;

herite : EXTENDS IDENTCLASS '(' listArgument ')' 
| /*ε*/ {$$=NULL;}
;

listArgument : subListArgument {$$=$1;}
| /*ε*/ {$$=NULL;}
;

subListArgument : expr {$$=$1;}
| expr ',' subListArgument {$$=makeTree(LIST, 2, $1, $3);}
;

constructor : bloc {$$=$1;}
| /*ε*/ {$$=NULL;}
;

corpsClasse : listDeclaration listDeclMethode {$$=makeList(LIST, 2, $1, $2);}
;

bloc : '{' instOpt '}' 
| '{' listDeclaration isInstruction '}' 
;

listDeclaration : declChamp listDeclaration {$$=makeTree(LIST, 2, $1, $2);}
|  /*ε*/ {$$=NULL;}
;

isInstruction : IS listInstruction
;

instOpt : listInstruction 
|  /*ε*/ {$$=NULL;}
;

listInstruction : instruction listInstruction {$$=makeTree(LIST, 2, $1, $2);}
| instruction {$$=$1;}
;

instruction : expr';'
| bloc {$$=$1;}
| RETURN';' 
| affectation';' 
| IF expr THEN instruction ELSE instruction 
;

expr : expr ADD expr {$$=makeTree(PLUS, 2, $1, $3);}
| expr SUB expr {$$=makeTree(MINUS, 2, $1, $3);}
| expr MULT expr {$$=makeTree(BY, 2, $1, $3);}
| expr DIV expr {$$=makeTree(DIVI, 2, $1, $3);}
| ADD expr %prec UNARY {$$=$2;}
| SUB expr %prec UNARY {$$=makeTree(MINUS, 2, makeLeafInt(0), $2);}
| expr AndOp expr { $$=makeTree(ESPER, 2, $1, $3);}
| expr RelOp expr { $$=makeTree($2, 2, $1, $3);}
| envoiMessage
| selection
| instanciation
| ID {$$ = makeLeafStr(AF, $1);}
| cast
| Cste {$$ = makeLeafInt(AF, $1);}
| '(' expr ')' {$$ = $2;}
;

selection : expr'.'ID
;

cast : '(' AS IDENTCLASS':' expr ')'
;

instanciation : INST IDENTCLASS '(' listArgument ')'
;

envoiMessage : expr'.' ID '('listArgument')'
;

listDeclMethode : declMethode listDeclMethode
|  /*ε*/ {$$=NULL;}
;

declMethode : override DEF ID '('listParameter')' endDeclMethode
;

override : OVERRIDE 
|  /*ε*/ {$$=NULL;}
;

endDeclMethode : ':' IDENTCLASS AFF expr
| identClassOpt IS bloc
;

identClassOpt : ':' IDENTCLASS 
|  /*ε*/ {$$=NULL;}
;

declChamp : VAR ID ':' IDENTCLASS champExp ';'
;

/*champ :selection
| methowde
| expr
;*/

champExp : AFF expr
|  /*ε*/ {$$=NULL;}
;

affectation : expr AFF expr {$$=makeTree(AFF, 2, $1, $3);}
;


