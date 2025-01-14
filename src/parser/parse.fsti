(*  Signature file for parser generated by fsyacc
    and then amended a bit for typing lexhelp.fs *)
module Microsoft.FStar.Parser.Parse
type token =
  | COMMENT
  | WHITESPACE
  | HASH_LINE
  | HASH_LIGHT
  | HASH_IF
  | HASH_ELSE
  | HASH_ENDIF
  | INACTIVECODE
  | LINE_COMMENT
  | STRING_TEXT
  | EOF
  | LEX_FAILURE of (string)
  | REQUIRES
  | ENSURES
  | EXTERN
  | REFERENCE
  | VOID
  | PUBLIC
  | PRINT
  | PRIVATE
  | INTERNAL
  | LBRACE_COLON_PATTERN
  | LBRACE_TILDE
  | TILDE_RBRACE
  | PIPE_LEFT
  | PIPE_RIGHT
  | STATIC
  | MEMBER
  | CLASS
  | VIRTUAL
  | ABSTRACT
  | OVERRIDE
  | OPAQUE
  | DEFAULT
  | CONSTRUCTOR
  | INHERIT
  | GREATER_RBRACK
  | STRUCT
  | SIG
  | BAR
  | RBRACK
  | RBRACE
  | MINUS
  | DOLLAR
  | LBRACE_LESS
  | BAR_RBRACK
  | GREATER_RBRACE
  | UNDERSCORE
  | SEMICOLON_SEMICOLON
  | LARROW
  | EQUALS
  | PERCENT_LBRACK
  | LBRACK
  | LBRACK_BAR
  | LBRACK_LESS
  | LBRACE
  | BACKSLASH
  | QMARK
  | QMARK_QMARK
  | DOT
  | COLON
  | COLON_COLON
  | ATSIGN
  | HAT
  | COLON_GREATER
  | COLON_QMARK_GREATER
  | COLON_QMARK
  | COLON_EQUALS
  | SEMICOLON
  | GREATER_DOT
  | GREATER_BAR_RBRACK
  | LPAREN_STAR_RPAREN
  | IFF
  | IMPLIES
  | CONJUNCTION
  | DISJUNCTION
  | WHEN
  | WHILE
  | WITH
  | HASH
  | AMP
  | AMP_AMP
  | QUOTE
  | LPAREN
  | RPAREN
  | LPAREN_RPAREN
  | STAR
  | COMMA
  | RARROW
  | RARROW2
  | RRARROW
  | OPEN
  | OR
  | PROP
  | REC
  | THEN
  | TO
  | TRUE
  | TRY
  | EFFECT
  | TYPE
  | KIND
  | VAL
  | INLINE
  | INTERFACE
  | INSTANCE
  | LAZY
  | MATCH
  | METHOD
  | MUTABLE
  | NEW
  | NEW_EFFECT
  | OF
  | EXCEPTION
  | FALSE
  | FOR
  | FUN
  | FUNCTION
  | IF
  | IN
  | FINALLY
  | DO_BANG
  | AND
  | AS
  | ASSERT
  | ASR
  | BEGIN
  | DO
  | DONE
  | DOWNTO
  | ELSE
  | ELIF
  | END
  | DOT_DOT
  | BAR_BAR
  | LEQ
  | GEQ
  | LESSLESS
  | LESS
  | GREATER
  | LESSGREATER
  | UPCAST
  | DOWNCAST
  | NULL
  | RESERVED
  | MODULE
  | DELEGATE
  | CONSTRAINT
  | BASE
  | SUB_EFFECT
  | SUBTYPE
  | SUBKIND
  | FORALL
  | EXISTS
  | ASSUME
  | QUERY
  | DEFINE
  | LOGIC
  | PRAGMALIGHT
  | PRAGMA_SET_OPTIONS
  | PRAGMA_RESET_OPTIONS
  | MONADLATTICE
  | SQUIGGLY_RARROW
  | TOTAL
  | LET of (bool)
  | INFIX_STAR_DIV_MOD_OP of (string)
  | DIV_MOD_OP of (string)
  | PREFIX_OP of (string)
  | INFIX_BAR_OP of (string)
  | INFIX_AT_HAT_OP of (string)
  | INFIX_COMPARE_OP of (string)
  | INFIX_STAR_STAR_OP of (string)
  | LANG of (string)
  | BASEKIND of (string)
  | TVAR of (string)
  | NAME of (string)
  | IDENT_LESS of (string)
  | IDENT of (string)
  | STRING of (array<byte>)
  | INT32 of (int32 * bool)
  | INT of (string * bool)
  | YIELD of (bool)
