%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node
{
	char *token;
	struct node *left;
	struct node *right;
} node;
node  *mknode(char *token, node *left, node *right);
void printtree(node * tree,int space);
#define YYSTYPE struct node*

%}

%token BOOL CHAR INT REAL STRING VAR
%token INTPOINTER CHARPOINTER REALPOINTER
%token IF ELSE
%token WHILE
%token FUNC PROC RETURN NULLPTR MAIN
%token AND EQ G GE L LE NOT NOTEQ OR
%token DIV ASS MINUS PLUS MUL ADDRESS DEREF
%token TRUE FALSE CHARLIT DECIMALLIT HEXLIT REALLIT STRINGLIT ID;



%left ASS
%left AND
%left OR
%left EQ NOTEQ
%left G GE L LE
%left PLUS MINUS
%left MUL DIV


/*---START OF THE RULES---*/

%%
S:  
		MYCODE { printtree($1,0);};

MYCODE:
		program { $$ = mknode("CODE",$1, NULL ); };

program: 
		program program {$$ = mknode("",$1,$2);}
		|proc 	{$$ = mknode("PROC",$1, NULL ); }
		|func	{$$ = mknode("FUNC",$1, NULL ); };

proc:
		PROC ID '(' ARGS ')' '{' body '}' {$$ = mknode($2->token,$4,$7);}
		|PROC MAIN '(' ARGS ')' '{' body '}' { $$ = mknode($2->token,$4,$7);} ;

func:	
		FUNC ID '(' ARGS ')' SEMI_FUNC	{ $$ = mknode($2->token,$4,$6);};

SEMI_FUNC:
		RETURN TYPE '{' BODY_FUNC '}' { $$ = mknode("RET",$2,$4);};

BODY_FUNC:
		body FUNC_RETURN { $$ = mknode("",$1,$2);};

FUNC_RETURN:
		RETURN EXP { $$ = mknode("RET",$2,NULL);};

		
ARGS:
		parameter_list {$$ = mknode("ARGS",$1,NULL);};
		


TYPE:		
		BOOL	{ }
		|CHAR	{ }
		|INT	{ }
		|REAL	{ }
		|STRING	{ }
		|STRING '[' DECIMALLIT ']' { }
		|INTPOINTER	{ }
		|CHARPOINTER	{ }
		|REALPOINTER	{ };


STRINGARR:
				STRING '[' DECIMALLIT ']' { }
				|ID '[' DECIMALLIT ']' { };		

parameter_list:
				PARM ':' TYPE { $$ = mknode($3->token,$1, NULL );}
				|PARM ':' TYPE ';' parameter_list { $$ = mknode($3->token,$1, $5 );  }
				|/*EMPTY*/ { $$ = mknode("NONE",NULL, NULL ); };

PARM:
				ID ',' PARM {$$ = mknode($1->token,NULL,$3); }
				|ID {$$ = mknode($1->token,NULL,NULL);};
				
body:
				func {  $$ = mknode("FUNC",$1, NULL ); }
				|body body {  $$ = mknode("",$1, $2 ); }
				|proc {  $$ = mknode("PROC",$1, NULL ); }
				|VAR_PARM { $$ = mknode("",$1, NULL); }
				|VAR_PARM body { $$ = mknode("",$1, $2); }
				|VAR PARM ':' STRINGARR ';' body { }				
				|STATMENT { $$ = mknode("",$1, NULL ); }
				|/*EMPTY*/ { $$ = mknode("",NULL, NULL ); };

VAR_PARM:
				VAR PARM ':' TYPE ';'{$$ = mknode($1->token,$2, $4); };

STATMENT:
				ASS_STAT { $$ = mknode("=",$1, NULL ); }
				|FUNC_CALL {$$ = mknode("FUNC",$1,NULL); }
				|IF_STAT {$$ = mknode("IF",$1,NULL); }
				|IF_ELSE_STAT { $$ = mknode("IF-ELSE",$1,NULL);}
				|WHILE_STAT { $$ = mknode("WHILE",$1,NULL); }
				|CODE_BLOCK { $$ = mknode("BLOCK",$1,NULL); }
				|STATMENT STATMENT { $$ = mknode("",$1,$2);};

ASS_STAT:
				ID ASS EXP {$$ = mknode("",$1 ,$3); }
				|STRINGARR ASS EXP {$$ = mknode("",$1 ,$3);  }
				|DEREF ID ASS EXP { $$ = mknode($1->token,$2 ,$4);  }
				|ID ASS FUNC_CALL { $$ = mknode("",$1 ,$3);  };

FUNC_CALL:
				ID '(' EXP ')' ';'{ $$ = mknode("",$1,$3); }
				|ID '(' EXP ')' { $$ = mknode("",$1,$3); };
				
IF_STAT:
				IF '(' EXP ')' '{' body '}' { $$ = mknode("",$3,$6); }
				|IF '(' EXP ')' STATMENT  { $$ = mknode("",$3,$5); }
				|IF '(' EXP ')' EXP { $$ = mknode("",$3,$5); }
				|IF '(' EXP ')' BODY_RET_EXP {$$ = mknode("",$3,$5); };

BODY_RET_EXP:
				'{' body BODY_RET_END {$$ = mknode("",$2,$3); };

BODY_RET_END:
				RETURN EXP '}' {$$ = mknode("RET",$2,NULL); };


IF_ELSE_STAT:
				IF_STAT MY_ESLE {$$ = mknode("",$1,$2); };

MY_ESLE: 
				ELSE STATMENT {$$ = mknode("",$2,NULL); }
				|ELSE '{' body '}' {$$ = mknode("",$3,NULL); }
				|ELSE '{' body BODY_RET_END {$$ = mknode("",$3,$4); };
				

WHILE_STAT:
				WHILE '(' EXP ')' '{' body '}' { $$ = mknode("",$3 ,$6);  }
				|WHILE '(' EXP ')' STATMENT ';' { $$ = mknode("",$3 ,$5);  };
				
CODE_BLOCK:
				'{' BLOCK_DEC '}' { $$ = mknode("",$2 ,NULL);  };
BLOCK_DEC:
				VAR_PARM BLOCK_DEC { $$ = mknode("",$1 ,$2);  }
				|BLOCK_STAT { $$ = mknode("",$1 ,NULL);  }
				|/* EMPTY */ { $$ = mknode("",NULL ,NULL);  };
BLOCK_STAT:
				STATMENT BLOCK_STAT { $$ = mknode("",$1 ,$2);  }
				|/* EMPTY */ { $$ = mknode("",NULL ,NULL);  };
				
EXP:
				EXP OPERATOR EXP {$$ = mknode($2->token,$1, $3 );  }
				|EXP CONDITION EXP {$$ = mknode($2->token,$1, $3 );  }
				|EXP ASS EXP { $$ = mknode("",$1, $3 );}
				|ID {}
				|DECIMALLIT { } 
				|REALLIT { }
				|CHARLIT { }
				|TRUE { }
				|FALSE { }
				|STRINGLIT { }
				|NULLPTR { }
				|EXP ';' { $$ = mknode("",$1,NULL );}
				|/*EMPTY*/ { $$ = mknode("NONE",NULL ,NULL);}
				|EXP ',' EXP { $$ = mknode("",$1,$3 );}
				|FUNC_CALL {}
				|RETURN EXP { $$ = mknode("",$1,$2 );}
				|ADDRESS ID { $$ = mknode("",$1,$2 );}
				|ADDRESS STRINGARR { $$ = mknode("",$1,$2 );}
				|OPERATOR EXP { $$ = mknode("",$1,$2 );};				
				
OPERATOR:

			DIV { }
			|MINUS { }
			|PLUS { }
			|MUL { }
			|DEREF { };
				
				
CONDITION:

			AND { $$ = mknode("AND",NULL,NULL );}
			|EQ { }
			|G {}
			|GE { }
			|L { }
			|LE { }
			|NOT {}
			|NOTEQ { }
			|OR { };
%%

#include "lex.yy.c"
int main()
{
	return yyparse();
}

node  *mknode(char *token,node*left,node*right)
{
	node *newnode= (node*)malloc(sizeof(node));
	newnode->left = left;
	newnode->right = right;
	newnode->token = strdup(token);
	return newnode;
}

void printtree(node * tree,int space){
    int i;
	if (sizeof(tree->token) > 0 && strcmp(tree->token, "")){
        for(i=0;i<space;i++)
		    printf(" ");
	    printf("(%s ",tree->token);
        if(!tree->left && !tree->right){
		    printf(")");
	    }
        else{
            printf("\n");
            if(tree->left)
		        printtree(tree->left ,space+1);
	        
	        if( tree->right)
		        printtree(tree->right,space+1);
            for(i=0;i<space;i++)
		        printf("");
            printf(")\n");
        }
    }
    else
    {
        if(tree->left){
		    printtree(tree->left ,space);
	    }
	    if( tree->right)
		    printtree(tree->right,space);
    }
}


void yyerror(char * err)
{
	int yydebug = 1;
	fflush(stdout);
	fprintf(stderr, "Error: %s at line %d\n", err, yylineno);
	fprintf(stderr, "Dos not accept '%s'\n", yytext);
}

