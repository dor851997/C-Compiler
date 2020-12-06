%%
"bool" { yylval = mknode(yytext,NULL,NULL); return BOOL;}
"char" { yylval = mknode(yytext,NULL,NULL); return CHAR;}
"int" { yylval = mknode(yytext,NULL,NULL); return INT;}
"real" { yylval = mknode(yytext,NULL,NULL); return REAL;}
"string" { yylval = mknode(yytext,NULL,NULL); return STRING;}
"var" { yylval = mknode(yytext,NULL,NULL); return VAR;}


"int*" { yylval = mknode(yytext,NULL,NULL); return INTPOINTER;}
"char*" { yylval = mknode(yytext,NULL,NULL); return CHARPOINTER;}
"real*" { yylval = mknode(yytext,NULL,NULL); return REALPOINTER;}


"if" { yylval = mknode(yytext,NULL,NULL); return IF;}
"else" { yylval = mknode(yytext,NULL,NULL); return ELSE;}


"while" { yylval = mknode(yytext,NULL,NULL); return WHILE;}

"func" { yylval = mknode(yytext,NULL,NULL); return FUNC;}
"proc" { yylval = mknode(yytext,NULL,NULL); return PROC;}
"return" { yylval = mknode(yytext,NULL,NULL); return RETURN;}
"null" { yylval = mknode(yytext,NULL,NULL); return NULLPTR;}
"Main" { yylval = mknode(yytext,NULL,NULL); return MAIN;}


"&&" { yylval = mknode(yytext,NULL,NULL); return AND;}
"==" { yylval = mknode(yytext,NULL,NULL); return EQ;}
">" { yylval = mknode(yytext,NULL,NULL); return G;}
">=" { yylval = mknode(yytext,NULL,NULL); return GE;}
"<" { yylval = mknode(yytext,NULL,NULL); return L;}
"<=" { yylval = mknode(yytext,NULL,NULL); return LE;}
"!" { yylval = mknode(yytext,NULL,NULL); return NOT;}
"!=" { yylval = mknode(yytext,NULL,NULL); return NOTEQ;}
"||" { yylval = mknode(yytext,NULL,NULL); return OR;}



"/" { yylval = mknode(yytext,NULL,NULL); return DIV;}
"=" { yylval = mknode(yytext,NULL,NULL); return ASS;}
"-" { yylval = mknode(yytext,NULL,NULL); return MINUS;}
"+" { yylval = mknode(yytext,NULL,NULL); return PLUS;}
"*" { yylval = mknode(yytext,NULL,NULL); return MUL;}
"&" { yylval = mknode(yytext,NULL,NULL); return ADDRESS;}
"^" { yylval = mknode(yytext,NULL,NULL); return DEREF;}


"true" { yylval = mknode(yytext,NULL,NULL); return TRUE;}
"false" { yylval = mknode(yytext,NULL,NULL); return FALSE;}
[a-zA-Z]+[a-zA-Z0-9_]* { yylval = mknode(yytext,NULL,NULL); return ID;}
\'[a-zA-Z0-9]\' { yylval = mknode(yytext,NULL,NULL); return CHARLIT;}
0|[1-9][0-9]* { yylval = mknode(yytext,NULL,NULL); return DECIMALLIT;}
0[xX][0-9A-F]* { yylval = mknode(yytext,NULL,NULL); return HEXLIT;}
[-+]?[0-9]*(\.)?[0-9]*[Ee]?[-+]?[0-9]* { yylval = mknode(yytext,NULL,NULL); return REALLIT;}
\"[^\"]*\" { yylval = mknode(yytext,NULL,NULL); return STRINGLIT;}
\/%.*%\/ ;




[ \t]  printf("");
.   return yytext[0];
.|\n  {yylineno++;}
%%
