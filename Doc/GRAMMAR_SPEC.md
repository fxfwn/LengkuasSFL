# Grammar Specifications for LengkuasSFL

This Document outlines the grammar rules for the `LengkuasSFL` programming language, derived from the [Documentation](https://github.com/TheSkyler-Dev/LengkuasSFL/blob/main/Doc/A-Tour-of-LengkuasSFL.md) and the [ANTLR grammar definition](https://github.com/TheSkyler-Dev/LengkuasSFL/blob/main/Grammar/LengkuasSFL.g4).

---

# Overview
The `LengkuasSFL` (`Lengkuas Sensor Filter Language`) language is a domain-specific programming language designed for sensor preprocessing in embedded systems and other sensor systems. It emphasizes a simple syntax and style for manipulating sensor data streams.

---

# Lexical Structure

## Tokens

1. **Keywords**:
   - `fun`, `endfun`, `if`, `elif`, `else`, `endif`, `sw`, `case`, `default`, `endsw`, `while`, `endwhile`, `do`, `enddo`, `for`, `endfor`, `try`, `catch`, `endtry`, `throw`, `ret`, `desync`, `resync`, `expect`, `true`, `false`, `nil`, `const`, `arr`, `dict`, `sstream`

2. **Operators**:
   - Arithmetic: `+`, `-`, `*`, `/`, `%`
   - Logical: `&&`, `||`, `!`
   - Assignment: `=`
   - Increment/Decrement: `++`, `--`
   - Pointer/Reference: `^`
   - Arrow: `->`

3. **Delimiters**:
   - `;`, `:`, `,`, `.`, `(`, `)`, `{`, `}`, `[`, `]`

4. **Literals**:
   - Numbers: Integers (`i32`, `i64`) and floating-point numbers (`f32`, `f64`). Hexadecimal supported via `0x` prefix.
   - Strings: Enclosed in double (`"`) quotes.
   - Booleans: `true`, `false`
   - Special values: `nil`

5. **Identifiers**:
   - Must start with a letter or underscore (`_`) and can include letters, digits, and underscores.

6. **Comments**:
   - Single-line: Begin with `~`, extend to end of line.
   - Multi-line: Begin and end with `~~`.

7. **Whitespace**:
   - Ignored except as a separator. Indentation is recommended to be four spaces (not tabs).

---

# Syntactic Structure

## Program Structure

A LengkuasSFL program consists of zero or more statements:

```
program: (statement)* EOF;
```

## Statements

Statements include variable and constant declarations, function definitions, control flow,
loops, input/output, template literals, error handling, pointer references, async blocks,
increment/decrement operations, and return statements.

```
statement:
    variableDeclaration
  | functionDeclaration
  | controlFlow
  | loop
  | ioOperation
  | templateLiteral
  | errorHandling
  | pointerReference
  | asyncBlock
  | incrementDecrement
  | returnStatement;
```

### Variable and Constant Declaration

Variables use primitive or special types, optionally as arrays or dictionaries. Constants use the `const` keyword.

```
variableDeclaration: (CONST)? dataType (ARR | DICT)? IDENTIFIER ASSIGN expression;
dataType: 'str' | 'i32' | 'i64' | 'f32' | 'f64' | 'bool' | 'dstream';
```

Example:
```LengkuasSFL
f64 MyVar = 9.81
const f64 pi = 3.141593
dstream MySensor = GPIO_PIN_17
f64 arr MyArray = [0.5, 0.49]
```

All variables are nullable and must be initialized; use `nil` for null values.

### Expressions

Expressions now use a standard precedence hierarchy:

- logical OR `||`
- logical AND `&&`
- equality `==`, `!=`
- relational `<`, `<=`, `>`, `>=`
- additive `+`, `-`
- multiplicative `*`, `/`, `%`
- unary `+`, `-`, `!`
- primary expressions and template literals

```
expression: orExpr;

orExpr: andExpr (OR andExpr)*;

andExpr: equalityExpr (AND equalityExpr)*;

equalityExpr: relationalExpr ((EQ | NEQ) relationalExpr)*;

relationalExpr: additiveExpr ((LT | LTE | GT | GTE) additiveExpr)*;

additiveExpr: multiplicativeExpr ((PLUS | MINUS) multiplicativeExpr)*;

multiplicativeExpr: unaryExpr ((MULT | DIV | MOD) unaryExpr)*;

unaryExpr: (PLUS | MINUS | NOT)* primaryExpression;

primaryExpression:
    NUMBER
  | STRING
  | BOOL_LITERAL
  | NIL
  | IDENTIFIER
  | templateLiteral
  | LPAREN expression RPAREN;
```
Template literals are expressions and can appear wherever an expression is allowed:
```
templateLiteral: STRING ('$' IDENTIFIER | '${' expression '}$')*;
```

### Arrays

Arrays are declared using the `arr` keyword. Push and pop operations are supported.

```LengkuasSFL
f64 arr MyArr = [nil]
MyArr.push(MySensor)
MyArr.pop([<index>])
```

### Input/Output Operations

```
ioOperation: functionCall;
```

Examples:
```LengkuasSFL
msgOut("Hello World!")
msgIn(var)
```

### Arithmetic and Logic

Operators:
- Arithmetic: `+`, `-`, `*`, `/`, `%`
- Logic: `&&`, `||`, `!`

Functions:
- `avg()`, `rnd()`

### Control Flow

#### If/Else

```
ifStatement:
    'if' LPAREN expression RPAREN COLON statement+
    ('elif' LPAREN expression RPAREN COLON statement+)*
    'else' COLON statement+
    'endif';
```

#### Switch

```
switchStatement:
    'sw' LPAREN expression RPAREN COLON (caseBlock)+ (defaultBlock)? 'endsw';
```

#### Loops

- While:
    ```
    whileLoop: 'while' LPAREN expression RPAREN COLON statement+ 'endwhile';
    ```
- Do/While:
    ```
    doWhileLoop: 'do' COLON statement+ 'enddo' 'while' LPAREN expression RPAREN;
    ```
- For:
    ```
    forLoop: 'for' LPAREN variableDeclaration SEMICOLON expression SEMICOLON expression RPAREN COLON statement+ 'endfor';
    ```

### Functions

Functions are declared with `fun`, specifying argument types and return type.

```
functionDeclaration:
    'fun' IDENTIFIER LPAREN (parameter (COMMA parameter)*)? RPAREN ARROW dataType COLON statement+ 'endfun';

parameter: dataType IDENTIFIER;
```

Example:
```LengkuasSFL
fun myFunc(i32 x, f64 y) -> i32:
    ret 0
endfun
```

### Asynchronous Operations

Async blocks use `desync` and `resync`.

```
asyncBlock:
    'desync' LPAREN (parameter (COMMA parameter)*)? RPAREN COLON statement+ 'resync';
```

Example:
```LengkuasSFL
desync myAsyncFunc(MySensor) -> f64:
    ~async logic here
    ret FilteredData
resync
expect f64 res = sensorFilter()
```

### Error Handling

Classic `try...catch` statements, with `throw`.

```
errorHandling:
    'try' COLON statement+ 'catch' COLON throwStatement 'endtry';

throwStatement:
    'throw' LPAREN expression RPAREN;
```

### Pointer References

Pointer references use the `^` caret.

```
pointerReference: '^' IDENTIFIER;
```

### Increment / Decrement

Identifiers can be incremented or decremented using postfix operators:

```
incrementDecrement: IDENTIFIER (INCREMENT | DECREMENT);
```

### Return Statements

Functions can return from any point using `ret`, optionally with an expression:

```
returnStatement: 'ret' expression?;
```

# Example Program

```LengkuasSFL
sstream MySensor = GPIO_PIN_17
f64 arr MyArr = [nil]

fun main() -> i32:
    msgOut("Starting sensor capture")
    MyArr.push(MySensor)
    try:
        f64 avgVal = avg(MyArr)
        msgOut("Average: $avgVal")
    catch:
        throw(errMsg("Error averaging!", prefix -> ecode()))
    endtry
    ret 0
endfun
```

---

# Notable Features

- **Style:** Four-space indentation recommended; semicolons optional.
- **Nullable Variables:** All variables can be `nil`.
- **Template Literals:** Support for `${}` interpolation.
- **Sensor Streams:** Dedicated `sstream` type for sensor data.
- **Array Operations:** Push and pop supported.
- **Control Flow:** Standard constructs and switch/case.
- **Async Syntax:** `desync`/`resync` blocks.
- **Error Handling:** Try/catch and throw.
- **Pointers:** Supported via `^` operator.

---

# References

- [A Tour of LengkuasSFL](https://github.com/TheSkyler-Dev/LengkuasSFL/blob/main/Doc/A-Tour-of-LengkuasSFL.md)
- [LengkuasSFL.g4 Grammar](https://github.com/TheSkyler-Dev/LengkuasSFL/blob/main/Grammar/LengkuasSFL.g4)
