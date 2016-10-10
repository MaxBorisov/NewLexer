%{
#include<stdio.h>
#include<string.h>
int cl=1, ln=1;
%}

%%
[/][/][^\n]*[\n] {int n;
char text[yyleng];
for(n=2; n<yyleng; n++)
{
	text[n-2]=yytext[n];
}
text[yyleng-3]='\0';
printf("Comment(\"%s\", %d, %d, %d); ", text,ln, cl, cl-1+yyleng);
cl=1;
ln=ln+1;}
[(][*]((([^*])*([^)])*)|((([^*])*([^)])*[*][^)]+[)]([^*])*([^)])*))*)[*][)] {int n;
int begin_ln=ln;
int begin_cl=cl;
int end_cl;
for(n=0; n<yyleng; n++)
{
	end_cl=cl;
	cl=cl+1;
	if(yytext[n]=='\n')
	{
		cl=1;
		ln=ln+1;
	}
}
char text[yyleng];
for(n=2; n<yyleng; n++)
{
	text[n-2]=yytext[n];
}
text[yyleng-4]='\0';
printf("Comment(\"%s\", %d, %d, %d, %d); ", text, begin_ln, ln, begin_cl, end_cl);
}
[*][*] {printf("Op(\"**\", %d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;
}
[\n] {cl=1;
ln=ln+1;}
[ ] {cl=cl+1;}
[\t] {cl=cl+1;} 
[s][k][n][p] {printf("KW_Skip(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[:][=] {printf("Assignment(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[\;] {printf("Colon(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[w][r][n][t][e] {printf("KW_Write(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[r][e][a][d] {printf("KW_Read(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[w][h][n][l][e] {printf("KW_While(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[d][o] {printf("KW_Do(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[n][f] {printf("KW_If(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[t][h][e][n] {printf("KW_Then(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[e][l][s][e] {printf("KW_Else(%d, %d, %d); ", ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[a-zA-Z_][a-zA-Z_0-9]* {yytext [yyleng] = (char) 0;
printf("Var(\"%s\", %d, %d, %d); ", yytext, ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
([+|\-|/|%|>|<])|([=|\!][=])|([>|<][=])|([&][&])|([\|][\|]) {yytext [yyleng] = (char) 0; 
printf("Op(\"%s\", %d, %d, %d); ", yytext, ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
([*]) {printf("Op(\"%s\", %d, %d, %d); ", yytext, ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[1-9][0-9]* {yytext [yyleng] = (char) 0;
printf("Num(\"%s\", %d, %d, %d); ", yytext, ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
([\(])|([\)]) {yytext [yyleng] = (char) 0;
printf("Parenthesis(\"%s\", %d, %d, %d); ", yytext, ln, cl, cl-1+yyleng);
cl=cl+yyleng;}
[^ \r\n] {printf("Error in line %d, columns %d - %d: \"%s\", lexer has been stoped", ln, cl, cl-1+yyleng, yytext);
return;}
%%

main(int argc,char *argv[])
{

yyin=fopen(argv[1],"r");
if(yyin==NULL)
	printf("File does not exist\n");	
else
{
	yylex();
	printf("\n");
}
}

