%{

(*
 Known (intentional) ambiguitites: 6 s/r conflicts in total; resolved by shifting
   3 s/r conflicts on BAR
      match  with | P -> match with | Q -> _ | R -> _
      function ...
      try e with | ... 

   1 s/r conflict on SEMICOLON
       fun x -> e1 ; e2
	 is parsed as
		(fun x -> e1; e2)
	 rather than
		(fun x -> e1); e2

   1 s/r conflict on DOT
      A.B ^ .C 

   1 s/r conflict on LBRACE
	
      Consider: 
		  let f (x: y:int & z:vector y{z=z /\ y=0}) = 0
	  
	  This is parsed as:
        let f (x: (y:int & z:vector y{z=z /\ y=0})) = 0
	  rather than:
	    let f (x: (y:int & z:vector y){z=z /\ y=0}) = 0

	  Analogous ambiguities with -> and * as well.
*)











%} 

%token <bytes> BYTEARRAY
%token <bytes> STRING 
%token <string> IDENT 
%token <string> IDENT_LESS
%token <string> NAME
%token <string> TVAR
%token <string> DIV_MOD_OP 
%token <string> TILDE
%token <string> CUSTOM_OP


/* bool indicates if INT8 was 'bad' max_int+1, e.g. '128'  */
%token <sbyte * bool> INT8 
%token <int16 * bool> INT16
%token <int32 * bool> INT32 INT32_DOT_DOT
%token <int64 * bool> INT64
%token <string * bool> INT

%token <byte> UINT8
%token <uint16> UINT16
%token <uint32> UINT32
%token <uint64> UINT64
%token <uint64> UNATIVEINT
%token <int64> NATIVEINT
%token <single> IEEE32
%token <double> IEEE64
%token <char> CHAR
%token <decimal> DECIMAL 
%token <bytes> BIGINT BIGNUM
%token <bool> LET 
%token <string * bool> LQUOTE RQUOTE 
%token FORALL EXISTS ASSUME QUERY DEFINE LOGIC OPAQUE PRAGMALIGHT PRAGMA_SET_OPTIONS PRAGMA_RESET_OPTIONS
%token BAR_BAR LEQ GEQ LESS LESSLESS TYP_APP_LESS TYP_APP_GREATER LESSGREATER SUBTYPE SUBKIND BANG
%token AND AS ASSERT BEGIN ELSE END DOT_DOT
%token EXCEPTION FALSE FOR FUN FUNCTION IF IN FINALLY RESERVED MODULE DEFAULT
%token LAZY MATCH OF 
%token OPEN OR REC THEN TO TRUE TRY TYPE EFFECT VAL 
%token WHEN WITH HASH AMP AMP_AMP QUOTE LPAREN RPAREN LPAREN_RPAREN STAR COMMA RARROW
%token IFF IMPLIES CONJUNCTION DISJUNCTION 
%token DOT COLON COLON_COLON ATSIGN HAT COLON_EQUALS SEMICOLON 
%token SEMICOLON_SEMICOLON EQUALS EQUALS_EQUALS PERCENT_LBRACK LBRACK LBRACK_BAR LBRACE BACKSLASH BANG_LBRACE
%token BAR_RBRACK UNDERSCORE LENS_PAREN_LEFT LENS_PAREN_RIGHT
%token BAR RBRACK RBRACE MINUS DOLLAR  
%token PUBLIC PRIVATE LBRACE_COLON_PATTERN PIPE_LEFT PIPE_RIGHT 
%token NEW_EFFECT SUB_EFFECT SQUIGGLY_RARROW TOTAL KIND
%token PRINT REQUIRES ENSURES
%token PLUS_OP MINUS_OP BAR_FOCUS
 
/* These are artificial */
%token <string> LEX_FAILURE
%token COMMENT WHITESPACE HASH_LINE HASH_LIGHT HASH_IF HASH_ELSE HASH_ENDIF INACTIVECODE LINE_COMMENT STRING_TEXT EOF

%nonassoc THEN
%nonassoc ELSE

%start inputFragment
%type <inputFragment> inputFragment

%%
inputFragment:
  | file
	  { Inl $1 }
  | decl decls EOF
	  { Inr ($1::$2) }

file: 
  | maybe_pragma_light moduleList
      { $2 }


moduleList:
  | modul moduleList
      { $1::$2 }
  | EOF
      { [] }
      
modul:    
  | MODULE qname decls endopt
        { Module($2, $3) }

endopt:
  | END  {} 
  |      {}

maybe_pragma_light:
  |     {}
  | PRAGMALIGHT STRING
        {}

pragma: 
  | PRAGMA_SET_OPTIONS STRING
	{ 
	   let s = string_of_bytes $2 in
	   if s = "--no_fs_typ_app"
	   then fs_typ_app := false;
	   SetOptions s
	}

  | PRAGMA_RESET_OPTIONS
	{ ResetOptions }

decls:
  |   { [] }
  | SEMICOLON_SEMICOLON term 
      { [mk_decl (Main $2) (rhs2 parseState 1 2)] }
  | decl decls
      { ($1::$2) }

decl:
  | decl2 { mk_decl $1 (rhs parseState 1) }

decl2:
  | OPEN qname
      { Open $2 }
  | kind_abbrev 
      { $1 }
  | tycon 
      { $1 }
  | LET recopt letbinding letbindings
      { 
		let r, focus = $2 in
		let lbs = focusLetBindings ((focus, $3)::$4) (rhs2 parseState 1 4) in
		ToplevelLet(r, lbs)
	  }
  | qualifiers VAL ident COLON typ
      { Val($1, $3, $5) }
  | assumeTag name COLON formula
      { Assume($1, $2, $4) }
  | EXCEPTION name of_typ
      { Exception($2, $3) }
  | qualifiers NEW_EFFECT new_effect
	  { NewEffect ($1, $3) }
  | SUB_EFFECT sub_effect
	  { SubEffect $2 }
  | pragma
	  { Pragma $1 }

tycon:
  | qualifiers TYPE tyconDefinition tyconDefinitions 
      { Tycon ($1, $3::$4) }

  | qualifiers EFFECT tyconDefinition 
	  { Tycon(Effect::$1, [$3]) }

kind_abbrev: 
  | KIND name binders EQUALS kind
      { KindAbbrev($2, $3, $5) }

new_effect: 
  | name binders EQUALS simpleTerm
	  {
		 RedefineEffect($1, $2, $4)
	  }
  | LBRACE name binders COLON kind WITH effect_decl more_effect_decls RBRACE
      {  
		 DefineEffect($2, $3, $5, $7::$8)
	  }

effect_decl: 
  | ident EQUALS simpleTerm
	{
		mk_decl (Tycon ([], [TyconAbbrev($1, [], None, $3)])) (rhs2 parseState 1 3)
	}

more_effect_decls:
  |									   	    { []     }
  | SEMICOLON effect_decl more_effect_decls { $2::$3 }


sub_effect:
  | qname SQUIGGLY_RARROW qname EQUALS simpleTerm
      {
        { 
          msource=$1;
          mdest=$3;
          lift_op=$5
        }
      }

qualifier:
  | LOGIC        { Logic }
  | ASSUME       { Assumption }
  | OPAQUE       { Opaque }
  | DEFAULT      { DefaultEffect None }
  | TOTAL        { TotalEffect }
  | PRIVATE      { Private }

qualifiers:
  |                      { [] }
  | qualifier qualifiers { $1::$2 }

assumeTag:
  | ASSUME { [Assumption] }

tyconDefinition:
  | eitherName typars ascribeKindOpt tyconDefn
      { $4 $1 $2 $3 }

tyconDefinitions:
  |   { [] }
  | AND tyconDefinition tyconDefinitions
      { $2::$3 }

ident_opt:
  |       { None }
  | ident { Some $1 }

maybeFocus:
  |  { false }
  | SQUIGGLY_RARROW { true }

recopt:
  | maybeFocus REC      { true, $1 }
  |                     { false, false }

letbindings:
  | AND maybeFocus letbinding letbindings 
      { ($2, $3)::$4 }
  |   { [] }

letbinding:
  | pattern ascribeTypOpt EQUALS term 
      { 
        match $2 with 
          | None -> ($1, $4)
          | Some t -> (mk_pattern (PatAscribed($1, t)) (rhs2 parseState 1 2), $4)
      }
      
pattern:
  | tuplePattern { $1 }


tuplePattern:
  | listPattern patternListComma 
      {
        match $2 with 
          | [] -> $1
          | _ -> mk_pattern (PatTuple($1::$2, false)) (rhs2 parseState 1 2)
      }


patternListComma:
  |   { [] }
  | COMMA listPattern patternListComma { $2::$3 }

listPattern:
  | appPattern consPattern
      { 
        match $2 with 
          | None -> $1
          | Some tl -> mk_pattern (consPat (rhs parseState 2) $1 tl) (rhs2 parseState 1 2) 
      }

consPattern:
  |  { None }
  |  COLON_COLON appPattern consPattern 
      { 
        match $3 with 
          | None -> Some $2
          | Some tl -> Some (mk_pattern (consPat (rhs parseState 1) $2 tl) (rhs2 parseState 1 3))
      }

appPattern:
  | atomicPattern atomicPatterns
      { 
        let hd = $1 in 
        let r = rhs parseState 1 in 
        match $2 with 
          | [] -> hd
          | _ -> mk_pattern (PatApp(hd, $2)) (union_ranges r (rhs parseState 1))
      }

compositePattern:
  | atomicPattern atomicPattern atomicPatterns
      {
        let args = $2::$3 in 
          mk_pattern (PatApp($1, args)) (rhs2 parseState 1 3)
      }
  | tuplePattern { $1 }

atomicPatterns:
  |    { [] }
  | atomicPattern atomicPatterns { $1::$2 }

atomicPattern: 
  | atomicPattern2 { mk_pattern $1 (rhs parseState 1) }

atomicPattern2:
  | nonTvarPattern2 { $1 }
  | tvar  { PatTvar ($1, false) }

nonTvarPattern:
  | nonTvarPattern2 { mk_pattern $1 (rhs parseState 1) }

nonTvarPattern2:
  | UNDERSCORE { PatWild }
  | constant { PatConst $1 }
  | HASH ident { PatVar($2, true) }
  | ident { PatVar($1, false) }
  | qname { PatName $1 }
  | LBRACK patternListSemiColon RBRACK { PatList $2 }
  | LPAREN ascriptionOrPattern RPAREN { $2 } 
  | LBRACE recordPattern RBRACE { PatRecord $2 }
  | LENS_PAREN_LEFT listPattern COMMA listPattern patternListComma LENS_PAREN_RIGHT 
      { 
        let args = $2::$4::$5 in
        PatTuple(args, true)
      }

ascriptionOrPattern:
  |  nonTvarPattern COLON typ refineOpt
      { 
		match $4 with
		  | None -> PatAscribed($1, $3) 
			  | Some phi ->
				let t = match $1.pat with 
				  | PatVar(x, _) -> 
					mk_term (Refine(mk_binder (Annotated(x, $3)) (rhs2 parseState 1 3) Type None, phi)) (rhs2 parseState 1 4) Type 
				  | _ -> errorR(Error("Not a valid refinement type", lhs(parseState))); $3 in
				PatAscribed($1, t)
      }
  |  pattern                { $1.pat }

patternListSemiColon:
  |   { [] }
  | appPattern patternListSemiColonRest { $1::$2 }

patternListSemiColonRest:
  |  { [] }
  | SEMICOLON appPattern patternListSemiColonRest { $2::$3 }


recordPattern:
  | lid EQUALS pattern moreFieldPatterns { ($1,$3)::$4 }
      
moreFieldPatterns:
  | { [] }
  | SEMICOLON lid EQUALS pattern moreFieldPatterns { ($2,$4)::$5 }

binder:
  | ident { mk_binder (Variable($1)) (rhs parseState 1) Type None  }
  | tvar  { mk_binder (TVariable($1)) (rhs parseState 1) Kind None  }
  | LPAREN aqual_opt ident COLON typ refineOpt RPAREN
	 { mkRefinedBinder $3 $5 $6 (rhs2 parseState 1 7) $2 }

typars:
  | tvarinsts              { $1 }
  | binders                { $1 }

tvarinsts: 
  | TYP_APP_LESS tvars TYP_APP_GREATER    { List.map (fun tv -> mk_binder (TVariable(tv)) tv.idRange Kind None) $2 }

aqual_opt:
  | HASH   { Some Implicit }
  | EQUALS { Some Equality }
  |        { None }

binders: 
  | binder binders { $1::$2 }
  |                { []     }

tyconDefn: 
  |               { (fun id binders kopt -> TyconAbstract(id, binders, kopt)) }
  | EQUALS typ    { (fun id binders kopt -> TyconAbbrev(id, binders, kopt, $2)) }
  | EQUALS LBRACE recordFieldDecl recordFields RBRACE { (fun id binders kopt -> TyconRecord(id, binders, kopt, $3::$4)) }
  | EQUALS constructors { (fun id binders kopt -> TyconVariant(id, binders, kopt, $2)) }


recordFields:
  | SEMICOLON recordFieldDecl recordFields
      { $2::$3 }
  | SEMICOLON { [] }
  |   { [] }


constructors:
  |   { [] }
  | constructors constructorDecl
      { $1@[$2] }

recordFieldDecl:
  |  ident COLON tmTuple
      { ($1, $3) }

constructorDecl:
  | BAR name COLON typ
      { ($2,Some $4,false) }
  | BAR name of_typ
      { ($2,$3,true) }

of_typ:
  |        {  None }
  | OF typ { Some $2 }

eitherQname: 
  | eitherpath { lid_of_ids $1 }

eitherpath: 
  | ident { [$1] }
  | name maybeMorePath { $1::$2 }

maybeMorePath:
  |		  { [] }
  | DOT eitherpath  { $2 }

lid:
  | idpath { lid_of_ids $1 }

qname:
  | namepath { lid_of_ids $1 }

eitherName:
  | ident { $1 } 
  | name  { $1 }

ident:
  | IDENT 
      { mk_ident($1, rhs parseState 1)}

name:
  | NAME 
      { mk_ident($1, rhs parseState 1) }

tvars:
  | TVAR                { [mk_ident($1, rhs parseState 1)] }
  | TVAR COMMA tvars    { mk_ident($1, rhs parseState 1) ::$3 }

tvar:
  | TVAR 
      { mk_ident($1, rhs parseState 1) }

namepath:
  | name 
      { [$1] }
  | name DOT namepath
      { $1::$3 }

idpath:
  | ident 
      { [$1] }
  | name DOT idpath
      { $1::$3 }
      
ascribeTypOpt:
  |              { None }
  | COLON product { Some $2 }

ascribeKindOpt: 
  |               { None }
  | COLON  kind { Some $2 }

kind:
  | product { {$1 with level=Kind} }
      
typ:
  | simpleTerm  { $1 }

  | FORALL binders DOT qpat noSeqTerm
      {
        mk_term (QForall($2,$4,$5)) (rhs2 parseState 1 5) Formula
      }

  | EXISTS binders DOT qpat noSeqTerm
      {
        mk_term (QExists($2,$4,$5)) (rhs2 parseState 1 5) Formula
      }
  
term:
  | noSeqTerm 
      { $1 }

  | noSeqTerm SEMICOLON term 
      { mk_term (Seq($1, $3)) (rhs2 parseState 1 3) Expr }


noSeqTerm:
  | typ  { $1 }

  | REQUIRES label_opt typ 
     {
        let pos = rhs2 parseState 1 4 in
        let f = $3 in
        mk_term (Requires(f, $2)) pos Type
     }

	 
  | ENSURES label_opt typ 
     {
        let pos = rhs2 parseState 1 4 in
        let f = $3 in
        mk_term (Ensures(f, $2)) pos Type 
     }

  | IF noSeqTerm THEN noSeqTerm ELSE noSeqTerm
      {
        mk_term (If($2, $4, $6)) (rhs2 parseState 1 6) Expr
      } 

  | IF noSeqTerm THEN noSeqTerm
      {
	    let e = mk_term (Const Const_unit) (rhs2 parseState 4 4) Expr in
        mk_term (If($2, $4, e)) (rhs2 parseState 1 4) Expr
      } 

  | TRY term WITH firstPatternBranch patternBranches 
      {
		 let branches = focusBranches ($4::$5) (rhs2 parseState 1 5) in
         mk_term (TryWith($2, branches)) (rhs2 parseState 1 5) Expr
      }

  | MATCH term WITH firstPatternBranch patternBranches 
      {	
		let branches = focusBranches ($4::$5) (rhs2 parseState 1 5) in
	    mk_term (Match($2, branches)) (rhs2 parseState 1 5) Expr
      }

  | LET recopt letbinding letbindings IN term
      {
		let r, focus = $2 in 
		let lbs = focusLetBindings ((focus,$3)::$4) (rhs2 parseState 2 4) in
        mk_term (Let(r, lbs, $6)) (rhs2 parseState 1 6) Expr
      }

  | FUNCTION firstPatternBranch patternBranches 
      { 
	    let branches = focusBranches ($2::$3) (rhs2 parseState 1 3) in
        mk_function branches (lhs parseState) (rhs2 parseState 1 3)
      }

  | ASSUME atomicTerm 
      { mkExplicitApp (mk_term (Var assume_lid) (rhs parseState 1) Expr) [$2]
          (rhs2 parseState 1 2)
      }

label_opt:
  |                        { None }
  | DOLLAR STRING          { Some (string_of_bytes $2) }

qpat: 
  |   { [] }
  | LBRACE_COLON_PATTERN appTerm morePats RBRACE
      { $2::$3 }

morePats:
  |  { [] }
  | SEMICOLON appTerm morePats  { $2::$3 }

simpleTerm:
  | tmIff { $1 }

  | FUN atomicPattern atomicPatterns funArrow term
      {
        $4 (Abs($2::$3, $5)) (rhs2 parseState 1 5) 
      }

patternBranches:
  |   { [] }
  | patternBranches patternBranch
      { $1@[$2] }

maybeBar:
  |     {()}
  | BAR {()}

maybeFocusArrow:
  | RARROW          { false }
  | SQUIGGLY_RARROW { true }

firstPatternBranch: /* shift/reduce conflict on BAR ... expected for nested matches */
  | maybeBar disjunctivePattern maybeWhen maybeFocusArrow term 
      { 
        let pat = match $2 with 
          | [p] -> p 
          | ps -> mk_pattern (PatOr ps) (rhs2 parseState 1 2) in
        ($4, (pat, $3, $5))
      }

patternBranch: /* shift/reduce conflict on BAR ... expected for nested matches */
  | BAR disjunctivePattern maybeWhen maybeFocusArrow term 
      { 
        let pat = match $2 with 
          | [p] -> p 
          | ps -> mk_pattern (PatOr ps) (rhs2 parseState 1 2) in
        ($4, (pat, $3, $5)) 
      }

disjunctivePattern:
  | pattern     { [$1] }
  | pattern BAR disjunctivePattern { $1::$3 }

maybeWhen:
  |             { None }
  | WHEN appTerm { Some $2 }       

funArrow:
  | RARROW { fun t r -> mk_term t r Un }
 
tmIff:
  | tmImplies IFF tmIff
      {
        mk_term (Op("<==>", [$1; $3])) (rhs2 parseState 1 3) Formula
      }

  | tmImplies
      { $1 }

tmImplies:
  | tmDisjunction IMPLIES tmImplies
      {
        mk_term (Op("==>", [$1; $3])) (rhs2 parseState 1 3) Formula
      }

  | tmDisjunction
      { $1 }

tmDisjunction:
  | tmDisjunction DISJUNCTION tmConjunction
      { mk_term (Op("\\/", [$1;$3])) (rhs2 parseState 1 3) Formula }
      
  | tmConjunction
      { $1 }

tmConjunction:
  | tmConjunction CONJUNCTION tmTuple
      { mk_term (Op("/\\", [$1;$3])) (rhs2 parseState 1 3) Formula }

  | tmTuple
      { $1 }

tmTuple:
  | tupleN
      {
        match $1 with 
          | [x] -> x
          | components -> mkTuple components (rhs2 parseState 1 1)
      }

tmEq:
  | tmEq COLON_EQUALS tmOr
      {
        mk_term (Op(":=", [$1; $3])) (rhs2 parseState 1 3) Un
      }

  | tmOr
      { $1 }

tmOr:
  | tmOr BAR_BAR tmAnd
      { mk_term (Op("||", [$1; $3])) (rhs2 parseState 1 3) Un}

  | tmAnd
      { $1 }

tmAnd:
  | tmAnd AMP_AMP cmpTerm
      { mk_term (Op("&&", [$1;$3])) (rhs2 parseState 1 3) Un}

  | cmpTerm
      { $1 }
      
cmpTerm:
  | cmpTerm comparisonOp tmCons
      { mk_term (Op($2, [$1;$3])) (rhs2 parseState 1 3) Expr }
  | tmCons 
      { $1 }

comparisonOp:
  | CUSTOM_OP { $1 }
  | EQUALS    { "=" }
 
tmCons:
  | product COLON_COLON tmCons
      { consTerm (rhs parseState 2) $1 $3 }

  | product
      { $1 }

product: 
  | productDomain RARROW product
	 {
		let aq, tm = $1 in 
		let b = match extract_named_refinement tm with 
			| None -> mk_binder (NoName tm) (rhs parseState 1) Un aq
			| Some (x, t, f) -> mkRefinedBinder x t f (rhs2 parseState 1 1) aq in
        mk_term (Product([b], $3)) (rhs2 parseState 1 3)  Un
	 
	 }

  | dtupleTerm 
	  { $1 }

productDomain:
  | aqual dtupleTerm { (Some $1, $2) }
  | dtupleTerm      { (None, $1)    }

dtupleTerm:
  | arithTerm AMP dtupleTerm
      { 
		let x, t, f = match extract_named_refinement $1 with 
			| Some (x, t, f) -> x, t, f
			| _ -> raise (Error("Missing binder for the first component of a dependent tuple", rhs2 parseState 1 2)) in
	    let dom = mkRefinedBinder x t f (rhs2 parseState 1 2) None in
		let tail = $3 in
		let dom, res = match tail.tm with 
			| Sum(dom', res) -> dom::dom', res
			| _ -> [dom], tail in 
	    mk_term (Sum(dom, res)) (rhs2 parseState 1 6) Type
	  }

  | arithTerm
	 { $1 }
  
arithTerm:
  | plusOp 
	  { $1 }

plusOp:
  | minusOp PLUS_OP plusOp
      { mk_term (Op("+", [$1;$3])) (rhs2 parseState 1 3) Un}

  | minusOp
	  { $1 }

minusOp:
  | minusOp MINUS_OP starDivModTerm
      { mk_term (Op("-", [$1;$3])) (rhs2 parseState 1 3) Un}

  | starDivModTerm 
      { $1 }


starDivModTerm:
  | refinementTerm STAR starDivModTerm 
      { 
        mk_term (Op("*", [$1;$3])) (rhs2 parseState 1 3) Un
      }

  | unaryTerm DIV_MOD_OP starDivModTerm
      { mk_term (Op($2, [$1;$3])) (rhs2 parseState 1 3) Un}

  | refinementTerm
      { 
        $1 
      }

refinementTerm:
  | ident COLON appTerm 
      {
        mk_term (NamedTyp($1, $3)) (rhs2 parseState 1 3) Type 
      }
	  
  | ident COLON appTerm LBRACE formula RBRACE 
      {
        mk_term (Refine(mk_binder (Annotated($1, $3)) (rhs2 parseState 1 3) Type None, $5)) 
        (rhs2 parseState 1 6) Type
      }
	  
  | LBRACE recordExp RBRACE { $2 }

  | unaryTerm { $1 }
  
aqual:
  | HASH      { Implicit }
  | EQUALS    { Equality }

refineOpt:
  |                       { None }
  | LBRACE formula RBRACE { Some $2 }



unaryTerm: 
  | PLUS_OP atomicTerm
      { mk_term (Op("+", [$2])) (rhs2 parseState 1 3) Expr }

  | MINUS_OP atomicTerm
      { mk_term (Op("-", [$2])) (rhs2 parseState 1 3) Expr }

  | TILDE atomicTerm
      { mk_term (Op($1, [$2])) (rhs2 parseState 1 3) Formula }

  | appTerm { $1 }

appTerm:
  | atomicTerm hashAtomicTerms
      {
        mkApp $1 $2 (rhs2 parseState 1 2)
      }

formula:
  | noSeqTerm
      { {$1 with level=Formula} }

atomicTerm:
  | UNDERSCORE { mk_term Wild (rhs parseState 1) Un }
  | ASSERT   { mk_term (Var assert_lid) (rhs parseState 1) Expr }
  | tvar     { mk_term (Tvar($1)) (rhs parseState 1) Type }
  | constant { mk_term (Const $1) (rhs parseState 1) Expr }
  | LENS_PAREN_LEFT tupleN LENS_PAREN_RIGHT 
      { 
        match $2 with 
          | [x] -> x
          | components -> mkDTuple components (rhs2 parseState 1 1)
      }
  | projectionLHS maybeFieldProjections 
      {  
        List.fold_left (fun e f -> 
                          mk_term (Project(e, lid_of_ids [f])) (rhs2 parseState 1 3) Expr )
          $1 $2
      }
  | BANG atomicTerm
      { mk_term (Op("!", [$2])) (rhs2 parseState 1 2) Expr }
  | BEGIN term END 
      { $2 }

recdFieldTypes:
  |  { [] }
  | recdFieldType moreRecdFieldTypes { $1::$2 }

moreRecdFieldTypes:
  |  { [] }
  | SEMICOLON recdFieldType moreRecdFieldTypes { $2::$3 }

recdFieldType:
  | ident COLON typ { ($1, $3) }

maybeFieldProjections:
  |    { [] }
  | maybeFieldProjections DOT ident 
      { $1@[$3] }

targs:
  | atomicTerm { [$1] }
  | atomicTerm COMMA targs { $1::$3 }

maybeInsts:
  |    { (fun x -> x) }
  | TYP_APP_LESS targs TYP_APP_GREATER 
      {
        (fun (x:term) -> mkFsTypApp x $2
          (union_ranges x.range (rhs2 parseState 1 3)))
      }

projectionLHS:
  | eitherQname maybeInsts
      { 
        let t = if is_name $1 then Name $1 else Var $1 in
        $2 (mk_term t (rhs parseState 1) Un) 
      }
  | LPAREN term maybeWithSort RPAREN 
      { mk_term (Paren($3 $2 (rhs2 parseState 2 3))) (rhs2 parseState 1 4) ($2.level) }
  | LBRACK_BAR semiColonTermList BAR_RBRACK
      {
        let l = mkConsList (rhs2 parseState 1 3) $2 in 
        mkExplicitApp (mk_term (Var (array_mk_array_lid)) (rhs2 parseState 1 3) Expr) 
              [l] (rhs2 parseState 1 3)
      }
  | LBRACK semiColonTermList RBRACK
      { 
        mkConsList (rhs2 parseState 1 3) $2
      }
  | PERCENT_LBRACK semiColonTermList RBRACK
	  {
		mkLexList (rhs2 parseState 1 3) $2
	  }

  | BANG_LBRACE commaTermList RBRACE
	  {
		mkRefSet (rhs2 parseState 1 3) $2
	  }
	  
commaTermList:
  |  { [] }
  | appTerm moreCommaTerms
      { $1::$2 }

moreCommaTerms:
  |   { [] }
  | COMMA appTerm moreCommaTerms
      { $2::$3 }


semiColonTermList:
  |  { [] }
  | noSeqTerm moreSemiColonTerms
      { $1::$2 }

moreSemiColonTerms:
  |   { [] }
  | SEMICOLON { [] }
  | SEMICOLON noSeqTerm moreSemiColonTerms 
      { $2::$3 }

recordExp: 
  | appTerm recordExpRest 
      { $2 $1 (lhs parseState) }

recordExpRest:
  | WITH recordFieldAssignment recordFieldAssignments
      {
        (fun e r -> mk_term (Record(Some e, $2::$3)) (union_ranges r (rhs2 parseState 1 3)) Expr)
      }

  | EQUALS simpleTerm recordFieldAssignments
      {
        (fun e r -> match e.tm with 
          | Var l -> mk_term (Record(None, (l,$2)::$3)) (union_ranges r (rhs2 parseState 1 3)) Expr
          | _ -> errorR(Error("Record field names must be constant identifiers", lhs(parseState)));
            mk_term (Record(None, $3)) (rhs2 parseState 1 3) Expr)
      }

recordFieldAssignment:
  | lid EQUALS simpleTerm
      { ($1,$3) }

recordFieldAssignments:
  |           { [] }
  | SEMICOLON { [] }
  | SEMICOLON recordFieldAssignment recordFieldAssignments
     { $2::$3 }

maybeWithSort:
  |     { fun x r -> x }
  | hasSort simpleTerm
        { fun x r -> mk_term (Ascribed(x,{$2 with level=$1})) (union_ranges r (rhs2 parseState 1 2)) $1 }
hasSort:
  | SUBTYPE { Expr }
  | SUBKIND { Type }

maybeHash: 
  |      { Nothing }
  | HASH { Hash }

hashAtomicTerms:
  |        { [] }
  | maybeHash atomicTerm hashAtomicTerms { ($2, $1)::$3 }

atomicTerms: 
  |        { [] }
  | atomicTerm atomicTerms { $1::$2 }

consTerm:
  |       { None }
  | COLON_COLON tmTuple consTerm 
      { 
        match $3 with 
          | None -> Some $2
          | Some tl -> Some (consTerm (rhs2 parseState 2 3) $2 tl)
      }

tupleN:
  | tmEq                       { [$1] }
  | tmEq COMMA tupleN       { $1::$3 }

constant:  
  | LPAREN_RPAREN { Const_unit }
  | INT 
	 {
	    if snd $1 then 
          errorR(Error("This number is outside the allowable range for representable integer constants", lhs(parseState)));
        Const_int (fst $1) 
	 }
  | INT32 
      { 
        if snd $1 then 
          errorR(Error("This number is outside the allowable range for 32-bit signed integers", lhs(parseState)));
        Const_int32 (fst $1) 
      } 
  | UINT8 { Const_uint8 $1 } 
  
  | CHAR { Const_char $1 } 
  | STRING { Const_string ($1,lhs(parseState)) } 
  | BYTEARRAY { Const_bytearray ($1,lhs(parseState)) }
  | TRUE { Const_bool true }
  | FALSE { Const_bool false } 
  | IEEE64 { Const_float $1 } 
  | INT64 
      { 
        if snd $1 then 
          errorR(Error("This number is outside the allowable range for 64-bit signed integers", lhs(parseState)));
        Const_int64 (fst $1) 
      }   
/*
  | UINT32 { Const_uint32 $1 } 
  | INT8 
      { 
        if snd $1 then
          errorR(Error("This number is outside the allowable range for 8-bit signed integers", lhs(parseState)));
        Const_int8 (fst $1) 
      } 
  | INT16 
      { 
        if snd $1 then 
          errorR(Error("This number is outside the allowable range for 16-bit signed integers", lhs(parseState)));
        Const_int16 (fst $1) 
      } 
  | UINT16 { Const_uint16 $1 } 
  | BIGINT { Const_bigint $1 } 
  | DECIMAL { Const_decimal $1 } 
  | BIGNUM { Const_bignum $1 } 
  | UINT64 { Const_uint64 $1 } 
  | NATIVEINT { Const_nativeint $1 } 
  | UNATIVEINT { Const_unativeint $1 } 
  | IEEE32 { Const_float32 $1 } 
*/
