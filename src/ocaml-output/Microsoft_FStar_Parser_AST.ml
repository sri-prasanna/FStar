
type level =
| Un
| Expr
| Type
| Kind
| Formula

let is_Un = (fun ( _discr_ ) -> (match (_discr_) with
| Un -> begin
true
end
| _ -> begin
false
end))

let is_Expr = (fun ( _discr_ ) -> (match (_discr_) with
| Expr -> begin
true
end
| _ -> begin
false
end))

let is_Type = (fun ( _discr_ ) -> (match (_discr_) with
| Type -> begin
true
end
| _ -> begin
false
end))

let is_Kind = (fun ( _discr_ ) -> (match (_discr_) with
| Kind -> begin
true
end
| _ -> begin
false
end))

let is_Formula = (fun ( _discr_ ) -> (match (_discr_) with
| Formula -> begin
true
end
| _ -> begin
false
end))

type lid =
Microsoft_FStar_Absyn_Syntax.l__LongIdent

type imp =
| FsTypApp
| Hash
| Nothing

let is_FsTypApp = (fun ( _discr_ ) -> (match (_discr_) with
| FsTypApp -> begin
true
end
| _ -> begin
false
end))

let is_Hash = (fun ( _discr_ ) -> (match (_discr_) with
| Hash -> begin
true
end
| _ -> begin
false
end))

let is_Nothing = (fun ( _discr_ ) -> (match (_discr_) with
| Nothing -> begin
true
end
| _ -> begin
false
end))

type term' =
| Wild
| Const of Microsoft_FStar_Absyn_Syntax.sconst
| Op of (string * term list)
| Tvar of Microsoft_FStar_Absyn_Syntax.ident
| Var of lid
| Name of lid
| Construct of (lid * (term * imp) list)
| Abs of (pattern list * term)
| App of (term * term * imp)
| Let of (bool * (pattern * term) list * term)
| Seq of (term * term)
| If of (term * term * term)
| Match of (term * branch list)
| TryWith of (term * branch list)
| Ascribed of (term * term)
| Record of (term option * (lid * term) list)
| Project of (term * lid)
| Product of (binder list * term)
| Sum of (binder list * term)
| QForall of (binder list * term list * term)
| QExists of (binder list * term list * term)
| Refine of (binder * term)
| NamedTyp of (Microsoft_FStar_Absyn_Syntax.ident * term)
| Paren of term
| Requires of (term * string option)
| Ensures of (term * string option)
| Labeled of (term * string * bool) 
 and term =
{tm : term'; range : Support.Microsoft.FStar.Range.range; level : level} 
 and binder' =
| Variable of Microsoft_FStar_Absyn_Syntax.ident
| TVariable of Microsoft_FStar_Absyn_Syntax.ident
| Annotated of (Microsoft_FStar_Absyn_Syntax.ident * term)
| TAnnotated of (Microsoft_FStar_Absyn_Syntax.ident * term)
| NoName of term 
 and binder =
{b : binder'; brange : Support.Microsoft.FStar.Range.range; blevel : level; aqual : Microsoft_FStar_Absyn_Syntax.aqual} 
 and pattern' =
| PatWild
| PatConst of Microsoft_FStar_Absyn_Syntax.sconst
| PatApp of (pattern * pattern list)
| PatVar of (Microsoft_FStar_Absyn_Syntax.ident * bool)
| PatName of lid
| PatTvar of (Microsoft_FStar_Absyn_Syntax.ident * bool)
| PatList of pattern list
| PatTuple of (pattern list * bool)
| PatRecord of (lid * pattern) list
| PatAscribed of (pattern * term)
| PatOr of pattern list 
 and pattern =
{pat : pattern'; prange : Support.Microsoft.FStar.Range.range} 
 and branch =
(pattern * term option * term)

let is_Wild = (fun ( _discr_ ) -> (match (_discr_) with
| Wild -> begin
true
end
| _ -> begin
false
end))

let is_Const = (fun ( _discr_ ) -> (match (_discr_) with
| Const (_) -> begin
true
end
| _ -> begin
false
end))

let is_Op = (fun ( _discr_ ) -> (match (_discr_) with
| Op (_) -> begin
true
end
| _ -> begin
false
end))

let is_Tvar = (fun ( _discr_ ) -> (match (_discr_) with
| Tvar (_) -> begin
true
end
| _ -> begin
false
end))

let is_Var = (fun ( _discr_ ) -> (match (_discr_) with
| Var (_) -> begin
true
end
| _ -> begin
false
end))

let is_Name = (fun ( _discr_ ) -> (match (_discr_) with
| Name (_) -> begin
true
end
| _ -> begin
false
end))

let is_Construct = (fun ( _discr_ ) -> (match (_discr_) with
| Construct (_) -> begin
true
end
| _ -> begin
false
end))

let is_Abs = (fun ( _discr_ ) -> (match (_discr_) with
| Abs (_) -> begin
true
end
| _ -> begin
false
end))

let is_App = (fun ( _discr_ ) -> (match (_discr_) with
| App (_) -> begin
true
end
| _ -> begin
false
end))

let is_Let = (fun ( _discr_ ) -> (match (_discr_) with
| Let (_) -> begin
true
end
| _ -> begin
false
end))

let is_Seq = (fun ( _discr_ ) -> (match (_discr_) with
| Seq (_) -> begin
true
end
| _ -> begin
false
end))

let is_If = (fun ( _discr_ ) -> (match (_discr_) with
| If (_) -> begin
true
end
| _ -> begin
false
end))

let is_Match = (fun ( _discr_ ) -> (match (_discr_) with
| Match (_) -> begin
true
end
| _ -> begin
false
end))

let is_TryWith = (fun ( _discr_ ) -> (match (_discr_) with
| TryWith (_) -> begin
true
end
| _ -> begin
false
end))

let is_Ascribed = (fun ( _discr_ ) -> (match (_discr_) with
| Ascribed (_) -> begin
true
end
| _ -> begin
false
end))

let is_Record = (fun ( _discr_ ) -> (match (_discr_) with
| Record (_) -> begin
true
end
| _ -> begin
false
end))

let is_Project = (fun ( _discr_ ) -> (match (_discr_) with
| Project (_) -> begin
true
end
| _ -> begin
false
end))

let is_Product = (fun ( _discr_ ) -> (match (_discr_) with
| Product (_) -> begin
true
end
| _ -> begin
false
end))

let is_Sum = (fun ( _discr_ ) -> (match (_discr_) with
| Sum (_) -> begin
true
end
| _ -> begin
false
end))

let is_QForall = (fun ( _discr_ ) -> (match (_discr_) with
| QForall (_) -> begin
true
end
| _ -> begin
false
end))

let is_QExists = (fun ( _discr_ ) -> (match (_discr_) with
| QExists (_) -> begin
true
end
| _ -> begin
false
end))

let is_Refine = (fun ( _discr_ ) -> (match (_discr_) with
| Refine (_) -> begin
true
end
| _ -> begin
false
end))

let is_NamedTyp = (fun ( _discr_ ) -> (match (_discr_) with
| NamedTyp (_) -> begin
true
end
| _ -> begin
false
end))

let is_Paren = (fun ( _discr_ ) -> (match (_discr_) with
| Paren (_) -> begin
true
end
| _ -> begin
false
end))

let is_Requires = (fun ( _discr_ ) -> (match (_discr_) with
| Requires (_) -> begin
true
end
| _ -> begin
false
end))

let is_Ensures = (fun ( _discr_ ) -> (match (_discr_) with
| Ensures (_) -> begin
true
end
| _ -> begin
false
end))

let is_Labeled = (fun ( _discr_ ) -> (match (_discr_) with
| Labeled (_) -> begin
true
end
| _ -> begin
false
end))

let is_Mkterm = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkterm")))

let is_Variable = (fun ( _discr_ ) -> (match (_discr_) with
| Variable (_) -> begin
true
end
| _ -> begin
false
end))

let is_TVariable = (fun ( _discr_ ) -> (match (_discr_) with
| TVariable (_) -> begin
true
end
| _ -> begin
false
end))

let is_Annotated = (fun ( _discr_ ) -> (match (_discr_) with
| Annotated (_) -> begin
true
end
| _ -> begin
false
end))

let is_TAnnotated = (fun ( _discr_ ) -> (match (_discr_) with
| TAnnotated (_) -> begin
true
end
| _ -> begin
false
end))

let is_NoName = (fun ( _discr_ ) -> (match (_discr_) with
| NoName (_) -> begin
true
end
| _ -> begin
false
end))

let is_Mkbinder = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkbinder")))

let is_PatWild = (fun ( _discr_ ) -> (match (_discr_) with
| PatWild -> begin
true
end
| _ -> begin
false
end))

let is_PatConst = (fun ( _discr_ ) -> (match (_discr_) with
| PatConst (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatApp = (fun ( _discr_ ) -> (match (_discr_) with
| PatApp (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatVar = (fun ( _discr_ ) -> (match (_discr_) with
| PatVar (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatName = (fun ( _discr_ ) -> (match (_discr_) with
| PatName (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatTvar = (fun ( _discr_ ) -> (match (_discr_) with
| PatTvar (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatList = (fun ( _discr_ ) -> (match (_discr_) with
| PatList (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatTuple = (fun ( _discr_ ) -> (match (_discr_) with
| PatTuple (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatRecord = (fun ( _discr_ ) -> (match (_discr_) with
| PatRecord (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatAscribed = (fun ( _discr_ ) -> (match (_discr_) with
| PatAscribed (_) -> begin
true
end
| _ -> begin
false
end))

let is_PatOr = (fun ( _discr_ ) -> (match (_discr_) with
| PatOr (_) -> begin
true
end
| _ -> begin
false
end))

let is_Mkpattern = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkpattern")))

type knd =
term

type typ =
term

type expr =
term

type tycon =
| TyconAbstract of (Microsoft_FStar_Absyn_Syntax.ident * binder list * knd option)
| TyconAbbrev of (Microsoft_FStar_Absyn_Syntax.ident * binder list * knd option * term)
| TyconRecord of (Microsoft_FStar_Absyn_Syntax.ident * binder list * knd option * (Microsoft_FStar_Absyn_Syntax.ident * term) list)
| TyconVariant of (Microsoft_FStar_Absyn_Syntax.ident * binder list * knd option * (Microsoft_FStar_Absyn_Syntax.ident * term option * bool) list)

let is_TyconAbstract = (fun ( _discr_ ) -> (match (_discr_) with
| TyconAbstract (_) -> begin
true
end
| _ -> begin
false
end))

let is_TyconAbbrev = (fun ( _discr_ ) -> (match (_discr_) with
| TyconAbbrev (_) -> begin
true
end
| _ -> begin
false
end))

let is_TyconRecord = (fun ( _discr_ ) -> (match (_discr_) with
| TyconRecord (_) -> begin
true
end
| _ -> begin
false
end))

let is_TyconVariant = (fun ( _discr_ ) -> (match (_discr_) with
| TyconVariant (_) -> begin
true
end
| _ -> begin
false
end))

type qualifiers =
Microsoft_FStar_Absyn_Syntax.qualifier list

type lift =
{msource : lid; mdest : lid; lift_op : term}

let is_Mklift = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mklift")))

type decl' =
| Open of lid
| KindAbbrev of (Microsoft_FStar_Absyn_Syntax.ident * binder list * knd)
| ToplevelLet of (bool * (pattern * term) list)
| Main of term
| Assume of (qualifiers * Microsoft_FStar_Absyn_Syntax.ident * term)
| Tycon of (qualifiers * tycon list)
| Val of (qualifiers * Microsoft_FStar_Absyn_Syntax.ident * term)
| Exception of (Microsoft_FStar_Absyn_Syntax.ident * term option)
| NewEffect of (qualifiers * effect_decl)
| SubEffect of lift
| Pragma of Microsoft_FStar_Absyn_Syntax.pragma 
 and decl =
{d : decl'; drange : Support.Microsoft.FStar.Range.range} 
 and effect_decl =
| DefineEffect of (Microsoft_FStar_Absyn_Syntax.ident * binder list * term * decl list)
| RedefineEffect of (Microsoft_FStar_Absyn_Syntax.ident * binder list * term)

let is_Open = (fun ( _discr_ ) -> (match (_discr_) with
| Open (_) -> begin
true
end
| _ -> begin
false
end))

let is_KindAbbrev = (fun ( _discr_ ) -> (match (_discr_) with
| KindAbbrev (_) -> begin
true
end
| _ -> begin
false
end))

let is_ToplevelLet = (fun ( _discr_ ) -> (match (_discr_) with
| ToplevelLet (_) -> begin
true
end
| _ -> begin
false
end))

let is_Main = (fun ( _discr_ ) -> (match (_discr_) with
| Main (_) -> begin
true
end
| _ -> begin
false
end))

let is_Assume = (fun ( _discr_ ) -> (match (_discr_) with
| Assume (_) -> begin
true
end
| _ -> begin
false
end))

let is_Tycon = (fun ( _discr_ ) -> (match (_discr_) with
| Tycon (_) -> begin
true
end
| _ -> begin
false
end))

let is_Val = (fun ( _discr_ ) -> (match (_discr_) with
| Val (_) -> begin
true
end
| _ -> begin
false
end))

let is_Exception = (fun ( _discr_ ) -> (match (_discr_) with
| Exception (_) -> begin
true
end
| _ -> begin
false
end))

let is_NewEffect = (fun ( _discr_ ) -> (match (_discr_) with
| NewEffect (_) -> begin
true
end
| _ -> begin
false
end))

let is_SubEffect = (fun ( _discr_ ) -> (match (_discr_) with
| SubEffect (_) -> begin
true
end
| _ -> begin
false
end))

let is_Pragma = (fun ( _discr_ ) -> (match (_discr_) with
| Pragma (_) -> begin
true
end
| _ -> begin
false
end))

let is_Mkdecl = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkdecl")))

let is_DefineEffect = (fun ( _discr_ ) -> (match (_discr_) with
| DefineEffect (_) -> begin
true
end
| _ -> begin
false
end))

let is_RedefineEffect = (fun ( _discr_ ) -> (match (_discr_) with
| RedefineEffect (_) -> begin
true
end
| _ -> begin
false
end))

type modul =
| Module of (Microsoft_FStar_Absyn_Syntax.l__LongIdent * decl list)
| Interface of (Microsoft_FStar_Absyn_Syntax.l__LongIdent * decl list * bool)

let is_Module = (fun ( _discr_ ) -> (match (_discr_) with
| Module (_) -> begin
true
end
| _ -> begin
false
end))

let is_Interface = (fun ( _discr_ ) -> (match (_discr_) with
| Interface (_) -> begin
true
end
| _ -> begin
false
end))

type file =
modul list

type inputFragment =
(file, decl list) Support.Microsoft.FStar.Util.either

let mk_decl = (fun ( d ) ( r ) -> {d = d; drange = r})

let mk_binder = (fun ( b ) ( r ) ( l ) ( i ) -> {b = b; brange = r; blevel = l; aqual = i})

let mk_term = (fun ( t ) ( r ) ( l ) -> {tm = t; range = r; level = l})

let mk_pattern = (fun ( p ) ( r ) -> {pat = p; prange = r})

let un_curry_abs = (fun ( ps ) ( body ) -> (match (body.tm) with
| Abs ((p', body')) -> begin
Abs (((Support.List.append ps p'), body'))
end
| _37_159 -> begin
Abs ((ps, body))
end))

let mk_function = (fun ( branches ) ( r1 ) ( r2 ) -> (let x = (Microsoft_FStar_Absyn_Util.genident (Some (r1)))
in (let _68_17831 = (let _68_17830 = (let _68_17829 = (let _68_17828 = (let _68_17827 = (let _68_17826 = (let _68_17825 = (let _68_17824 = (Microsoft_FStar_Absyn_Syntax.lid_of_ids ((x)::[]))
in Var (_68_17824))
in (mk_term _68_17825 r1 Expr))
in (_68_17826, branches))
in Match (_68_17827))
in (mk_term _68_17828 r2 Expr))
in (((mk_pattern (PatVar ((x, false))) r1))::[], _68_17829))
in Abs (_68_17830))
in (mk_term _68_17831 r2 Expr))))

let un_function = (fun ( p ) ( tm ) -> (match ((p.pat, tm.tm)) with
| (PatVar (_37_167), Abs ((pats, body))) -> begin
Some (((mk_pattern (PatApp ((p, pats))) p.prange), body))
end
| _37_175 -> begin
None
end))

let lid_with_range = (fun ( lid ) ( r ) -> (let _68_17840 = (Microsoft_FStar_Absyn_Syntax.path_of_lid lid)
in (Microsoft_FStar_Absyn_Syntax.lid_of_path _68_17840 r)))

let to_string_l = (fun ( sep ) ( f ) ( l ) -> (let _68_17847 = (Support.List.map f l)
in (Support.String.concat sep _68_17847)))

let imp_to_string = (fun ( _37_1 ) -> (match (_37_1) with
| Hash -> begin
"#"
end
| _37_184 -> begin
""
end))

let rec term_to_string = (fun ( x ) -> (match (x.tm) with
| Wild -> begin
"_"
end
| Requires ((t, _37_189)) -> begin
(let _68_17854 = (term_to_string t)
in (Support.Microsoft.FStar.Util.format1 "(requires %s)" _68_17854))
end
| Ensures ((t, _37_194)) -> begin
(let _68_17855 = (term_to_string t)
in (Support.Microsoft.FStar.Util.format1 "(ensures %s)" _68_17855))
end
| Labeled ((t, l, _37_200)) -> begin
(let _68_17856 = (term_to_string t)
in (Support.Microsoft.FStar.Util.format2 "(labeled %s %s)" l _68_17856))
end
| Const (c) -> begin
(Microsoft_FStar_Absyn_Print.const_to_string c)
end
| Op ((s, xs)) -> begin
(let _68_17859 = (let _68_17858 = (Support.List.map (fun ( x ) -> (Support.Prims.pipe_right x term_to_string)) xs)
in (Support.String.concat ", " _68_17858))
in (Support.Microsoft.FStar.Util.format2 "%s(%s)" s _68_17859))
end
| Tvar (id) -> begin
id.Microsoft_FStar_Absyn_Syntax.idText
end
| (Var (l)) | (Name (l)) -> begin
(Microsoft_FStar_Absyn_Print.sli l)
end
| Construct ((l, args)) -> begin
(let _68_17863 = (Microsoft_FStar_Absyn_Print.sli l)
in (let _68_17862 = (to_string_l " " (fun ( _37_221 ) -> (match (_37_221) with
| (a, imp) -> begin
(let _68_17861 = (term_to_string a)
in (Support.Microsoft.FStar.Util.format2 "%s%s" (imp_to_string imp) _68_17861))
end)) args)
in (Support.Microsoft.FStar.Util.format2 "(%s %s)" _68_17863 _68_17862)))
end
| Abs ((pats, t)) when (x.level = Expr) -> begin
(let _68_17865 = (to_string_l " " pat_to_string pats)
in (let _68_17864 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "(fun %s -> %s)" _68_17865 _68_17864)))
end
| Abs ((pats, t)) when (x.level = Type) -> begin
(let _68_17867 = (to_string_l " " pat_to_string pats)
in (let _68_17866 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "(fun %s => %s)" _68_17867 _68_17866)))
end
| App ((t1, t2, imp)) -> begin
(let _68_17869 = (Support.Prims.pipe_right t1 term_to_string)
in (let _68_17868 = (Support.Prims.pipe_right t2 term_to_string)
in (Support.Microsoft.FStar.Util.format3 "%s %s%s" _68_17869 (imp_to_string imp) _68_17868)))
end
| Let ((false, (pat, tm)::[], body)) -> begin
(let _68_17872 = (Support.Prims.pipe_right pat pat_to_string)
in (let _68_17871 = (Support.Prims.pipe_right tm term_to_string)
in (let _68_17870 = (Support.Prims.pipe_right body term_to_string)
in (Support.Microsoft.FStar.Util.format3 "let %s = %s in %s" _68_17872 _68_17871 _68_17870))))
end
| Let ((_37_244, lbs, body)) -> begin
(let _68_17877 = (to_string_l " and " (fun ( _37_251 ) -> (match (_37_251) with
| (p, b) -> begin
(let _68_17875 = (Support.Prims.pipe_right p pat_to_string)
in (let _68_17874 = (Support.Prims.pipe_right b term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s=%s" _68_17875 _68_17874)))
end)) lbs)
in (let _68_17876 = (Support.Prims.pipe_right body term_to_string)
in (Support.Microsoft.FStar.Util.format2 "let rec %s in %s" _68_17877 _68_17876)))
end
| Seq ((t1, t2)) -> begin
(let _68_17879 = (Support.Prims.pipe_right t1 term_to_string)
in (let _68_17878 = (Support.Prims.pipe_right t2 term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s; %s" _68_17879 _68_17878)))
end
| If ((t1, t2, t3)) -> begin
(let _68_17882 = (Support.Prims.pipe_right t1 term_to_string)
in (let _68_17881 = (Support.Prims.pipe_right t2 term_to_string)
in (let _68_17880 = (Support.Prims.pipe_right t3 term_to_string)
in (Support.Microsoft.FStar.Util.format3 "if %s then %s else %s" _68_17882 _68_17881 _68_17880))))
end
| Match ((t, branches)) -> begin
(let _68_17889 = (Support.Prims.pipe_right t term_to_string)
in (let _68_17888 = (to_string_l " | " (fun ( _37_268 ) -> (match (_37_268) with
| (p, w, e) -> begin
(let _68_17887 = (Support.Prims.pipe_right p pat_to_string)
in (let _68_17886 = (match (w) with
| None -> begin
""
end
| Some (e) -> begin
(let _68_17884 = (term_to_string e)
in (Support.Microsoft.FStar.Util.format1 "when %s" _68_17884))
end)
in (let _68_17885 = (Support.Prims.pipe_right e term_to_string)
in (Support.Microsoft.FStar.Util.format3 "%s %s -> %s" _68_17887 _68_17886 _68_17885))))
end)) branches)
in (Support.Microsoft.FStar.Util.format2 "match %s with %s" _68_17889 _68_17888)))
end
| Ascribed ((t1, t2)) -> begin
(let _68_17891 = (Support.Prims.pipe_right t1 term_to_string)
in (let _68_17890 = (Support.Prims.pipe_right t2 term_to_string)
in (Support.Microsoft.FStar.Util.format2 "(%s : %s)" _68_17891 _68_17890)))
end
| Record ((Some (e), fields)) -> begin
(let _68_17896 = (Support.Prims.pipe_right e term_to_string)
in (let _68_17895 = (to_string_l " " (fun ( _37_283 ) -> (match (_37_283) with
| (l, e) -> begin
(let _68_17894 = (Microsoft_FStar_Absyn_Print.sli l)
in (let _68_17893 = (Support.Prims.pipe_right e term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s=%s" _68_17894 _68_17893)))
end)) fields)
in (Support.Microsoft.FStar.Util.format2 "{%s with %s}" _68_17896 _68_17895)))
end
| Record ((None, fields)) -> begin
(let _68_17900 = (to_string_l " " (fun ( _37_290 ) -> (match (_37_290) with
| (l, e) -> begin
(let _68_17899 = (Microsoft_FStar_Absyn_Print.sli l)
in (let _68_17898 = (Support.Prims.pipe_right e term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s=%s" _68_17899 _68_17898)))
end)) fields)
in (Support.Microsoft.FStar.Util.format1 "{%s}" _68_17900))
end
| Project ((e, l)) -> begin
(let _68_17902 = (Support.Prims.pipe_right e term_to_string)
in (let _68_17901 = (Microsoft_FStar_Absyn_Print.sli l)
in (Support.Microsoft.FStar.Util.format2 "%s.%s" _68_17902 _68_17901)))
end
| Product (([], t)) -> begin
(term_to_string t)
end
| Product ((b::hd::tl, t)) -> begin
(term_to_string (mk_term (Product (((b)::[], (mk_term (Product (((hd)::tl, t))) x.range x.level)))) x.range x.level))
end
| Product ((b::[], t)) when (x.level = Type) -> begin
(let _68_17904 = (Support.Prims.pipe_right b binder_to_string)
in (let _68_17903 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s -> %s" _68_17904 _68_17903)))
end
| Product ((b::[], t)) when (x.level = Kind) -> begin
(let _68_17906 = (Support.Prims.pipe_right b binder_to_string)
in (let _68_17905 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s => %s" _68_17906 _68_17905)))
end
| Sum ((binders, t)) -> begin
(let _68_17909 = (let _68_17907 = (Support.Prims.pipe_right binders (Support.List.map binder_to_string))
in (Support.Prims.pipe_right _68_17907 (Support.String.concat " * ")))
in (let _68_17908 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s * %s" _68_17909 _68_17908)))
end
| QForall ((bs, pats, t)) -> begin
(let _68_17912 = (to_string_l " " binder_to_string bs)
in (let _68_17911 = (to_string_l "; " term_to_string pats)
in (let _68_17910 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format3 "forall %s.{:pattern %s} %s" _68_17912 _68_17911 _68_17910))))
end
| QExists ((bs, pats, t)) -> begin
(let _68_17915 = (to_string_l " " binder_to_string bs)
in (let _68_17914 = (to_string_l "; " term_to_string pats)
in (let _68_17913 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format3 "exists %s.{:pattern %s} %s" _68_17915 _68_17914 _68_17913))))
end
| Refine ((b, t)) -> begin
(let _68_17917 = (Support.Prims.pipe_right b binder_to_string)
in (let _68_17916 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s:{%s}" _68_17917 _68_17916)))
end
| NamedTyp ((x, t)) -> begin
(let _68_17918 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s:%s" x.Microsoft_FStar_Absyn_Syntax.idText _68_17918))
end
| Paren (t) -> begin
(let _68_17919 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format1 "(%s)" _68_17919))
end
| Product ((bs, t)) -> begin
(let _68_17922 = (let _68_17920 = (Support.Prims.pipe_right bs (Support.List.map binder_to_string))
in (Support.Prims.pipe_right _68_17920 (Support.String.concat ",")))
in (let _68_17921 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "Unidentified product: [%s] %s" _68_17922 _68_17921)))
end
| t -> begin
(failwith ("Missing case in term_to_string"))
end))
and binder_to_string = (fun ( x ) -> (let s = (match (x.b) with
| Variable (i) -> begin
i.Microsoft_FStar_Absyn_Syntax.idText
end
| TVariable (i) -> begin
(Support.Microsoft.FStar.Util.format1 "%s:_" i.Microsoft_FStar_Absyn_Syntax.idText)
end
| (TAnnotated ((i, t))) | (Annotated ((i, t))) -> begin
(let _68_17924 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s:%s" i.Microsoft_FStar_Absyn_Syntax.idText _68_17924))
end
| NoName (t) -> begin
(Support.Prims.pipe_right t term_to_string)
end)
in (match (x.aqual) with
| Some (Microsoft_FStar_Absyn_Syntax.Implicit) -> begin
(Support.Microsoft.FStar.Util.format1 "#%s" s)
end
| Some (Microsoft_FStar_Absyn_Syntax.Equality) -> begin
(Support.Microsoft.FStar.Util.format1 "=%s" s)
end
| _37_365 -> begin
s
end)))
and pat_to_string = (fun ( x ) -> (match (x.pat) with
| PatWild -> begin
"_"
end
| PatConst (c) -> begin
(Microsoft_FStar_Absyn_Print.const_to_string c)
end
| PatApp ((p, ps)) -> begin
(let _68_17927 = (Support.Prims.pipe_right p pat_to_string)
in (let _68_17926 = (to_string_l " " pat_to_string ps)
in (Support.Microsoft.FStar.Util.format2 "(%s %s)" _68_17927 _68_17926)))
end
| (PatTvar ((i, true))) | (PatVar ((i, true))) -> begin
(Support.Microsoft.FStar.Util.format1 "#%s" i.Microsoft_FStar_Absyn_Syntax.idText)
end
| (PatTvar ((i, false))) | (PatVar ((i, false))) -> begin
i.Microsoft_FStar_Absyn_Syntax.idText
end
| PatName (l) -> begin
(Microsoft_FStar_Absyn_Print.sli l)
end
| PatList (l) -> begin
(let _68_17928 = (to_string_l "; " pat_to_string l)
in (Support.Microsoft.FStar.Util.format1 "[%s]" _68_17928))
end
| PatTuple ((l, false)) -> begin
(let _68_17929 = (to_string_l ", " pat_to_string l)
in (Support.Microsoft.FStar.Util.format1 "(%s)" _68_17929))
end
| PatTuple ((l, true)) -> begin
(let _68_17930 = (to_string_l ", " pat_to_string l)
in (Support.Microsoft.FStar.Util.format1 "(|%s|)" _68_17930))
end
| PatRecord (l) -> begin
(let _68_17934 = (to_string_l "; " (fun ( _37_404 ) -> (match (_37_404) with
| (f, e) -> begin
(let _68_17933 = (Microsoft_FStar_Absyn_Print.sli f)
in (let _68_17932 = (Support.Prims.pipe_right e pat_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s=%s" _68_17933 _68_17932)))
end)) l)
in (Support.Microsoft.FStar.Util.format1 "{%s}" _68_17934))
end
| PatOr (l) -> begin
(to_string_l "|\n " pat_to_string l)
end
| PatAscribed ((p, t)) -> begin
(let _68_17936 = (Support.Prims.pipe_right p pat_to_string)
in (let _68_17935 = (Support.Prims.pipe_right t term_to_string)
in (Support.Microsoft.FStar.Util.format2 "(%s:%s)" _68_17936 _68_17935)))
end))

let error = (fun ( msg ) ( tm ) ( r ) -> (let tm = (Support.Prims.pipe_right tm term_to_string)
in (let tm = (match (((Support.String.length tm) >= 80)) with
| true -> begin
(let _68_17940 = (Support.Microsoft.FStar.Util.substring tm 0 77)
in (Support.String.strcat _68_17940 "..."))
end
| false -> begin
tm
end)
in (raise (Microsoft_FStar_Absyn_Syntax.Error (((Support.String.strcat (Support.String.strcat msg "\n") tm), r)))))))

let consPat = (fun ( r ) ( hd ) ( tl ) -> PatApp (((mk_pattern (PatName (Microsoft_FStar_Absyn_Const.cons_lid)) r), (hd)::(tl)::[])))

let consTerm = (fun ( r ) ( hd ) ( tl ) -> (mk_term (Construct ((Microsoft_FStar_Absyn_Const.cons_lid, ((hd, Nothing))::((tl, Nothing))::[]))) r Expr))

let lexConsTerm = (fun ( r ) ( hd ) ( tl ) -> (mk_term (Construct ((Microsoft_FStar_Absyn_Const.lexcons_lid, ((hd, Nothing))::((tl, Nothing))::[]))) r Expr))

let mkConsList = (fun ( r ) ( elts ) -> (let nil = (mk_term (Construct ((Microsoft_FStar_Absyn_Const.nil_lid, []))) r Expr)
in (Support.List.fold_right (fun ( e ) ( tl ) -> (consTerm r e tl)) elts nil)))

let mkLexList = (fun ( r ) ( elts ) -> (let nil = (mk_term (Construct ((Microsoft_FStar_Absyn_Const.lextop_lid, []))) r Expr)
in (Support.List.fold_right (fun ( e ) ( tl ) -> (lexConsTerm r e tl)) elts nil)))

let mkApp = (fun ( t ) ( args ) ( r ) -> (match (args) with
| [] -> begin
t
end
| _37_440 -> begin
(match (t.tm) with
| Name (s) -> begin
(mk_term (Construct ((s, args))) r Un)
end
| _37_444 -> begin
(Support.List.fold_left (fun ( t ) ( _37_448 ) -> (match (_37_448) with
| (a, imp) -> begin
(mk_term (App ((t, a, imp))) r Un)
end)) t args)
end)
end))

let mkRefSet = (fun ( r ) ( elts ) -> (let empty = (let _68_17984 = (let _68_17983 = (Microsoft_FStar_Absyn_Util.set_lid_range Microsoft_FStar_Absyn_Const.set_empty r)
in Var (_68_17983))
in (mk_term _68_17984 r Expr))
in (let ref_constr = (let _68_17986 = (let _68_17985 = (Microsoft_FStar_Absyn_Util.set_lid_range Microsoft_FStar_Absyn_Const.heap_ref r)
in Var (_68_17985))
in (mk_term _68_17986 r Expr))
in (let singleton = (let _68_17988 = (let _68_17987 = (Microsoft_FStar_Absyn_Util.set_lid_range Microsoft_FStar_Absyn_Const.set_singleton r)
in Var (_68_17987))
in (mk_term _68_17988 r Expr))
in (let union = (let _68_17990 = (let _68_17989 = (Microsoft_FStar_Absyn_Util.set_lid_range Microsoft_FStar_Absyn_Const.set_union r)
in Var (_68_17989))
in (mk_term _68_17990 r Expr))
in (Support.List.fold_right (fun ( e ) ( tl ) -> (let e = (mkApp ref_constr (((e, Nothing))::[]) r)
in (let single_e = (mkApp singleton (((e, Nothing))::[]) r)
in (mkApp union (((single_e, Nothing))::((tl, Nothing))::[]) r)))) elts empty))))))

let mkExplicitApp = (fun ( t ) ( args ) ( r ) -> (match (args) with
| [] -> begin
t
end
| _37_464 -> begin
(match (t.tm) with
| Name (s) -> begin
(let _68_18002 = (let _68_18001 = (let _68_18000 = (Support.List.map (fun ( a ) -> (a, Nothing)) args)
in (s, _68_18000))
in Construct (_68_18001))
in (mk_term _68_18002 r Un))
end
| _37_469 -> begin
(Support.List.fold_left (fun ( t ) ( a ) -> (mk_term (App ((t, a, Nothing))) r Un)) t args)
end)
end))

let mkAdmitMagic = (fun ( r ) -> (let unit_const = (mk_term (Const (Microsoft_FStar_Absyn_Syntax.Const_unit)) r Expr)
in (let admit = (let admit_name = (let _68_18008 = (let _68_18007 = (Microsoft_FStar_Absyn_Util.set_lid_range Microsoft_FStar_Absyn_Const.admit_lid r)
in Var (_68_18007))
in (mk_term _68_18008 r Expr))
in (mkExplicitApp admit_name ((unit_const)::[]) r))
in (let magic = (let magic_name = (let _68_18010 = (let _68_18009 = (Microsoft_FStar_Absyn_Util.set_lid_range Microsoft_FStar_Absyn_Const.magic_lid r)
in Var (_68_18009))
in (mk_term _68_18010 r Expr))
in (mkExplicitApp magic_name ((unit_const)::[]) r))
in (let admit_magic = (mk_term (Seq ((admit, magic))) r Expr)
in admit_magic)))))

let mkWildAdmitMagic = (fun ( r ) -> (let _68_18012 = (mkAdmitMagic r)
in ((mk_pattern PatWild r), None, _68_18012)))

let focusBranches = (fun ( branches ) ( r ) -> (let should_filter = (Support.Microsoft.FStar.Util.for_some Support.Prims.fst branches)
in (match (should_filter) with
| true -> begin
(let _37_483 = (Microsoft_FStar_Tc_Errors.warn r "Focusing on only some cases")
in (let focussed = (let _68_18015 = (Support.List.filter Support.Prims.fst branches)
in (Support.Prims.pipe_right _68_18015 (Support.List.map Support.Prims.snd)))
in (let _68_18017 = (let _68_18016 = (mkWildAdmitMagic r)
in (_68_18016)::[])
in (Support.List.append focussed _68_18017))))
end
| false -> begin
(Support.Prims.pipe_right branches (Support.List.map Support.Prims.snd))
end)))

let focusLetBindings = (fun ( lbs ) ( r ) -> (let should_filter = (Support.Microsoft.FStar.Util.for_some Support.Prims.fst lbs)
in (match (should_filter) with
| true -> begin
(let _37_489 = (Microsoft_FStar_Tc_Errors.warn r "Focusing on only some cases in this (mutually) recursive definition")
in (Support.List.map (fun ( _37_493 ) -> (match (_37_493) with
| (f, lb) -> begin
(match (f) with
| true -> begin
lb
end
| false -> begin
(let _68_18021 = (mkAdmitMagic r)
in ((Support.Prims.fst lb), _68_18021))
end)
end)) lbs))
end
| false -> begin
(Support.Prims.pipe_right lbs (Support.List.map Support.Prims.snd))
end)))

let mkFsTypApp = (fun ( t ) ( args ) ( r ) -> (let _68_18029 = (Support.List.map (fun ( a ) -> (a, FsTypApp)) args)
in (mkApp t _68_18029 r)))

let mkTuple = (fun ( args ) ( r ) -> (let cons = (Microsoft_FStar_Absyn_Util.mk_tuple_data_lid (Support.List.length args) r)
in (let _68_18035 = (Support.List.map (fun ( x ) -> (x, Nothing)) args)
in (mkApp (mk_term (Name (cons)) r Expr) _68_18035 r))))

let mkDTuple = (fun ( args ) ( r ) -> (let cons = (Microsoft_FStar_Absyn_Util.mk_dtuple_data_lid (Support.List.length args) r)
in (let _68_18041 = (Support.List.map (fun ( x ) -> (x, Nothing)) args)
in (mkApp (mk_term (Name (cons)) r Expr) _68_18041 r))))

let mkRefinedBinder = (fun ( id ) ( t ) ( refopt ) ( m ) ( implicit ) -> (let b = (mk_binder (Annotated ((id, t))) m Type implicit)
in (match (refopt) with
| None -> begin
b
end
| Some (t) -> begin
(mk_binder (Annotated ((id, (mk_term (Refine ((b, t))) m Type)))) m Type implicit)
end)))

let rec extract_named_refinement = (fun ( t1 ) -> (match (t1.tm) with
| NamedTyp ((x, t)) -> begin
Some ((x, t, None))
end
| Refine (({b = Annotated ((x, t)); brange = _37_525; blevel = _37_523; aqual = _37_521}, t')) -> begin
Some ((x, t, Some (t')))
end
| Paren (t) -> begin
(extract_named_refinement t)
end
| _37_537 -> begin
None
end))




