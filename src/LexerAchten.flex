%%
%class LexicalAnalyzerAchten
%unicode
%line
%column
// the return type of the lexical analyzer
%type Symbol  
//name of the function 
%function nextSymbol

%xstate YYINITIAL, SHORT_COMMENT, LONG_COMMENT


VARNAME = [a-z][a-zA-Z0-9_]*
NUMBER = [1-9][0-9]*|0
WHITESPACE = [ \t\r\n]+
BADVARNAMES = [0-9]+[a-zA-Z_]+[a-zA-Z0-9_]*

%eofval{
    if (yystate() == LONG_COMMENT) {
        System.out.println("no closing comment token found");
        System.exit(1);
    }
    return new Symbol(LexicalUnit.EOS, yyline, yycolumn);
%eofval}
%%


// initial state
<YYINITIAL> {
    
    {WHITESPACE} { }
    "begin" {return new Symbol(LexicalUnit.BEG, yyline, yycolumn, yytext());} 
    "end" {return new Symbol(LexicalUnit.END, yyline, yycolumn, yytext());}
    "..." {return new Symbol(LexicalUnit.DOTS, yyline, yycolumn, yytext());}
    ":=" {return new Symbol(LexicalUnit.ASSIGN, yyline, yycolumn, yytext());}
    "(" {return new Symbol(LexicalUnit.LPAREN, yyline, yycolumn, yytext());}
    ")" {return new Symbol(LexicalUnit.RPAREN, yyline, yycolumn, yytext());}
    "-" {return new Symbol(LexicalUnit.MINUS, yyline, yycolumn, yytext());}
    "+" {return new Symbol(LexicalUnit.PLUS, yyline, yycolumn, yytext());}
    "*" {return new Symbol(LexicalUnit.TIMES, yyline, yycolumn, yytext());}
    "/" {return new Symbol(LexicalUnit.DIVIDE, yyline, yycolumn, yytext());}
    "if" {return new Symbol(LexicalUnit.IF, yyline, yycolumn, yytext());}
    "then" {return new Symbol(LexicalUnit.THEN, yyline, yycolumn, yytext());}
    "else" {return new Symbol(LexicalUnit.ELSE, yyline, yycolumn, yytext());}
    "and" {return new Symbol(LexicalUnit.AND, yyline, yycolumn, yytext());}
    "or" {return new Symbol(LexicalUnit.OR, yyline, yycolumn, yytext());}
    "{" {return new Symbol(LexicalUnit.LBRACK, yyline, yycolumn, yytext());}
    "}" {return new Symbol(LexicalUnit.RBRACK, yyline, yycolumn, yytext());}
    "=" {return new Symbol(LexicalUnit.EQUAL, yyline, yycolumn, yytext());}
    "<" {return new Symbol(LexicalUnit.SMALLER, yyline, yycolumn, yytext());}
    "while" {return new Symbol(LexicalUnit.WHILE, yyline, yycolumn, yytext());}
    "do" {return new Symbol(LexicalUnit.DO, yyline, yycolumn, yytext());}
    "print" {return new Symbol(LexicalUnit.PRINT, yyline, yycolumn, yytext());}
    "read" {return new Symbol(LexicalUnit.READ, yyline, yycolumn, yytext());}
    {BADVARNAMES} {System.out.println("Illegal variable name: " + yytext()); System.exit(1);}
    {VARNAME} {return new Symbol(LexicalUnit.VARNAME, yyline, yycolumn, yytext());}
    {NUMBER} {return new Symbol(LexicalUnit.NUMBER, yyline, yycolumn, yytext());}
    "''" {yybegin(LONG_COMMENT);}
    "**" {yybegin(SHORT_COMMENT);}
    . {System.out.println("Illegal character: " + yytext()); System.exit(1);}


    
}
// comment states
<SHORT_COMMENT> {
    \n {yybegin(YYINITIAL);}
    . { }
}
<LONG_COMMENT> {
    "''" {yybegin(YYINITIAL);} //
    \n { }
    . { }
    
}


// ignore everything else
