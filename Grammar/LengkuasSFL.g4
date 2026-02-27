grammar LengkuasSFL;

//Lexer rules
//data types
STR: 'str';
I32: 'i32';
I64: 'i64';
F32: 'f32';
F64: 'f64';
BOOL: 'bool';
DSTREAM: 'dstream';
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
NUMBER: '0x' [0-9a-fA-F]+ | [0-9]+ ('.' [0-9]+)?;
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
program: NEWLINE* (statement (NEWLINE+))* EOF;

simpleStatement: variableDeclaration
               | assignmentStatement
               | incrementDecrement
               | returnStatement
               | diagnosticStatement
               | exprStatement;

exprStatement: expression;

statement: simpleStatement
         | functionDeclaration
         | controlFlow
         | loop
         | asyncBlock
         | errorHandling;

variableDeclaration: (CONST)? dataType (ARR | DICT)? IDENTIFIER ASSIGN expression;

assignmentStatement: IDENTIFIER ASSIGN expression;

dataType: STR | I32 | I64 | F32 | F64 | BOOL | DSTREAM | ANY;

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
                 | functionCall
                 | IDENTIFIER
                 | LPAREN expression RPAREN;


blockBody: (statement NEWLINE+)+;

functionDeclaration: FUN IDENTIFIER LPAREN (parameter (COMMA parameter)*)? RPAREN ARROW dataType COLON blockBody ENDFUN;

parameter: dataType IDENTIFIER;

returnStatement: RET expression?;

controlFlow: ifStatement | switchStatement;

ifStatement: IF LPAREN expression RPAREN COLON blockBody (ELIF LPAREN expression RPAREN COLON blockBody)* ELSE COLON blockBody ENDIF;

switchStatement: SWITCH LPAREN expression RPAREN COLON (caseBlock)+ defaultBlock ENDSW;

caseBlock: CASE expression COLON blockBody ENDCASE;

defaultBlock: DEFAULT COLON blockBody;

loop: whileLoop |doWhileLoop | forLoop;

whileLoop: WHILE LPAREN expression RPAREN COLON blockBody ENDWHILE;

doWhileLoop: DO COLON blockBody ENDDO WHILE LPAREN expression RPAREN;

forLoop: FOR LPAREN variableDeclaration SEMICOLON expression SEMICOLON expression RPAREN COLON blockBody ENDFOR;

functionCall: IDENTIFIER LPAREN (expression (COMMA expression)*)? RPAREN;

diagnosticStatement: PTR IDENTIFIER;

asyncBlock: ASYNC LPAREN (parameter (COMMA parameter)*)? RPAREN COLON blockBody RESYNC;

errorHandling: TRY COLON blockBody CATCH COLON throwStatement ENDTRY;

throwStatement: THROW LPAREN expression RPAREN;

//rules for advanced syntax
incrementDecrement: IDENTIFIER (INCREMENT | DECREMENT);