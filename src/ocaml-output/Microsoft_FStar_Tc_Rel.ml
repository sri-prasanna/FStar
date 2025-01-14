
let new_kvar = (fun ( r ) ( binders ) -> (let wf = (fun ( k ) ( _33_39 ) -> (match (()) with
| () -> begin
true
end))
in (let u = (Support.Microsoft.FStar.Unionfind.fresh Microsoft_FStar_Absyn_Syntax.Uvar)
in (let _68_12910 = (let _68_12909 = (let _68_12908 = (Microsoft_FStar_Absyn_Util.args_of_non_null_binders binders)
in (u, _68_12908))
in (Microsoft_FStar_Absyn_Syntax.mk_Kind_uvar _68_12909 r))
in (_68_12910, u)))))

let new_tvar = (fun ( r ) ( binders ) ( k ) -> (let wf = (fun ( t ) ( tk ) -> true)
in (let binders = (Support.Prims.pipe_right binders (Support.List.filter (fun ( x ) -> (let _68_12922 = (Microsoft_FStar_Absyn_Syntax.is_null_binder x)
in (Support.Prims.pipe_right _68_12922 Support.Prims.op_Negation)))))
in (let uv = (Support.Microsoft.FStar.Unionfind.fresh Microsoft_FStar_Absyn_Syntax.Uvar)
in (match (binders) with
| [] -> begin
(let uv = (Microsoft_FStar_Absyn_Syntax.mk_Typ_uvar' (uv, k) None r)
in (uv, uv))
end
| _33_53 -> begin
(let args = (Microsoft_FStar_Absyn_Util.args_of_non_null_binders binders)
in (let k' = (Microsoft_FStar_Absyn_Syntax.mk_Kind_arrow (binders, k) r)
in (let uv = (Microsoft_FStar_Absyn_Syntax.mk_Typ_uvar' (uv, k') None r)
in (let _68_12923 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app (uv, args) None r)
in (_68_12923, uv)))))
end)))))

let new_evar = (fun ( r ) ( binders ) ( t ) -> (let wf = (fun ( e ) ( t ) -> true)
in (let binders = (Support.Prims.pipe_right binders (Support.List.filter (fun ( x ) -> (let _68_12935 = (Microsoft_FStar_Absyn_Syntax.is_null_binder x)
in (Support.Prims.pipe_right _68_12935 Support.Prims.op_Negation)))))
in (let uv = (Support.Microsoft.FStar.Unionfind.fresh Microsoft_FStar_Absyn_Syntax.Uvar)
in (match (binders) with
| [] -> begin
(let uv = (Microsoft_FStar_Absyn_Syntax.mk_Exp_uvar' (uv, t) None r)
in (uv, uv))
end
| _33_69 -> begin
(let args = (Microsoft_FStar_Absyn_Util.args_of_non_null_binders binders)
in (let t' = (let _68_12937 = (let _68_12936 = (Microsoft_FStar_Absyn_Syntax.mk_Total t)
in (binders, _68_12936))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_fun _68_12937 None r))
in (let uv = (Microsoft_FStar_Absyn_Syntax.mk_Exp_uvar' (uv, t') None r)
in (match (args) with
| [] -> begin
(uv, uv)
end
| _33_75 -> begin
(let _68_12938 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app (uv, args) None r)
in (_68_12938, uv))
end))))
end)))))

type rel =
| EQ
| SUB
| SUBINV

let is_EQ = (fun ( _discr_ ) -> (match (_discr_) with
| EQ -> begin
true
end
| _ -> begin
false
end))

let is_SUB = (fun ( _discr_ ) -> (match (_discr_) with
| SUB -> begin
true
end
| _ -> begin
false
end))

let is_SUBINV = (fun ( _discr_ ) -> (match (_discr_) with
| SUBINV -> begin
true
end
| _ -> begin
false
end))

type variance =
| COVARIANT
| CONTRAVARIANT
| INVARIANT

let is_COVARIANT = (fun ( _discr_ ) -> (match (_discr_) with
| COVARIANT -> begin
true
end
| _ -> begin
false
end))

let is_CONTRAVARIANT = (fun ( _discr_ ) -> (match (_discr_) with
| CONTRAVARIANT -> begin
true
end
| _ -> begin
false
end))

let is_INVARIANT = (fun ( _discr_ ) -> (match (_discr_) with
| INVARIANT -> begin
true
end
| _ -> begin
false
end))

type ('a, 'b) problem =
{lhs : 'a; relation : rel; rhs : 'a; element : 'b option; logical_guard : (Microsoft_FStar_Absyn_Syntax.typ * Microsoft_FStar_Absyn_Syntax.typ); scope : Microsoft_FStar_Absyn_Syntax.binders; reason : string list; loc : Support.Microsoft.FStar.Range.range; rank : int option}

let is_Mkproblem = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkproblem")))

type ('a, 'b) problem_t =
('a, 'b) problem

type prob =
| KProb of (Microsoft_FStar_Absyn_Syntax.knd, unit) problem
| TProb of (Microsoft_FStar_Absyn_Syntax.typ, Microsoft_FStar_Absyn_Syntax.exp) problem
| EProb of (Microsoft_FStar_Absyn_Syntax.exp, unit) problem
| CProb of (Microsoft_FStar_Absyn_Syntax.comp, unit) problem

let is_KProb = (fun ( _discr_ ) -> (match (_discr_) with
| KProb (_) -> begin
true
end
| _ -> begin
false
end))

let is_TProb = (fun ( _discr_ ) -> (match (_discr_) with
| TProb (_) -> begin
true
end
| _ -> begin
false
end))

let is_EProb = (fun ( _discr_ ) -> (match (_discr_) with
| EProb (_) -> begin
true
end
| _ -> begin
false
end))

let is_CProb = (fun ( _discr_ ) -> (match (_discr_) with
| CProb (_) -> begin
true
end
| _ -> begin
false
end))

type probs =
prob list

type uvi =
| UK of (Microsoft_FStar_Absyn_Syntax.uvar_k * Microsoft_FStar_Absyn_Syntax.knd)
| UT of ((Microsoft_FStar_Absyn_Syntax.uvar_t * Microsoft_FStar_Absyn_Syntax.knd) * Microsoft_FStar_Absyn_Syntax.typ)
| UE of ((Microsoft_FStar_Absyn_Syntax.uvar_e * Microsoft_FStar_Absyn_Syntax.typ) * Microsoft_FStar_Absyn_Syntax.exp)

let is_UK = (fun ( _discr_ ) -> (match (_discr_) with
| UK (_) -> begin
true
end
| _ -> begin
false
end))

let is_UT = (fun ( _discr_ ) -> (match (_discr_) with
| UT (_) -> begin
true
end
| _ -> begin
false
end))

let is_UE = (fun ( _discr_ ) -> (match (_discr_) with
| UE (_) -> begin
true
end
| _ -> begin
false
end))

type worklist =
{attempting : probs; deferred : (int * string * prob) list; subst : uvi list; ctr : int; slack_vars : (bool * Microsoft_FStar_Absyn_Syntax.typ) list; defer_ok : bool; smt_ok : bool; tcenv : Microsoft_FStar_Tc_Env.env}

let is_Mkworklist = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkworklist")))

type deferred =
{carry : (string * prob) list; slack : (bool * Microsoft_FStar_Absyn_Syntax.typ) list}

let is_Mkdeferred = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkdeferred")))

let no_deferred = {carry = []; slack = []}

type solution =
| Success of (uvi list * deferred)
| Failed of (prob * string)

let is_Success = (fun ( _discr_ ) -> (match (_discr_) with
| Success (_) -> begin
true
end
| _ -> begin
false
end))

let is_Failed = (fun ( _discr_ ) -> (match (_discr_) with
| Failed (_) -> begin
true
end
| _ -> begin
false
end))

let rel_to_string = (fun ( _33_1 ) -> (match (_33_1) with
| EQ -> begin
"="
end
| SUB -> begin
"<:"
end
| SUBINV -> begin
":>"
end))

let prob_to_string = (fun ( env ) ( _33_2 ) -> (match (_33_2) with
| KProb (p) -> begin
(let _68_13077 = (Microsoft_FStar_Absyn_Print.kind_to_string p.lhs)
in (let _68_13076 = (Microsoft_FStar_Absyn_Print.kind_to_string p.rhs)
in (Support.Microsoft.FStar.Util.format3 "\t%s\n\t\t%s\n\t%s" _68_13077 (rel_to_string p.relation) _68_13076)))
end
| TProb (p) -> begin
(let _68_13090 = (let _68_13089 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env p.lhs)
in (let _68_13088 = (let _68_13087 = (Microsoft_FStar_Absyn_Print.tag_of_typ p.lhs)
in (let _68_13086 = (let _68_13085 = (let _68_13084 = (Support.Prims.pipe_right p.reason Support.List.hd)
in (let _68_13083 = (let _68_13082 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env p.rhs)
in (let _68_13081 = (let _68_13080 = (Microsoft_FStar_Absyn_Print.tag_of_typ p.rhs)
in (let _68_13079 = (let _68_13078 = (Microsoft_FStar_Tc_Normalize.formula_norm_to_string env (Support.Prims.fst p.logical_guard))
in (_68_13078)::[])
in (_68_13080)::_68_13079))
in (_68_13082)::_68_13081))
in (_68_13084)::_68_13083))
in ((rel_to_string p.relation))::_68_13085)
in (_68_13087)::_68_13086))
in (_68_13089)::_68_13088))
in (Support.Microsoft.FStar.Util.format "\t%s (%s) \n\t\t%s(%s)\n\t%s (%s) (guard %s)" _68_13090))
end
| EProb (p) -> begin
(let _68_13092 = (Microsoft_FStar_Tc_Normalize.exp_norm_to_string env p.lhs)
in (let _68_13091 = (Microsoft_FStar_Tc_Normalize.exp_norm_to_string env p.rhs)
in (Support.Microsoft.FStar.Util.format3 "\t%s \n\t\t%s\n\t%s" _68_13092 (rel_to_string p.relation) _68_13091)))
end
| CProb (p) -> begin
(let _68_13094 = (Microsoft_FStar_Tc_Normalize.comp_typ_norm_to_string env p.lhs)
in (let _68_13093 = (Microsoft_FStar_Tc_Normalize.comp_typ_norm_to_string env p.rhs)
in (Support.Microsoft.FStar.Util.format3 "\t%s \n\t\t%s\n\t%s" _68_13094 (rel_to_string p.relation) _68_13093)))
end))

let uvi_to_string = (fun ( env ) ( uvi ) -> (let str = (fun ( u ) -> (match ((Support.ST.read Microsoft_FStar_Options.hide_uvar_nums)) with
| true -> begin
"?"
end
| false -> begin
(let _68_13100 = (Support.Microsoft.FStar.Unionfind.uvar_id u)
in (Support.Prims.pipe_right _68_13100 Support.Microsoft.FStar.Util.string_of_int))
end))
in (match (uvi) with
| UK ((u, _33_141)) -> begin
(let _68_13101 = (str u)
in (Support.Prims.pipe_right _68_13101 (Support.Microsoft.FStar.Util.format1 "UK %s")))
end
| UT (((u, _33_146), t)) -> begin
(let _68_13104 = (str u)
in (Support.Prims.pipe_right _68_13104 (fun ( x ) -> (let _68_13103 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env t)
in (Support.Microsoft.FStar.Util.format2 "UT %s %s" x _68_13103)))))
end
| UE (((u, _33_154), _33_157)) -> begin
(let _68_13105 = (str u)
in (Support.Prims.pipe_right _68_13105 (Support.Microsoft.FStar.Util.format1 "UE %s")))
end)))

let invert_rel = (fun ( _33_3 ) -> (match (_33_3) with
| EQ -> begin
EQ
end
| SUB -> begin
SUBINV
end
| SUBINV -> begin
SUB
end))

let invert = (fun ( p ) -> (let _33_165 = p
in {lhs = p.rhs; relation = (invert_rel p.relation); rhs = p.lhs; element = _33_165.element; logical_guard = _33_165.logical_guard; scope = _33_165.scope; reason = _33_165.reason; loc = _33_165.loc; rank = _33_165.rank}))

let maybe_invert = (fun ( p ) -> (match ((p.relation = SUBINV)) with
| true -> begin
(invert p)
end
| false -> begin
p
end))

let maybe_invert_p = (fun ( _33_4 ) -> (match (_33_4) with
| KProb (p) -> begin
(Support.Prims.pipe_right (maybe_invert p) (fun ( _68_13112 ) -> KProb (_68_13112)))
end
| TProb (p) -> begin
(Support.Prims.pipe_right (maybe_invert p) (fun ( _68_13113 ) -> TProb (_68_13113)))
end
| EProb (p) -> begin
(Support.Prims.pipe_right (maybe_invert p) (fun ( _68_13114 ) -> EProb (_68_13114)))
end
| CProb (p) -> begin
(Support.Prims.pipe_right (maybe_invert p) (fun ( _68_13115 ) -> CProb (_68_13115)))
end))

let vary_rel = (fun ( rel ) ( _33_5 ) -> (match (_33_5) with
| INVARIANT -> begin
EQ
end
| CONTRAVARIANT -> begin
(invert_rel rel)
end
| COVARIANT -> begin
rel
end))

let p_rel = (fun ( _33_6 ) -> (match (_33_6) with
| KProb (p) -> begin
p.relation
end
| TProb (p) -> begin
p.relation
end
| EProb (p) -> begin
p.relation
end
| CProb (p) -> begin
p.relation
end))

let p_reason = (fun ( _33_7 ) -> (match (_33_7) with
| KProb (p) -> begin
p.reason
end
| TProb (p) -> begin
p.reason
end
| EProb (p) -> begin
p.reason
end
| CProb (p) -> begin
p.reason
end))

let p_loc = (fun ( _33_8 ) -> (match (_33_8) with
| KProb (p) -> begin
p.loc
end
| TProb (p) -> begin
p.loc
end
| EProb (p) -> begin
p.loc
end
| CProb (p) -> begin
p.loc
end))

let p_context = (fun ( _33_9 ) -> (match (_33_9) with
| KProb (p) -> begin
p.scope
end
| TProb (p) -> begin
p.scope
end
| EProb (p) -> begin
p.scope
end
| CProb (p) -> begin
p.scope
end))

let p_guard = (fun ( _33_10 ) -> (match (_33_10) with
| KProb (p) -> begin
p.logical_guard
end
| TProb (p) -> begin
p.logical_guard
end
| EProb (p) -> begin
p.logical_guard
end
| CProb (p) -> begin
p.logical_guard
end))

let p_scope = (fun ( _33_11 ) -> (match (_33_11) with
| KProb (p) -> begin
p.scope
end
| TProb (p) -> begin
p.scope
end
| EProb (p) -> begin
p.scope
end
| CProb (p) -> begin
p.scope
end))

let p_invert = (fun ( _33_12 ) -> (match (_33_12) with
| KProb (p) -> begin
(Support.Prims.pipe_left (fun ( _68_13134 ) -> KProb (_68_13134)) (invert p))
end
| TProb (p) -> begin
(Support.Prims.pipe_left (fun ( _68_13135 ) -> TProb (_68_13135)) (invert p))
end
| EProb (p) -> begin
(Support.Prims.pipe_left (fun ( _68_13136 ) -> EProb (_68_13136)) (invert p))
end
| CProb (p) -> begin
(Support.Prims.pipe_left (fun ( _68_13137 ) -> CProb (_68_13137)) (invert p))
end))

let is_top_level_prob = (fun ( p ) -> ((Support.Prims.pipe_right (p_reason p) Support.List.length) = 1))

let mk_problem = (fun ( scope ) ( orig ) ( lhs ) ( rel ) ( rhs ) ( elt ) ( reason ) -> (let _68_13147 = (new_tvar (p_loc orig) scope Microsoft_FStar_Absyn_Syntax.ktype)
in {lhs = lhs; relation = rel; rhs = rhs; element = elt; logical_guard = _68_13147; scope = []; reason = (reason)::(p_reason orig); loc = (p_loc orig); rank = None}))

let new_problem = (fun ( env ) ( lhs ) ( rel ) ( rhs ) ( elt ) ( loc ) ( reason ) -> (let _68_13157 = (let _68_13156 = (Microsoft_FStar_Tc_Env.get_range env)
in (let _68_13155 = (Microsoft_FStar_Tc_Env.binders env)
in (new_tvar _68_13156 _68_13155 Microsoft_FStar_Absyn_Syntax.ktype)))
in {lhs = lhs; relation = rel; rhs = rhs; element = elt; logical_guard = _68_13157; scope = []; reason = (reason)::[]; loc = loc; rank = None}))

let problem_using_guard = (fun ( orig ) ( lhs ) ( rel ) ( rhs ) ( elt ) ( reason ) -> {lhs = lhs; relation = rel; rhs = rhs; element = elt; logical_guard = (p_guard orig); scope = []; reason = (reason)::(p_reason orig); loc = (p_loc orig); rank = None})

let guard_on_element = (fun ( problem ) ( x ) ( phi ) -> (match (problem.element) with
| None -> begin
(let _68_13168 = (let _68_13167 = (Microsoft_FStar_Absyn_Syntax.v_binder x)
in (_68_13167)::[])
in (Microsoft_FStar_Absyn_Util.close_forall _68_13168 phi))
end
| Some (e) -> begin
(Microsoft_FStar_Absyn_Util.subst_typ ((Support.Microsoft.FStar.Util.Inr ((x.Microsoft_FStar_Absyn_Syntax.v, e)))::[]) phi)
end))

let solve_prob' = (fun ( resolve_ok ) ( prob ) ( logical_guard ) ( uvis ) ( wl ) -> (let phi = (match (logical_guard) with
| None -> begin
Microsoft_FStar_Absyn_Util.t_true
end
| Some (phi) -> begin
phi
end)
in (let _33_284 = (p_guard prob)
in (match (_33_284) with
| (_33_282, uv) -> begin
(let _33_292 = (match ((let _68_13179 = (Microsoft_FStar_Absyn_Util.compress_typ uv)
in _68_13179.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uvar, k)) -> begin
(let phi = (Microsoft_FStar_Absyn_Util.close_for_kind phi k)
in (Microsoft_FStar_Absyn_Util.unchecked_unify uvar phi))
end
| _33_291 -> begin
(match ((not (resolve_ok))) with
| true -> begin
(failwith ("Impossible: this instance has already been assigned a solution"))
end
| false -> begin
()
end)
end)
in (match (uvis) with
| [] -> begin
wl
end
| _33_296 -> begin
(let _33_297 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug wl.tcenv) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_13181 = (let _68_13180 = (Support.List.map (uvi_to_string wl.tcenv) uvis)
in (Support.Prims.pipe_right _68_13180 (Support.String.concat ", ")))
in (Support.Microsoft.FStar.Util.fprint1 "Extending solution: %s\n" _68_13181))
end
| false -> begin
()
end)
in (let _33_299 = wl
in {attempting = _33_299.attempting; deferred = _33_299.deferred; subst = (Support.List.append uvis wl.subst); ctr = (wl.ctr + 1); slack_vars = _33_299.slack_vars; defer_ok = _33_299.defer_ok; smt_ok = _33_299.smt_ok; tcenv = _33_299.tcenv}))
end))
end))))

let extend_solution = (fun ( sol ) ( wl ) -> (let _33_303 = wl
in {attempting = _33_303.attempting; deferred = _33_303.deferred; subst = (sol)::wl.subst; ctr = (wl.ctr + 1); slack_vars = _33_303.slack_vars; defer_ok = _33_303.defer_ok; smt_ok = _33_303.smt_ok; tcenv = _33_303.tcenv}))

let solve_prob = (fun ( prob ) ( logical_guard ) ( uvis ) ( wl ) -> (solve_prob' false prob logical_guard uvis wl))

let explain = (fun ( env ) ( d ) ( s ) -> (let _68_13202 = (Support.Prims.pipe_left Support.Microsoft.FStar.Range.string_of_range (p_loc d))
in (let _68_13201 = (prob_to_string env d)
in (let _68_13200 = (Support.Prims.pipe_right (p_reason d) (Support.String.concat "\n\t>"))
in (Support.Microsoft.FStar.Util.format4 "(%s) Failed to solve the sub-problem\n%s\nWhich arose because:\n\t%s\nFailed because:%s\n" _68_13202 _68_13201 _68_13200 s)))))

let empty_worklist = (fun ( env ) -> {attempting = []; deferred = []; subst = []; ctr = 0; slack_vars = []; defer_ok = true; smt_ok = true; tcenv = env})

let singleton = (fun ( env ) ( prob ) -> (let _33_315 = (empty_worklist env)
in {attempting = (prob)::[]; deferred = _33_315.deferred; subst = _33_315.subst; ctr = _33_315.ctr; slack_vars = _33_315.slack_vars; defer_ok = _33_315.defer_ok; smt_ok = _33_315.smt_ok; tcenv = _33_315.tcenv}))

let wl_of_guard = (fun ( env ) ( g ) -> (let _33_319 = (empty_worklist env)
in (let _68_13213 = (Support.List.map Support.Prims.snd g.carry)
in {attempting = _68_13213; deferred = _33_319.deferred; subst = _33_319.subst; ctr = _33_319.ctr; slack_vars = g.slack; defer_ok = false; smt_ok = _33_319.smt_ok; tcenv = _33_319.tcenv})))

let defer = (fun ( reason ) ( prob ) ( wl ) -> (let _33_324 = wl
in {attempting = _33_324.attempting; deferred = ((wl.ctr, reason, prob))::wl.deferred; subst = _33_324.subst; ctr = _33_324.ctr; slack_vars = _33_324.slack_vars; defer_ok = _33_324.defer_ok; smt_ok = _33_324.smt_ok; tcenv = _33_324.tcenv}))

let attempt = (fun ( probs ) ( wl ) -> (let _33_328 = wl
in {attempting = (Support.List.append probs wl.attempting); deferred = _33_328.deferred; subst = _33_328.subst; ctr = _33_328.ctr; slack_vars = _33_328.slack_vars; defer_ok = _33_328.defer_ok; smt_ok = _33_328.smt_ok; tcenv = _33_328.tcenv}))

let add_slack_mul = (fun ( slack ) ( wl ) -> (let _33_332 = wl
in {attempting = _33_332.attempting; deferred = _33_332.deferred; subst = _33_332.subst; ctr = _33_332.ctr; slack_vars = ((true, slack))::wl.slack_vars; defer_ok = _33_332.defer_ok; smt_ok = _33_332.smt_ok; tcenv = _33_332.tcenv}))

let add_slack_add = (fun ( slack ) ( wl ) -> (let _33_336 = wl
in {attempting = _33_336.attempting; deferred = _33_336.deferred; subst = _33_336.subst; ctr = _33_336.ctr; slack_vars = ((false, slack))::wl.slack_vars; defer_ok = _33_336.defer_ok; smt_ok = _33_336.smt_ok; tcenv = _33_336.tcenv}))

let giveup = (fun ( env ) ( reason ) ( prob ) -> (let _33_341 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_13238 = (prob_to_string env prob)
in (Support.Microsoft.FStar.Util.fprint2 "Failed %s:\n%s\n" reason _68_13238))
end
| false -> begin
()
end)
in Failed ((prob, reason))))

let commit = (fun ( env ) ( uvis ) -> (Support.Prims.pipe_right uvis (Support.List.iter (fun ( _33_13 ) -> (match (_33_13) with
| UK ((u, k)) -> begin
(Microsoft_FStar_Absyn_Util.unchecked_unify u k)
end
| UT (((u, k), t)) -> begin
(Microsoft_FStar_Absyn_Util.unchecked_unify u t)
end
| UE (((u, _33_358), e)) -> begin
(Microsoft_FStar_Absyn_Util.unchecked_unify u e)
end)))))

let find_uvar_k = (fun ( uv ) ( s ) -> (Support.Microsoft.FStar.Util.find_map s (fun ( _33_14 ) -> (match (_33_14) with
| UK ((u, t)) -> begin
(match ((Support.Microsoft.FStar.Unionfind.equivalent uv u)) with
| true -> begin
Some (t)
end
| false -> begin
None
end)
end
| _33_371 -> begin
None
end))))

let find_uvar_t = (fun ( uv ) ( s ) -> (Support.Microsoft.FStar.Util.find_map s (fun ( _33_15 ) -> (match (_33_15) with
| UT (((u, _33_377), t)) -> begin
(match ((Support.Microsoft.FStar.Unionfind.equivalent uv u)) with
| true -> begin
Some (t)
end
| false -> begin
None
end)
end
| _33_383 -> begin
None
end))))

let find_uvar_e = (fun ( uv ) ( s ) -> (Support.Microsoft.FStar.Util.find_map s (fun ( _33_16 ) -> (match (_33_16) with
| UE (((u, _33_389), t)) -> begin
(match ((Support.Microsoft.FStar.Unionfind.equivalent uv u)) with
| true -> begin
Some (t)
end
| false -> begin
None
end)
end
| _33_395 -> begin
None
end))))

let simplify_formula = (fun ( env ) ( f ) -> (Microsoft_FStar_Tc_Normalize.norm_typ ((Microsoft_FStar_Tc_Normalize.Beta)::(Microsoft_FStar_Tc_Normalize.Simplify)::[]) env f))

let norm_targ = (fun ( env ) ( t ) -> (Microsoft_FStar_Tc_Normalize.norm_typ ((Microsoft_FStar_Tc_Normalize.Beta)::[]) env t))

let norm_arg = (fun ( env ) ( a ) -> (match ((Support.Prims.fst a)) with
| Support.Microsoft.FStar.Util.Inl (t) -> begin
(let _68_13269 = (let _68_13268 = (norm_targ env t)
in (Support.Prims.pipe_left (fun ( _68_13267 ) -> Support.Microsoft.FStar.Util.Inl (_68_13267)) _68_13268))
in (_68_13269, (Support.Prims.snd a)))
end
| Support.Microsoft.FStar.Util.Inr (v) -> begin
(let _68_13272 = (let _68_13271 = (Microsoft_FStar_Tc_Normalize.norm_exp ((Microsoft_FStar_Tc_Normalize.Beta)::[]) env v)
in (Support.Prims.pipe_left (fun ( _68_13270 ) -> Support.Microsoft.FStar.Util.Inr (_68_13270)) _68_13271))
in (_68_13272, (Support.Prims.snd a)))
end))

let whnf = (fun ( env ) ( t ) -> (let _68_13277 = (Microsoft_FStar_Tc_Normalize.whnf env t)
in (Support.Prims.pipe_right _68_13277 Microsoft_FStar_Absyn_Util.compress_typ)))

let sn = (fun ( env ) ( t ) -> (let _68_13282 = (Microsoft_FStar_Tc_Normalize.norm_typ ((Microsoft_FStar_Tc_Normalize.Beta)::(Microsoft_FStar_Tc_Normalize.Eta)::[]) env t)
in (Support.Prims.pipe_right _68_13282 Microsoft_FStar_Absyn_Util.compress_typ)))

let sn_binders = (fun ( env ) ( binders ) -> (Support.Prims.pipe_right binders (Support.List.map (fun ( _33_17 ) -> (match (_33_17) with
| (Support.Microsoft.FStar.Util.Inl (a), imp) -> begin
(let _68_13288 = (let _68_13287 = (let _33_417 = a
in (let _68_13286 = (Microsoft_FStar_Tc_Normalize.norm_kind ((Microsoft_FStar_Tc_Normalize.Beta)::[]) env a.Microsoft_FStar_Absyn_Syntax.sort)
in {Microsoft_FStar_Absyn_Syntax.v = _33_417.Microsoft_FStar_Absyn_Syntax.v; Microsoft_FStar_Absyn_Syntax.sort = _68_13286; Microsoft_FStar_Absyn_Syntax.p = _33_417.Microsoft_FStar_Absyn_Syntax.p}))
in Support.Microsoft.FStar.Util.Inl (_68_13287))
in (_68_13288, imp))
end
| (Support.Microsoft.FStar.Util.Inr (x), imp) -> begin
(let _68_13291 = (let _68_13290 = (let _33_423 = x
in (let _68_13289 = (norm_targ env x.Microsoft_FStar_Absyn_Syntax.sort)
in {Microsoft_FStar_Absyn_Syntax.v = _33_423.Microsoft_FStar_Absyn_Syntax.v; Microsoft_FStar_Absyn_Syntax.sort = _68_13289; Microsoft_FStar_Absyn_Syntax.p = _33_423.Microsoft_FStar_Absyn_Syntax.p}))
in Support.Microsoft.FStar.Util.Inr (_68_13290))
in (_68_13291, imp))
end)))))

let whnf_k = (fun ( env ) ( k ) -> (let _68_13296 = (Microsoft_FStar_Tc_Normalize.norm_kind ((Microsoft_FStar_Tc_Normalize.Beta)::(Microsoft_FStar_Tc_Normalize.Eta)::(Microsoft_FStar_Tc_Normalize.WHNF)::[]) env k)
in (Support.Prims.pipe_right _68_13296 Microsoft_FStar_Absyn_Util.compress_kind)))

let whnf_e = (fun ( env ) ( e ) -> (let _68_13301 = (Microsoft_FStar_Tc_Normalize.norm_exp ((Microsoft_FStar_Tc_Normalize.Beta)::(Microsoft_FStar_Tc_Normalize.Eta)::(Microsoft_FStar_Tc_Normalize.WHNF)::[]) env e)
in (Support.Prims.pipe_right _68_13301 Microsoft_FStar_Absyn_Util.compress_exp)))

let rec compress_k = (fun ( env ) ( wl ) ( k ) -> (let k = (Microsoft_FStar_Absyn_Util.compress_kind k)
in (match (k.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Kind_uvar ((uv, actuals)) -> begin
(match ((find_uvar_k uv wl.subst)) with
| None -> begin
k
end
| Some (k') -> begin
(match (k'.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Kind_lam ((formals, body)) -> begin
(let k = (let _68_13308 = (Microsoft_FStar_Absyn_Util.subst_of_list formals actuals)
in (Microsoft_FStar_Absyn_Util.subst_kind _68_13308 body))
in (compress_k env wl k))
end
| _33_446 -> begin
(match (((Support.List.length actuals) = 0)) with
| true -> begin
(compress_k env wl k')
end
| false -> begin
(failwith ("Wrong arity for kind unifier"))
end)
end)
end)
end
| _33_448 -> begin
k
end)))

let rec compress = (fun ( env ) ( wl ) ( t ) -> (let t = (let _68_13315 = (Microsoft_FStar_Absyn_Util.unmeta_typ t)
in (whnf env _68_13315))
in (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, _33_455)) -> begin
(match ((find_uvar_t uv wl.subst)) with
| None -> begin
t
end
| Some (t) -> begin
(compress env wl t)
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, _33_471)); Microsoft_FStar_Absyn_Syntax.tk = _33_468; Microsoft_FStar_Absyn_Syntax.pos = _33_466; Microsoft_FStar_Absyn_Syntax.fvs = _33_464; Microsoft_FStar_Absyn_Syntax.uvs = _33_462}, args)) -> begin
(match ((find_uvar_t uv wl.subst)) with
| Some (t') -> begin
(let t = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app (t', args) None t.Microsoft_FStar_Absyn_Syntax.pos)
in (compress env wl t))
end
| _33_482 -> begin
t
end)
end
| _33_484 -> begin
t
end)))

let rec compress_e = (fun ( env ) ( wl ) ( e ) -> (let e = (Microsoft_FStar_Absyn_Util.unmeta_exp e)
in (match (e.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Exp_uvar ((uv, t)) -> begin
(match ((find_uvar_e uv wl.subst)) with
| None -> begin
e
end
| Some (e') -> begin
(compress_e env wl e')
end)
end
| Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar ((uv, _33_506)); Microsoft_FStar_Absyn_Syntax.tk = _33_503; Microsoft_FStar_Absyn_Syntax.pos = _33_501; Microsoft_FStar_Absyn_Syntax.fvs = _33_499; Microsoft_FStar_Absyn_Syntax.uvs = _33_497}, args)) -> begin
(match ((find_uvar_e uv wl.subst)) with
| None -> begin
e
end
| Some (e') -> begin
(let e' = (compress_e env wl e')
in (Microsoft_FStar_Absyn_Syntax.mk_Exp_app (e', args) None e.Microsoft_FStar_Absyn_Syntax.pos))
end)
end
| _33_518 -> begin
e
end)))

let normalize_refinement = (fun ( env ) ( wl ) ( t0 ) -> (let _68_13328 = (compress env wl t0)
in (Microsoft_FStar_Tc_Normalize.normalize_refinement env _68_13328)))

let base_and_refinement = (fun ( env ) ( wl ) ( t1 ) -> (let rec aux = (fun ( norm ) ( t1 ) -> (match (t1.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, phi)) -> begin
(match (norm) with
| true -> begin
(x.Microsoft_FStar_Absyn_Syntax.sort, Some ((x, phi)))
end
| false -> begin
(match ((normalize_refinement env wl t1)) with
| {Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, phi)); Microsoft_FStar_Absyn_Syntax.tk = _33_539; Microsoft_FStar_Absyn_Syntax.pos = _33_537; Microsoft_FStar_Absyn_Syntax.fvs = _33_535; Microsoft_FStar_Absyn_Syntax.uvs = _33_533} -> begin
(x.Microsoft_FStar_Absyn_Syntax.sort, Some ((x, phi)))
end
| tt -> begin
(let _68_13341 = (let _68_13340 = (Microsoft_FStar_Absyn_Print.typ_to_string tt)
in (let _68_13339 = (Microsoft_FStar_Absyn_Print.tag_of_typ tt)
in (Support.Microsoft.FStar.Util.format2 "impossible: Got %s ... %s\n" _68_13340 _68_13339)))
in (failwith (_68_13341)))
end)
end)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_const (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_app (_)) -> begin
(match (norm) with
| true -> begin
(t1, None)
end
| false -> begin
(let _33_554 = (let _68_13342 = (normalize_refinement env wl t1)
in (aux true _68_13342))
in (match (_33_554) with
| (t2', refinement) -> begin
(match (refinement) with
| None -> begin
(t1, None)
end
| _33_557 -> begin
(t2', refinement)
end)
end))
end)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_btvar (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_fun (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_lam (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_uvar (_)) -> begin
(t1, None)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_ascribed (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_delayed (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_meta (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_unknown) -> begin
(let _68_13345 = (let _68_13344 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (let _68_13343 = (Microsoft_FStar_Absyn_Print.tag_of_typ t1)
in (Support.Microsoft.FStar.Util.format2 "impossible (outer): Got %s ... %s\n" _68_13344 _68_13343)))
in (failwith (_68_13345)))
end))
in (let _68_13346 = (compress env wl t1)
in (aux false _68_13346))))

let unrefine = (fun ( env ) ( t ) -> (let _68_13351 = (base_and_refinement env (empty_worklist env) t)
in (Support.Prims.pipe_right _68_13351 Support.Prims.fst)))

let trivial_refinement = (fun ( t ) -> (let _68_13353 = (Microsoft_FStar_Absyn_Util.gen_bvar_p t.Microsoft_FStar_Absyn_Syntax.pos t)
in (_68_13353, Microsoft_FStar_Absyn_Util.t_true)))

let as_refinement = (fun ( env ) ( wl ) ( t ) -> (let _33_588 = (base_and_refinement env wl t)
in (match (_33_588) with
| (t_base, refinement) -> begin
(match (refinement) with
| None -> begin
(trivial_refinement t_base)
end
| Some ((x, phi)) -> begin
(x, phi)
end)
end)))

let force_refinement = (fun ( _33_596 ) -> (match (_33_596) with
| (t_base, refopt) -> begin
(let _33_604 = (match (refopt) with
| Some ((y, phi)) -> begin
(y, phi)
end
| None -> begin
(trivial_refinement t_base)
end)
in (match (_33_604) with
| (y, phi) -> begin
(Microsoft_FStar_Absyn_Syntax.mk_Typ_refine (y, phi) None t_base.Microsoft_FStar_Absyn_Syntax.pos)
end))
end))

let rec occurs = (fun ( env ) ( wl ) ( uk ) ( t ) -> (let uvs = (Microsoft_FStar_Absyn_Util.uvars_in_typ t)
in (let _68_13373 = (Support.Prims.pipe_right uvs.Microsoft_FStar_Absyn_Syntax.uvars_t Support.Microsoft.FStar.Util.set_elements)
in (Support.Prims.pipe_right _68_13373 (Support.Microsoft.FStar.Util.for_some (fun ( _33_615 ) -> (match (_33_615) with
| (uvt, _33_614) -> begin
(match ((find_uvar_t uvt wl.subst)) with
| None -> begin
(Support.Microsoft.FStar.Unionfind.equivalent uvt (Support.Prims.fst uk))
end
| Some (t) -> begin
(let t = (match ((Microsoft_FStar_Absyn_Util.compress_typ t)) with
| {Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_lam ((_33_628, t)); Microsoft_FStar_Absyn_Syntax.tk = _33_626; Microsoft_FStar_Absyn_Syntax.pos = _33_624; Microsoft_FStar_Absyn_Syntax.fvs = _33_622; Microsoft_FStar_Absyn_Syntax.uvs = _33_620} -> begin
t
end
| t -> begin
t
end)
in (occurs env wl uk t))
end)
end)))))))

let occurs_check = (fun ( env ) ( wl ) ( uk ) ( t ) -> (let occurs_ok = (not ((occurs env wl uk t)))
in (let msg = (match (occurs_ok) with
| true -> begin
None
end
| false -> begin
(let _68_13386 = (let _68_13385 = (Microsoft_FStar_Absyn_Print.uvar_t_to_string uk)
in (let _68_13384 = (Microsoft_FStar_Absyn_Print.typ_to_string t)
in (let _68_13383 = (let _68_13382 = (Support.Prims.pipe_right wl.subst (Support.List.map (uvi_to_string env)))
in (Support.Prims.pipe_right _68_13382 (Support.String.concat ", ")))
in (Support.Microsoft.FStar.Util.format3 "occurs-check failed (%s occurs in %s) (with substitution %s)" _68_13385 _68_13384 _68_13383))))
in Some (_68_13386))
end)
in (occurs_ok, msg))))

let occurs_and_freevars_check = (fun ( env ) ( wl ) ( uk ) ( fvs ) ( t ) -> (let fvs_t = (Microsoft_FStar_Absyn_Util.freevars_typ t)
in (let _33_649 = (occurs_check env wl uk t)
in (match (_33_649) with
| (occurs_ok, msg) -> begin
(let _68_13397 = (Microsoft_FStar_Absyn_Util.fvs_included fvs_t fvs)
in (occurs_ok, _68_13397, (msg, fvs, fvs_t)))
end))))

let occurs_check_e = (fun ( env ) ( ut ) ( e ) -> (let uvs = (Microsoft_FStar_Absyn_Util.uvars_in_exp e)
in (let occurs_ok = (not ((Support.Microsoft.FStar.Util.set_mem ut uvs.Microsoft_FStar_Absyn_Syntax.uvars_e)))
in (let msg = (match (occurs_ok) with
| true -> begin
None
end
| false -> begin
(let _68_13409 = (let _68_13408 = (Microsoft_FStar_Absyn_Print.uvar_e_to_string ut)
in (let _68_13407 = (let _68_13405 = (let _68_13404 = (Support.Microsoft.FStar.Util.set_elements uvs.Microsoft_FStar_Absyn_Syntax.uvars_e)
in (Support.Prims.pipe_right _68_13404 (Support.List.map Microsoft_FStar_Absyn_Print.uvar_e_to_string)))
in (Support.Prims.pipe_right _68_13405 (Support.String.concat ", ")))
in (let _68_13406 = (Microsoft_FStar_Tc_Normalize.exp_norm_to_string env e)
in (Support.Microsoft.FStar.Util.format3 "occurs-check failed (%s occurs in {%s} uvars of %s)" _68_13408 _68_13407 _68_13406))))
in Some (_68_13409))
end)
in (occurs_ok, msg)))))

let intersect_vars = (fun ( v1 ) ( v2 ) -> (let fvs1 = (Microsoft_FStar_Absyn_Syntax.freevars_of_binders v1)
in (let fvs2 = (Microsoft_FStar_Absyn_Syntax.freevars_of_binders v2)
in (let _68_13416 = (let _68_13415 = (Support.Microsoft.FStar.Util.set_intersect fvs1.Microsoft_FStar_Absyn_Syntax.ftvs fvs2.Microsoft_FStar_Absyn_Syntax.ftvs)
in (let _68_13414 = (Support.Microsoft.FStar.Util.set_intersect fvs1.Microsoft_FStar_Absyn_Syntax.fxvs fvs2.Microsoft_FStar_Absyn_Syntax.fxvs)
in {Microsoft_FStar_Absyn_Syntax.ftvs = _68_13415; Microsoft_FStar_Absyn_Syntax.fxvs = _68_13414}))
in (Microsoft_FStar_Absyn_Syntax.binders_of_freevars _68_13416)))))

let binders_eq = (fun ( v1 ) ( v2 ) -> (((Support.List.length v1) = (Support.List.length v2)) && (Support.List.forall2 (fun ( ax1 ) ( ax2 ) -> (match (((Support.Prims.fst ax1), (Support.Prims.fst ax2))) with
| (Support.Microsoft.FStar.Util.Inl (a), Support.Microsoft.FStar.Util.Inl (b)) -> begin
(Microsoft_FStar_Absyn_Util.bvar_eq a b)
end
| (Support.Microsoft.FStar.Util.Inr (x), Support.Microsoft.FStar.Util.Inr (y)) -> begin
(Microsoft_FStar_Absyn_Util.bvar_eq x y)
end
| _33_675 -> begin
false
end)) v1 v2)))

let pat_var_opt = (fun ( env ) ( seen ) ( arg ) -> (let hd = (norm_arg env arg)
in (match ((Support.Prims.pipe_left Support.Prims.fst hd)) with
| Support.Microsoft.FStar.Util.Inl ({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_btvar (a); Microsoft_FStar_Absyn_Syntax.tk = _33_687; Microsoft_FStar_Absyn_Syntax.pos = _33_685; Microsoft_FStar_Absyn_Syntax.fvs = _33_683; Microsoft_FStar_Absyn_Syntax.uvs = _33_681}) -> begin
(match ((Support.Prims.pipe_right seen (Support.Microsoft.FStar.Util.for_some (fun ( _33_18 ) -> (match (_33_18) with
| (Support.Microsoft.FStar.Util.Inl (b), _33_696) -> begin
(Microsoft_FStar_Absyn_Syntax.bvd_eq a.Microsoft_FStar_Absyn_Syntax.v b.Microsoft_FStar_Absyn_Syntax.v)
end
| _33_699 -> begin
false
end))))) with
| true -> begin
None
end
| false -> begin
Some ((Support.Microsoft.FStar.Util.Inl (a), (Support.Prims.snd hd)))
end)
end
| Support.Microsoft.FStar.Util.Inr ({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_bvar (x); Microsoft_FStar_Absyn_Syntax.tk = _33_707; Microsoft_FStar_Absyn_Syntax.pos = _33_705; Microsoft_FStar_Absyn_Syntax.fvs = _33_703; Microsoft_FStar_Absyn_Syntax.uvs = _33_701}) -> begin
(match ((Support.Prims.pipe_right seen (Support.Microsoft.FStar.Util.for_some (fun ( _33_19 ) -> (match (_33_19) with
| (Support.Microsoft.FStar.Util.Inr (y), _33_716) -> begin
(Microsoft_FStar_Absyn_Syntax.bvd_eq x.Microsoft_FStar_Absyn_Syntax.v y.Microsoft_FStar_Absyn_Syntax.v)
end
| _33_719 -> begin
false
end))))) with
| true -> begin
None
end
| false -> begin
Some ((Support.Microsoft.FStar.Util.Inr (x), (Support.Prims.snd hd)))
end)
end
| _33_721 -> begin
None
end)))

let rec pat_vars = (fun ( env ) ( seen ) ( args ) -> (match (args) with
| [] -> begin
Some ((Support.List.rev seen))
end
| hd::rest -> begin
(match ((pat_var_opt env seen hd)) with
| None -> begin
(let _33_730 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_13432 = (Microsoft_FStar_Absyn_Print.arg_to_string hd)
in (Support.Microsoft.FStar.Util.fprint1 "Not a pattern: %s\n" _68_13432))
end
| false -> begin
()
end)
in None)
end
| Some (x) -> begin
(pat_vars env ((x)::seen) rest)
end)
end))

let destruct_flex_t = (fun ( t ) -> (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, k)) -> begin
(t, uv, k, [])
end
| Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, k)); Microsoft_FStar_Absyn_Syntax.tk = _33_746; Microsoft_FStar_Absyn_Syntax.pos = _33_744; Microsoft_FStar_Absyn_Syntax.fvs = _33_742; Microsoft_FStar_Absyn_Syntax.uvs = _33_740}, args)) -> begin
(t, uv, k, args)
end
| _33_756 -> begin
(failwith ("Not a flex-uvar"))
end))

let destruct_flex_e = (fun ( e ) -> (match (e.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Exp_uvar ((uv, k)) -> begin
(e, uv, k, [])
end
| Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar ((uv, k)); Microsoft_FStar_Absyn_Syntax.tk = _33_769; Microsoft_FStar_Absyn_Syntax.pos = _33_767; Microsoft_FStar_Absyn_Syntax.fvs = _33_765; Microsoft_FStar_Absyn_Syntax.uvs = _33_763}, args)) -> begin
(e, uv, k, args)
end
| _33_779 -> begin
(failwith ("Not a flex-uvar"))
end))

let destruct_flex_pattern = (fun ( env ) ( t ) -> (let _33_786 = (destruct_flex_t t)
in (match (_33_786) with
| (t, uv, k, args) -> begin
(match ((pat_vars env [] args)) with
| Some (vars) -> begin
((t, uv, k, args), Some (vars))
end
| _33_790 -> begin
((t, uv, k, args), None)
end)
end)))

type match_result =
| MisMatch
| HeadMatch
| FullMatch

let is_MisMatch = (fun ( _discr_ ) -> (match (_discr_) with
| MisMatch -> begin
true
end
| _ -> begin
false
end))

let is_HeadMatch = (fun ( _discr_ ) -> (match (_discr_) with
| HeadMatch -> begin
true
end
| _ -> begin
false
end))

let is_FullMatch = (fun ( _discr_ ) -> (match (_discr_) with
| FullMatch -> begin
true
end
| _ -> begin
false
end))

let head_match = (fun ( _33_20 ) -> (match (_33_20) with
| MisMatch -> begin
MisMatch
end
| _33_794 -> begin
HeadMatch
end))

let rec head_matches = (fun ( t1 ) ( t2 ) -> (match ((let _68_13449 = (let _68_13446 = (Microsoft_FStar_Absyn_Util.unmeta_typ t1)
in _68_13446.Microsoft_FStar_Absyn_Syntax.n)
in (let _68_13448 = (let _68_13447 = (Microsoft_FStar_Absyn_Util.unmeta_typ t2)
in _68_13447.Microsoft_FStar_Absyn_Syntax.n)
in (_68_13449, _68_13448)))) with
| (Microsoft_FStar_Absyn_Syntax.Typ_btvar (x), Microsoft_FStar_Absyn_Syntax.Typ_btvar (y)) -> begin
(match ((Microsoft_FStar_Absyn_Util.bvar_eq x y)) with
| true -> begin
FullMatch
end
| false -> begin
MisMatch
end)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_const (f), Microsoft_FStar_Absyn_Syntax.Typ_const (g)) -> begin
(match ((Microsoft_FStar_Absyn_Util.fvar_eq f g)) with
| true -> begin
FullMatch
end
| false -> begin
MisMatch
end)
end
| ((Microsoft_FStar_Absyn_Syntax.Typ_btvar (_), Microsoft_FStar_Absyn_Syntax.Typ_const (_))) | ((Microsoft_FStar_Absyn_Syntax.Typ_const (_), Microsoft_FStar_Absyn_Syntax.Typ_btvar (_))) -> begin
MisMatch
end
| (Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, _33_823)), Microsoft_FStar_Absyn_Syntax.Typ_refine ((y, _33_828))) -> begin
(let _68_13450 = (head_matches x.Microsoft_FStar_Absyn_Syntax.sort y.Microsoft_FStar_Absyn_Syntax.sort)
in (Support.Prims.pipe_right _68_13450 head_match))
end
| (Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, _33_834)), _33_838) -> begin
(let _68_13451 = (head_matches x.Microsoft_FStar_Absyn_Syntax.sort t2)
in (Support.Prims.pipe_right _68_13451 head_match))
end
| (_33_841, Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, _33_844))) -> begin
(let _68_13452 = (head_matches t1 x.Microsoft_FStar_Absyn_Syntax.sort)
in (Support.Prims.pipe_right _68_13452 head_match))
end
| (Microsoft_FStar_Absyn_Syntax.Typ_fun (_33_849), Microsoft_FStar_Absyn_Syntax.Typ_fun (_33_852)) -> begin
HeadMatch
end
| (Microsoft_FStar_Absyn_Syntax.Typ_app ((head, _33_857)), Microsoft_FStar_Absyn_Syntax.Typ_app ((head', _33_862))) -> begin
(head_matches head head')
end
| (Microsoft_FStar_Absyn_Syntax.Typ_app ((head, _33_868)), _33_872) -> begin
(head_matches head t2)
end
| (_33_875, Microsoft_FStar_Absyn_Syntax.Typ_app ((head, _33_878))) -> begin
(head_matches t1 head)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, _33_884)), Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv', _33_889))) -> begin
(match ((Support.Microsoft.FStar.Unionfind.equivalent uv uv')) with
| true -> begin
FullMatch
end
| false -> begin
MisMatch
end)
end
| (_33_894, Microsoft_FStar_Absyn_Syntax.Typ_lam (_33_896)) -> begin
HeadMatch
end
| _33_900 -> begin
MisMatch
end))

let head_matches_delta = (fun ( env ) ( wl ) ( t1 ) ( t2 ) -> (let success = (fun ( d ) ( r ) ( t1 ) ( t2 ) -> (r, (match (d) with
| true -> begin
Some ((t1, t2))
end
| false -> begin
None
end)))
in (let fail = (fun ( _33_911 ) -> (match (()) with
| () -> begin
(MisMatch, None)
end))
in (let rec aux = (fun ( d ) ( t1 ) ( t2 ) -> (match ((head_matches t1 t2)) with
| MisMatch -> begin
(match (d) with
| true -> begin
(fail ())
end
| false -> begin
(let t1 = (normalize_refinement env wl t1)
in (let t2 = (normalize_refinement env wl t2)
in (aux true t1 t2)))
end)
end
| r -> begin
(success d r t1 t2)
end))
in (aux false t1 t2)))))

let decompose_binder = (fun ( bs ) ( v_ktec ) ( rebuild_base ) -> (let fail = (fun ( _33_925 ) -> (match (()) with
| () -> begin
(failwith ("Bad reconstruction"))
end))
in (let rebuild = (fun ( ktecs ) -> (let rec aux = (fun ( new_bs ) ( bs ) ( ktecs ) -> (match ((bs, ktecs)) with
| ([], ktec::[]) -> begin
(rebuild_base (Support.List.rev new_bs) ktec)
end
| ((Support.Microsoft.FStar.Util.Inl (a), imp)::rest, Microsoft_FStar_Absyn_Syntax.K (k)::rest') -> begin
(aux (((Support.Microsoft.FStar.Util.Inl ((let _33_947 = a
in {Microsoft_FStar_Absyn_Syntax.v = _33_947.Microsoft_FStar_Absyn_Syntax.v; Microsoft_FStar_Absyn_Syntax.sort = k; Microsoft_FStar_Absyn_Syntax.p = _33_947.Microsoft_FStar_Absyn_Syntax.p})), imp))::new_bs) rest rest')
end
| ((Support.Microsoft.FStar.Util.Inr (x), imp)::rest, Microsoft_FStar_Absyn_Syntax.T ((t, _33_958))::rest') -> begin
(aux (((Support.Microsoft.FStar.Util.Inr ((let _33_963 = x
in {Microsoft_FStar_Absyn_Syntax.v = _33_963.Microsoft_FStar_Absyn_Syntax.v; Microsoft_FStar_Absyn_Syntax.sort = t; Microsoft_FStar_Absyn_Syntax.p = _33_963.Microsoft_FStar_Absyn_Syntax.p})), imp))::new_bs) rest rest')
end
| _33_966 -> begin
(fail ())
end))
in (aux [] bs ktecs)))
in (let rec mk_b_ktecs = (fun ( _33_970 ) ( _33_21 ) -> (match (_33_970) with
| (binders, b_ktecs) -> begin
(match (_33_21) with
| [] -> begin
(Support.List.rev (((None, COVARIANT, v_ktec))::b_ktecs))
end
| hd::rest -> begin
(let bopt = (match ((Microsoft_FStar_Absyn_Syntax.is_null_binder hd)) with
| true -> begin
None
end
| false -> begin
Some (hd)
end)
in (let b_ktec = (match ((Support.Prims.fst hd)) with
| Support.Microsoft.FStar.Util.Inl (a) -> begin
(bopt, CONTRAVARIANT, Microsoft_FStar_Absyn_Syntax.K (a.Microsoft_FStar_Absyn_Syntax.sort))
end
| Support.Microsoft.FStar.Util.Inr (x) -> begin
(bopt, CONTRAVARIANT, Microsoft_FStar_Absyn_Syntax.T ((x.Microsoft_FStar_Absyn_Syntax.sort, Some (Microsoft_FStar_Absyn_Syntax.ktype))))
end)
in (let binders' = (match (bopt) with
| None -> begin
binders
end
| Some (hd) -> begin
(Support.List.append binders ((hd)::[]))
end)
in (mk_b_ktecs (binders', (b_ktec)::b_ktecs) rest))))
end)
end))
in (let _68_13506 = (mk_b_ktecs ([], []) bs)
in (rebuild, _68_13506))))))

let rec decompose_kind = (fun ( env ) ( k ) -> (let fail = (fun ( _33_989 ) -> (match (()) with
| () -> begin
(failwith ("Bad reconstruction"))
end))
in (let k0 = k
in (let k = (Microsoft_FStar_Absyn_Util.compress_kind k)
in (match (k.Microsoft_FStar_Absyn_Syntax.n) with
| (Microsoft_FStar_Absyn_Syntax.Kind_type) | (Microsoft_FStar_Absyn_Syntax.Kind_effect) -> begin
(let rebuild = (fun ( _33_22 ) -> (match (_33_22) with
| [] -> begin
k
end
| _33_997 -> begin
(fail ())
end))
in (rebuild, []))
end
| Microsoft_FStar_Absyn_Syntax.Kind_arrow ((bs, k)) -> begin
(decompose_binder bs (Microsoft_FStar_Absyn_Syntax.K (k)) (fun ( bs ) ( _33_23 ) -> (match (_33_23) with
| Microsoft_FStar_Absyn_Syntax.K (k) -> begin
(Microsoft_FStar_Absyn_Syntax.mk_Kind_arrow (bs, k) k0.Microsoft_FStar_Absyn_Syntax.pos)
end
| _33_1008 -> begin
(fail ())
end)))
end
| Microsoft_FStar_Absyn_Syntax.Kind_abbrev ((_33_1010, k)) -> begin
(decompose_kind env k)
end
| _33_1015 -> begin
(failwith ("Impossible"))
end)))))

let rec decompose_typ = (fun ( env ) ( t ) -> (let t = (Microsoft_FStar_Absyn_Util.unmeta_typ t)
in (let matches = (fun ( t' ) -> ((head_matches t t') <> MisMatch))
in (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_app ((hd, args)) -> begin
(let rebuild = (fun ( args' ) -> (let args = (Support.List.map2 (fun ( x ) ( y ) -> (match ((x, y)) with
| ((Support.Microsoft.FStar.Util.Inl (_33_1030), imp), Microsoft_FStar_Absyn_Syntax.T ((t, _33_1036))) -> begin
(Support.Microsoft.FStar.Util.Inl (t), imp)
end
| ((Support.Microsoft.FStar.Util.Inr (_33_1041), imp), Microsoft_FStar_Absyn_Syntax.E (e)) -> begin
(Support.Microsoft.FStar.Util.Inr (e), imp)
end
| _33_1049 -> begin
(failwith ("Bad reconstruction"))
end)) args args')
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_app (hd, args) None t.Microsoft_FStar_Absyn_Syntax.pos)))
in (let b_ktecs = (Support.Prims.pipe_right args (Support.List.map (fun ( _33_24 ) -> (match (_33_24) with
| (Support.Microsoft.FStar.Util.Inl (t), _33_1055) -> begin
(None, INVARIANT, Microsoft_FStar_Absyn_Syntax.T ((t, None)))
end
| (Support.Microsoft.FStar.Util.Inr (e), _33_1060) -> begin
(None, INVARIANT, Microsoft_FStar_Absyn_Syntax.E (e))
end))))
in (rebuild, matches, b_ktecs)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_fun ((bs, c)) -> begin
(let _33_1075 = (decompose_binder bs (Microsoft_FStar_Absyn_Syntax.C (c)) (fun ( bs ) ( _33_25 ) -> (match (_33_25) with
| Microsoft_FStar_Absyn_Syntax.C (c) -> begin
(Microsoft_FStar_Absyn_Syntax.mk_Typ_fun (bs, c) None t.Microsoft_FStar_Absyn_Syntax.pos)
end
| _33_1072 -> begin
(failwith ("Bad reconstruction"))
end)))
in (match (_33_1075) with
| (rebuild, b_ktecs) -> begin
(rebuild, matches, b_ktecs)
end))
end
| _33_1077 -> begin
(let rebuild = (fun ( _33_26 ) -> (match (_33_26) with
| [] -> begin
t
end
| _33_1081 -> begin
(failwith ("Bad reconstruction"))
end))
in (rebuild, (fun ( t ) -> true), []))
end))))

let un_T = (fun ( _33_27 ) -> (match (_33_27) with
| Microsoft_FStar_Absyn_Syntax.T ((x, _33_1087)) -> begin
x
end
| _33_1091 -> begin
(failwith ("impossible"))
end))

let arg_of_ktec = (fun ( _33_28 ) -> (match (_33_28) with
| Microsoft_FStar_Absyn_Syntax.T ((t, _33_1095)) -> begin
(Microsoft_FStar_Absyn_Syntax.targ t)
end
| Microsoft_FStar_Absyn_Syntax.E (e) -> begin
(Microsoft_FStar_Absyn_Syntax.varg e)
end
| _33_1101 -> begin
(failwith ("Impossible"))
end))

let imitation_sub_probs = (fun ( orig ) ( env ) ( scope ) ( ps ) ( qs ) -> (let r = (p_loc orig)
in (let rel = (p_rel orig)
in (let sub_prob = (fun ( scope ) ( args ) ( q ) -> (match (q) with
| (_33_1114, variance, Microsoft_FStar_Absyn_Syntax.K (ki)) -> begin
(let _33_1121 = (new_kvar r scope)
in (match (_33_1121) with
| (gi_xs, gi) -> begin
(let gi_ps = (Microsoft_FStar_Absyn_Syntax.mk_Kind_uvar (gi, args) r)
in (let _68_13589 = (let _68_13588 = (mk_problem scope orig gi_ps (vary_rel rel variance) ki None "kind subterm")
in (Support.Prims.pipe_left (fun ( _68_13587 ) -> KProb (_68_13587)) _68_13588))
in (Microsoft_FStar_Absyn_Syntax.K (gi_xs), _68_13589)))
end))
end
| (_33_1124, variance, Microsoft_FStar_Absyn_Syntax.T ((ti, kopt))) -> begin
(let k = (match (kopt) with
| Some (k) -> begin
k
end
| None -> begin
(Microsoft_FStar_Tc_Recheck.recompute_kind ti)
end)
in (let _33_1137 = (new_tvar r scope k)
in (match (_33_1137) with
| (gi_xs, gi) -> begin
(let gi_ps = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app' (gi, args) None r)
in (let _68_13592 = (let _68_13591 = (mk_problem scope orig gi_ps (vary_rel rel variance) ti None "type subterm")
in (Support.Prims.pipe_left (fun ( _68_13590 ) -> TProb (_68_13590)) _68_13591))
in (Microsoft_FStar_Absyn_Syntax.T ((gi_xs, Some (k))), _68_13592)))
end)))
end
| (_33_1140, variance, Microsoft_FStar_Absyn_Syntax.E (ei)) -> begin
(let t = (Microsoft_FStar_Tc_Recheck.recompute_typ ei)
in (let _33_1148 = (new_evar r scope t)
in (match (_33_1148) with
| (gi_xs, gi) -> begin
(let gi_ps = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app' (gi, args) (Some (t)) r)
in (let _68_13595 = (let _68_13594 = (mk_problem scope orig gi_ps (vary_rel rel variance) ei None "expression subterm")
in (Support.Prims.pipe_left (fun ( _68_13593 ) -> EProb (_68_13593)) _68_13594))
in (Microsoft_FStar_Absyn_Syntax.E (gi_xs), _68_13595)))
end)))
end
| (_33_1151, _33_1153, Microsoft_FStar_Absyn_Syntax.C (_33_1155)) -> begin
(failwith ("impos"))
end))
in (let rec aux = (fun ( scope ) ( args ) ( qs ) -> (match (qs) with
| [] -> begin
([], [], Microsoft_FStar_Absyn_Util.t_true)
end
| q::qs -> begin
(let _33_1231 = (match (q) with
| (bopt, variance, Microsoft_FStar_Absyn_Syntax.C ({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Total (ti); Microsoft_FStar_Absyn_Syntax.tk = _33_1175; Microsoft_FStar_Absyn_Syntax.pos = _33_1173; Microsoft_FStar_Absyn_Syntax.fvs = _33_1171; Microsoft_FStar_Absyn_Syntax.uvs = _33_1169})) -> begin
(match ((sub_prob scope args (bopt, variance, Microsoft_FStar_Absyn_Syntax.T ((ti, Some (Microsoft_FStar_Absyn_Syntax.ktype)))))) with
| (Microsoft_FStar_Absyn_Syntax.T ((gi_xs, _33_1183)), prob) -> begin
(let _68_13604 = (let _68_13603 = (Microsoft_FStar_Absyn_Syntax.mk_Total gi_xs)
in (Support.Prims.pipe_left (fun ( _68_13602 ) -> Microsoft_FStar_Absyn_Syntax.C (_68_13602)) _68_13603))
in (_68_13604, (prob)::[]))
end
| _33_1189 -> begin
(failwith ("impossible"))
end)
end
| (_33_1191, _33_1193, Microsoft_FStar_Absyn_Syntax.C ({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Comp (c); Microsoft_FStar_Absyn_Syntax.tk = _33_1201; Microsoft_FStar_Absyn_Syntax.pos = _33_1199; Microsoft_FStar_Absyn_Syntax.fvs = _33_1197; Microsoft_FStar_Absyn_Syntax.uvs = _33_1195})) -> begin
(let components = (Support.Prims.pipe_right c.Microsoft_FStar_Absyn_Syntax.effect_args (Support.List.map (fun ( _33_29 ) -> (match (_33_29) with
| (Support.Microsoft.FStar.Util.Inl (t), _33_1211) -> begin
(None, INVARIANT, Microsoft_FStar_Absyn_Syntax.T ((t, None)))
end
| (Support.Microsoft.FStar.Util.Inr (e), _33_1216) -> begin
(None, INVARIANT, Microsoft_FStar_Absyn_Syntax.E (e))
end))))
in (let components = ((None, COVARIANT, Microsoft_FStar_Absyn_Syntax.T ((c.Microsoft_FStar_Absyn_Syntax.result_typ, Some (Microsoft_FStar_Absyn_Syntax.ktype)))))::components
in (let _33_1222 = (let _68_13606 = (Support.List.map (sub_prob scope args) components)
in (Support.Prims.pipe_right _68_13606 Support.List.unzip))
in (match (_33_1222) with
| (ktecs, sub_probs) -> begin
(let gi_xs = (let _68_13611 = (let _68_13610 = (let _68_13607 = (Support.List.hd ktecs)
in (Support.Prims.pipe_right _68_13607 un_T))
in (let _68_13609 = (let _68_13608 = (Support.List.tl ktecs)
in (Support.Prims.pipe_right _68_13608 (Support.List.map arg_of_ktec)))
in {Microsoft_FStar_Absyn_Syntax.effect_name = c.Microsoft_FStar_Absyn_Syntax.effect_name; Microsoft_FStar_Absyn_Syntax.result_typ = _68_13610; Microsoft_FStar_Absyn_Syntax.effect_args = _68_13609; Microsoft_FStar_Absyn_Syntax.flags = c.Microsoft_FStar_Absyn_Syntax.flags}))
in (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.mk_Comp _68_13611))
in (Microsoft_FStar_Absyn_Syntax.C (gi_xs), sub_probs))
end))))
end
| _33_1225 -> begin
(let _33_1228 = (sub_prob scope args q)
in (match (_33_1228) with
| (ktec, prob) -> begin
(ktec, (prob)::[])
end))
end)
in (match (_33_1231) with
| (ktec, probs) -> begin
(let _33_1244 = (match (q) with
| (Some (b), _33_1235, _33_1237) -> begin
(let _68_13613 = (let _68_13612 = (Microsoft_FStar_Absyn_Util.arg_of_non_null_binder b)
in (_68_13612)::args)
in (Some (b), (b)::scope, _68_13613))
end
| _33_1240 -> begin
(None, scope, args)
end)
in (match (_33_1244) with
| (bopt, scope, args) -> begin
(let _33_1248 = (aux scope args qs)
in (match (_33_1248) with
| (sub_probs, ktecs, f) -> begin
(let f = (match (bopt) with
| None -> begin
(let _68_13616 = (let _68_13615 = (Support.Prims.pipe_right probs (Support.List.map (fun ( prob ) -> (Support.Prims.pipe_right (p_guard prob) Support.Prims.fst))))
in (f)::_68_13615)
in (Microsoft_FStar_Absyn_Util.mk_conj_l _68_13616))
end
| Some (b) -> begin
(let _68_13620 = (let _68_13619 = (Microsoft_FStar_Absyn_Util.close_forall ((b)::[]) f)
in (let _68_13618 = (Support.Prims.pipe_right probs (Support.List.map (fun ( prob ) -> (Support.Prims.pipe_right (p_guard prob) Support.Prims.fst))))
in (_68_13619)::_68_13618))
in (Microsoft_FStar_Absyn_Util.mk_conj_l _68_13620))
end)
in ((Support.List.append probs sub_probs), (ktec)::ktecs, f))
end))
end))
end))
end))
in (aux scope ps qs))))))

type slack =
{lower : (Microsoft_FStar_Absyn_Syntax.typ * Microsoft_FStar_Absyn_Syntax.typ); upper : (Microsoft_FStar_Absyn_Syntax.typ * Microsoft_FStar_Absyn_Syntax.typ); flag : bool ref}

let is_Mkslack = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkslack")))

let fix_slack_uv = (fun ( _33_1261 ) ( mul ) -> (match (_33_1261) with
| (uv, k) -> begin
(let inst = (match (mul) with
| true -> begin
(Microsoft_FStar_Absyn_Util.close_for_kind Microsoft_FStar_Absyn_Util.t_true k)
end
| false -> begin
(Microsoft_FStar_Absyn_Util.close_for_kind Microsoft_FStar_Absyn_Util.t_false k)
end)
in (Microsoft_FStar_Absyn_Util.unchecked_unify uv inst))
end))

let fix_slack_vars = (fun ( slack ) -> (Support.Prims.pipe_right slack (Support.List.iter (fun ( _33_1267 ) -> (match (_33_1267) with
| (mul, s) -> begin
(match ((let _68_13638 = (Microsoft_FStar_Absyn_Util.compress_typ s)
in _68_13638.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, k)) -> begin
(fix_slack_uv (uv, k) mul)
end
| _33_1273 -> begin
()
end)
end)))))

let fix_slack = (fun ( slack ) -> (let _33_1281 = (Support.Prims.pipe_left destruct_flex_t (Support.Prims.snd slack.lower))
in (match (_33_1281) with
| (_33_1276, ul, kl, _33_1280) -> begin
(let _33_1288 = (Support.Prims.pipe_left destruct_flex_t (Support.Prims.snd slack.upper))
in (match (_33_1288) with
| (_33_1283, uh, kh, _33_1287) -> begin
(let _33_1289 = (fix_slack_uv (ul, kl) false)
in (let _33_1291 = (fix_slack_uv (uh, kh) true)
in (let _33_1293 = (Support.ST.op_Colon_Equals slack.flag true)
in (Microsoft_FStar_Absyn_Util.mk_conj (Support.Prims.fst slack.lower) (Support.Prims.fst slack.upper)))))
end))
end)))

let new_slack_var = (fun ( env ) ( slack ) -> (let xs = (let _68_13646 = (let _68_13645 = (destruct_flex_pattern env (Support.Prims.snd slack.lower))
in (Support.Prims.pipe_right _68_13645 Support.Prims.snd))
in (Support.Prims.pipe_right _68_13646 Support.Microsoft.FStar.Util.must))
in (let _68_13647 = (new_tvar (Support.Prims.fst slack.lower).Microsoft_FStar_Absyn_Syntax.pos xs Microsoft_FStar_Absyn_Syntax.ktype)
in (_68_13647, xs))))

let new_slack_formula = (fun ( p ) ( env ) ( wl ) ( xs ) ( low ) ( high ) -> (let _33_1306 = (new_tvar p xs Microsoft_FStar_Absyn_Syntax.ktype)
in (match (_33_1306) with
| (low_var, uv1) -> begin
(let wl = (add_slack_add uv1 wl)
in (let _33_1310 = (new_tvar p xs Microsoft_FStar_Absyn_Syntax.ktype)
in (match (_33_1310) with
| (high_var, uv2) -> begin
(let wl = (add_slack_mul uv2 wl)
in (let low = (match (low) with
| None -> begin
(Microsoft_FStar_Absyn_Util.mk_disj Microsoft_FStar_Absyn_Util.t_false low_var)
end
| Some (f) -> begin
(Microsoft_FStar_Absyn_Util.mk_disj f low_var)
end)
in (let high = (match (high) with
| None -> begin
(Microsoft_FStar_Absyn_Util.mk_conj Microsoft_FStar_Absyn_Util.t_true high_var)
end
| Some (f) -> begin
(Microsoft_FStar_Absyn_Util.mk_conj f high_var)
end)
in (let _68_13657 = (let _68_13656 = (let _68_13655 = (let _68_13654 = (Support.Microsoft.FStar.Util.mk_ref false)
in (low, high, _68_13654))
in Microsoft_FStar_Absyn_Syntax.Meta_slack_formula (_68_13655))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_meta _68_13656))
in (_68_13657, wl)))))
end)))
end)))

let destruct_slack = (fun ( env ) ( wl ) ( phi ) -> (let rec destruct = (fun ( conn_lid ) ( mk_conn ) ( phi ) -> (match (phi.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_const (tc); Microsoft_FStar_Absyn_Syntax.tk = _33_1334; Microsoft_FStar_Absyn_Syntax.pos = _33_1332; Microsoft_FStar_Absyn_Syntax.fvs = _33_1330; Microsoft_FStar_Absyn_Syntax.uvs = _33_1328}, (Support.Microsoft.FStar.Util.Inl (lhs), _33_1346)::(Support.Microsoft.FStar.Util.Inl (rhs), _33_1341)::[])) when (Microsoft_FStar_Absyn_Syntax.lid_equals tc.Microsoft_FStar_Absyn_Syntax.v conn_lid) -> begin
(let rhs = (compress env wl rhs)
in (match (rhs.Microsoft_FStar_Absyn_Syntax.n) with
| (Microsoft_FStar_Absyn_Syntax.Typ_uvar (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _))) -> begin
Some ((lhs, rhs))
end
| _33_1372 -> begin
(match ((destruct conn_lid mk_conn rhs)) with
| None -> begin
None
end
| Some ((rest, uvar)) -> begin
(let _68_13681 = (let _68_13680 = (mk_conn lhs rest)
in (_68_13680, uvar))
in Some (_68_13681))
end)
end))
end
| _33_1379 -> begin
None
end))
in (let phi = (Microsoft_FStar_Absyn_Util.compress_typ phi)
in (match (phi.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_slack_formula ((phi1, phi2, flag))) -> begin
(match ((Support.ST.read flag)) with
| true -> begin
(let _68_13682 = (Microsoft_FStar_Absyn_Util.unmeta_typ phi)
in Support.Microsoft.FStar.Util.Inl (_68_13682))
end
| false -> begin
(let low = (let _68_13683 = (compress env wl phi1)
in (Support.Prims.pipe_left (destruct Microsoft_FStar_Absyn_Const.or_lid Microsoft_FStar_Absyn_Util.mk_disj) _68_13683))
in (let hi = (let _68_13684 = (compress env wl phi2)
in (Support.Prims.pipe_left (destruct Microsoft_FStar_Absyn_Const.and_lid Microsoft_FStar_Absyn_Util.mk_disj) _68_13684))
in (match ((low, hi)) with
| (None, None) -> begin
(let _33_1392 = (Support.ST.op_Colon_Equals flag true)
in (let _68_13685 = (Microsoft_FStar_Absyn_Util.unmeta_typ phi)
in Support.Microsoft.FStar.Util.Inl (_68_13685)))
end
| ((Some (_), None)) | ((None, Some (_))) -> begin
(failwith ("Impossible"))
end
| (Some (l), Some (u)) -> begin
Support.Microsoft.FStar.Util.Inr ({lower = l; upper = u; flag = flag})
end)))
end)
end
| _33_1410 -> begin
Support.Microsoft.FStar.Util.Inl (phi)
end))))

let rec eq_typ = (fun ( t1 ) ( t2 ) -> (let t1 = (Microsoft_FStar_Absyn_Util.compress_typ t1)
in (let t2 = (Microsoft_FStar_Absyn_Util.compress_typ t2)
in (match ((t1.Microsoft_FStar_Absyn_Syntax.n, t2.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Typ_btvar (a), Microsoft_FStar_Absyn_Syntax.Typ_btvar (b)) -> begin
(Microsoft_FStar_Absyn_Util.bvar_eq a b)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_const (f), Microsoft_FStar_Absyn_Syntax.Typ_const (g)) -> begin
(Microsoft_FStar_Absyn_Util.fvar_eq f g)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_uvar ((u1, _33_1427)), Microsoft_FStar_Absyn_Syntax.Typ_uvar ((u2, _33_1432))) -> begin
(Support.Microsoft.FStar.Unionfind.equivalent u1 u2)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_app ((h1, args1)), Microsoft_FStar_Absyn_Syntax.Typ_app ((h2, args2))) -> begin
((eq_typ h1 h2) && (eq_args args1 args2))
end
| _33_1446 -> begin
false
end))))
and eq_exp = (fun ( e1 ) ( e2 ) -> (let e1 = (Microsoft_FStar_Absyn_Util.compress_exp e1)
in (let e2 = (Microsoft_FStar_Absyn_Util.compress_exp e2)
in (match ((e1.Microsoft_FStar_Absyn_Syntax.n, e2.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Exp_bvar (a), Microsoft_FStar_Absyn_Syntax.Exp_bvar (b)) -> begin
(Microsoft_FStar_Absyn_Util.bvar_eq a b)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_fvar ((f, _33_1458)), Microsoft_FStar_Absyn_Syntax.Exp_fvar ((g, _33_1463))) -> begin
(Microsoft_FStar_Absyn_Util.fvar_eq f g)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_constant (c), Microsoft_FStar_Absyn_Syntax.Exp_constant (d)) -> begin
(c = d)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_app ((h1, args1)), Microsoft_FStar_Absyn_Syntax.Exp_app ((h2, args2))) -> begin
((eq_exp h1 h2) && (eq_args args1 args2))
end
| _33_1482 -> begin
false
end))))
and eq_args = (fun ( a1 ) ( a2 ) -> (match (((Support.List.length a1) = (Support.List.length a2))) with
| true -> begin
(Support.List.forall2 (fun ( a1 ) ( a2 ) -> (match ((a1, a2)) with
| ((Support.Microsoft.FStar.Util.Inl (t), _33_1490), (Support.Microsoft.FStar.Util.Inl (s), _33_1495)) -> begin
(eq_typ t s)
end
| ((Support.Microsoft.FStar.Util.Inr (e), _33_1501), (Support.Microsoft.FStar.Util.Inr (f), _33_1506)) -> begin
(eq_exp e f)
end
| _33_1510 -> begin
false
end)) a1 a2)
end
| false -> begin
false
end))

type flex_t =
(Microsoft_FStar_Absyn_Syntax.typ * Microsoft_FStar_Absyn_Syntax.uvar_t * Microsoft_FStar_Absyn_Syntax.knd * Microsoft_FStar_Absyn_Syntax.args)

type im_or_proj_t =
((Microsoft_FStar_Absyn_Syntax.uvar_t * Microsoft_FStar_Absyn_Syntax.knd) * Microsoft_FStar_Absyn_Syntax.arg list * Microsoft_FStar_Absyn_Syntax.binders * ((Microsoft_FStar_Absyn_Syntax.ktec list  ->  Microsoft_FStar_Absyn_Syntax.typ) * (Microsoft_FStar_Absyn_Syntax.typ  ->  bool) * (Microsoft_FStar_Absyn_Syntax.binder option * variance * Microsoft_FStar_Absyn_Syntax.ktec) list))

let rigid_rigid = 0

let flex_rigid_eq = 1

let flex_refine_inner = 2

let flex_refine = 3

let flex_rigid = 4

let rigid_flex = 5

let refine_flex = 6

let flex_flex = 7

let compress_prob = (fun ( wl ) ( p ) -> (match (p) with
| KProb (p) -> begin
(let _68_13715 = (let _33_1515 = p
in (let _68_13713 = (compress_k wl.tcenv wl p.lhs)
in (let _68_13712 = (compress_k wl.tcenv wl p.rhs)
in {lhs = _68_13713; relation = _33_1515.relation; rhs = _68_13712; element = _33_1515.element; logical_guard = _33_1515.logical_guard; scope = _33_1515.scope; reason = _33_1515.reason; loc = _33_1515.loc; rank = _33_1515.rank})))
in (Support.Prims.pipe_right _68_13715 (fun ( _68_13714 ) -> KProb (_68_13714))))
end
| TProb (p) -> begin
(let _68_13719 = (let _33_1519 = p
in (let _68_13717 = (compress wl.tcenv wl p.lhs)
in (let _68_13716 = (compress wl.tcenv wl p.rhs)
in {lhs = _68_13717; relation = _33_1519.relation; rhs = _68_13716; element = _33_1519.element; logical_guard = _33_1519.logical_guard; scope = _33_1519.scope; reason = _33_1519.reason; loc = _33_1519.loc; rank = _33_1519.rank})))
in (Support.Prims.pipe_right _68_13719 (fun ( _68_13718 ) -> TProb (_68_13718))))
end
| EProb (p) -> begin
(let _68_13723 = (let _33_1523 = p
in (let _68_13721 = (compress_e wl.tcenv wl p.lhs)
in (let _68_13720 = (compress_e wl.tcenv wl p.rhs)
in {lhs = _68_13721; relation = _33_1523.relation; rhs = _68_13720; element = _33_1523.element; logical_guard = _33_1523.logical_guard; scope = _33_1523.scope; reason = _33_1523.reason; loc = _33_1523.loc; rank = _33_1523.rank})))
in (Support.Prims.pipe_right _68_13723 (fun ( _68_13722 ) -> EProb (_68_13722))))
end
| CProb (_33_1526) -> begin
p
end))

let rank = (fun ( wl ) ( prob ) -> (let prob = (let _68_13728 = (compress_prob wl prob)
in (Support.Prims.pipe_right _68_13728 maybe_invert_p))
in (match (prob) with
| KProb (kp) -> begin
(let rank = (match ((kp.lhs.Microsoft_FStar_Absyn_Syntax.n, kp.rhs.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Kind_uvar (_33_1534), Microsoft_FStar_Absyn_Syntax.Kind_uvar (_33_1537)) -> begin
flex_flex
end
| (Microsoft_FStar_Absyn_Syntax.Kind_uvar (_33_1541), _33_1544) -> begin
(match ((kp.relation = EQ)) with
| true -> begin
flex_rigid_eq
end
| false -> begin
flex_rigid
end)
end
| (_33_1547, Microsoft_FStar_Absyn_Syntax.Kind_uvar (_33_1549)) -> begin
(match ((kp.relation = EQ)) with
| true -> begin
flex_rigid_eq
end
| false -> begin
rigid_flex
end)
end
| (_33_1553, _33_1555) -> begin
rigid_rigid
end)
in (let _68_13730 = (Support.Prims.pipe_right (let _33_1558 = kp
in {lhs = _33_1558.lhs; relation = _33_1558.relation; rhs = _33_1558.rhs; element = _33_1558.element; logical_guard = _33_1558.logical_guard; scope = _33_1558.scope; reason = _33_1558.reason; loc = _33_1558.loc; rank = Some (rank)}) (fun ( _68_13729 ) -> KProb (_68_13729)))
in (rank, _68_13730)))
end
| TProb (tp) -> begin
(let _33_1565 = (Microsoft_FStar_Absyn_Util.head_and_args tp.lhs)
in (match (_33_1565) with
| (lh, _33_1564) -> begin
(let _33_1569 = (Microsoft_FStar_Absyn_Util.head_and_args tp.rhs)
in (match (_33_1569) with
| (rh, _33_1568) -> begin
(let _33_1625 = (match ((lh.Microsoft_FStar_Absyn_Syntax.n, rh.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Typ_uvar (_33_1571), Microsoft_FStar_Absyn_Syntax.Typ_uvar (_33_1574)) -> begin
(flex_flex, tp)
end
| ((Microsoft_FStar_Absyn_Syntax.Typ_uvar (_), _)) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_uvar (_))) when (tp.relation = EQ) -> begin
(flex_rigid_eq, tp)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_uvar (_33_1590), _33_1593) -> begin
(let _33_1597 = (base_and_refinement wl.tcenv wl tp.rhs)
in (match (_33_1597) with
| (b, ref_opt) -> begin
(match (ref_opt) with
| None -> begin
(flex_rigid, tp)
end
| _33_1600 -> begin
(let rank = (match ((is_top_level_prob prob)) with
| true -> begin
flex_refine
end
| false -> begin
flex_refine_inner
end)
in (let _68_13732 = (let _33_1602 = tp
in (let _68_13731 = (force_refinement (b, ref_opt))
in {lhs = _33_1602.lhs; relation = _33_1602.relation; rhs = _68_13731; element = _33_1602.element; logical_guard = _33_1602.logical_guard; scope = _33_1602.scope; reason = _33_1602.reason; loc = _33_1602.loc; rank = _33_1602.rank}))
in (rank, _68_13732)))
end)
end))
end
| (_33_1605, Microsoft_FStar_Absyn_Syntax.Typ_uvar (_33_1607)) -> begin
(let _33_1612 = (base_and_refinement wl.tcenv wl tp.lhs)
in (match (_33_1612) with
| (b, ref_opt) -> begin
(match (ref_opt) with
| None -> begin
(rigid_flex, tp)
end
| _33_1615 -> begin
(let _68_13734 = (let _33_1616 = tp
in (let _68_13733 = (force_refinement (b, ref_opt))
in {lhs = _68_13733; relation = _33_1616.relation; rhs = _33_1616.rhs; element = _33_1616.element; logical_guard = _33_1616.logical_guard; scope = _33_1616.scope; reason = _33_1616.reason; loc = _33_1616.loc; rank = _33_1616.rank}))
in (refine_flex, _68_13734))
end)
end))
end
| (_33_1619, _33_1621) -> begin
(rigid_rigid, tp)
end)
in (match (_33_1625) with
| (rank, tp) -> begin
(let _68_13736 = (Support.Prims.pipe_right (let _33_1626 = tp
in {lhs = _33_1626.lhs; relation = _33_1626.relation; rhs = _33_1626.rhs; element = _33_1626.element; logical_guard = _33_1626.logical_guard; scope = _33_1626.scope; reason = _33_1626.reason; loc = _33_1626.loc; rank = Some (rank)}) (fun ( _68_13735 ) -> TProb (_68_13735)))
in (rank, _68_13736))
end))
end))
end))
end
| EProb (ep) -> begin
(let _33_1633 = (Microsoft_FStar_Absyn_Util.head_and_args_e ep.lhs)
in (match (_33_1633) with
| (lh, _33_1632) -> begin
(let _33_1637 = (Microsoft_FStar_Absyn_Util.head_and_args_e ep.rhs)
in (match (_33_1637) with
| (rh, _33_1636) -> begin
(let rank = (match ((lh.Microsoft_FStar_Absyn_Syntax.n, rh.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Exp_uvar (_33_1639), Microsoft_FStar_Absyn_Syntax.Exp_uvar (_33_1642)) -> begin
flex_flex
end
| ((Microsoft_FStar_Absyn_Syntax.Exp_uvar (_), _)) | ((_, Microsoft_FStar_Absyn_Syntax.Exp_uvar (_))) -> begin
flex_rigid_eq
end
| (_33_1658, _33_1660) -> begin
rigid_rigid
end)
in (let _68_13738 = (Support.Prims.pipe_right (let _33_1663 = ep
in {lhs = _33_1663.lhs; relation = _33_1663.relation; rhs = _33_1663.rhs; element = _33_1663.element; logical_guard = _33_1663.logical_guard; scope = _33_1663.scope; reason = _33_1663.reason; loc = _33_1663.loc; rank = Some (rank)}) (fun ( _68_13737 ) -> EProb (_68_13737)))
in (rank, _68_13738)))
end))
end))
end
| CProb (cp) -> begin
(let _68_13740 = (Support.Prims.pipe_right (let _33_1667 = cp
in {lhs = _33_1667.lhs; relation = _33_1667.relation; rhs = _33_1667.rhs; element = _33_1667.element; logical_guard = _33_1667.logical_guard; scope = _33_1667.scope; reason = _33_1667.reason; loc = _33_1667.loc; rank = Some (rigid_rigid)}) (fun ( _68_13739 ) -> CProb (_68_13739)))
in (rigid_rigid, _68_13740))
end)))

let next_prob = (fun ( wl ) -> (let rec aux = (fun ( _33_1674 ) ( probs ) -> (match (_33_1674) with
| (min_rank, min, out) -> begin
(match (probs) with
| [] -> begin
(min, out, min_rank)
end
| hd::tl -> begin
(let _33_1682 = (rank wl hd)
in (match (_33_1682) with
| (rank, hd) -> begin
(match ((rank <= flex_rigid_eq)) with
| true -> begin
(match (min) with
| None -> begin
(Some (hd), (Support.List.append out tl), rank)
end
| Some (m) -> begin
(Some (hd), (Support.List.append out ((m)::tl)), rank)
end)
end
| false -> begin
(match ((rank < min_rank)) with
| true -> begin
(match (min) with
| None -> begin
(aux (rank, Some (hd), out) tl)
end
| Some (m) -> begin
(aux (rank, Some (hd), (m)::out) tl)
end)
end
| false -> begin
(aux (min_rank, min, (hd)::out) tl)
end)
end)
end))
end)
end))
in (aux ((flex_flex + 1), None, []) wl.attempting)))

let is_flex_rigid = (fun ( rank ) -> ((flex_refine_inner <= rank) && (rank <= flex_rigid)))

let rec solve_flex_rigid_join = (fun ( env ) ( tp ) ( wl ) -> (let _33_1693 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_13790 = (prob_to_string env (TProb (tp)))
in (Support.Microsoft.FStar.Util.fprint1 "Trying to solve by joining refinements:%s\n" _68_13790))
end
| false -> begin
()
end)
in (let _33_1697 = (Microsoft_FStar_Absyn_Util.head_and_args tp.lhs)
in (match (_33_1697) with
| (u, args) -> begin
(let _33_1703 = (0, 1, 2, 3, 4)
in (match (_33_1703) with
| (ok, head_match, partial_match, fallback, failed_match) -> begin
(let max = (fun ( i ) ( j ) -> (match ((i < j)) with
| true -> begin
j
end
| false -> begin
i
end))
in (let base_types_match = (fun ( t1 ) ( t2 ) -> (let _33_1712 = (Microsoft_FStar_Absyn_Util.head_and_args t1)
in (match (_33_1712) with
| (h1, args1) -> begin
(let _33_1716 = (Microsoft_FStar_Absyn_Util.head_and_args t2)
in (match (_33_1716) with
| (h2, _33_1715) -> begin
(match ((h1.Microsoft_FStar_Absyn_Syntax.n, h2.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Typ_const (tc1), Microsoft_FStar_Absyn_Syntax.Typ_const (tc2)) -> begin
(match ((Microsoft_FStar_Absyn_Syntax.lid_equals tc1.Microsoft_FStar_Absyn_Syntax.v tc2.Microsoft_FStar_Absyn_Syntax.v)) with
| true -> begin
(match (((Support.List.length args1) = 0)) with
| true -> begin
Some ([])
end
| false -> begin
(let _68_13802 = (let _68_13801 = (let _68_13800 = (new_problem env t1 EQ t2 None t1.Microsoft_FStar_Absyn_Syntax.pos "joining refinements")
in (Support.Prims.pipe_left (fun ( _68_13799 ) -> TProb (_68_13799)) _68_13800))
in (_68_13801)::[])
in Some (_68_13802))
end)
end
| false -> begin
None
end)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_btvar (a), Microsoft_FStar_Absyn_Syntax.Typ_btvar (b)) -> begin
(match ((Microsoft_FStar_Absyn_Util.bvar_eq a b)) with
| true -> begin
Some ([])
end
| false -> begin
None
end)
end
| _33_1728 -> begin
None
end)
end))
end)))
in (let conjoin = (fun ( t1 ) ( t2 ) -> (match ((t1.Microsoft_FStar_Absyn_Syntax.n, t2.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, phi1)), Microsoft_FStar_Absyn_Syntax.Typ_refine ((y, phi2))) -> begin
(let m = (base_types_match x.Microsoft_FStar_Absyn_Syntax.sort y.Microsoft_FStar_Absyn_Syntax.sort)
in (match (m) with
| None -> begin
None
end
| Some (m) -> begin
(let phi2 = (let _68_13809 = (let _68_13808 = (Microsoft_FStar_Absyn_Syntax.v_binder x)
in (let _68_13807 = (Microsoft_FStar_Absyn_Syntax.v_binder y)
in (Microsoft_FStar_Absyn_Util.mk_subst_one_binder _68_13808 _68_13807)))
in (Microsoft_FStar_Absyn_Util.subst_typ _68_13809 phi2))
in (let _68_13813 = (let _68_13812 = (let _68_13811 = (let _68_13810 = (Microsoft_FStar_Absyn_Util.mk_conj phi1 phi2)
in (x, _68_13810))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_refine _68_13811 (Some (Microsoft_FStar_Absyn_Syntax.ktype)) t1.Microsoft_FStar_Absyn_Syntax.pos))
in (_68_13812, m))
in Some (_68_13813)))
end))
end
| (_33_1747, Microsoft_FStar_Absyn_Syntax.Typ_refine ((y, _33_1750))) -> begin
(let m = (base_types_match t1 y.Microsoft_FStar_Absyn_Syntax.sort)
in (match (m) with
| None -> begin
None
end
| Some (m) -> begin
Some ((t2, m))
end))
end
| (Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, _33_1760)), _33_1764) -> begin
(let m = (base_types_match x.Microsoft_FStar_Absyn_Syntax.sort t2)
in (match (m) with
| None -> begin
None
end
| Some (m) -> begin
Some ((t1, m))
end))
end
| _33_1771 -> begin
(let m = (base_types_match t1 t2)
in (match (m) with
| None -> begin
None
end
| Some (m) -> begin
Some ((t1, m))
end))
end))
in (let tt = u
in (match (tt.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, _33_1779)) -> begin
(let _33_1804 = (Support.Prims.pipe_right wl.attempting (Support.List.partition (fun ( _33_30 ) -> (match (_33_30) with
| TProb (tp) -> begin
(match (tp.rank) with
| Some (rank) when (is_flex_rigid rank) -> begin
(let _33_1790 = (Microsoft_FStar_Absyn_Util.head_and_args tp.lhs)
in (match (_33_1790) with
| (u', _33_1789) -> begin
(match ((let _68_13815 = (compress env wl u')
in _68_13815.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv', _33_1793)) -> begin
(Support.Microsoft.FStar.Unionfind.equivalent uv uv')
end
| _33_1797 -> begin
false
end)
end))
end
| _33_1799 -> begin
false
end)
end
| _33_1801 -> begin
false
end))))
in (match (_33_1804) with
| (upper_bounds, rest) -> begin
(let rec make_upper_bound = (fun ( _33_1808 ) ( tps ) -> (match (_33_1808) with
| (bound, sub_probs) -> begin
(match (tps) with
| [] -> begin
Some ((bound, sub_probs))
end
| TProb (hd)::tl -> begin
(match ((let _68_13820 = (compress env wl hd.rhs)
in (conjoin bound _68_13820))) with
| Some ((bound, sub)) -> begin
(make_upper_bound (bound, (Support.List.append sub sub_probs)) tl)
end
| None -> begin
None
end)
end
| _33_1821 -> begin
None
end)
end))
in (match ((let _68_13822 = (let _68_13821 = (compress env wl tp.rhs)
in (_68_13821, []))
in (make_upper_bound _68_13822 upper_bounds))) with
| None -> begin
(let _33_1823 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(Support.Microsoft.FStar.Util.print_string "No upper bounds\n")
end
| false -> begin
()
end)
in None)
end
| Some ((rhs_bound, sub_probs)) -> begin
(let eq_prob = (new_problem env tp.lhs EQ rhs_bound None tp.loc "joining refinements")
in (match ((solve_t env eq_prob (let _33_1830 = wl
in {attempting = sub_probs; deferred = _33_1830.deferred; subst = _33_1830.subst; ctr = _33_1830.ctr; slack_vars = _33_1830.slack_vars; defer_ok = _33_1830.defer_ok; smt_ok = _33_1830.smt_ok; tcenv = _33_1830.tcenv}))) with
| Success ((subst, _33_1834)) -> begin
(let wl = (let _33_1837 = wl
in {attempting = rest; deferred = _33_1837.deferred; subst = []; ctr = _33_1837.ctr; slack_vars = _33_1837.slack_vars; defer_ok = _33_1837.defer_ok; smt_ok = _33_1837.smt_ok; tcenv = _33_1837.tcenv})
in (let wl = (solve_prob (TProb (tp)) None subst wl)
in (let _33_1843 = (Support.List.fold_left (fun ( wl ) ( p ) -> (solve_prob' true p None [] wl)) wl upper_bounds)
in Some (wl))))
end
| _33_1846 -> begin
None
end))
end))
end))
end
| _33_1848 -> begin
(failwith ("Impossible: Not a flex-rigid"))
end)))))
end))
end))))
and solve = (fun ( env ) ( probs ) -> (match ((next_prob probs)) with
| (Some (hd), tl, rank) -> begin
(let probs = (let _33_1856 = probs
in {attempting = tl; deferred = _33_1856.deferred; subst = _33_1856.subst; ctr = _33_1856.ctr; slack_vars = _33_1856.slack_vars; defer_ok = _33_1856.defer_ok; smt_ok = _33_1856.smt_ok; tcenv = _33_1856.tcenv})
in (match (hd) with
| KProb (kp) -> begin
(solve_k' env (maybe_invert kp) probs)
end
| TProb (tp) -> begin
(match (((((not (probs.defer_ok)) && (flex_refine_inner <= rank)) && (rank <= flex_rigid)) && (not ((Support.ST.read Microsoft_FStar_Options.no_slack))))) with
| true -> begin
(match ((solve_flex_rigid_join env tp probs)) with
| None -> begin
(solve_t' env (maybe_invert tp) probs)
end
| Some (wl) -> begin
(solve env wl)
end)
end
| false -> begin
(solve_t' env (maybe_invert tp) probs)
end)
end
| EProb (ep) -> begin
(solve_e' env (maybe_invert ep) probs)
end
| CProb (cp) -> begin
(solve_c env (maybe_invert cp) probs)
end))
end
| (None, _33_1872, _33_1874) -> begin
(match (probs.deferred) with
| [] -> begin
Success ((probs.subst, {carry = []; slack = probs.slack_vars}))
end
| _33_1878 -> begin
(let _33_1887 = (Support.Prims.pipe_right probs.deferred (Support.List.partition (fun ( _33_1884 ) -> (match (_33_1884) with
| (c, _33_1881, _33_1883) -> begin
(c < probs.ctr)
end))))
in (match (_33_1887) with
| (attempt, rest) -> begin
(match (attempt) with
| [] -> begin
(let _68_13831 = (let _68_13830 = (let _68_13829 = (Support.List.map (fun ( _33_1893 ) -> (match (_33_1893) with
| (_33_1890, x, y) -> begin
(x, y)
end)) probs.deferred)
in {carry = _68_13829; slack = probs.slack_vars})
in (probs.subst, _68_13830))
in Success (_68_13831))
end
| _33_1895 -> begin
(let _68_13834 = (let _33_1896 = probs
in (let _68_13833 = (Support.Prims.pipe_right attempt (Support.List.map (fun ( _33_1903 ) -> (match (_33_1903) with
| (_33_1899, _33_1901, y) -> begin
y
end))))
in {attempting = _68_13833; deferred = rest; subst = _33_1896.subst; ctr = _33_1896.ctr; slack_vars = _33_1896.slack_vars; defer_ok = _33_1896.defer_ok; smt_ok = _33_1896.smt_ok; tcenv = _33_1896.tcenv}))
in (solve env _68_13834))
end)
end))
end)
end))
and solve_binders = (fun ( env ) ( bs1 ) ( bs2 ) ( orig ) ( wl ) ( rhs ) -> (let rec aux = (fun ( scope ) ( env ) ( subst ) ( xs ) ( ys ) -> (match ((xs, ys)) with
| ([], []) -> begin
(let rhs_prob = (rhs scope env subst)
in (let formula = (Support.Prims.pipe_right (p_guard rhs_prob) Support.Prims.fst)
in Support.Microsoft.FStar.Util.Inl (((rhs_prob)::[], formula))))
end
| (((Support.Microsoft.FStar.Util.Inl (_), _)::_, (Support.Microsoft.FStar.Util.Inr (_), _)::_)) | (((Support.Microsoft.FStar.Util.Inr (_), _)::_, (Support.Microsoft.FStar.Util.Inl (_), _)::_)) -> begin
Support.Microsoft.FStar.Util.Inr ("sort mismatch")
end
| (hd1::xs, hd2::ys) -> begin
(let subst = (let _68_13860 = (Microsoft_FStar_Absyn_Util.mk_subst_one_binder hd2 hd1)
in (Support.List.append _68_13860 subst))
in (let env = (let _68_13861 = (Microsoft_FStar_Tc_Env.binding_of_binder hd2)
in (Microsoft_FStar_Tc_Env.push_local_binding env _68_13861))
in (let prob = (match (((Support.Prims.fst hd1), (Support.Prims.fst hd2))) with
| (Support.Microsoft.FStar.Util.Inl (a), Support.Microsoft.FStar.Util.Inl (b)) -> begin
(let _68_13865 = (let _68_13864 = (Microsoft_FStar_Absyn_Util.subst_kind subst a.Microsoft_FStar_Absyn_Syntax.sort)
in (let _68_13863 = (Support.Prims.pipe_left invert_rel (p_rel orig))
in (mk_problem ((hd2)::scope) orig _68_13864 _68_13863 b.Microsoft_FStar_Absyn_Syntax.sort None "Formal type parameter")))
in (Support.Prims.pipe_left (fun ( _68_13862 ) -> KProb (_68_13862)) _68_13865))
end
| (Support.Microsoft.FStar.Util.Inr (x), Support.Microsoft.FStar.Util.Inr (y)) -> begin
(let _68_13869 = (let _68_13868 = (Microsoft_FStar_Absyn_Util.subst_typ subst x.Microsoft_FStar_Absyn_Syntax.sort)
in (let _68_13867 = (Support.Prims.pipe_left invert_rel (p_rel orig))
in (mk_problem ((hd2)::scope) orig _68_13868 _68_13867 y.Microsoft_FStar_Absyn_Syntax.sort None "Formal value parameter")))
in (Support.Prims.pipe_left (fun ( _68_13866 ) -> TProb (_68_13866)) _68_13869))
end
| _33_1979 -> begin
(failwith ("impos"))
end)
in (match ((aux ((hd2)::scope) env subst xs ys)) with
| Support.Microsoft.FStar.Util.Inr (msg) -> begin
Support.Microsoft.FStar.Util.Inr (msg)
end
| Support.Microsoft.FStar.Util.Inl ((sub_probs, phi)) -> begin
(let phi = (let _68_13871 = (Support.Prims.pipe_right (p_guard prob) Support.Prims.fst)
in (let _68_13870 = (Microsoft_FStar_Absyn_Util.close_forall ((hd2)::[]) phi)
in (Microsoft_FStar_Absyn_Util.mk_conj _68_13871 _68_13870)))
in Support.Microsoft.FStar.Util.Inl (((prob)::sub_probs, phi)))
end))))
end
| _33_1989 -> begin
Support.Microsoft.FStar.Util.Inr ("arity mismatch")
end))
in (let scope = (Microsoft_FStar_Tc_Env.binders env)
in (match ((aux scope env [] bs1 bs2)) with
| Support.Microsoft.FStar.Util.Inr (msg) -> begin
(giveup env msg orig)
end
| Support.Microsoft.FStar.Util.Inl ((sub_probs, phi)) -> begin
(let wl = (solve_prob orig (Some (phi)) [] wl)
in (solve env (attempt sub_probs wl)))
end))))
and solve_k = (fun ( env ) ( problem ) ( wl ) -> (match ((compress_prob wl (KProb (problem)))) with
| KProb (p) -> begin
(solve_k' env p wl)
end
| _33_2004 -> begin
(failwith ("impossible"))
end))
and solve_k' = (fun ( env ) ( problem ) ( wl ) -> (let orig = KProb (problem)
in (match ((Support.Microsoft.FStar.Util.physical_equality problem.lhs problem.rhs)) with
| true -> begin
(let _68_13878 = (solve_prob orig None [] wl)
in (solve env _68_13878))
end
| false -> begin
(let k1 = problem.lhs
in (let k2 = problem.rhs
in (match ((Support.Microsoft.FStar.Util.physical_equality k1 k2)) with
| true -> begin
(let _68_13879 = (solve_prob orig None [] wl)
in (solve env _68_13879))
end
| false -> begin
(let r = (Microsoft_FStar_Tc_Env.get_range env)
in (let imitate_k = (fun ( _33_2020 ) -> (match (_33_2020) with
| (rel, u, ps, xs, (h, qs)) -> begin
(let r = (Microsoft_FStar_Tc_Env.get_range env)
in (let _33_2025 = (imitation_sub_probs orig env xs ps qs)
in (match (_33_2025) with
| (sub_probs, gs_xs, f) -> begin
(let im = (let _68_13895 = (let _68_13894 = (h gs_xs)
in (xs, _68_13894))
in (Microsoft_FStar_Absyn_Syntax.mk_Kind_lam _68_13895 r))
in (let wl = (solve_prob orig (Some (f)) ((UK ((u, im)))::[]) wl)
in (solve env (attempt sub_probs wl))))
end)))
end))
in (let flex_rigid = (fun ( rel ) ( u ) ( args ) ( k ) -> (let maybe_vars1 = (pat_vars env [] args)
in (match (maybe_vars1) with
| Some (xs) -> begin
(let fvs1 = (Microsoft_FStar_Absyn_Syntax.freevars_of_binders xs)
in (let fvs2 = (Microsoft_FStar_Absyn_Util.freevars_kind k2)
in (let uvs2 = (Microsoft_FStar_Absyn_Util.uvars_in_kind k2)
in (match ((((Support.Microsoft.FStar.Util.set_is_subset_of fvs2.Microsoft_FStar_Absyn_Syntax.ftvs fvs1.Microsoft_FStar_Absyn_Syntax.ftvs) && (Support.Microsoft.FStar.Util.set_is_subset_of fvs2.Microsoft_FStar_Absyn_Syntax.fxvs fvs1.Microsoft_FStar_Absyn_Syntax.fxvs)) && (not ((Support.Microsoft.FStar.Util.set_mem u uvs2.Microsoft_FStar_Absyn_Syntax.uvars_k))))) with
| true -> begin
(let k1 = (Microsoft_FStar_Absyn_Syntax.mk_Kind_lam (xs, k2) r)
in (let _68_13904 = (solve_prob orig None ((UK ((u, k1)))::[]) wl)
in (solve env _68_13904)))
end
| false -> begin
(let _68_13909 = (let _68_13908 = (Support.Prims.pipe_right xs Microsoft_FStar_Absyn_Util.args_of_non_null_binders)
in (let _68_13907 = (decompose_kind env k)
in (rel, u, _68_13908, xs, _68_13907)))
in (imitate_k _68_13909))
end))))
end
| None -> begin
(giveup env "flex-rigid: not a pattern" (KProb (problem)))
end)))
in (match ((k1.Microsoft_FStar_Absyn_Syntax.n, k2.Microsoft_FStar_Absyn_Syntax.n)) with
| ((Microsoft_FStar_Absyn_Syntax.Kind_type, Microsoft_FStar_Absyn_Syntax.Kind_type)) | ((Microsoft_FStar_Absyn_Syntax.Kind_effect, Microsoft_FStar_Absyn_Syntax.Kind_effect)) -> begin
(let _68_13910 = (solve_prob orig None [] wl)
in (Support.Prims.pipe_left (solve env) _68_13910))
end
| (Microsoft_FStar_Absyn_Syntax.Kind_abbrev ((_33_2048, k1)), _33_2053) -> begin
(solve_k env (let _33_2055 = problem
in {lhs = k1; relation = _33_2055.relation; rhs = _33_2055.rhs; element = _33_2055.element; logical_guard = _33_2055.logical_guard; scope = _33_2055.scope; reason = _33_2055.reason; loc = _33_2055.loc; rank = _33_2055.rank}) wl)
end
| (_33_2058, Microsoft_FStar_Absyn_Syntax.Kind_abbrev ((_33_2060, k2))) -> begin
(solve_k env (let _33_2065 = problem
in {lhs = _33_2065.lhs; relation = _33_2065.relation; rhs = k2; element = _33_2065.element; logical_guard = _33_2065.logical_guard; scope = _33_2065.scope; reason = _33_2065.reason; loc = _33_2065.loc; rank = _33_2065.rank}) wl)
end
| (Microsoft_FStar_Absyn_Syntax.Kind_arrow ((bs1, k1')), Microsoft_FStar_Absyn_Syntax.Kind_arrow ((bs2, k2'))) -> begin
(let sub_prob = (fun ( scope ) ( env ) ( subst ) -> (let _68_13919 = (let _68_13918 = (Microsoft_FStar_Absyn_Util.subst_kind subst k1')
in (mk_problem scope orig _68_13918 problem.relation k2' None "Arrow-kind result"))
in (Support.Prims.pipe_left (fun ( _68_13917 ) -> KProb (_68_13917)) _68_13919)))
in (solve_binders env bs1 bs2 orig wl sub_prob))
end
| (Microsoft_FStar_Absyn_Syntax.Kind_uvar ((u1, args1)), Microsoft_FStar_Absyn_Syntax.Kind_uvar ((u2, args2))) -> begin
(let maybe_vars1 = (pat_vars env [] args1)
in (let maybe_vars2 = (pat_vars env [] args2)
in (match ((maybe_vars1, maybe_vars2)) with
| ((None, _)) | ((_, None)) -> begin
(giveup env "flex-flex: non patterns" (KProb (problem)))
end
| (Some (xs), Some (ys)) -> begin
(match (((Support.Microsoft.FStar.Unionfind.equivalent u1 u2) && (binders_eq xs ys))) with
| true -> begin
(solve env wl)
end
| false -> begin
(let zs = (intersect_vars xs ys)
in (let _33_2108 = (new_kvar r zs)
in (match (_33_2108) with
| (u, _33_2107) -> begin
(let k1 = (Microsoft_FStar_Absyn_Syntax.mk_Kind_lam (xs, u) r)
in (let k2 = (Microsoft_FStar_Absyn_Syntax.mk_Kind_lam (ys, u) r)
in (let wl = (solve_prob orig None ((UK ((u1, k1)))::(UK ((u2, k2)))::[]) wl)
in (solve env wl))))
end)))
end)
end)))
end
| (Microsoft_FStar_Absyn_Syntax.Kind_uvar ((u, args)), _33_2117) -> begin
(flex_rigid problem.relation u args k2)
end
| (_33_2120, Microsoft_FStar_Absyn_Syntax.Kind_uvar ((u, args))) -> begin
(flex_rigid (invert_rel problem.relation) u args k1)
end
| ((Microsoft_FStar_Absyn_Syntax.Kind_delayed (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Kind_unknown, _)) | ((_, Microsoft_FStar_Absyn_Syntax.Kind_delayed (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Kind_unknown)) -> begin
(failwith ("Impossible"))
end
| _33_2147 -> begin
(giveup env "head mismatch (k-1)" (KProb (problem)))
end))))
end)))
end)))
and solve_t = (fun ( env ) ( problem ) ( wl ) -> (let p = (compress_prob wl (TProb (problem)))
in (match (p) with
| TProb (p) -> begin
(solve_t' env p wl)
end
| _33_2155 -> begin
(failwith ("Impossible"))
end)))
and solve_t' = (fun ( env ) ( problem ) ( wl ) -> (let giveup_or_defer = (fun ( orig ) ( msg ) -> (match (wl.defer_ok) with
| true -> begin
(let _33_2162 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_13930 = (prob_to_string env orig)
in (Support.Microsoft.FStar.Util.fprint2 "\n\t\tDeferring %s\n\t\tBecause %s\n" _68_13930 msg))
end
| false -> begin
()
end)
in (solve env (defer msg orig wl)))
end
| false -> begin
(giveup env msg orig)
end))
in (let imitate_t = (fun ( orig ) ( env ) ( wl ) ( p ) -> (let _33_2179 = p
in (match (_33_2179) with
| ((u, k), ps, xs, (h, _33_2176, qs)) -> begin
(let xs = (sn_binders env xs)
in (let r = (Microsoft_FStar_Tc_Env.get_range env)
in (let _33_2185 = (imitation_sub_probs orig env xs ps qs)
in (match (_33_2185) with
| (sub_probs, gs_xs, formula) -> begin
(let im = (let _68_13942 = (let _68_13941 = (h gs_xs)
in (xs, _68_13941))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam' _68_13942 None r))
in (let _33_2187 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_13947 = (Microsoft_FStar_Absyn_Print.typ_to_string im)
in (let _68_13946 = (Microsoft_FStar_Absyn_Print.tag_of_typ im)
in (let _68_13945 = (let _68_13943 = (Support.List.map (prob_to_string env) sub_probs)
in (Support.Prims.pipe_right _68_13943 (Support.String.concat ", ")))
in (let _68_13944 = (Microsoft_FStar_Tc_Normalize.formula_norm_to_string env formula)
in (Support.Microsoft.FStar.Util.fprint4 "Imitating %s (%s)\nsub_probs = %s\nformula=%s\n" _68_13947 _68_13946 _68_13945 _68_13944)))))
end
| false -> begin
()
end)
in (let wl = (solve_prob orig (Some (formula)) ((UT (((u, k), im)))::[]) wl)
in (solve env (attempt sub_probs wl)))))
end))))
end)))
in (let project_t = (fun ( orig ) ( env ) ( wl ) ( i ) ( p ) -> (let _33_2203 = p
in (match (_33_2203) with
| (u, ps, xs, (h, matches, qs)) -> begin
(let r = (Microsoft_FStar_Tc_Env.get_range env)
in (let pi = (Support.List.nth ps i)
in (let rec gs = (fun ( k ) -> (let _33_2210 = (Microsoft_FStar_Absyn_Util.kind_formals k)
in (match (_33_2210) with
| (bs, k) -> begin
(let rec aux = (fun ( subst ) ( bs ) -> (match (bs) with
| [] -> begin
([], [])
end
| hd::tl -> begin
(let _33_2239 = (match ((Support.Prims.fst hd)) with
| Support.Microsoft.FStar.Util.Inl (a) -> begin
(let k_a = (Microsoft_FStar_Absyn_Util.subst_kind subst a.Microsoft_FStar_Absyn_Syntax.sort)
in (let _33_2223 = (new_tvar r xs k_a)
in (match (_33_2223) with
| (gi_xs, gi) -> begin
(let gi_xs = (Microsoft_FStar_Tc_Normalize.eta_expand env gi_xs)
in (let gi_ps = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app (gi, ps) (Some (k_a)) r)
in (let subst = (match ((Microsoft_FStar_Absyn_Syntax.is_null_binder hd)) with
| true -> begin
subst
end
| false -> begin
(Support.Microsoft.FStar.Util.Inl ((a.Microsoft_FStar_Absyn_Syntax.v, gi_xs)))::subst
end)
in (let _68_13967 = (Microsoft_FStar_Absyn_Syntax.targ gi_xs)
in (let _68_13966 = (Microsoft_FStar_Absyn_Syntax.targ gi_ps)
in (_68_13967, _68_13966, subst))))))
end)))
end
| Support.Microsoft.FStar.Util.Inr (x) -> begin
(let t_x = (Microsoft_FStar_Absyn_Util.subst_typ subst x.Microsoft_FStar_Absyn_Syntax.sort)
in (let _33_2232 = (new_evar r xs t_x)
in (match (_33_2232) with
| (gi_xs, gi) -> begin
(let gi_xs = (Microsoft_FStar_Tc_Normalize.eta_expand_exp env gi_xs)
in (let gi_ps = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app (gi, ps) (Some (t_x)) r)
in (let subst = (match ((Microsoft_FStar_Absyn_Syntax.is_null_binder hd)) with
| true -> begin
subst
end
| false -> begin
(Support.Microsoft.FStar.Util.Inr ((x.Microsoft_FStar_Absyn_Syntax.v, gi_xs)))::subst
end)
in (let _68_13969 = (Microsoft_FStar_Absyn_Syntax.varg gi_xs)
in (let _68_13968 = (Microsoft_FStar_Absyn_Syntax.varg gi_ps)
in (_68_13969, _68_13968, subst))))))
end)))
end)
in (match (_33_2239) with
| (gi_xs, gi_ps, subst) -> begin
(let _33_2242 = (aux subst tl)
in (match (_33_2242) with
| (gi_xs', gi_ps') -> begin
((gi_xs)::gi_xs', (gi_ps)::gi_ps')
end))
end))
end))
in (aux [] bs))
end)))
in (match ((let _68_13971 = (let _68_13970 = (Support.List.nth xs i)
in (Support.Prims.pipe_left Support.Prims.fst _68_13970))
in ((Support.Prims.fst pi), _68_13971))) with
| (Support.Microsoft.FStar.Util.Inl (pi), Support.Microsoft.FStar.Util.Inl (xi)) -> begin
(match ((let _68_13972 = (matches pi)
in (Support.Prims.pipe_left Support.Prims.op_Negation _68_13972))) with
| true -> begin
None
end
| false -> begin
(let _33_2251 = (gs xi.Microsoft_FStar_Absyn_Syntax.sort)
in (match (_33_2251) with
| (g_xs, _33_2250) -> begin
(let xi = (Microsoft_FStar_Absyn_Util.btvar_to_typ xi)
in (let proj = (let _68_13974 = (let _68_13973 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app' (xi, g_xs) (Some (Microsoft_FStar_Absyn_Syntax.ktype)) r)
in (xs, _68_13973))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam _68_13974 None r))
in (let sub = (let _68_13980 = (let _68_13979 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app' (proj, ps) (Some (Microsoft_FStar_Absyn_Syntax.ktype)) r)
in (let _68_13978 = (let _68_13977 = (Support.List.map (fun ( _33_2259 ) -> (match (_33_2259) with
| (_33_2255, _33_2257, y) -> begin
y
end)) qs)
in (Support.Prims.pipe_left h _68_13977))
in (mk_problem (p_scope orig) orig _68_13979 (p_rel orig) _68_13978 None "projection")))
in (Support.Prims.pipe_left (fun ( _68_13975 ) -> TProb (_68_13975)) _68_13980))
in (let _33_2261 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_13982 = (Microsoft_FStar_Absyn_Print.typ_to_string proj)
in (let _68_13981 = (prob_to_string env sub)
in (Support.Microsoft.FStar.Util.fprint2 "Projecting %s\n\tsubprob=%s\n" _68_13982 _68_13981)))
end
| false -> begin
()
end)
in (let wl = (let _68_13984 = (let _68_13983 = (Support.Prims.pipe_left Support.Prims.fst (p_guard sub))
in Some (_68_13983))
in (solve_prob orig _68_13984 ((UT ((u, proj)))::[]) wl))
in (let _68_13986 = (solve env (attempt ((sub)::[]) wl))
in (Support.Prims.pipe_left (fun ( _68_13985 ) -> Some (_68_13985)) _68_13986)))))))
end))
end)
end
| _33_2265 -> begin
None
end))))
end)))
in (let solve_t_flex_rigid = (fun ( orig ) ( lhs ) ( t2 ) ( wl ) -> (let _33_2277 = lhs
in (match (_33_2277) with
| ((t1, uv, k, args_lhs), maybe_pat_vars) -> begin
(let subterms = (fun ( ps ) -> (let xs = (let _68_14013 = (Microsoft_FStar_Absyn_Util.kind_formals k)
in (Support.Prims.pipe_right _68_14013 Support.Prims.fst))
in (let xs = (Microsoft_FStar_Absyn_Util.name_binders xs)
in (let _68_14018 = (decompose_typ env t2)
in ((uv, k), ps, xs, _68_14018)))))
in (let rec imitate_or_project = (fun ( n ) ( st ) ( i ) -> (match ((i >= n)) with
| true -> begin
(giveup env "flex-rigid case failed all backtracking attempts" orig)
end
| false -> begin
(match ((i = (- (1)))) with
| true -> begin
(match ((imitate_t orig env wl st)) with
| Failed (_33_2287) -> begin
(imitate_or_project n st (i + 1))
end
| sol -> begin
sol
end)
end
| false -> begin
(match ((project_t orig env wl i st)) with
| (None) | (Some (Failed (_))) -> begin
(imitate_or_project n st (i + 1))
end
| Some (sol) -> begin
sol
end)
end)
end))
in (let check_head = (fun ( fvs1 ) ( t2 ) -> (let _33_2303 = (Microsoft_FStar_Absyn_Util.head_and_args t2)
in (match (_33_2303) with
| (hd, _33_2302) -> begin
(match (hd.Microsoft_FStar_Absyn_Syntax.n) with
| (Microsoft_FStar_Absyn_Syntax.Typ_fun (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_const (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_lam (_)) -> begin
true
end
| _33_2314 -> begin
(let fvs_hd = (Microsoft_FStar_Absyn_Util.freevars_typ hd)
in (match ((Microsoft_FStar_Absyn_Util.fvs_included fvs_hd fvs1)) with
| true -> begin
true
end
| false -> begin
(let _33_2316 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14029 = (Microsoft_FStar_Absyn_Print.freevars_to_string fvs_hd)
in (Support.Microsoft.FStar.Util.fprint1 "Free variables are %s" _68_14029))
end
| false -> begin
()
end)
in false)
end))
end)
end)))
in (let imitate_ok = (fun ( t2 ) -> (let fvs_hd = (let _68_14033 = (let _68_14032 = (Microsoft_FStar_Absyn_Util.head_and_args t2)
in (Support.Prims.pipe_right _68_14032 Support.Prims.fst))
in (Support.Prims.pipe_right _68_14033 Microsoft_FStar_Absyn_Util.freevars_typ))
in (match ((Support.Microsoft.FStar.Util.set_is_empty fvs_hd.Microsoft_FStar_Absyn_Syntax.ftvs)) with
| true -> begin
(- (1))
end
| false -> begin
0
end)))
in (match (maybe_pat_vars) with
| Some (vars) -> begin
(let t1 = (sn env t1)
in (let t2 = (sn env t2)
in (let fvs1 = (Microsoft_FStar_Absyn_Util.freevars_typ t1)
in (let fvs2 = (Microsoft_FStar_Absyn_Util.freevars_typ t2)
in (let _33_2329 = (occurs_check env wl (uv, k) t2)
in (match (_33_2329) with
| (occurs_ok, msg) -> begin
(match ((not (occurs_ok))) with
| true -> begin
(let _68_14035 = (let _68_14034 = (Support.Option.get msg)
in (Support.String.strcat "occurs-check failed: " _68_14034))
in (giveup_or_defer orig _68_14035))
end
| false -> begin
(match ((Microsoft_FStar_Absyn_Util.fvs_included fvs2 fvs1)) with
| true -> begin
(match (((Microsoft_FStar_Absyn_Util.is_function_typ t2) && ((p_rel orig) <> EQ))) with
| true -> begin
(let _68_14036 = (subterms args_lhs)
in (imitate_t orig env wl _68_14036))
end
| false -> begin
(let _33_2330 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14039 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (let _68_14038 = (Microsoft_FStar_Absyn_Print.freevars_to_string fvs1)
in (let _68_14037 = (Microsoft_FStar_Absyn_Print.freevars_to_string fvs2)
in (Support.Microsoft.FStar.Util.fprint3 "Pattern %s with fvars=%s succeeded fvar check: %s\n" _68_14039 _68_14038 _68_14037))))
end
| false -> begin
()
end)
in (let sol = (match (vars) with
| [] -> begin
t2
end
| _33_2334 -> begin
(let _68_14041 = (let _68_14040 = (sn_binders env vars)
in (_68_14040, t2))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam _68_14041 None t1.Microsoft_FStar_Absyn_Syntax.pos))
end)
in (let wl = (solve_prob orig None ((UT (((uv, k), sol)))::[]) wl)
in (solve env wl))))
end)
end
| false -> begin
(match (wl.defer_ok) with
| true -> begin
(solve env (defer "flex pattern/rigid: occurs or freevar check" orig wl))
end
| false -> begin
(match ((check_head fvs1 t2)) with
| true -> begin
(let _33_2337 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14044 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (let _68_14043 = (Microsoft_FStar_Absyn_Print.freevars_to_string fvs1)
in (let _68_14042 = (Microsoft_FStar_Absyn_Print.freevars_to_string fvs2)
in (Support.Microsoft.FStar.Util.fprint3 "Pattern %s with fvars=%s failed fvar check: %s ... imitating\n" _68_14044 _68_14043 _68_14042))))
end
| false -> begin
()
end)
in (let _68_14045 = (subterms args_lhs)
in (imitate_or_project (Support.List.length args_lhs) _68_14045 (- (1)))))
end
| false -> begin
(giveup env "free-variable check failed on a non-redex" orig)
end)
end)
end)
end)
end))))))
end
| None -> begin
(match (wl.defer_ok) with
| true -> begin
(solve env (defer "not a pattern" orig wl))
end
| false -> begin
(match ((let _68_14046 = (Microsoft_FStar_Absyn_Util.freevars_typ t1)
in (check_head _68_14046 t2))) with
| true -> begin
(let im_ok = (imitate_ok t2)
in (let _33_2341 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14047 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (Support.Microsoft.FStar.Util.fprint2 "Not a pattern (%s) ... %s\n" _68_14047 (match ((im_ok < 0)) with
| true -> begin
"imitating"
end
| false -> begin
"projecting"
end)))
end
| false -> begin
()
end)
in (let _68_14048 = (subterms args_lhs)
in (imitate_or_project (Support.List.length args_lhs) _68_14048 im_ok))))
end
| false -> begin
(giveup env "head-symbol is free" orig)
end)
end)
end)))))
end)))
in (let flex_flex = (fun ( orig ) ( lhs ) ( rhs ) -> (match ((wl.defer_ok && ((p_rel orig) <> EQ))) with
| true -> begin
(solve env (defer "flex-flex deferred" orig wl))
end
| false -> begin
(let force_quasi_pattern = (fun ( xs_opt ) ( _33_2353 ) -> (match (_33_2353) with
| (t, u, k, args) -> begin
(let rec aux = (fun ( binders ) ( ys ) ( args ) -> (match (args) with
| [] -> begin
(let ys = (Support.List.rev ys)
in (let binders = (Support.List.rev binders)
in (let kk = (Microsoft_FStar_Tc_Recheck.recompute_kind t)
in (let _33_2365 = (new_tvar t.Microsoft_FStar_Absyn_Syntax.pos ys kk)
in (match (_33_2365) with
| (t', _33_2364) -> begin
(let _33_2371 = (destruct_flex_t t')
in (match (_33_2371) with
| (u1_ys, u1, k1, _33_2370) -> begin
(let sol = (let _68_14066 = (let _68_14065 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam (binders, u1_ys) (Some (k)) t.Microsoft_FStar_Absyn_Syntax.pos)
in ((u, k), _68_14065))
in UT (_68_14066))
in (sol, (t', u, k1, ys)))
end))
end)))))
end
| hd::tl -> begin
(let new_binder = (fun ( hd ) -> (match ((Support.Prims.fst hd)) with
| Support.Microsoft.FStar.Util.Inl (a) -> begin
(let _68_14070 = (let _68_14069 = (Microsoft_FStar_Tc_Recheck.recompute_kind a)
in (Support.Prims.pipe_right _68_14069 (Microsoft_FStar_Absyn_Util.gen_bvar_p a.Microsoft_FStar_Absyn_Syntax.pos)))
in (Support.Prims.pipe_right _68_14070 Microsoft_FStar_Absyn_Syntax.t_binder))
end
| Support.Microsoft.FStar.Util.Inr (x) -> begin
(let _68_14072 = (let _68_14071 = (Microsoft_FStar_Tc_Recheck.recompute_typ x)
in (Support.Prims.pipe_right _68_14071 (Microsoft_FStar_Absyn_Util.gen_bvar_p x.Microsoft_FStar_Absyn_Syntax.pos)))
in (Support.Prims.pipe_right _68_14072 Microsoft_FStar_Absyn_Syntax.v_binder))
end))
in (let _33_2390 = (match ((pat_var_opt env ys hd)) with
| None -> begin
(let _68_14073 = (new_binder hd)
in (_68_14073, ys))
end
| Some (y) -> begin
(match (xs_opt) with
| None -> begin
(y, (y)::ys)
end
| Some (xs) -> begin
(match ((Support.Prims.pipe_right xs (Support.Microsoft.FStar.Util.for_some (Microsoft_FStar_Absyn_Util.eq_binder y)))) with
| true -> begin
(y, (y)::ys)
end
| false -> begin
(let _68_14074 = (new_binder hd)
in (_68_14074, ys))
end)
end)
end)
in (match (_33_2390) with
| (binder, ys) -> begin
(aux ((binder)::binders) ys tl)
end)))
end))
in (aux [] [] args))
end))
in (let solve_both_pats = (fun ( wl ) ( _33_2396 ) ( _33_2400 ) ( k ) ( r ) -> (match ((_33_2396, _33_2400)) with
| ((u1, k1, xs), (u2, k2, ys)) -> begin
(match (((Support.Microsoft.FStar.Unionfind.equivalent u1 u2) && (binders_eq xs ys))) with
| true -> begin
(let _68_14085 = (solve_prob orig None [] wl)
in (solve env _68_14085))
end
| false -> begin
(let xs = (sn_binders env xs)
in (let ys = (sn_binders env ys)
in (let zs = (intersect_vars xs ys)
in (let _33_2409 = (new_tvar r zs k)
in (match (_33_2409) with
| (u_zs, _33_2408) -> begin
(let sub1 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam' (xs, u_zs) (Some (k1)) r)
in (let _33_2413 = (occurs_check env wl (u1, k1) sub1)
in (match (_33_2413) with
| (occurs_ok, msg) -> begin
(match ((not (occurs_ok))) with
| true -> begin
(giveup_or_defer orig "flex-flex: failed occcurs check")
end
| false -> begin
(let sol1 = UT (((u1, k1), sub1))
in (match ((Support.Microsoft.FStar.Unionfind.equivalent u1 u2)) with
| true -> begin
(let wl = (solve_prob orig None ((sol1)::[]) wl)
in (solve env wl))
end
| false -> begin
(let sub2 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam' (ys, u_zs) (Some (k2)) r)
in (let _33_2419 = (occurs_check env wl (u2, k2) sub2)
in (match (_33_2419) with
| (occurs_ok, msg) -> begin
(match ((not (occurs_ok))) with
| true -> begin
(giveup_or_defer orig "flex-flex: failed occurs check")
end
| false -> begin
(let sol2 = UT (((u2, k2), sub2))
in (let wl = (solve_prob orig None ((sol1)::(sol2)::[]) wl)
in (solve env wl)))
end)
end)))
end))
end)
end)))
end)))))
end)
end))
in (let solve_one_pat = (fun ( _33_2427 ) ( _33_2432 ) -> (match ((_33_2427, _33_2432)) with
| ((t1, u1, k1, xs), (t2, u2, k2, args2)) -> begin
(let _33_2433 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14091 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (let _68_14090 = (Microsoft_FStar_Absyn_Print.typ_to_string t2)
in (Support.Microsoft.FStar.Util.fprint2 "Trying flex-flex one pattern (%s) with %s\n" _68_14091 _68_14090)))
end
| false -> begin
()
end)
in (match ((Support.Microsoft.FStar.Unionfind.equivalent u1 u2)) with
| true -> begin
(let sub_probs = (Support.List.map2 (fun ( a ) ( b ) -> (let a = (Microsoft_FStar_Absyn_Util.arg_of_non_null_binder a)
in (match (((Support.Prims.fst a), (Support.Prims.fst b))) with
| (Support.Microsoft.FStar.Util.Inl (t1), Support.Microsoft.FStar.Util.Inl (t2)) -> begin
(let _68_14095 = (mk_problem (p_scope orig) orig t1 EQ t2 None "flex-flex index")
in (Support.Prims.pipe_right _68_14095 (fun ( _68_14094 ) -> TProb (_68_14094))))
end
| (Support.Microsoft.FStar.Util.Inr (t1), Support.Microsoft.FStar.Util.Inr (t2)) -> begin
(let _68_14097 = (mk_problem (p_scope orig) orig t1 EQ t2 None "flex-flex index")
in (Support.Prims.pipe_right _68_14097 (fun ( _68_14096 ) -> EProb (_68_14096))))
end
| _33_2449 -> begin
(failwith ("Impossible"))
end))) xs args2)
in (let guard = (let _68_14099 = (Support.List.map (fun ( p ) -> (Support.Prims.pipe_right (p_guard p) Support.Prims.fst)) sub_probs)
in (Microsoft_FStar_Absyn_Util.mk_conj_l _68_14099))
in (let wl = (solve_prob orig (Some (guard)) [] wl)
in (solve env (attempt sub_probs wl)))))
end
| false -> begin
(let t2 = (sn env t2)
in (let rhs_vars = (Microsoft_FStar_Absyn_Util.freevars_typ t2)
in (let _33_2459 = (occurs_check env wl (u1, k1) t2)
in (match (_33_2459) with
| (occurs_ok, _33_2458) -> begin
(let lhs_vars = (Microsoft_FStar_Absyn_Syntax.freevars_of_binders xs)
in (match ((occurs_ok && (Microsoft_FStar_Absyn_Util.fvs_included rhs_vars lhs_vars))) with
| true -> begin
(let sol = (let _68_14101 = (let _68_14100 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam' (xs, t2) (Some (k1)) t1.Microsoft_FStar_Absyn_Syntax.pos)
in ((u1, k1), _68_14100))
in UT (_68_14101))
in (let wl = (solve_prob orig None ((sol)::[]) wl)
in (solve env wl)))
end
| false -> begin
(match ((occurs_ok && (Support.Prims.pipe_left Support.Prims.op_Negation wl.defer_ok))) with
| true -> begin
(let _33_2470 = (force_quasi_pattern (Some (xs)) (t2, u2, k2, args2))
in (match (_33_2470) with
| (sol, (_33_2465, u2, k2, ys)) -> begin
(let wl = (extend_solution sol wl)
in (let _33_2472 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("QuasiPattern")))) with
| true -> begin
(let _68_14102 = (uvi_to_string env sol)
in (Support.Microsoft.FStar.Util.fprint1 "flex-flex quasi pattern (2): %s\n" _68_14102))
end
| false -> begin
()
end)
in (match (orig) with
| TProb (p) -> begin
(solve_t env p wl)
end
| _33_2477 -> begin
(giveup env "impossible" orig)
end)))
end))
end
| false -> begin
(giveup_or_defer orig "flex-flex constraint")
end)
end))
end))))
end))
end))
in (let _33_2482 = lhs
in (match (_33_2482) with
| (t1, u1, k1, args1) -> begin
(let _33_2487 = rhs
in (match (_33_2487) with
| (t2, u2, k2, args2) -> begin
(let maybe_pat_vars1 = (pat_vars env [] args1)
in (let maybe_pat_vars2 = (pat_vars env [] args2)
in (let r = t2.Microsoft_FStar_Absyn_Syntax.pos
in (match ((maybe_pat_vars1, maybe_pat_vars2)) with
| (Some (xs), Some (ys)) -> begin
(let _68_14103 = (Microsoft_FStar_Tc_Recheck.recompute_kind t2)
in (solve_both_pats wl (u1, k1, xs) (u2, k2, ys) _68_14103 t2.Microsoft_FStar_Absyn_Syntax.pos))
end
| (Some (xs), None) -> begin
(solve_one_pat (t1, u1, k1, xs) rhs)
end
| (None, Some (ys)) -> begin
(solve_one_pat (t2, u2, k2, ys) lhs)
end
| _33_2505 -> begin
(match (wl.defer_ok) with
| true -> begin
(giveup_or_defer orig "flex-flex: neither side is a pattern")
end
| false -> begin
(let _33_2509 = (force_quasi_pattern None (t1, u1, k1, args1))
in (match (_33_2509) with
| (sol, _33_2508) -> begin
(let wl = (extend_solution sol wl)
in (let _33_2511 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("QuasiPattern")))) with
| true -> begin
(let _68_14104 = (uvi_to_string env sol)
in (Support.Microsoft.FStar.Util.fprint1 "flex-flex quasi pattern (1): %s\n" _68_14104))
end
| false -> begin
()
end)
in (match (orig) with
| TProb (p) -> begin
(solve_t env p wl)
end
| _33_2516 -> begin
(giveup env "impossible" orig)
end)))
end))
end)
end))))
end))
end)))))
end))
in (let orig = TProb (problem)
in (match ((Support.Microsoft.FStar.Util.physical_equality problem.lhs problem.rhs)) with
| true -> begin
(let _68_14105 = (solve_prob orig None [] wl)
in (solve env _68_14105))
end
| false -> begin
(let t1 = problem.lhs
in (let t2 = problem.rhs
in (match ((Support.Microsoft.FStar.Util.physical_equality t1 t2)) with
| true -> begin
(let _68_14106 = (solve_prob orig None [] wl)
in (solve env _68_14106))
end
| false -> begin
(let _33_2520 = (match ((Microsoft_FStar_Tc_Env.debug env (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14109 = (prob_to_string env orig)
in (let _68_14108 = (let _68_14107 = (Support.List.map (uvi_to_string wl.tcenv) wl.subst)
in (Support.Prims.pipe_right _68_14107 (Support.String.concat "; ")))
in (Support.Microsoft.FStar.Util.fprint2 "Attempting %s\n\tSubst is %s\n" _68_14109 _68_14108)))
end
| false -> begin
()
end)
in (let r = (Microsoft_FStar_Tc_Env.get_range env)
in (let match_num_binders = (fun ( _33_2525 ) ( _33_2528 ) -> (match ((_33_2525, _33_2528)) with
| ((bs1, mk_cod1), (bs2, mk_cod2)) -> begin
(let curry = (fun ( n ) ( bs ) ( mk_cod ) -> (let _33_2535 = (Support.Microsoft.FStar.Util.first_N n bs)
in (match (_33_2535) with
| (bs, rest) -> begin
(let _68_14139 = (mk_cod rest)
in (bs, _68_14139))
end)))
in (let l1 = (Support.List.length bs1)
in (let l2 = (Support.List.length bs2)
in (match ((l1 = l2)) with
| true -> begin
(let _68_14143 = (let _68_14140 = (mk_cod1 [])
in (bs1, _68_14140))
in (let _68_14142 = (let _68_14141 = (mk_cod2 [])
in (bs2, _68_14141))
in (_68_14143, _68_14142)))
end
| false -> begin
(match ((l1 > l2)) with
| true -> begin
(let _68_14146 = (curry l2 bs1 mk_cod1)
in (let _68_14145 = (let _68_14144 = (mk_cod2 [])
in (bs2, _68_14144))
in (_68_14146, _68_14145)))
end
| false -> begin
(let _68_14149 = (let _68_14147 = (mk_cod1 [])
in (bs1, _68_14147))
in (let _68_14148 = (curry l1 bs2 mk_cod2)
in (_68_14149, _68_14148)))
end)
end))))
end))
in (match ((t1.Microsoft_FStar_Absyn_Syntax.n, t2.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Typ_btvar (a), Microsoft_FStar_Absyn_Syntax.Typ_btvar (b)) -> begin
(match ((Microsoft_FStar_Absyn_Util.bvd_eq a.Microsoft_FStar_Absyn_Syntax.v b.Microsoft_FStar_Absyn_Syntax.v)) with
| true -> begin
(let _68_14150 = (solve_prob orig None [] wl)
in (solve env _68_14150))
end
| false -> begin
(let _68_14154 = (let _68_14153 = (let _68_14152 = (Microsoft_FStar_Absyn_Util.mk_eq_typ t1 t2)
in (Support.Prims.pipe_left (fun ( _68_14151 ) -> Some (_68_14151)) _68_14152))
in (solve_prob orig _68_14153 [] wl))
in (solve env _68_14154))
end)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_fun ((bs1, c1)), Microsoft_FStar_Absyn_Syntax.Typ_fun ((bs2, c2))) -> begin
(let mk_c = (fun ( c ) ( _33_31 ) -> (match (_33_31) with
| [] -> begin
c
end
| bs -> begin
(let _68_14159 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_fun (bs, c) None c.Microsoft_FStar_Absyn_Syntax.pos)
in (Microsoft_FStar_Absyn_Syntax.mk_Total _68_14159))
end))
in (let _33_2566 = (match_num_binders (bs1, (mk_c c1)) (bs2, (mk_c c2)))
in (match (_33_2566) with
| ((bs1, c1), (bs2, c2)) -> begin
(solve_binders env bs1 bs2 orig wl (fun ( scope ) ( env ) ( subst ) -> (let c1 = (Microsoft_FStar_Absyn_Util.subst_comp subst c1)
in (let rel = (match ((Support.ST.read Microsoft_FStar_Options.use_eq_at_higher_order)) with
| true -> begin
EQ
end
| false -> begin
problem.relation
end)
in (let _33_2572 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("EQ")))) with
| true -> begin
(let _68_14166 = (let _68_14165 = (Microsoft_FStar_Tc_Env.get_range env)
in (Support.Prims.pipe_right _68_14165 Support.Microsoft.FStar.Range.string_of_range))
in (Support.Microsoft.FStar.Util.fprint2 "(%s) Using relation %s at higher order\n" _68_14166 (rel_to_string rel)))
end
| false -> begin
()
end)
in (let _68_14168 = (mk_problem scope orig c1 rel c2 None "function co-domain")
in (Support.Prims.pipe_left (fun ( _68_14167 ) -> CProb (_68_14167)) _68_14168)))))))
end)))
end
| (Microsoft_FStar_Absyn_Syntax.Typ_lam ((bs1, t1')), Microsoft_FStar_Absyn_Syntax.Typ_lam ((bs2, t2'))) -> begin
(let mk_t = (fun ( t ) ( _33_32 ) -> (match (_33_32) with
| [] -> begin
t
end
| bs -> begin
(Microsoft_FStar_Absyn_Syntax.mk_Typ_lam (bs, t) None t.Microsoft_FStar_Absyn_Syntax.pos)
end))
in (let _33_2594 = (match_num_binders (bs1, (mk_t t1')) (bs2, (mk_t t2')))
in (match (_33_2594) with
| ((bs1, t1'), (bs2, t2')) -> begin
(solve_binders env bs1 bs2 orig wl (fun ( scope ) ( env ) ( subst ) -> (let t1' = (Microsoft_FStar_Absyn_Util.subst_typ subst t1')
in (let _68_14179 = (mk_problem scope orig t1' problem.relation t2' None "lambda co-domain")
in (Support.Prims.pipe_left (fun ( _68_14178 ) -> TProb (_68_14178)) _68_14179)))))
end)))
end
| (Microsoft_FStar_Absyn_Syntax.Typ_refine (_33_2600), Microsoft_FStar_Absyn_Syntax.Typ_refine (_33_2603)) -> begin
(let _33_2608 = (as_refinement env wl t1)
in (match (_33_2608) with
| (x1, phi1) -> begin
(let _33_2611 = (as_refinement env wl t2)
in (match (_33_2611) with
| (x2, phi2) -> begin
(let base_prob = (let _68_14181 = (mk_problem (p_scope orig) orig x1.Microsoft_FStar_Absyn_Syntax.sort problem.relation x2.Microsoft_FStar_Absyn_Syntax.sort problem.element "refinement base type")
in (Support.Prims.pipe_left (fun ( _68_14180 ) -> TProb (_68_14180)) _68_14181))
in (let x1_for_x2 = (let _68_14183 = (Microsoft_FStar_Absyn_Syntax.v_binder x1)
in (let _68_14182 = (Microsoft_FStar_Absyn_Syntax.v_binder x2)
in (Microsoft_FStar_Absyn_Util.mk_subst_one_binder _68_14183 _68_14182)))
in (let phi2 = (Microsoft_FStar_Absyn_Util.subst_typ x1_for_x2 phi2)
in (let mk_imp = (fun ( imp ) ( phi1 ) ( phi2 ) -> (let _68_14200 = (imp phi1 phi2)
in (Support.Prims.pipe_right _68_14200 (guard_on_element problem x1))))
in (let fallback = (fun ( _33_2620 ) -> (match (()) with
| () -> begin
(let impl = (match ((problem.relation = EQ)) with
| true -> begin
(mk_imp Microsoft_FStar_Absyn_Util.mk_iff phi1 phi2)
end
| false -> begin
(mk_imp Microsoft_FStar_Absyn_Util.mk_imp phi1 phi2)
end)
in (let guard = (let _68_14203 = (Support.Prims.pipe_right (p_guard base_prob) Support.Prims.fst)
in (Microsoft_FStar_Absyn_Util.mk_conj _68_14203 impl))
in (let wl = (solve_prob orig (Some (guard)) [] wl)
in (solve env (attempt ((base_prob)::[]) wl)))))
end))
in (match ((problem.relation = EQ)) with
| true -> begin
(let ref_prob = (let _68_14205 = (mk_problem (p_scope orig) orig phi1 EQ phi2 None "refinement formula")
in (Support.Prims.pipe_left (fun ( _68_14204 ) -> TProb (_68_14204)) _68_14205))
in (match ((solve env (let _33_2625 = wl
in {attempting = (ref_prob)::[]; deferred = []; subst = _33_2625.subst; ctr = _33_2625.ctr; slack_vars = _33_2625.slack_vars; defer_ok = false; smt_ok = _33_2625.smt_ok; tcenv = _33_2625.tcenv}))) with
| Failed (_33_2628) -> begin
(fallback ())
end
| Success ((subst, _33_2632)) -> begin
(let guard = (let _68_14208 = (Support.Prims.pipe_right (p_guard base_prob) Support.Prims.fst)
in (let _68_14207 = (let _68_14206 = (Support.Prims.pipe_right (p_guard ref_prob) Support.Prims.fst)
in (Support.Prims.pipe_right _68_14206 (guard_on_element problem x1)))
in (Microsoft_FStar_Absyn_Util.mk_conj _68_14208 _68_14207)))
in (let wl = (solve_prob orig (Some (guard)) [] wl)
in (solve env (attempt ((base_prob)::[]) wl))))
end))
end
| false -> begin
(fallback ())
end))))))
end))
end))
end
| ((Microsoft_FStar_Absyn_Syntax.Typ_uvar (_), Microsoft_FStar_Absyn_Syntax.Typ_uvar (_))) | ((Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)), Microsoft_FStar_Absyn_Syntax.Typ_uvar (_))) | ((Microsoft_FStar_Absyn_Syntax.Typ_uvar (_), Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)))) | ((Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)), Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)))) -> begin
(let _68_14210 = (destruct_flex_t t1)
in (let _68_14209 = (destruct_flex_t t2)
in (flex_flex orig _68_14210 _68_14209)))
end
| ((Microsoft_FStar_Absyn_Syntax.Typ_uvar (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)), _)) when (problem.relation = EQ) -> begin
(let _68_14211 = (destruct_flex_pattern env t1)
in (solve_t_flex_rigid orig _68_14211 t2 wl))
end
| ((_, Microsoft_FStar_Absyn_Syntax.Typ_uvar (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)))) when (problem.relation = EQ) -> begin
(solve_t env (invert problem) wl)
end
| ((Microsoft_FStar_Absyn_Syntax.Typ_uvar (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)), _)) -> begin
(match (wl.defer_ok) with
| true -> begin
(solve env (defer "flex-rigid subtyping deferred" orig wl))
end
| false -> begin
(let new_rel = (match ((Support.ST.read Microsoft_FStar_Options.no_slack)) with
| true -> begin
EQ
end
| false -> begin
problem.relation
end)
in (match ((let _68_14212 = (is_top_level_prob orig)
in (Support.Prims.pipe_left Support.Prims.op_Negation _68_14212))) with
| true -> begin
(let _68_14215 = (Support.Prims.pipe_left (fun ( _68_14213 ) -> TProb (_68_14213)) (let _33_2793 = problem
in {lhs = _33_2793.lhs; relation = new_rel; rhs = _33_2793.rhs; element = _33_2793.element; logical_guard = _33_2793.logical_guard; scope = _33_2793.scope; reason = _33_2793.reason; loc = _33_2793.loc; rank = _33_2793.rank}))
in (let _68_14214 = (destruct_flex_pattern env t1)
in (solve_t_flex_rigid _68_14215 _68_14214 t2 wl)))
end
| false -> begin
(let _33_2797 = (base_and_refinement env wl t2)
in (match (_33_2797) with
| (t_base, ref_opt) -> begin
(match (ref_opt) with
| None -> begin
(let _68_14218 = (Support.Prims.pipe_left (fun ( _68_14216 ) -> TProb (_68_14216)) (let _33_2799 = problem
in {lhs = _33_2799.lhs; relation = new_rel; rhs = _33_2799.rhs; element = _33_2799.element; logical_guard = _33_2799.logical_guard; scope = _33_2799.scope; reason = _33_2799.reason; loc = _33_2799.loc; rank = _33_2799.rank}))
in (let _68_14217 = (destruct_flex_pattern env t1)
in (solve_t_flex_rigid _68_14218 _68_14217 t_base wl)))
end
| Some ((y, phi)) -> begin
(let y' = (let _33_2805 = y
in {Microsoft_FStar_Absyn_Syntax.v = _33_2805.Microsoft_FStar_Absyn_Syntax.v; Microsoft_FStar_Absyn_Syntax.sort = t1; Microsoft_FStar_Absyn_Syntax.p = _33_2805.Microsoft_FStar_Absyn_Syntax.p})
in (let impl = (guard_on_element problem y' phi)
in (let base_prob = (let _68_14220 = (mk_problem problem.scope orig t1 new_rel y.Microsoft_FStar_Absyn_Syntax.sort problem.element "flex-rigid: base type")
in (Support.Prims.pipe_left (fun ( _68_14219 ) -> TProb (_68_14219)) _68_14220))
in (let guard = (let _68_14221 = (Support.Prims.pipe_right (p_guard base_prob) Support.Prims.fst)
in (Microsoft_FStar_Absyn_Util.mk_conj _68_14221 impl))
in (let wl = (solve_prob orig (Some (guard)) [] wl)
in (solve env (attempt ((base_prob)::[]) wl)))))))
end)
end))
end))
end)
end
| ((_, Microsoft_FStar_Absyn_Syntax.Typ_uvar (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)))) -> begin
(match (wl.defer_ok) with
| true -> begin
(solve env (defer "rigid-flex subtyping deferred" orig wl))
end
| false -> begin
(let _33_2840 = (base_and_refinement env wl t1)
in (match (_33_2840) with
| (t_base, _33_2839) -> begin
(solve_t env (let _33_2841 = problem
in {lhs = t_base; relation = EQ; rhs = _33_2841.rhs; element = _33_2841.element; logical_guard = _33_2841.logical_guard; scope = _33_2841.scope; reason = _33_2841.reason; loc = _33_2841.loc; rank = _33_2841.rank}) wl)
end))
end)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_refine (_33_2844), _33_2847) -> begin
(let t2 = (let _68_14222 = (base_and_refinement env wl t2)
in (Support.Prims.pipe_left force_refinement _68_14222))
in (solve_t env (let _33_2850 = problem
in {lhs = _33_2850.lhs; relation = _33_2850.relation; rhs = t2; element = _33_2850.element; logical_guard = _33_2850.logical_guard; scope = _33_2850.scope; reason = _33_2850.reason; loc = _33_2850.loc; rank = _33_2850.rank}) wl))
end
| (_33_2853, Microsoft_FStar_Absyn_Syntax.Typ_refine (_33_2855)) -> begin
(let t1 = (let _68_14223 = (base_and_refinement env wl t1)
in (Support.Prims.pipe_left force_refinement _68_14223))
in (solve_t env (let _33_2859 = problem
in {lhs = t1; relation = _33_2859.relation; rhs = _33_2859.rhs; element = _33_2859.element; logical_guard = _33_2859.logical_guard; scope = _33_2859.scope; reason = _33_2859.reason; loc = _33_2859.loc; rank = _33_2859.rank}) wl))
end
| ((Microsoft_FStar_Absyn_Syntax.Typ_btvar (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Typ_const (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Typ_app (_), _)) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_btvar (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_const (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_app (_))) -> begin
(let _33_2899 = (head_matches_delta env wl t1 t2)
in (match (_33_2899) with
| (m, o) -> begin
(match ((m, o)) with
| (MisMatch, _33_2902) -> begin
(let head1 = (let _68_14224 = (Microsoft_FStar_Absyn_Util.head_and_args t1)
in (Support.Prims.pipe_right _68_14224 Support.Prims.fst))
in (let head2 = (let _68_14225 = (Microsoft_FStar_Absyn_Util.head_and_args t2)
in (Support.Prims.pipe_right _68_14225 Support.Prims.fst))
in (let may_equate = (fun ( head ) -> (match (head.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_btvar (_33_2909) -> begin
true
end
| Microsoft_FStar_Absyn_Syntax.Typ_const (tc) -> begin
(Microsoft_FStar_Tc_Env.is_projector env tc.Microsoft_FStar_Absyn_Syntax.v)
end
| _33_2914 -> begin
false
end))
in (match ((((may_equate head1) || (may_equate head2)) && wl.smt_ok)) with
| true -> begin
(let _68_14231 = (let _68_14230 = (let _68_14229 = (Microsoft_FStar_Absyn_Util.mk_eq_typ t1 t2)
in (Support.Prims.pipe_left (fun ( _68_14228 ) -> Some (_68_14228)) _68_14229))
in (solve_prob orig _68_14230 [] wl))
in (solve env _68_14231))
end
| false -> begin
(giveup env "head mismatch" orig)
end))))
end
| (_33_2916, Some ((t1, t2))) -> begin
(solve_t env (let _33_2922 = problem
in {lhs = t1; relation = _33_2922.relation; rhs = t2; element = _33_2922.element; logical_guard = _33_2922.logical_guard; scope = _33_2922.scope; reason = _33_2922.reason; loc = _33_2922.loc; rank = _33_2922.rank}) wl)
end
| (_33_2925, None) -> begin
(let _33_2928 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14233 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (let _68_14232 = (Microsoft_FStar_Absyn_Print.typ_to_string t2)
in (Support.Microsoft.FStar.Util.fprint2 "Head matches: %s and %s\n" _68_14233 _68_14232)))
end
| false -> begin
()
end)
in (let _33_2932 = (Microsoft_FStar_Absyn_Util.head_and_args t1)
in (match (_33_2932) with
| (head, args) -> begin
(let _33_2935 = (Microsoft_FStar_Absyn_Util.head_and_args t2)
in (match (_33_2935) with
| (head', args') -> begin
(let nargs = (Support.List.length args)
in (match ((nargs <> (Support.List.length args'))) with
| true -> begin
(let _68_14238 = (let _68_14237 = (Microsoft_FStar_Absyn_Print.typ_to_string head)
in (let _68_14236 = (Microsoft_FStar_Absyn_Print.args_to_string args)
in (let _68_14235 = (Microsoft_FStar_Absyn_Print.typ_to_string head')
in (let _68_14234 = (Microsoft_FStar_Absyn_Print.args_to_string args')
in (Support.Microsoft.FStar.Util.format4 "unequal number of arguments: %s[%s] and %s[%s]" _68_14237 _68_14236 _68_14235 _68_14234)))))
in (giveup env _68_14238 orig))
end
| false -> begin
(match (((nargs = 0) || (eq_args args args'))) with
| true -> begin
(let _68_14239 = (solve_prob orig None [] wl)
in (solve env _68_14239))
end
| false -> begin
(let _33_2939 = (base_and_refinement env wl t1)
in (match (_33_2939) with
| (base1, refinement1) -> begin
(let _33_2942 = (base_and_refinement env wl t2)
in (match (_33_2942) with
| (base2, refinement2) -> begin
(match ((refinement1, refinement2)) with
| (None, None) -> begin
(let _33_2946 = (match (((head_matches head head) <> FullMatch)) with
| true -> begin
(let _68_14242 = (let _68_14241 = (Microsoft_FStar_Absyn_Print.typ_to_string head)
in (let _68_14240 = (Microsoft_FStar_Absyn_Print.typ_to_string head')
in (Support.Microsoft.FStar.Util.format2 "Assertion failed: expected full match of %s and %s\n" _68_14241 _68_14240)))
in (failwith (_68_14242)))
end
| false -> begin
()
end)
in (let subprobs = (Support.List.map2 (fun ( a ) ( a' ) -> (match (((Support.Prims.fst a), (Support.Prims.fst a'))) with
| (Support.Microsoft.FStar.Util.Inl (t), Support.Microsoft.FStar.Util.Inl (t')) -> begin
(let _68_14246 = (mk_problem (p_scope orig) orig t EQ t' None "type index")
in (Support.Prims.pipe_left (fun ( _68_14245 ) -> TProb (_68_14245)) _68_14246))
end
| (Support.Microsoft.FStar.Util.Inr (v), Support.Microsoft.FStar.Util.Inr (v')) -> begin
(let _68_14248 = (mk_problem (p_scope orig) orig v EQ v' None "term index")
in (Support.Prims.pipe_left (fun ( _68_14247 ) -> EProb (_68_14247)) _68_14248))
end
| _33_2961 -> begin
(failwith ("Impossible"))
end)) args args')
in (let formula = (let _68_14250 = (Support.List.map (fun ( p ) -> (Support.Prims.fst (p_guard p))) subprobs)
in (Microsoft_FStar_Absyn_Util.mk_conj_l _68_14250))
in (let wl = (solve_prob orig (Some (formula)) [] wl)
in (solve env (attempt subprobs wl))))))
end
| _33_2967 -> begin
(let lhs = (force_refinement (base1, refinement1))
in (let rhs = (force_refinement (base2, refinement2))
in (solve_t env (let _33_2970 = problem
in {lhs = lhs; relation = _33_2970.relation; rhs = rhs; element = _33_2970.element; logical_guard = _33_2970.logical_guard; scope = _33_2970.scope; reason = _33_2970.reason; loc = _33_2970.loc; rank = _33_2970.rank}) wl)))
end)
end))
end))
end)
end))
end))
end)))
end)
end))
end
| ((Microsoft_FStar_Absyn_Syntax.Typ_ascribed (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Typ_meta (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Typ_delayed (_), _)) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_ascribed (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_meta (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Typ_delayed (_))) -> begin
(failwith ("Impossible"))
end
| _33_3009 -> begin
(giveup env "head mismatch" orig)
end))))
end)))
end))))))))
and solve_c = (fun ( env ) ( problem ) ( wl ) -> (let c1 = problem.lhs
in (let c2 = problem.rhs
in (let orig = CProb (problem)
in (let sub_prob = (fun ( t1 ) ( rel ) ( t2 ) ( reason ) -> (mk_problem (p_scope orig) orig t1 rel t2 None reason))
in (let solve_eq = (fun ( c1_comp ) ( c2_comp ) -> (let _33_3026 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("EQ")))) with
| true -> begin
(Support.Microsoft.FStar.Util.print_string "solve_c is using an equality constraint\n")
end
| false -> begin
()
end)
in (let sub_probs = (Support.List.map2 (fun ( arg1 ) ( arg2 ) -> (match (((Support.Prims.fst arg1), (Support.Prims.fst arg2))) with
| (Support.Microsoft.FStar.Util.Inl (t1), Support.Microsoft.FStar.Util.Inl (t2)) -> begin
(let _68_14265 = (sub_prob t1 EQ t2 "effect arg")
in (Support.Prims.pipe_left (fun ( _68_14264 ) -> TProb (_68_14264)) _68_14265))
end
| (Support.Microsoft.FStar.Util.Inr (e1), Support.Microsoft.FStar.Util.Inr (e2)) -> begin
(let _68_14267 = (sub_prob e1 EQ e2 "effect arg")
in (Support.Prims.pipe_left (fun ( _68_14266 ) -> EProb (_68_14266)) _68_14267))
end
| _33_3041 -> begin
(failwith ("impossible"))
end)) c1_comp.Microsoft_FStar_Absyn_Syntax.effect_args c2_comp.Microsoft_FStar_Absyn_Syntax.effect_args)
in (let guard = (let _68_14269 = (Support.List.map (fun ( p ) -> (Support.Prims.pipe_right (p_guard p) Support.Prims.fst)) sub_probs)
in (Microsoft_FStar_Absyn_Util.mk_conj_l _68_14269))
in (let wl = (solve_prob orig (Some (guard)) [] wl)
in (solve env (attempt sub_probs wl)))))))
in (match ((Support.Microsoft.FStar.Util.physical_equality c1 c2)) with
| true -> begin
(let _68_14270 = (solve_prob orig None [] wl)
in (solve env _68_14270))
end
| false -> begin
(let _33_3046 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14272 = (Microsoft_FStar_Absyn_Print.comp_typ_to_string c1)
in (let _68_14271 = (Microsoft_FStar_Absyn_Print.comp_typ_to_string c2)
in (Support.Microsoft.FStar.Util.fprint3 "solve_c %s %s %s\n" _68_14272 (rel_to_string problem.relation) _68_14271)))
end
| false -> begin
()
end)
in (let r = (Microsoft_FStar_Tc_Env.get_range env)
in (let _33_3051 = (c1, c2)
in (match (_33_3051) with
| (c1_0, c2_0) -> begin
(match ((c1.Microsoft_FStar_Absyn_Syntax.n, c2.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Total (t1), Microsoft_FStar_Absyn_Syntax.Total (t2)) -> begin
(solve_t env (problem_using_guard orig t1 problem.relation t2 None "result type") wl)
end
| (Microsoft_FStar_Absyn_Syntax.Total (_33_3058), Microsoft_FStar_Absyn_Syntax.Comp (_33_3061)) -> begin
(let _68_14274 = (let _33_3064 = problem
in (let _68_14273 = (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.mk_Comp (Microsoft_FStar_Absyn_Util.comp_to_comp_typ c1))
in {lhs = _68_14273; relation = _33_3064.relation; rhs = _33_3064.rhs; element = _33_3064.element; logical_guard = _33_3064.logical_guard; scope = _33_3064.scope; reason = _33_3064.reason; loc = _33_3064.loc; rank = _33_3064.rank}))
in (solve_c env _68_14274 wl))
end
| (Microsoft_FStar_Absyn_Syntax.Comp (_33_3067), Microsoft_FStar_Absyn_Syntax.Total (_33_3070)) -> begin
(let _68_14276 = (let _33_3073 = problem
in (let _68_14275 = (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.mk_Comp (Microsoft_FStar_Absyn_Util.comp_to_comp_typ c2))
in {lhs = _33_3073.lhs; relation = _33_3073.relation; rhs = _68_14275; element = _33_3073.element; logical_guard = _33_3073.logical_guard; scope = _33_3073.scope; reason = _33_3073.reason; loc = _33_3073.loc; rank = _33_3073.rank}))
in (solve_c env _68_14276 wl))
end
| (Microsoft_FStar_Absyn_Syntax.Comp (_33_3076), Microsoft_FStar_Absyn_Syntax.Comp (_33_3079)) -> begin
(match ((((Microsoft_FStar_Absyn_Util.is_ml_comp c1) && (Microsoft_FStar_Absyn_Util.is_ml_comp c2)) || ((Microsoft_FStar_Absyn_Util.is_total_comp c1) && ((Microsoft_FStar_Absyn_Util.is_total_comp c2) || (Microsoft_FStar_Absyn_Util.is_ml_comp c2))))) with
| true -> begin
(solve_t env (problem_using_guard orig (Microsoft_FStar_Absyn_Util.comp_result c1) problem.relation (Microsoft_FStar_Absyn_Util.comp_result c2) None "result type") wl)
end
| false -> begin
(let c1_comp = (Microsoft_FStar_Absyn_Util.comp_to_comp_typ c1)
in (let c2_comp = (Microsoft_FStar_Absyn_Util.comp_to_comp_typ c2)
in (match (((problem.relation = EQ) && (Microsoft_FStar_Absyn_Syntax.lid_equals c1_comp.Microsoft_FStar_Absyn_Syntax.effect_name c2_comp.Microsoft_FStar_Absyn_Syntax.effect_name))) with
| true -> begin
(solve_eq c1_comp c2_comp)
end
| false -> begin
(let c1 = (Microsoft_FStar_Tc_Normalize.weak_norm_comp env c1)
in (let c2 = (Microsoft_FStar_Tc_Normalize.weak_norm_comp env c2)
in (let _33_3086 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(Support.Microsoft.FStar.Util.fprint2 "solve_c for %s and %s\n" c1.Microsoft_FStar_Absyn_Syntax.effect_name.Microsoft_FStar_Absyn_Syntax.str c2.Microsoft_FStar_Absyn_Syntax.effect_name.Microsoft_FStar_Absyn_Syntax.str)
end
| false -> begin
()
end)
in (match ((Microsoft_FStar_Tc_Env.monad_leq env c1.Microsoft_FStar_Absyn_Syntax.effect_name c2.Microsoft_FStar_Absyn_Syntax.effect_name)) with
| None -> begin
(let _68_14279 = (let _68_14278 = (Microsoft_FStar_Absyn_Print.sli c1.Microsoft_FStar_Absyn_Syntax.effect_name)
in (let _68_14277 = (Microsoft_FStar_Absyn_Print.sli c2.Microsoft_FStar_Absyn_Syntax.effect_name)
in (Support.Microsoft.FStar.Util.format2 "incompatible monad ordering: %s </: %s" _68_14278 _68_14277)))
in (giveup env _68_14279 orig))
end
| Some (edge) -> begin
(match ((problem.relation = EQ)) with
| true -> begin
(let _33_3106 = (match (c1.Microsoft_FStar_Absyn_Syntax.effect_args) with
| (Support.Microsoft.FStar.Util.Inl (wp1), _33_3099)::(Support.Microsoft.FStar.Util.Inl (wlp1), _33_3094)::[] -> begin
(wp1, wlp1)
end
| _33_3103 -> begin
(let _68_14282 = (let _68_14281 = (let _68_14280 = (Microsoft_FStar_Absyn_Syntax.range_of_lid c1.Microsoft_FStar_Absyn_Syntax.effect_name)
in (Support.Microsoft.FStar.Range.string_of_range _68_14280))
in (Support.Microsoft.FStar.Util.format1 "Unexpected number of indices on a normalized effect (%s)" _68_14281))
in (failwith (_68_14282)))
end)
in (match (_33_3106) with
| (wp, wlp) -> begin
(let c1 = (let _68_14288 = (let _68_14287 = (let _68_14283 = (edge.Microsoft_FStar_Tc_Env.mlift c1.Microsoft_FStar_Absyn_Syntax.result_typ wp)
in (Microsoft_FStar_Absyn_Syntax.targ _68_14283))
in (let _68_14286 = (let _68_14285 = (let _68_14284 = (edge.Microsoft_FStar_Tc_Env.mlift c1.Microsoft_FStar_Absyn_Syntax.result_typ wlp)
in (Microsoft_FStar_Absyn_Syntax.targ _68_14284))
in (_68_14285)::[])
in (_68_14287)::_68_14286))
in {Microsoft_FStar_Absyn_Syntax.effect_name = c2.Microsoft_FStar_Absyn_Syntax.effect_name; Microsoft_FStar_Absyn_Syntax.result_typ = c1.Microsoft_FStar_Absyn_Syntax.result_typ; Microsoft_FStar_Absyn_Syntax.effect_args = _68_14288; Microsoft_FStar_Absyn_Syntax.flags = c1.Microsoft_FStar_Absyn_Syntax.flags})
in (solve_eq c1 c2))
end))
end
| false -> begin
(let is_null_wp_2 = (Support.Prims.pipe_right c2.Microsoft_FStar_Absyn_Syntax.flags (Support.Microsoft.FStar.Util.for_some (fun ( _33_33 ) -> (match (_33_33) with
| (Microsoft_FStar_Absyn_Syntax.TOTAL) | (Microsoft_FStar_Absyn_Syntax.MLEFFECT) | (Microsoft_FStar_Absyn_Syntax.SOMETRIVIAL) -> begin
true
end
| _33_3113 -> begin
false
end))))
in (let _33_3136 = (match ((c1.Microsoft_FStar_Absyn_Syntax.effect_args, c2.Microsoft_FStar_Absyn_Syntax.effect_args)) with
| ((Support.Microsoft.FStar.Util.Inl (wp1), _33_3120)::_33_3116, (Support.Microsoft.FStar.Util.Inl (wp2), _33_3128)::_33_3124) -> begin
(wp1, wp2)
end
| _33_3133 -> begin
(let _68_14292 = (let _68_14291 = (Microsoft_FStar_Absyn_Print.sli c1.Microsoft_FStar_Absyn_Syntax.effect_name)
in (let _68_14290 = (Microsoft_FStar_Absyn_Print.sli c2.Microsoft_FStar_Absyn_Syntax.effect_name)
in (Support.Microsoft.FStar.Util.format2 "Got effects %s and %s, expected normalized effects" _68_14291 _68_14290)))
in (failwith (_68_14292)))
end)
in (match (_33_3136) with
| (wpc1, wpc2) -> begin
(match ((Support.Microsoft.FStar.Util.physical_equality wpc1 wpc2)) with
| true -> begin
(solve_t env (problem_using_guard orig c1.Microsoft_FStar_Absyn_Syntax.result_typ problem.relation c2.Microsoft_FStar_Absyn_Syntax.result_typ None "result type") wl)
end
| false -> begin
(let c2_decl = (Microsoft_FStar_Tc_Env.get_effect_decl env c2.Microsoft_FStar_Absyn_Syntax.effect_name)
in (let g = (match (is_null_wp_2) with
| true -> begin
(let _33_3138 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(Support.Microsoft.FStar.Util.print_string "Using trivial wp ... \n")
end
| false -> begin
()
end)
in (let _68_14298 = (let _68_14297 = (let _68_14296 = (Microsoft_FStar_Absyn_Syntax.targ c1.Microsoft_FStar_Absyn_Syntax.result_typ)
in (let _68_14295 = (let _68_14294 = (let _68_14293 = (edge.Microsoft_FStar_Tc_Env.mlift c1.Microsoft_FStar_Absyn_Syntax.result_typ wpc1)
in (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.targ _68_14293))
in (_68_14294)::[])
in (_68_14296)::_68_14295))
in (c2_decl.Microsoft_FStar_Absyn_Syntax.trivial, _68_14297))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_app _68_14298 (Some (Microsoft_FStar_Absyn_Syntax.ktype)) r)))
end
| false -> begin
(let wp2_imp_wp1 = (let _68_14310 = (let _68_14309 = (let _68_14308 = (Microsoft_FStar_Absyn_Syntax.targ c2.Microsoft_FStar_Absyn_Syntax.result_typ)
in (let _68_14307 = (let _68_14306 = (Microsoft_FStar_Absyn_Syntax.targ wpc2)
in (let _68_14305 = (let _68_14304 = (let _68_14300 = (let _68_14299 = (Microsoft_FStar_Absyn_Const.kbin Microsoft_FStar_Absyn_Syntax.ktype Microsoft_FStar_Absyn_Syntax.ktype Microsoft_FStar_Absyn_Syntax.ktype)
in (Microsoft_FStar_Absyn_Util.ftv Microsoft_FStar_Absyn_Const.imp_lid _68_14299))
in (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.targ _68_14300))
in (let _68_14303 = (let _68_14302 = (let _68_14301 = (edge.Microsoft_FStar_Tc_Env.mlift c1.Microsoft_FStar_Absyn_Syntax.result_typ wpc1)
in (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.targ _68_14301))
in (_68_14302)::[])
in (_68_14304)::_68_14303))
in (_68_14306)::_68_14305))
in (_68_14308)::_68_14307))
in (c2_decl.Microsoft_FStar_Absyn_Syntax.wp_binop, _68_14309))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_app _68_14310 None r))
in (let _68_14315 = (let _68_14314 = (let _68_14313 = (Microsoft_FStar_Absyn_Syntax.targ c2.Microsoft_FStar_Absyn_Syntax.result_typ)
in (let _68_14312 = (let _68_14311 = (Microsoft_FStar_Absyn_Syntax.targ wp2_imp_wp1)
in (_68_14311)::[])
in (_68_14313)::_68_14312))
in (c2_decl.Microsoft_FStar_Absyn_Syntax.wp_as_type, _68_14314))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_app _68_14315 (Some (Microsoft_FStar_Absyn_Syntax.ktype)) r)))
end)
in (let base_prob = (let _68_14317 = (sub_prob c1.Microsoft_FStar_Absyn_Syntax.result_typ problem.relation c2.Microsoft_FStar_Absyn_Syntax.result_typ "result type")
in (Support.Prims.pipe_left (fun ( _68_14316 ) -> TProb (_68_14316)) _68_14317))
in (let wl = (let _68_14321 = (let _68_14320 = (let _68_14319 = (Support.Prims.pipe_right (p_guard base_prob) Support.Prims.fst)
in (Microsoft_FStar_Absyn_Util.mk_conj _68_14319 g))
in (Support.Prims.pipe_left (fun ( _68_14318 ) -> Some (_68_14318)) _68_14320))
in (solve_prob orig _68_14321 [] wl))
in (solve env (attempt ((base_prob)::[]) wl))))))
end)
end)))
end)
end))))
end)))
end)
end)
end))))
end)))))))
and solve_e = (fun ( env ) ( problem ) ( wl ) -> (match ((compress_prob wl (EProb (problem)))) with
| EProb (p) -> begin
(solve_e' env p wl)
end
| _33_3150 -> begin
(failwith ("Impossible"))
end))
and solve_e' = (fun ( env ) ( problem ) ( wl ) -> (let problem = (let _33_3154 = problem
in {lhs = _33_3154.lhs; relation = EQ; rhs = _33_3154.rhs; element = _33_3154.element; logical_guard = _33_3154.logical_guard; scope = _33_3154.scope; reason = _33_3154.reason; loc = _33_3154.loc; rank = _33_3154.rank})
in (let e1 = problem.lhs
in (let e2 = problem.rhs
in (let orig = EProb (problem)
in (let sub_prob = (fun ( lhs ) ( rhs ) ( reason ) -> (mk_problem (p_scope orig) orig lhs EQ rhs None reason))
in (let _33_3166 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14331 = (prob_to_string env orig)
in (Support.Microsoft.FStar.Util.fprint1 "Attempting:\n%s\n" _68_14331))
end
| false -> begin
()
end)
in (let flex_rigid = (fun ( _33_3173 ) ( e2 ) -> (match (_33_3173) with
| (e1, u1, t1, args1) -> begin
(let maybe_vars1 = (pat_vars env [] args1)
in (let sub_problems = (fun ( xs ) ( args2 ) -> (let _33_3200 = (let _68_14347 = (Support.Prims.pipe_right args2 (Support.List.map (fun ( _33_34 ) -> (match (_33_34) with
| (Support.Microsoft.FStar.Util.Inl (t), imp) -> begin
(let kk = (Microsoft_FStar_Tc_Recheck.recompute_kind t)
in (let _33_3187 = (new_tvar t.Microsoft_FStar_Absyn_Syntax.pos xs kk)
in (match (_33_3187) with
| (gi_xi, gi) -> begin
(let gi_pi = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app (gi, args1) (Some (kk)) t.Microsoft_FStar_Absyn_Syntax.pos)
in (let _68_14343 = (let _68_14342 = (sub_prob gi_pi t "type index")
in (Support.Prims.pipe_left (fun ( _68_14341 ) -> TProb (_68_14341)) _68_14342))
in ((Support.Microsoft.FStar.Util.Inl (gi_xi), imp), _68_14343)))
end)))
end
| (Support.Microsoft.FStar.Util.Inr (v), imp) -> begin
(let tt = (Microsoft_FStar_Tc_Recheck.recompute_typ v)
in (let _33_3196 = (new_evar v.Microsoft_FStar_Absyn_Syntax.pos xs tt)
in (match (_33_3196) with
| (gi_xi, gi) -> begin
(let gi_pi = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app (gi, args1) (Some (tt)) v.Microsoft_FStar_Absyn_Syntax.pos)
in (let _68_14346 = (let _68_14345 = (sub_prob gi_pi v "expression index")
in (Support.Prims.pipe_left (fun ( _68_14344 ) -> EProb (_68_14344)) _68_14345))
in ((Support.Microsoft.FStar.Util.Inr (gi_xi), imp), _68_14346)))
end)))
end))))
in (Support.Prims.pipe_right _68_14347 Support.List.unzip))
in (match (_33_3200) with
| (gi_xi, gi_pi) -> begin
(let formula = (let _68_14349 = (Support.List.map (fun ( p ) -> (Support.Prims.pipe_right (p_guard p) Support.Prims.fst)) gi_pi)
in (Microsoft_FStar_Absyn_Util.mk_conj_l _68_14349))
in (gi_xi, gi_pi, formula))
end)))
in (let project_e = (fun ( head2 ) ( args2 ) -> (let giveup = (fun ( reason ) -> (let _68_14356 = (Support.Microsoft.FStar.Util.format1 "flex-rigid: refusing to project expressions (%s)" reason)
in (giveup env _68_14356 orig)))
in (match ((let _68_14357 = (Microsoft_FStar_Absyn_Util.compress_exp head2)
in _68_14357.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Exp_bvar (y) -> begin
(let _33_3217 = (match ((Microsoft_FStar_Absyn_Util.function_formals t1)) with
| None -> begin
([], t1)
end
| Some ((xs, c)) -> begin
(xs, (Microsoft_FStar_Absyn_Util.comp_result c))
end)
in (match (_33_3217) with
| (all_xs, tres) -> begin
(match (((Support.List.length all_xs) <> (Support.List.length args1))) with
| true -> begin
(let _68_14360 = (let _68_14359 = (Microsoft_FStar_Absyn_Print.binders_to_string ", " all_xs)
in (let _68_14358 = (Microsoft_FStar_Absyn_Print.args_to_string args2)
in (Support.Microsoft.FStar.Util.format2 "unequal arity:\n\texpetced binders %s\n\tgot args {%s}" _68_14359 _68_14358)))
in (giveup _68_14360))
end
| false -> begin
(let rec aux = (fun ( xs ) ( args ) -> (match ((xs, args)) with
| ([], []) -> begin
(giveup "variable to project not found")
end
| (([], _)) | ((_, [])) -> begin
(failwith ("impossible"))
end
| ((Support.Microsoft.FStar.Util.Inl (_33_3234), _33_3237)::xs, (Support.Microsoft.FStar.Util.Inl (_33_3242), _33_3245)::args) -> begin
(aux xs args)
end
| ((Support.Microsoft.FStar.Util.Inr (xi), _33_3253)::xs, (Support.Microsoft.FStar.Util.Inr (arg), _33_3260)::args) -> begin
(match ((let _68_14365 = (Microsoft_FStar_Absyn_Util.compress_exp arg)
in _68_14365.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Exp_bvar (z) -> begin
(match ((Microsoft_FStar_Absyn_Util.bvar_eq y z)) with
| true -> begin
(let _33_3269 = (sub_problems all_xs args2)
in (match (_33_3269) with
| (gi_xi, gi_pi, f) -> begin
(let sol = (let _68_14369 = (let _68_14368 = (let _68_14367 = (let _68_14366 = (Microsoft_FStar_Absyn_Util.bvar_to_exp xi)
in (_68_14366, gi_xi))
in (Microsoft_FStar_Absyn_Syntax.mk_Exp_app' _68_14367 None e1.Microsoft_FStar_Absyn_Syntax.pos))
in (all_xs, _68_14368))
in (Microsoft_FStar_Absyn_Syntax.mk_Exp_abs _68_14369 None e1.Microsoft_FStar_Absyn_Syntax.pos))
in (let _33_3271 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14373 = (Microsoft_FStar_Absyn_Print.uvar_e_to_string (u1, t1))
in (let _68_14372 = (Microsoft_FStar_Absyn_Print.exp_to_string sol)
in (let _68_14371 = (let _68_14370 = (Support.Prims.pipe_right gi_pi (Support.List.map (prob_to_string env)))
in (Support.Prims.pipe_right _68_14370 (Support.String.concat "\n")))
in (Support.Microsoft.FStar.Util.fprint3 "Projected: %s -> %s\nSubprobs=\n%s\n" _68_14373 _68_14372 _68_14371))))
end
| false -> begin
()
end)
in (let _68_14375 = (let _68_14374 = (solve_prob orig (Some (f)) ((UE (((u1, t1), sol)))::[]) wl)
in (attempt gi_pi _68_14374))
in (solve env _68_14375))))
end))
end
| false -> begin
(aux xs args)
end)
end
| _33_3274 -> begin
(aux xs args)
end)
end
| (x::xs, arg::args) -> begin
(let _68_14378 = (let _68_14377 = (Microsoft_FStar_Absyn_Print.binder_to_string x)
in (let _68_14376 = (Microsoft_FStar_Absyn_Print.arg_to_string arg)
in (Support.Microsoft.FStar.Util.format2 "type incorrect term---impossible: expected %s; got %s\n" _68_14377 _68_14376)))
in (giveup _68_14378))
end))
in (aux (Support.List.rev all_xs) (Support.List.rev args1)))
end)
end))
end
| _33_3283 -> begin
(giveup "rigid head term is not a variable")
end)))
in (let imitate_or_project_e = (fun ( _33_3285 ) -> (match (()) with
| () -> begin
(match (wl.defer_ok) with
| true -> begin
(solve env (defer "flex-rigid: not a pattern" orig wl))
end
| false -> begin
(let _33_3286 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14382 = (Microsoft_FStar_Absyn_Print.exp_to_string e1)
in (let _68_14381 = (Microsoft_FStar_Absyn_Print.exp_to_string e2)
in (Support.Microsoft.FStar.Util.fprint2 "Imitating expressions: %s =?= %s\n" _68_14382 _68_14381)))
end
| false -> begin
()
end)
in (let _33_3290 = (Microsoft_FStar_Absyn_Util.head_and_args_e e2)
in (match (_33_3290) with
| (head2, args2) -> begin
(let fvhead = (Microsoft_FStar_Absyn_Util.freevars_exp head2)
in (let _33_3295 = (occurs_check_e env (u1, t1) head2)
in (match (_33_3295) with
| (occurs_ok, _33_3294) -> begin
(match (((Microsoft_FStar_Absyn_Util.fvs_included fvhead Microsoft_FStar_Absyn_Syntax.no_fvs) && occurs_ok)) with
| true -> begin
(let _33_3303 = (match ((Microsoft_FStar_Absyn_Util.function_formals t1)) with
| None -> begin
([], t1)
end
| Some ((xs, c)) -> begin
(xs, (Microsoft_FStar_Absyn_Util.comp_result c))
end)
in (match (_33_3303) with
| (xs, tres) -> begin
(let _33_3307 = (sub_problems xs args2)
in (match (_33_3307) with
| (gi_xi, gi_pi, f) -> begin
(let sol = (let body = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app' (head2, gi_xi) None e1.Microsoft_FStar_Absyn_Syntax.pos)
in (match (xs) with
| [] -> begin
body
end
| _33_3311 -> begin
(let _68_14384 = (let _68_14383 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app' (head2, gi_xi) None e1.Microsoft_FStar_Absyn_Syntax.pos)
in (xs, _68_14383))
in (Microsoft_FStar_Absyn_Syntax.mk_Exp_abs _68_14384 None e1.Microsoft_FStar_Absyn_Syntax.pos))
end))
in (let _33_3313 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14388 = (Microsoft_FStar_Absyn_Print.uvar_e_to_string (u1, t1))
in (let _68_14387 = (Microsoft_FStar_Absyn_Print.exp_to_string sol)
in (let _68_14386 = (let _68_14385 = (Support.Prims.pipe_right gi_pi (Support.List.map (prob_to_string env)))
in (Support.Prims.pipe_right _68_14385 (Support.String.concat "\n")))
in (Support.Microsoft.FStar.Util.fprint3 "Imitated: %s -> %s\nSubprobs=\n%s\n" _68_14388 _68_14387 _68_14386))))
end
| false -> begin
()
end)
in (let _68_14390 = (let _68_14389 = (solve_prob orig (Some (f)) ((UE (((u1, t1), sol)))::[]) wl)
in (attempt gi_pi _68_14389))
in (solve env _68_14390))))
end))
end))
end
| false -> begin
(match (occurs_ok) with
| true -> begin
(project_e head2 args2)
end
| false -> begin
(giveup env "flex-rigid: occurs check failed" orig)
end)
end)
end)))
end)))
end)
end))
in (match (maybe_vars1) with
| (None) | (Some ([])) -> begin
(imitate_or_project_e ())
end
| Some (xs) -> begin
(let fvs1 = (Microsoft_FStar_Absyn_Syntax.freevars_of_binders xs)
in (let fvs2 = (Microsoft_FStar_Absyn_Util.freevars_exp e2)
in (let _33_3325 = (occurs_check_e env (u1, t1) e2)
in (match (_33_3325) with
| (occurs_ok, _33_3324) -> begin
(match ((((Support.Microsoft.FStar.Util.set_is_subset_of fvs2.Microsoft_FStar_Absyn_Syntax.ftvs fvs1.Microsoft_FStar_Absyn_Syntax.ftvs) && (Support.Microsoft.FStar.Util.set_is_subset_of fvs2.Microsoft_FStar_Absyn_Syntax.fxvs fvs1.Microsoft_FStar_Absyn_Syntax.fxvs)) && occurs_ok)) with
| true -> begin
(let sol = (Microsoft_FStar_Absyn_Syntax.mk_Exp_abs' (xs, e2) None e1.Microsoft_FStar_Absyn_Syntax.pos)
in (let _68_14391 = (solve_prob orig None ((UE (((u1, t1), sol)))::[]) wl)
in (solve env _68_14391)))
end
| false -> begin
(imitate_or_project_e ())
end)
end))))
end)))))
end))
in (let flex_flex = (fun ( _33_3332 ) ( _33_3337 ) -> (match ((_33_3332, _33_3337)) with
| ((e1, u1, t1, args1), (e2, u2, t2, args2)) -> begin
(let maybe_vars1 = (pat_vars env [] args1)
in (let maybe_vars2 = (pat_vars env [] args2)
in (match ((maybe_vars1, maybe_vars2)) with
| ((None, _)) | ((_, None)) -> begin
(match (wl.defer_ok) with
| true -> begin
(solve env (defer "flex-flex: not a pattern" orig wl))
end
| false -> begin
(giveup env "flex-flex expressions not patterns" orig)
end)
end
| (Some (xs), Some (ys)) -> begin
(match (((Support.Microsoft.FStar.Unionfind.equivalent u1 u2) && (binders_eq xs ys))) with
| true -> begin
(solve env wl)
end
| false -> begin
(let zs = (intersect_vars xs ys)
in (let tt = (Microsoft_FStar_Tc_Recheck.recompute_typ e2)
in (let _33_3358 = (let _68_14396 = (Microsoft_FStar_Tc_Env.get_range env)
in (new_evar _68_14396 zs tt))
in (match (_33_3358) with
| (u, _33_3357) -> begin
(let sub1 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_abs (xs, u) (Some (t1)) e1.Microsoft_FStar_Absyn_Syntax.pos)
in (let sub2 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_abs (ys, u) (Some (t2)) e1.Microsoft_FStar_Absyn_Syntax.pos)
in (let _68_14397 = (solve_prob orig None ((UE (((u1, t1), sub1)))::(UE (((u2, t2), sub2)))::[]) wl)
in (solve env _68_14397))))
end))))
end)
end)))
end))
in (let smt_fallback = (fun ( e1 ) ( e2 ) -> (match (wl.smt_ok) with
| true -> begin
(let _33_3364 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14402 = (prob_to_string env orig)
in (Support.Microsoft.FStar.Util.fprint1 "Using SMT to solve:\n%s\n" _68_14402))
end
| false -> begin
()
end)
in (let _33_3369 = (let _68_14404 = (Microsoft_FStar_Tc_Env.get_range env)
in (let _68_14403 = (Microsoft_FStar_Tc_Env.binders env)
in (new_tvar _68_14404 _68_14403 Microsoft_FStar_Absyn_Syntax.ktype)))
in (match (_33_3369) with
| (t, _33_3368) -> begin
(let _68_14408 = (let _68_14407 = (let _68_14406 = (Microsoft_FStar_Absyn_Util.mk_eq t t e1 e2)
in (Support.Prims.pipe_left (fun ( _68_14405 ) -> Some (_68_14405)) _68_14406))
in (solve_prob orig _68_14407 [] wl))
in (solve env _68_14408))
end)))
end
| false -> begin
(giveup env "no SMT solution permitted" orig)
end))
in (match ((e1.Microsoft_FStar_Absyn_Syntax.n, e2.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Exp_ascribed ((e1, _33_3372, _33_3374)), _33_3378) -> begin
(solve_e env (let _33_3380 = problem
in {lhs = e1; relation = _33_3380.relation; rhs = _33_3380.rhs; element = _33_3380.element; logical_guard = _33_3380.logical_guard; scope = _33_3380.scope; reason = _33_3380.reason; loc = _33_3380.loc; rank = _33_3380.rank}) wl)
end
| (_33_3383, Microsoft_FStar_Absyn_Syntax.Exp_ascribed ((e2, _33_3386, _33_3388))) -> begin
(solve_e env (let _33_3392 = problem
in {lhs = _33_3392.lhs; relation = _33_3392.relation; rhs = e2; element = _33_3392.element; logical_guard = _33_3392.logical_guard; scope = _33_3392.scope; reason = _33_3392.reason; loc = _33_3392.loc; rank = _33_3392.rank}) wl)
end
| ((Microsoft_FStar_Absyn_Syntax.Exp_uvar (_), Microsoft_FStar_Absyn_Syntax.Exp_uvar (_))) | ((Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)), Microsoft_FStar_Absyn_Syntax.Exp_uvar (_))) | ((Microsoft_FStar_Absyn_Syntax.Exp_uvar (_), Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)))) | ((Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)), Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)))) -> begin
(let _68_14410 = (destruct_flex_e e1)
in (let _68_14409 = (destruct_flex_e e2)
in (flex_flex _68_14410 _68_14409)))
end
| ((Microsoft_FStar_Absyn_Syntax.Exp_uvar (_), _)) | ((Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)), _)) -> begin
(let _68_14411 = (destruct_flex_e e1)
in (flex_rigid _68_14411 e2))
end
| ((_, Microsoft_FStar_Absyn_Syntax.Exp_uvar (_))) | ((_, Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _)))) -> begin
(let _68_14412 = (destruct_flex_e e2)
in (flex_rigid _68_14412 e1))
end
| (Microsoft_FStar_Absyn_Syntax.Exp_bvar (x1), Microsoft_FStar_Absyn_Syntax.Exp_bvar (x1')) -> begin
(match ((Microsoft_FStar_Absyn_Util.bvd_eq x1.Microsoft_FStar_Absyn_Syntax.v x1'.Microsoft_FStar_Absyn_Syntax.v)) with
| true -> begin
(let _68_14413 = (solve_prob orig None [] wl)
in (solve env _68_14413))
end
| false -> begin
(let _68_14419 = (let _68_14418 = (let _68_14417 = (let _68_14416 = (Microsoft_FStar_Tc_Recheck.recompute_typ e1)
in (let _68_14415 = (Microsoft_FStar_Tc_Recheck.recompute_typ e2)
in (Microsoft_FStar_Absyn_Util.mk_eq _68_14416 _68_14415 e1 e2)))
in (Support.Prims.pipe_left (fun ( _68_14414 ) -> Some (_68_14414)) _68_14417))
in (solve_prob orig _68_14418 [] wl))
in (solve env _68_14419))
end)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_fvar ((fv1, _33_3531)), Microsoft_FStar_Absyn_Syntax.Exp_fvar ((fv1', _33_3536))) -> begin
(match ((Microsoft_FStar_Absyn_Syntax.lid_equals fv1.Microsoft_FStar_Absyn_Syntax.v fv1'.Microsoft_FStar_Absyn_Syntax.v)) with
| true -> begin
(let _68_14420 = (solve_prob orig None [] wl)
in (solve env _68_14420))
end
| false -> begin
(giveup env "free-variables unequal" orig)
end)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_constant (s1), Microsoft_FStar_Absyn_Syntax.Exp_constant (s1')) -> begin
(let const_eq = (fun ( s1 ) ( s2 ) -> (match ((s1, s2)) with
| (Microsoft_FStar_Absyn_Syntax.Const_bytearray ((b1, _33_3550)), Microsoft_FStar_Absyn_Syntax.Const_bytearray ((b2, _33_3555))) -> begin
(b1 = b2)
end
| (Microsoft_FStar_Absyn_Syntax.Const_string ((b1, _33_3561)), Microsoft_FStar_Absyn_Syntax.Const_string ((b2, _33_3566))) -> begin
(b1 = b2)
end
| _33_3571 -> begin
(s1 = s2)
end))
in (match ((const_eq s1 s1')) with
| true -> begin
(let _68_14425 = (solve_prob orig None [] wl)
in (solve env _68_14425))
end
| false -> begin
(giveup env "constants unequal" orig)
end))
end
| (Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_abs (_33_3581); Microsoft_FStar_Absyn_Syntax.tk = _33_3579; Microsoft_FStar_Absyn_Syntax.pos = _33_3577; Microsoft_FStar_Absyn_Syntax.fvs = _33_3575; Microsoft_FStar_Absyn_Syntax.uvs = _33_3573}, _33_3585)), _33_3589) -> begin
(let _68_14427 = (let _33_3591 = problem
in (let _68_14426 = (whnf_e env e1)
in {lhs = _68_14426; relation = _33_3591.relation; rhs = _33_3591.rhs; element = _33_3591.element; logical_guard = _33_3591.logical_guard; scope = _33_3591.scope; reason = _33_3591.reason; loc = _33_3591.loc; rank = _33_3591.rank}))
in (solve_e env _68_14427 wl))
end
| (_33_3594, Microsoft_FStar_Absyn_Syntax.Exp_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Exp_abs (_33_3604); Microsoft_FStar_Absyn_Syntax.tk = _33_3602; Microsoft_FStar_Absyn_Syntax.pos = _33_3600; Microsoft_FStar_Absyn_Syntax.fvs = _33_3598; Microsoft_FStar_Absyn_Syntax.uvs = _33_3596}, _33_3608))) -> begin
(let _68_14429 = (let _33_3612 = problem
in (let _68_14428 = (whnf_e env e2)
in {lhs = _33_3612.lhs; relation = _33_3612.relation; rhs = _68_14428; element = _33_3612.element; logical_guard = _33_3612.logical_guard; scope = _33_3612.scope; reason = _33_3612.reason; loc = _33_3612.loc; rank = _33_3612.rank}))
in (solve_e env _68_14429 wl))
end
| (Microsoft_FStar_Absyn_Syntax.Exp_app ((head1, args1)), Microsoft_FStar_Absyn_Syntax.Exp_app ((head2, args2))) -> begin
(let orig_wl = wl
in (let rec solve_args = (fun ( sub_probs ) ( wl ) ( args1 ) ( args2 ) -> (match ((args1, args2)) with
| ([], []) -> begin
(let guard = (let _68_14439 = (let _68_14438 = (Support.List.map p_guard sub_probs)
in (Support.Prims.pipe_right _68_14438 (Support.List.map Support.Prims.fst)))
in (Microsoft_FStar_Absyn_Util.mk_conj_l _68_14439))
in (let g = (simplify_formula env guard)
in (let g = (Microsoft_FStar_Absyn_Util.compress_typ g)
in (match (g.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (fv) when (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.true_lid) -> begin
(let _68_14440 = (solve_prob orig None wl.subst (let _33_3637 = orig_wl
in {attempting = _33_3637.attempting; deferred = _33_3637.deferred; subst = []; ctr = _33_3637.ctr; slack_vars = _33_3637.slack_vars; defer_ok = _33_3637.defer_ok; smt_ok = _33_3637.smt_ok; tcenv = _33_3637.tcenv}))
in (solve env _68_14440))
end
| _33_3640 -> begin
(let _33_3644 = (let _68_14442 = (Microsoft_FStar_Tc_Env.get_range env)
in (let _68_14441 = (Microsoft_FStar_Tc_Env.binders env)
in (new_tvar _68_14442 _68_14441 Microsoft_FStar_Absyn_Syntax.ktype)))
in (match (_33_3644) with
| (t, _33_3643) -> begin
(let guard = (let _68_14443 = (Microsoft_FStar_Absyn_Util.mk_eq t t e1 e2)
in (Microsoft_FStar_Absyn_Util.mk_disj g _68_14443))
in (let _68_14444 = (solve_prob orig (Some (guard)) wl.subst (let _33_3646 = orig_wl
in {attempting = _33_3646.attempting; deferred = _33_3646.deferred; subst = []; ctr = _33_3646.ctr; slack_vars = _33_3646.slack_vars; defer_ok = _33_3646.defer_ok; smt_ok = _33_3646.smt_ok; tcenv = _33_3646.tcenv}))
in (solve env _68_14444)))
end))
end))))
end
| (arg1::rest1, arg2::rest2) -> begin
(let prob = (match (((Support.Prims.fst arg1), (Support.Prims.fst arg2))) with
| (Support.Microsoft.FStar.Util.Inl (t1), Support.Microsoft.FStar.Util.Inl (t2)) -> begin
(let _68_14446 = (mk_problem (p_scope orig) orig t1 EQ t2 None "expression type arg")
in (Support.Prims.pipe_left (fun ( _68_14445 ) -> TProb (_68_14445)) _68_14446))
end
| (Support.Microsoft.FStar.Util.Inr (e1), Support.Microsoft.FStar.Util.Inr (e2)) -> begin
(let _68_14448 = (mk_problem (p_scope orig) orig e1 EQ e2 None "expression arg")
in (Support.Prims.pipe_left (fun ( _68_14447 ) -> EProb (_68_14447)) _68_14448))
end
| _33_3666 -> begin
(failwith ("Impossible: ill-typed expression"))
end)
in (match ((solve env (let _33_3668 = wl
in {attempting = (prob)::[]; deferred = []; subst = _33_3668.subst; ctr = _33_3668.ctr; slack_vars = _33_3668.slack_vars; defer_ok = false; smt_ok = false; tcenv = _33_3668.tcenv}))) with
| Failed (_33_3671) -> begin
(smt_fallback e1 e2)
end
| Success ((subst, _33_3675)) -> begin
(solve_args ((prob)::sub_probs) (let _33_3678 = wl
in {attempting = _33_3678.attempting; deferred = _33_3678.deferred; subst = subst; ctr = _33_3678.ctr; slack_vars = _33_3678.slack_vars; defer_ok = _33_3678.defer_ok; smt_ok = _33_3678.smt_ok; tcenv = _33_3678.tcenv}) rest1 rest2)
end))
end
| _33_3681 -> begin
(failwith ("Impossible: lengths defer"))
end))
in (let rec match_head_and_args = (fun ( head1 ) ( head2 ) -> (match ((let _68_14456 = (let _68_14453 = (Microsoft_FStar_Absyn_Util.compress_exp head1)
in _68_14453.Microsoft_FStar_Absyn_Syntax.n)
in (let _68_14455 = (let _68_14454 = (Microsoft_FStar_Absyn_Util.compress_exp head2)
in _68_14454.Microsoft_FStar_Absyn_Syntax.n)
in (_68_14456, _68_14455)))) with
| (Microsoft_FStar_Absyn_Syntax.Exp_bvar (x), Microsoft_FStar_Absyn_Syntax.Exp_bvar (y)) when ((Microsoft_FStar_Absyn_Util.bvar_eq x y) && ((Support.List.length args1) = (Support.List.length args2))) -> begin
(solve_args [] wl args1 args2)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_fvar ((f, _33_3692)), Microsoft_FStar_Absyn_Syntax.Exp_fvar ((g, _33_3697))) when (((Microsoft_FStar_Absyn_Util.fvar_eq f g) && (not ((Microsoft_FStar_Absyn_Util.is_interpreted f.Microsoft_FStar_Absyn_Syntax.v)))) && ((Support.List.length args1) = (Support.List.length args2))) -> begin
(solve_args [] wl args1 args2)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_ascribed ((e, _33_3703, _33_3705)), _33_3709) -> begin
(match_head_and_args e head2)
end
| (_33_3712, Microsoft_FStar_Absyn_Syntax.Exp_ascribed ((e, _33_3715, _33_3717))) -> begin
(match_head_and_args head1 e)
end
| (Microsoft_FStar_Absyn_Syntax.Exp_abs (_33_3722), _33_3725) -> begin
(let _68_14458 = (let _33_3727 = problem
in (let _68_14457 = (whnf_e env e1)
in {lhs = _68_14457; relation = _33_3727.relation; rhs = _33_3727.rhs; element = _33_3727.element; logical_guard = _33_3727.logical_guard; scope = _33_3727.scope; reason = _33_3727.reason; loc = _33_3727.loc; rank = _33_3727.rank}))
in (solve_e env _68_14458 wl))
end
| (_33_3730, Microsoft_FStar_Absyn_Syntax.Exp_abs (_33_3732)) -> begin
(let _68_14460 = (let _33_3735 = problem
in (let _68_14459 = (whnf_e env e2)
in {lhs = _33_3735.lhs; relation = _33_3735.relation; rhs = _68_14459; element = _33_3735.element; logical_guard = _33_3735.logical_guard; scope = _33_3735.scope; reason = _33_3735.reason; loc = _33_3735.loc; rank = _33_3735.rank}))
in (solve_e env _68_14460 wl))
end
| _33_3738 -> begin
(smt_fallback e1 e2)
end))
in (match_head_and_args head1 head2))))
end
| _33_3740 -> begin
(let _33_3744 = (let _68_14462 = (Microsoft_FStar_Tc_Env.get_range env)
in (let _68_14461 = (Microsoft_FStar_Tc_Env.binders env)
in (new_tvar _68_14462 _68_14461 Microsoft_FStar_Absyn_Syntax.ktype)))
in (match (_33_3744) with
| (t, _33_3743) -> begin
(let guard = (Microsoft_FStar_Absyn_Util.mk_eq t t e1 e2)
in (let _33_3746 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14463 = (Microsoft_FStar_Absyn_Print.typ_to_string guard)
in (Support.Microsoft.FStar.Util.fprint1 "Emitting guard %s\n" _68_14463))
end
| false -> begin
()
end)
in (let _68_14467 = (let _68_14466 = (let _68_14465 = (Microsoft_FStar_Absyn_Util.mk_eq t t e1 e2)
in (Support.Prims.pipe_left (fun ( _68_14464 ) -> Some (_68_14464)) _68_14465))
in (solve_prob orig _68_14466 [] wl))
in (solve env _68_14467))))
end))
end)))))))))))

type guard_formula =
| Trivial
| NonTrivial of Microsoft_FStar_Absyn_Syntax.formula

let is_Trivial = (fun ( _discr_ ) -> (match (_discr_) with
| Trivial -> begin
true
end
| _ -> begin
false
end))

let is_NonTrivial = (fun ( _discr_ ) -> (match (_discr_) with
| NonTrivial (_) -> begin
true
end
| _ -> begin
false
end))

type implicits =
((Microsoft_FStar_Absyn_Syntax.uvar_t * Support.Microsoft.FStar.Range.range), (Microsoft_FStar_Absyn_Syntax.uvar_e * Support.Microsoft.FStar.Range.range)) Support.Microsoft.FStar.Util.either list

type guard_t =
{guard_f : guard_formula; deferred : deferred; implicits : implicits}

let is_Mkguard_t = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkguard_t")))

let guard_to_string = (fun ( env ) ( g ) -> (let form = (match (g.guard_f) with
| Trivial -> begin
"trivial"
end
| NonTrivial (f) -> begin
(match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(Microsoft_FStar_Tc_Normalize.formula_norm_to_string env f)
end
| false -> begin
"non-trivial"
end)
end)
in (let carry = (let _68_14491 = (Support.List.map (fun ( _33_3763 ) -> (match (_33_3763) with
| (_33_3761, x) -> begin
(prob_to_string env x)
end)) g.deferred.carry)
in (Support.Prims.pipe_right _68_14491 (Support.String.concat ",\n")))
in (Support.Microsoft.FStar.Util.format2 "\n\t{guard_f=%s;\n\t deferred={\n%s};}\n" form carry))))

let guard_of_guard_formula = (fun ( g ) -> {guard_f = g; deferred = {carry = []; slack = []}; implicits = []})

let guard_f = (fun ( g ) -> g.guard_f)

let is_trivial = (fun ( g ) -> (match (g) with
| {guard_f = Trivial; deferred = {carry = []; slack = []}; implicits = _33_3769} -> begin
true
end
| _33_3776 -> begin
false
end))

let trivial_guard = {guard_f = Trivial; deferred = {carry = []; slack = []}; implicits = []}

let abstract_guard = (fun ( x ) ( g ) -> (match (g) with
| (None) | (Some ({guard_f = Trivial; deferred = _; implicits = _})) -> begin
g
end
| Some (g) -> begin
(let f = (match (g.guard_f) with
| NonTrivial (f) -> begin
f
end
| _33_3792 -> begin
(failwith ("impossible"))
end)
in (let _68_14508 = (let _33_3794 = g
in (let _68_14507 = (let _68_14506 = (let _68_14505 = (let _68_14504 = (let _68_14503 = (Microsoft_FStar_Absyn_Syntax.v_binder x)
in (_68_14503)::[])
in (_68_14504, f))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam _68_14505 None f.Microsoft_FStar_Absyn_Syntax.pos))
in (Support.Prims.pipe_left (fun ( _68_14502 ) -> NonTrivial (_68_14502)) _68_14506))
in {guard_f = _68_14507; deferred = _33_3794.deferred; implicits = _33_3794.implicits}))
in Some (_68_14508)))
end))

let apply_guard = (fun ( g ) ( e ) -> (match (g.guard_f) with
| Trivial -> begin
g
end
| NonTrivial (f) -> begin
(let _33_3801 = g
in (let _68_14520 = (let _68_14519 = (let _68_14518 = (let _68_14517 = (let _68_14516 = (let _68_14515 = (Microsoft_FStar_Absyn_Syntax.varg e)
in (_68_14515)::[])
in (f, _68_14516))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_app _68_14517))
in (Support.Prims.pipe_left (Microsoft_FStar_Absyn_Syntax.syn f.Microsoft_FStar_Absyn_Syntax.pos (Some (Microsoft_FStar_Absyn_Syntax.ktype))) _68_14518))
in NonTrivial (_68_14519))
in {guard_f = _68_14520; deferred = _33_3801.deferred; implicits = _33_3801.implicits}))
end))

let trivial = (fun ( t ) -> (match (t) with
| Trivial -> begin
()
end
| NonTrivial (_33_3806) -> begin
(failwith ("impossible"))
end))

let conj_guard_f = (fun ( g1 ) ( g2 ) -> (match ((g1, g2)) with
| ((Trivial, g)) | ((g, Trivial)) -> begin
g
end
| (NonTrivial (f1), NonTrivial (f2)) -> begin
(let _68_14527 = (Microsoft_FStar_Absyn_Util.mk_conj f1 f2)
in NonTrivial (_68_14527))
end))

let check_trivial = (fun ( t ) -> (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (tc) when (Microsoft_FStar_Absyn_Syntax.lid_equals tc.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.true_lid) -> begin
Trivial
end
| _33_3824 -> begin
NonTrivial (t)
end))

let imp_guard_f = (fun ( g1 ) ( g2 ) -> (match ((g1, g2)) with
| (Trivial, g) -> begin
g
end
| (g, Trivial) -> begin
Trivial
end
| (NonTrivial (f1), NonTrivial (f2)) -> begin
(let imp = (Microsoft_FStar_Absyn_Util.mk_imp f1 f2)
in (check_trivial imp))
end))

let binop_guard = (fun ( f ) ( g1 ) ( g2 ) -> (let _68_14550 = (f g1.guard_f g2.guard_f)
in {guard_f = _68_14550; deferred = {carry = (Support.List.append g1.deferred.carry g2.deferred.carry); slack = (Support.List.append g1.deferred.slack g2.deferred.slack)}; implicits = (Support.List.append g1.implicits g2.implicits)}))

let conj_guard = (fun ( g1 ) ( g2 ) -> (binop_guard conj_guard_f g1 g2))

let imp_guard = (fun ( g1 ) ( g2 ) -> (binop_guard imp_guard_f g1 g2))

let close_guard = (fun ( binders ) ( g ) -> (match (g.guard_f) with
| Trivial -> begin
g
end
| NonTrivial (f) -> begin
(let _33_3851 = g
in (let _68_14565 = (let _68_14564 = (Microsoft_FStar_Absyn_Util.close_forall binders f)
in (Support.Prims.pipe_right _68_14564 (fun ( _68_14563 ) -> NonTrivial (_68_14563))))
in {guard_f = _68_14565; deferred = _33_3851.deferred; implicits = _33_3851.implicits}))
end))

let mk_guard = (fun ( g ) ( ps ) ( slack ) ( locs ) -> {guard_f = g; deferred = {carry = ps; slack = slack}; implicits = []})

let new_t_problem = (fun ( env ) ( lhs ) ( rel ) ( rhs ) ( elt ) ( loc ) -> (let reason = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("ExplainRel")))) with
| true -> begin
(let _68_14577 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env lhs)
in (let _68_14576 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env rhs)
in (Support.Microsoft.FStar.Util.format3 "Top-level:\n%s\n\t%s\n%s" _68_14577 (rel_to_string rel) _68_14576)))
end
| false -> begin
"TOP"
end)
in (let p = (new_problem env lhs rel rhs elt loc reason)
in p)))

let new_t_prob = (fun ( env ) ( t1 ) ( rel ) ( t2 ) -> (let x = (let _68_14586 = (Microsoft_FStar_Tc_Env.get_range env)
in (Microsoft_FStar_Absyn_Util.gen_bvar_p _68_14586 t1))
in (let env = (Microsoft_FStar_Tc_Env.push_local_binding env (Microsoft_FStar_Tc_Env.Binding_var ((x.Microsoft_FStar_Absyn_Syntax.v, x.Microsoft_FStar_Absyn_Syntax.sort))))
in (let p = (let _68_14590 = (let _68_14588 = (Microsoft_FStar_Absyn_Util.bvar_to_exp x)
in (Support.Prims.pipe_left (fun ( _68_14587 ) -> Some (_68_14587)) _68_14588))
in (let _68_14589 = (Microsoft_FStar_Tc_Env.get_range env)
in (new_t_problem env t1 rel t2 _68_14590 _68_14589)))
in (TProb (p), x)))))

let new_k_problem = (fun ( env ) ( lhs ) ( rel ) ( rhs ) ( elt ) ( loc ) -> (let reason = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("ExplainRel")))) with
| true -> begin
(let _68_14598 = (Microsoft_FStar_Tc_Normalize.kind_norm_to_string env lhs)
in (let _68_14597 = (Microsoft_FStar_Tc_Normalize.kind_norm_to_string env rhs)
in (Support.Microsoft.FStar.Util.format3 "Top-level:\n%s\n\t%s\n%s" _68_14598 (rel_to_string rel) _68_14597)))
end
| false -> begin
"TOP"
end)
in (let p = (new_problem env lhs rel rhs elt loc reason)
in p)))

let simplify_guard = (fun ( env ) ( g ) -> (match (g.guard_f) with
| Trivial -> begin
g
end
| NonTrivial (f) -> begin
(let _33_3885 = (match ((Microsoft_FStar_Tc_Env.debug env Microsoft_FStar_Options.High)) with
| true -> begin
(let _68_14603 = (Microsoft_FStar_Absyn_Print.typ_to_string f)
in (Support.Microsoft.FStar.Util.fprint1 "Simplifying guard %s\n" _68_14603))
end
| false -> begin
()
end)
in (let f = (Microsoft_FStar_Tc_Normalize.norm_typ ((Microsoft_FStar_Tc_Normalize.Beta)::(Microsoft_FStar_Tc_Normalize.Simplify)::[]) env f)
in (let f = (match (f.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (fv) when (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.true_lid) -> begin
Trivial
end
| _33_3891 -> begin
NonTrivial (f)
end)
in (let _33_3893 = g
in {guard_f = f; deferred = _33_3893.deferred; implicits = _33_3893.implicits}))))
end))

let solve_and_commit = (fun ( env ) ( probs ) ( err ) -> (let probs = (match ((Support.ST.read Microsoft_FStar_Options.eager_inference)) with
| true -> begin
(let _33_3898 = probs
in {attempting = _33_3898.attempting; deferred = _33_3898.deferred; subst = _33_3898.subst; ctr = _33_3898.ctr; slack_vars = _33_3898.slack_vars; defer_ok = false; smt_ok = _33_3898.smt_ok; tcenv = _33_3898.tcenv})
end
| false -> begin
probs
end)
in (let sol = (solve env probs)
in (match (sol) with
| Success ((s, deferred)) -> begin
(let _33_3906 = (commit env s)
in Some (deferred))
end
| Failed ((d, s)) -> begin
(let _33_3912 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("ExplainRel")))) with
| true -> begin
(let _68_14615 = (explain env d s)
in (Support.Prims.pipe_left Support.Microsoft.FStar.Util.print_string _68_14615))
end
| false -> begin
()
end)
in (err (d, s)))
end))))

let with_guard = (fun ( env ) ( prob ) ( dopt ) -> (match (dopt) with
| None -> begin
None
end
| Some (d) -> begin
(let _68_14627 = (let _68_14626 = (let _68_14625 = (let _68_14624 = (Support.Prims.pipe_right (p_guard prob) Support.Prims.fst)
in (Support.Prims.pipe_right _68_14624 (fun ( _68_14623 ) -> NonTrivial (_68_14623))))
in {guard_f = _68_14625; deferred = d; implicits = []})
in (simplify_guard env _68_14626))
in (Support.Prims.pipe_left (fun ( _68_14622 ) -> Some (_68_14622)) _68_14627))
end))

let try_keq = (fun ( env ) ( k1 ) ( k2 ) -> (let _33_3923 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14635 = (Microsoft_FStar_Absyn_Print.kind_to_string k1)
in (let _68_14634 = (Microsoft_FStar_Absyn_Print.kind_to_string k2)
in (Support.Microsoft.FStar.Util.fprint2 "try_keq of %s and %s\n" _68_14635 _68_14634)))
end
| false -> begin
()
end)
in (let prob = (let _68_14640 = (let _68_14639 = (Microsoft_FStar_Tc_Normalize.norm_kind ((Microsoft_FStar_Tc_Normalize.Beta)::[]) env k1)
in (let _68_14638 = (Microsoft_FStar_Tc_Normalize.norm_kind ((Microsoft_FStar_Tc_Normalize.Beta)::[]) env k2)
in (let _68_14637 = (Microsoft_FStar_Tc_Env.get_range env)
in (new_k_problem env _68_14639 EQ _68_14638 None _68_14637))))
in (Support.Prims.pipe_left (fun ( _68_14636 ) -> KProb (_68_14636)) _68_14640))
in (let _68_14642 = (solve_and_commit env (singleton env prob) (fun ( _33_3926 ) -> None))
in (Support.Prims.pipe_left (with_guard env prob) _68_14642)))))

let keq = (fun ( env ) ( t ) ( k1 ) ( k2 ) -> (match ((try_keq env k1 k2)) with
| None -> begin
(let r = (match (t) with
| None -> begin
(Microsoft_FStar_Tc_Env.get_range env)
end
| Some (t) -> begin
t.Microsoft_FStar_Absyn_Syntax.pos
end)
in (match (t) with
| None -> begin
(let _68_14653 = (let _68_14652 = (let _68_14651 = (Microsoft_FStar_Tc_Errors.incompatible_kinds env k2 k1)
in (_68_14651, r))
in Microsoft_FStar_Absyn_Syntax.Error (_68_14652))
in (raise (_68_14653)))
end
| Some (t) -> begin
(let _68_14656 = (let _68_14655 = (let _68_14654 = (Microsoft_FStar_Tc_Errors.expected_typ_of_kind env k2 t k1)
in (_68_14654, r))
in Microsoft_FStar_Absyn_Syntax.Error (_68_14655))
in (raise (_68_14656)))
end))
end
| Some (g) -> begin
g
end))

let subkind = (fun ( env ) ( k1 ) ( k2 ) -> (let _33_3945 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14666 = (let _68_14663 = (Microsoft_FStar_Tc_Env.get_range env)
in (Support.Prims.pipe_left Support.Microsoft.FStar.Range.string_of_range _68_14663))
in (let _68_14665 = (Microsoft_FStar_Absyn_Print.kind_to_string k1)
in (let _68_14664 = (Microsoft_FStar_Absyn_Print.kind_to_string k2)
in (Support.Microsoft.FStar.Util.fprint3 "(%s) subkind of %s and %s\n" _68_14666 _68_14665 _68_14664))))
end
| false -> begin
()
end)
in (let prob = (let _68_14671 = (let _68_14670 = (whnf_k env k1)
in (let _68_14669 = (whnf_k env k2)
in (let _68_14668 = (Microsoft_FStar_Tc_Env.get_range env)
in (new_k_problem env _68_14670 SUB _68_14669 None _68_14668))))
in (Support.Prims.pipe_left (fun ( _68_14667 ) -> KProb (_68_14667)) _68_14671))
in (let res = (let _68_14678 = (let _68_14677 = (solve_and_commit env (singleton env prob) (fun ( _33_3948 ) -> (let _68_14676 = (let _68_14675 = (let _68_14674 = (Microsoft_FStar_Tc_Errors.incompatible_kinds env k1 k2)
in (let _68_14673 = (Microsoft_FStar_Tc_Env.get_range env)
in (_68_14674, _68_14673)))
in Microsoft_FStar_Absyn_Syntax.Error (_68_14675))
in (raise (_68_14676)))))
in (Support.Prims.pipe_left (with_guard env prob) _68_14677))
in (Support.Microsoft.FStar.Util.must _68_14678))
in res))))

let try_teq = (fun ( env ) ( t1 ) ( t2 ) -> (let _33_3954 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14686 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (let _68_14685 = (Microsoft_FStar_Absyn_Print.typ_to_string t2)
in (Support.Microsoft.FStar.Util.fprint2 "try_teq of %s and %s\n" _68_14686 _68_14685)))
end
| false -> begin
()
end)
in (let prob = (let _68_14689 = (let _68_14688 = (Microsoft_FStar_Tc_Env.get_range env)
in (new_t_problem env t1 EQ t2 None _68_14688))
in (Support.Prims.pipe_left (fun ( _68_14687 ) -> TProb (_68_14687)) _68_14689))
in (let g = (let _68_14691 = (solve_and_commit env (singleton env prob) (fun ( _33_3957 ) -> None))
in (Support.Prims.pipe_left (with_guard env prob) _68_14691))
in g))))

let teq = (fun ( env ) ( t1 ) ( t2 ) -> (match ((try_teq env t1 t2)) with
| None -> begin
(let _68_14701 = (let _68_14700 = (let _68_14699 = (Microsoft_FStar_Tc_Errors.basic_type_error env None t2 t1)
in (let _68_14698 = (Microsoft_FStar_Tc_Env.get_range env)
in (_68_14699, _68_14698)))
in Microsoft_FStar_Absyn_Syntax.Error (_68_14700))
in (raise (_68_14701)))
end
| Some (g) -> begin
(let _33_3966 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14704 = (Microsoft_FStar_Absyn_Print.typ_to_string t1)
in (let _68_14703 = (Microsoft_FStar_Absyn_Print.typ_to_string t2)
in (let _68_14702 = (guard_to_string env g)
in (Support.Microsoft.FStar.Util.fprint3 "teq of %s and %s succeeded with guard %s\n" _68_14704 _68_14703 _68_14702))))
end
| false -> begin
()
end)
in g)
end))

let try_subtype = (fun ( env ) ( t1 ) ( t2 ) -> (let _33_3971 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14712 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env t1)
in (let _68_14711 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env t2)
in (Support.Microsoft.FStar.Util.fprint2 "try_subtype of %s and %s\n" _68_14712 _68_14711)))
end
| false -> begin
()
end)
in (let _33_3975 = (new_t_prob env t1 SUB t2)
in (match (_33_3975) with
| (prob, x) -> begin
(let g = (let _68_14714 = (solve_and_commit env (singleton env prob) (fun ( _33_3976 ) -> None))
in (Support.Prims.pipe_left (with_guard env prob) _68_14714))
in (let _33_3979 = (match (((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel"))) && (Support.Microsoft.FStar.Util.is_some g))) with
| true -> begin
(let _68_14718 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env t1)
in (let _68_14717 = (Microsoft_FStar_Tc_Normalize.typ_norm_to_string env t2)
in (let _68_14716 = (let _68_14715 = (Support.Microsoft.FStar.Util.must g)
in (guard_to_string env _68_14715))
in (Support.Microsoft.FStar.Util.fprint3 "try_subtype succeeded: %s <: %s\n\tguard is %s\n" _68_14718 _68_14717 _68_14716))))
end
| false -> begin
()
end)
in (abstract_guard x g)))
end))))

let subtype_fail = (fun ( env ) ( t1 ) ( t2 ) -> (let _68_14725 = (let _68_14724 = (let _68_14723 = (Microsoft_FStar_Tc_Errors.basic_type_error env None t2 t1)
in (let _68_14722 = (Microsoft_FStar_Tc_Env.get_range env)
in (_68_14723, _68_14722)))
in Microsoft_FStar_Absyn_Syntax.Error (_68_14724))
in (raise (_68_14725))))

let subtype = (fun ( env ) ( t1 ) ( t2 ) -> (match ((try_subtype env t1 t2)) with
| Some (f) -> begin
f
end
| None -> begin
(subtype_fail env t1 t2)
end))

let sub_comp = (fun ( env ) ( c1 ) ( c2 ) -> (let _33_3993 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14739 = (Microsoft_FStar_Absyn_Print.comp_typ_to_string c1)
in (let _68_14738 = (Microsoft_FStar_Absyn_Print.comp_typ_to_string c2)
in (Support.Microsoft.FStar.Util.fprint2 "sub_comp of %s and %s\n" _68_14739 _68_14738)))
end
| false -> begin
()
end)
in (let rel = (match (env.Microsoft_FStar_Tc_Env.use_eq) with
| true -> begin
EQ
end
| false -> begin
SUB
end)
in (let prob = (let _68_14742 = (let _68_14741 = (Microsoft_FStar_Tc_Env.get_range env)
in (new_problem env c1 rel c2 None _68_14741 "sub_comp"))
in (Support.Prims.pipe_left (fun ( _68_14740 ) -> CProb (_68_14740)) _68_14742))
in (let _68_14744 = (solve_and_commit env (singleton env prob) (fun ( _33_3997 ) -> None))
in (Support.Prims.pipe_left (with_guard env prob) _68_14744))))))

let solve_deferred_constraints = (fun ( env ) ( g ) -> (let fail = (fun ( _33_4004 ) -> (match (_33_4004) with
| (d, s) -> begin
(let msg = (explain env d s)
in (raise (Microsoft_FStar_Absyn_Syntax.Error ((msg, (p_loc d))))))
end))
in (let _33_4009 = (match (((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel"))) && ((Support.List.length g.deferred.carry) <> 0))) with
| true -> begin
(let _68_14757 = (let _68_14756 = (Support.Prims.pipe_right g.deferred.carry (Support.List.map (fun ( _33_4008 ) -> (match (_33_4008) with
| (msg, x) -> begin
(let _68_14755 = (Support.Prims.pipe_left Support.Microsoft.FStar.Range.string_of_range (p_loc x))
in (let _68_14754 = (prob_to_string env x)
in (let _68_14753 = (let _68_14752 = (Support.Prims.pipe_right (p_guard x) Support.Prims.fst)
in (Microsoft_FStar_Tc_Normalize.formula_norm_to_string env _68_14752))
in (Support.Microsoft.FStar.Util.format4 "(At %s) %s\n%s\nguard is %s\n" _68_14755 msg _68_14754 _68_14753))))
end))))
in (Support.Prims.pipe_right _68_14756 (Support.String.concat "\n")))
in (Support.Prims.pipe_left (Support.Microsoft.FStar.Util.fprint1 "Trying to solve carried problems: begin\n%s\nend\n") _68_14757))
end
| false -> begin
()
end)
in (let gopt = (let _68_14758 = (wl_of_guard env g.deferred)
in (solve_and_commit env _68_14758 fail))
in (match (gopt) with
| Some ({carry = _33_4014; slack = slack}) -> begin
(let _33_4017 = (fix_slack_vars slack)
in (let _33_4019 = g
in {guard_f = _33_4019.guard_f; deferred = no_deferred; implicits = _33_4019.implicits}))
end
| _33_4022 -> begin
(failwith ("impossible"))
end)))))

let try_discharge_guard = (fun ( env ) ( g ) -> (let g = (solve_deferred_constraints env g)
in (match ((not ((Microsoft_FStar_Options.should_verify env.Microsoft_FStar_Tc_Env.curmodule.Microsoft_FStar_Absyn_Syntax.str)))) with
| true -> begin
()
end
| false -> begin
(match (g.guard_f) with
| Trivial -> begin
()
end
| NonTrivial (vc) -> begin
(let vc = (Microsoft_FStar_Tc_Normalize.norm_typ ((Microsoft_FStar_Tc_Normalize.DeltaHard)::(Microsoft_FStar_Tc_Normalize.Beta)::(Microsoft_FStar_Tc_Normalize.Eta)::(Microsoft_FStar_Tc_Normalize.Simplify)::[]) env vc)
in (match ((check_trivial vc)) with
| Trivial -> begin
()
end
| NonTrivial (vc) -> begin
(let _33_4033 = (match ((Support.Prims.pipe_left (Microsoft_FStar_Tc_Env.debug env) (Microsoft_FStar_Options.Other ("Rel")))) with
| true -> begin
(let _68_14765 = (Microsoft_FStar_Tc_Env.get_range env)
in (let _68_14764 = (let _68_14763 = (Microsoft_FStar_Absyn_Print.formula_to_string vc)
in (Support.Microsoft.FStar.Util.format1 "Checking VC=\n%s\n" _68_14763))
in (Microsoft_FStar_Tc_Errors.diag _68_14765 _68_14764)))
end
| false -> begin
()
end)
in (env.Microsoft_FStar_Tc_Env.solver.Microsoft_FStar_Tc_Env.solve env vc))
end))
end)
end)))




