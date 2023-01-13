/*** Definition Section ***/
%{
#include <string.h>

typedef struct {
    char token[257];
    int symbolTableCode;
}PIF;

typedef struct{
    char token[257];
    int index;
}ST;

ST SymbolTable[100];
int stLength = 0;

PIF ProgramInternalForm[300];
int pifLength = 0;

int errorFound = 0;
int lineNumber = 1;


int addToST(char* token) {
	for(int i = 0; i < stLength; i++) {
		
		if(strcmp(SymbolTable[i].token, token) == 0) {
		  return SymbolTable[i].index;
		}
	}
	strcpy(SymbolTable[stLength].token, token);
	SymbolTable[stLength].index = stLength;
	stLength++;
	
	return stLength - 1;
}

void addToPIF(char* token, int stCode) {
	strcpy(ProgramInternalForm[pifLength].token, token);
	ProgramInternalForm[pifLength].symbolTableCode = stCode;
	
	pifLength++;
}

void showSymbolTable() {
    printf("~~~~~~~ Symbol table ~~~~~~~\n");
    
    for(int i = 0 ; i < stLength; i++) {
        printf(" %s  %d", SymbolTable[i].token, SymbolTable[i].index);
        printf("\n");
    }
    
    printf("~~~~~~~ End ST ~~~~~~~\n");
    printf("\n");
}

void showProgramInternalForm() {
    printf("~~~~~~~ Program internal form ~~~~~~~\n");
    
    for(int i = 0; i < pifLength; i++) {
    
        printf(" %s  %d ", ProgramInternalForm[i].token, ProgramInternalForm[i].symbolTableCode);
        printf("\n");
    }
    
    printf("~~~~~~~ End PIF ~~~~~~~\n");
    printf("\n");
}

%}

%option noyywrap
%option caseless


REAL_NUMBER  [+-]?(0|[1-9][0-9]*)(\.[0-9]+)?
IDENTIFIER   [a-z][a-z0-9_]*
STRING       \".*\"

/*** Rule Section ***/
%%
					/* yytext is the text in the buffer */
CHAR                          { addToPIF(yytext, -1); return CHAR;}
INT					{ addToPIF(yytext, -1); return INT;}
FLOAT					{ addToPIF(yytext, -1); return FLOAT;}
CONST					{ addToPIF(yytext, -1); return CONST;}
IF                            { addToPIF(yytext, -1); return IF;}
ELSE                          { addToPIF(yytext, -1); return ELSE;}
READ                          { addToPIF(yytext, -1); return READ;}
WRITE                         { addToPIF(yytext, -1); return WRITE;}
WHILE                         { addToPIF(yytext, -1); return WHILE;}
BOOL                          { addToPIF(yytext, -1); return BOOL;}
\{                                    	{ addToPIF(yytext, -1); return LEFTBRACKET;}
\}                                    	{ addToPIF(yytext, -1); return RIGHTBRACKET;}
\+                                    	{ addToPIF(yytext, -1); return PLUS;}
\-                                    	{ addToPIF(yytext, -1); return MINUS;}
\*                                    	{ addToPIF(yytext, -1); return MULTIPLICATION;}
\/                                    	{ addToPIF(yytext, -1); return DIV;}
\%                                    	{ addToPIF(yytext, -1); return MOD;}
\>                                    	{ addToPIF(yytext, -1); return GREATER;}
\<                                    	{ addToPIF(yytext, -1); return LESS;}
\>=                                    	{ addToPIF(yytext, -1); return GREATEREQUAL;}
\<=                                    	{ addToPIF(yytext, -1); return LESSEQUAL;}
\=                                    	{ addToPIF(yytext, -1); return ATRIBUTE;}
\==                                    	{ addToPIF(yytext, -1); return EQUAL;}
\!=                                    	{ addToPIF(yytext, -1); return NOTEQUAL}
{IDENTIFIER}			{ int stCode = addToST(yytext); addToPIF(yytext, stCode); return IDENTIFIER;}
{REAL_NUMBER}                 { int stCode = addToST(yytext); addToPIF(yytext, stCode); return REAL;}
{STRING}				{ int stCode = addToST(yytext); addToPIF(yytext, stCode); return STRING;}
[\n]					{ ++lineNumber; return NEWLINE;}
[ \t\n]+             			{ ; /* eat up whitespace */ }
.                			{ errorFound = 1; printf("Illegal token %s at line %d !", yytext, lineNumber); printf("\n"); }
%%

/* yywrap() - wraps the above rule section */
/*int yywrap() {}

int main(int argc, char** argv) {

	FILE *fp;
	fp = fopen(argv[1], "r");
	
	/* yyin - takes the file pointer which contains the input*/
	yyin = fp;

	/* yylex() - this is the main flex function which runs the Rule Section*/ 
	yylex();
	
	if (errorFound == 0) {
    		showSymbolTable();
    		showProgramInternalForm();
	}
  
	return 0;
}*/
