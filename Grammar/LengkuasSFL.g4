grammar LengkuasSFL;

//Lexer rules
//data types
STR: 'str';
I32: 'i32';
I64: 'i64';
F32: 'f32';
F64: 'f64';
BOOL: 'bool';
SSTREAM: 'sstream';
CONST: 'const';
ANY: 'any';

//control flow
IF: 'if';
ELIF: 'elif';
ELSE: 'else';
ENDIF: 'endif';
SWITCH: 'sw';
CASE: 'case';
ENDCASE: 'endcase';
DEFAULT: 'default';
ENDSW: 'endsw';

//loops
WHILE: 'while';
ENDWHILE: 'endwhile';
DO: 'do';
ENDDO: 'enddo';
FOR: 'for';
ENDFOR: 'endfor';

//data structures
ARR: 'arr';
DICT: 'dict';

//functions, async, error handling
FUN: 'fun';
ENDFUN: 'endfun';
ASYNC: 'desync';
RESYNC: 'resync';
AWAIT: 'expect';
TRY: 'try';
CATCH: 'catch';
ENDTRY: 'endtry';
THROW: 'throw';
RET: 'ret';

//units
CELSIUS: 'celsius';
FAHRENHEIT: 'fahrenheit';
KELVIN: 'kelvin';

//other syntax
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]*;
NUMBER: [0-9]+ ('.' [0-9]+)? | '0x' [0-9a-fA-F]+;
STRING: '"' ( '\\' . | ~["\\\r\n] )* '"';
BOOL_LITERAL: 'true' | 'false';
NIL: 'nil';
SEMICOLON: ';';
COLON: ':';
COMMA: ',';
DOT: '.';
ARROW: '->';
ASSIGN: '=';
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
MOD: '%';
LPAREN: '(';
RPAREN: ')';
LBRACE:'{';
RBRACE: '}';
LBRACKET: '[';
RBRACKET: ']';
INCREMENT: '++';
DECREMENT: '--';
NEWLINE: ('\r'? '\n')+;
WS: [ \t]+ -> skip;
MULTILINE_COMMENT: '~~' .*? '~~' -> skip;
COMMENT: '~' ~[ \r\n]* -> skip;
AND: '&&';
OR: '||';
NOT: '!';
EQ: '==';
NEQ: '!=';
LT: '<';
GT: '>';
LTE: '<=';
GTE: '>=';
PTR: '^';

//Parser rules
program: (statement (NEWLINE+))* EOF;

simpleStatement: variableDeclaration
               | functionCall
               | incrementDecrement
               | returnStatement
               | diagnosticStatement;

statement: simpleStatement
         | functionDeclaration
         | controlFlow
         | loop
         | ioOperation
         | asyncBlock
         | errorHandling;

variableDeclaration: (CONST)? dataType (ARR | DICT)? IDENTIFIER ASSIGN expression;

dataType: STR | I32 | I64 | F32 | F64 | BOOL | SSTREAM | ANY;

expression: orExpr;

orExpr: andExpr (OR andExpr)*;

andExpr: equalityExpr (AND equalityExpr)*;

equalityExpr: relationalExpr ((EQ | NEQ) relationalExpr)*;

relationalExpr: additiveExpr ((LT | LTE | GT | GTE) additiveExpr)*;

additiveExpr: multiplicativeExpr ((PLUS | MINUS) multiplicativeExpr)*;

multiplicativeExpr: unaryExpr ((MULT | DIV | MOD) unaryExpr)*;

unaryExpr: (PLUS | MINUS | NOT)* primaryExpression;

primaryExpression: NUMBER
                 | STRING
                 | BOOL_LITERAL
                 | NIL
                 | IDENTIFIER
                 | LPAREN expression RPAREN;


functionDeclaration: FUN IDENTIFIER LPAREN (parameter (COMMA parameter)*)? RPAREN ARROW dataType COLON statement+ ENDFUN;

parameter: dataType IDENTIFIER;

returnStatement: RET expression?;

controlFlow: ifStatement | switchStatement;

ifStatement: IF LPAREN expression RPAREN COLON statement+ (ELIF LPAREN expression RPAREN COLON statement+)* ELSE COLON statement+ ENDIF;

switchStatement: SWITCH LPAREN expression RPAREN COLON (caseBlock)+ defaultBlock ENDSW;

caseBlock: CASE expression COLON statement+ ENDCASE;

defaultBlock: DEFAULT COLON LBRACE statement+ RBRACE;

loop: whileLoop |doWhileLoop | forLoop;

whileLoop: WHILE LPAREN expression RPAREN COLON statement+ ENDWHILE;

doWhileLoop: DO COLON statement+ ENDDO WHILE LPAREN expression RPAREN;

forLoop: FOR LPAREN variableDeclaration SEMICOLON expression SEMICOLON expression RPAREN COLON statement+ ENDFOR;

ioOperation: functionCall;

functionCall: IDENTIFIER LPAREN (expression (COMMA expression)*)? RPAREN;

diagnosticStatement: PTR IDENTIFIER;

asyncBlock: ASYNC LPAREN (parameter (COMMA parameter)*)? RPAREN COLON statement+ RESYNC;

errorHandling: TRY COLON statement+ CATCH COLON throwStatement ENDTRY;

throwStatement: THROW LPAREN expression RPAREN;

//rules for advanced syntax
incrementDecrement: IDENTIFIER (INCREMENT | DECREMENT);