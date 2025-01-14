
type step =
| WHNF
| Eta
| Delta
| DeltaHard
| Beta
| DeltaComp
| Simplify
| SNComp
| Unmeta
| Unlabel 
 and steps =
step list

let is_WHNF = (fun ( _discr_ ) -> (match (_discr_) with
| WHNF -> begin
true
end
| _ -> begin
false
end))

let is_Eta = (fun ( _discr_ ) -> (match (_discr_) with
| Eta -> begin
true
end
| _ -> begin
false
end))

let is_Delta = (fun ( _discr_ ) -> (match (_discr_) with
| Delta -> begin
true
end
| _ -> begin
false
end))

let is_DeltaHard = (fun ( _discr_ ) -> (match (_discr_) with
| DeltaHard -> begin
true
end
| _ -> begin
false
end))

let is_Beta = (fun ( _discr_ ) -> (match (_discr_) with
| Beta -> begin
true
end
| _ -> begin
false
end))

let is_DeltaComp = (fun ( _discr_ ) -> (match (_discr_) with
| DeltaComp -> begin
true
end
| _ -> begin
false
end))

let is_Simplify = (fun ( _discr_ ) -> (match (_discr_) with
| Simplify -> begin
true
end
| _ -> begin
false
end))

let is_SNComp = (fun ( _discr_ ) -> (match (_discr_) with
| SNComp -> begin
true
end
| _ -> begin
false
end))

let is_Unmeta = (fun ( _discr_ ) -> (match (_discr_) with
| Unmeta -> begin
true
end
| _ -> begin
false
end))

let is_Unlabel = (fun ( _discr_ ) -> (match (_discr_) with
| Unlabel -> begin
true
end
| _ -> begin
false
end))

type 'a config =
{code : 'a; environment : environment; stack : stack; close : ('a  ->  'a) option; steps : step list} 
 and environment =
{context : env_entry list; label_suffix : (bool option * Support.Microsoft.FStar.Range.range) list} 
 and stack =
{args : (Microsoft_FStar_Absyn_Syntax.arg * environment) list} 
 and env_entry =
| T of (Microsoft_FStar_Absyn_Syntax.btvdef * tclos)
| V of (Microsoft_FStar_Absyn_Syntax.bvvdef * vclos) 
 and tclos =
(Microsoft_FStar_Absyn_Syntax.typ * environment) 
 and vclos =
(Microsoft_FStar_Absyn_Syntax.exp * environment) 
 and 'a memo =
'a option ref

let is_Mkconfig = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkconfig")))

let is_Mkenvironment = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkenvironment")))

let is_Mkstack = (fun ( _ ) -> (failwith ("Not yet implemented:is_Mkstack")))

let is_T = (fun ( _discr_ ) -> (match (_discr_) with
| T (_) -> begin
true
end
| _ -> begin
false
end))

let is_V = (fun ( _discr_ ) -> (match (_discr_) with
| V (_) -> begin
true
end
| _ -> begin
false
end))

let empty_env = {context = []; label_suffix = []}

let extend_env' = (fun ( env ) ( b ) -> (let _30_29 = env
in {context = (b)::env.context; label_suffix = _30_29.label_suffix}))

let extend_env = (fun ( env ) ( bindings ) -> (let _30_33 = env
in {context = (Support.List.append bindings env.context); label_suffix = _30_33.label_suffix}))

let lookup_env = (fun ( env ) ( key ) -> (Support.Prims.pipe_right env.context (Support.Microsoft.FStar.Util.find_opt (fun ( _30_1 ) -> (match (_30_1) with
| T ((a, _30_40)) -> begin
(a.Microsoft_FStar_Absyn_Syntax.realname.Microsoft_FStar_Absyn_Syntax.idText = key)
end
| V ((x, _30_45)) -> begin
(x.Microsoft_FStar_Absyn_Syntax.realname.Microsoft_FStar_Absyn_Syntax.idText = key)
end)))))

let fold_env = (fun ( env ) ( f ) ( acc ) -> (Support.List.fold_left (fun ( acc ) ( v ) -> (match (v) with
| T ((a, _30_55)) -> begin
(f a.Microsoft_FStar_Absyn_Syntax.realname.Microsoft_FStar_Absyn_Syntax.idText v acc)
end
| V ((x, _30_60)) -> begin
(f x.Microsoft_FStar_Absyn_Syntax.realname.Microsoft_FStar_Absyn_Syntax.idText v acc)
end)) acc env.context))

let empty_stack = {args = []}

let rec subst_of_env' = (fun ( env ) -> (fold_env env (fun ( _30_64 ) ( v ) ( acc ) -> (match (v) with
| T ((a, (t, env'))) -> begin
(let _68_12172 = (let _68_12171 = (let _68_12170 = (let _68_12169 = (subst_of_env' env')
in (Microsoft_FStar_Absyn_Util.subst_typ _68_12169 t))
in (a, _68_12170))
in Support.Microsoft.FStar.Util.Inl (_68_12171))
in (_68_12172)::acc)
end
| V ((x, (v, env'))) -> begin
(let _68_12176 = (let _68_12175 = (let _68_12174 = (let _68_12173 = (subst_of_env' env')
in (Microsoft_FStar_Absyn_Util.subst_exp _68_12173 v))
in (x, _68_12174))
in Support.Microsoft.FStar.Util.Inr (_68_12175))
in (_68_12176)::acc)
end)) []))

let subst_of_env = (fun ( tcenv ) ( env ) -> (subst_of_env' env))

let with_new_code = (fun ( c ) ( e ) -> {code = e; environment = c.environment; stack = empty_stack; close = None; steps = c.steps})

let rec eta_expand = (fun ( tcenv ) ( t ) -> (let k = (let _68_12186 = (Microsoft_FStar_Tc_Recheck.recompute_kind t)
in (Support.Prims.pipe_right _68_12186 Microsoft_FStar_Absyn_Util.compress_kind))
in (let rec aux = (fun ( t ) ( k ) -> (match (k.Microsoft_FStar_Absyn_Syntax.n) with
| (Microsoft_FStar_Absyn_Syntax.Kind_type) | (Microsoft_FStar_Absyn_Syntax.Kind_effect) | (Microsoft_FStar_Absyn_Syntax.Kind_uvar (_)) -> begin
t
end
| Microsoft_FStar_Absyn_Syntax.Kind_abbrev ((_30_96, k)) -> begin
(aux t k)
end
| Microsoft_FStar_Absyn_Syntax.Kind_arrow ((binders, k')) -> begin
(match ((let _68_12191 = (Microsoft_FStar_Absyn_Util.unascribe_typ t)
in _68_12191.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((real, body)) -> begin
(let rec aux = (fun ( real ) ( expected ) -> (match ((real, expected)) with
| (_30_113::real, _30_117::expected) -> begin
(aux real expected)
end
| ([], []) -> begin
t
end
| (_30_126::_30_124, []) -> begin
(failwith ("Ill-kinded type"))
end
| ([], more) -> begin
(let _30_135 = (Microsoft_FStar_Absyn_Util.args_of_binders more)
in (match (_30_135) with
| (more, args) -> begin
(let body = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app (body, args) None body.Microsoft_FStar_Absyn_Syntax.pos)
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam ((Support.List.append binders more), body) None body.Microsoft_FStar_Absyn_Syntax.pos))
end))
end))
in (aux real binders))
end
| _30_138 -> begin
(let _30_141 = (Microsoft_FStar_Absyn_Util.args_of_binders binders)
in (match (_30_141) with
| (binders, args) -> begin
(let body = (Microsoft_FStar_Absyn_Syntax.mk_Typ_app (t, args) None t.Microsoft_FStar_Absyn_Syntax.pos)
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam (binders, body) None t.Microsoft_FStar_Absyn_Syntax.pos))
end))
end)
end
| (Microsoft_FStar_Absyn_Syntax.Kind_lam (_)) | (Microsoft_FStar_Absyn_Syntax.Kind_delayed (_)) -> begin
(failwith ("Impossible"))
end
| Microsoft_FStar_Absyn_Syntax.Kind_unknown -> begin
(let _68_12199 = (let _68_12198 = (let _68_12196 = (Microsoft_FStar_Tc_Env.get_range tcenv)
in (Support.Prims.pipe_right _68_12196 Support.Microsoft.FStar.Range.string_of_range))
in (let _68_12197 = (Microsoft_FStar_Absyn_Print.typ_to_string t)
in (Support.Microsoft.FStar.Util.format2 "%s: Impossible: Kind_unknown: %s" _68_12198 _68_12197)))
in (failwith (_68_12199)))
end))
in (aux t k))))

let is_var = (fun ( t ) -> (match ((Microsoft_FStar_Absyn_Util.compress_typ t)) with
| {Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_btvar (_30_160); Microsoft_FStar_Absyn_Syntax.tk = _30_158; Microsoft_FStar_Absyn_Syntax.pos = _30_156; Microsoft_FStar_Absyn_Syntax.fvs = _30_154; Microsoft_FStar_Absyn_Syntax.uvs = _30_152} -> begin
true
end
| _30_164 -> begin
false
end))

let rec eta_expand_exp = (fun ( tcenv ) ( e ) -> (let t = (let _68_12206 = (Microsoft_FStar_Tc_Recheck.recompute_typ e)
in (Support.Prims.pipe_right _68_12206 Microsoft_FStar_Absyn_Util.compress_typ))
in (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_fun ((bs, c)) -> begin
(match ((let _68_12207 = (Microsoft_FStar_Absyn_Util.compress_exp e)
in _68_12207.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Exp_abs ((bs', body)) -> begin
(match (((Support.List.length bs) = (Support.List.length bs'))) with
| true -> begin
e
end
| false -> begin
(failwith ("NYI"))
end)
end
| _30_177 -> begin
(let _30_180 = (Microsoft_FStar_Absyn_Util.args_of_binders bs)
in (match (_30_180) with
| (bs, args) -> begin
(let _68_12209 = (let _68_12208 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app (e, args) None e.Microsoft_FStar_Absyn_Syntax.pos)
in (bs, _68_12208))
in (Microsoft_FStar_Absyn_Syntax.mk_Exp_abs _68_12209 (Some (t)) e.Microsoft_FStar_Absyn_Syntax.pos))
end))
end)
end
| _30_182 -> begin
e
end)))

let no_eta = (Support.List.filter (fun ( _30_2 ) -> (match (_30_2) with
| Eta -> begin
false
end
| _30_186 -> begin
true
end)))

let no_eta_cfg = (fun ( c ) -> (let _30_188 = c
in (let _68_12213 = (no_eta c.steps)
in {code = _30_188.code; environment = _30_188.environment; stack = _30_188.stack; close = _30_188.close; steps = _68_12213})))

let whnf_only = (fun ( config ) -> (Support.Prims.pipe_right config.steps (Support.List.contains WHNF)))

let unmeta = (fun ( config ) -> (Support.Prims.pipe_right config.steps (Support.List.contains Unmeta)))

let unlabel = (fun ( config ) -> ((unmeta config) || (Support.Prims.pipe_right config.steps (Support.List.contains Unlabel))))

let is_stack_empty = (fun ( config ) -> (match (config.stack.args) with
| [] -> begin
true
end
| _30_196 -> begin
false
end))

let has_eta = (fun ( cfg ) -> (Support.Prims.pipe_right cfg.steps (Support.List.contains Eta)))

let rec weak_norm_comp = (fun ( env ) ( comp ) -> (let c = (Microsoft_FStar_Absyn_Util.comp_to_comp_typ comp)
in (match ((Microsoft_FStar_Tc_Env.lookup_effect_abbrev env c.Microsoft_FStar_Absyn_Syntax.effect_name)) with
| None -> begin
c
end
| Some ((binders, cdef)) -> begin
(let binders' = (Support.List.map (fun ( _30_3 ) -> (match (_30_3) with
| (Support.Microsoft.FStar.Util.Inl (b), imp) -> begin
(let _68_12225 = (let _68_12224 = (Microsoft_FStar_Absyn_Util.freshen_bvar b)
in Support.Microsoft.FStar.Util.Inl (_68_12224))
in (_68_12225, imp))
end
| (Support.Microsoft.FStar.Util.Inr (b), imp) -> begin
(let _68_12227 = (let _68_12226 = (Microsoft_FStar_Absyn_Util.freshen_bvar b)
in Support.Microsoft.FStar.Util.Inr (_68_12226))
in (_68_12227, imp))
end)) binders)
in (let subst = (let _68_12229 = (let _68_12228 = (Microsoft_FStar_Absyn_Util.args_of_binders binders')
in (Support.Prims.pipe_right _68_12228 Support.Prims.snd))
in (Microsoft_FStar_Absyn_Util.subst_of_list binders _68_12229))
in (let cdef = (Microsoft_FStar_Absyn_Util.subst_comp subst cdef)
in (let subst = (let _68_12231 = (let _68_12230 = (Microsoft_FStar_Absyn_Syntax.targ c.Microsoft_FStar_Absyn_Syntax.result_typ)
in (_68_12230)::c.Microsoft_FStar_Absyn_Syntax.effect_args)
in (Microsoft_FStar_Absyn_Util.subst_of_list binders' _68_12231))
in (let c1 = (Microsoft_FStar_Absyn_Util.subst_comp subst cdef)
in (let c = (Support.Prims.pipe_right (let _30_220 = (Microsoft_FStar_Absyn_Util.comp_to_comp_typ c1)
in {Microsoft_FStar_Absyn_Syntax.effect_name = _30_220.Microsoft_FStar_Absyn_Syntax.effect_name; Microsoft_FStar_Absyn_Syntax.result_typ = _30_220.Microsoft_FStar_Absyn_Syntax.result_typ; Microsoft_FStar_Absyn_Syntax.effect_args = _30_220.Microsoft_FStar_Absyn_Syntax.effect_args; Microsoft_FStar_Absyn_Syntax.flags = c.Microsoft_FStar_Absyn_Syntax.flags}) Microsoft_FStar_Absyn_Syntax.mk_Comp)
in (weak_norm_comp env c)))))))
end)))

let t_config = (fun ( code ) ( env ) ( steps ) -> {code = code; environment = env; stack = empty_stack; close = None; steps = steps})

let k_config = (fun ( code ) ( env ) ( steps ) -> {code = code; environment = env; stack = empty_stack; close = None; steps = steps})

let e_config = (fun ( code ) ( env ) ( steps ) -> {code = code; environment = env; stack = empty_stack; close = None; steps = steps})

let c_config = (fun ( code ) ( env ) ( steps ) -> {code = code; environment = env; stack = empty_stack; close = None; steps = steps})

let close_with_config = (fun ( cfg ) ( f ) -> Some ((fun ( t ) -> (let t = (f t)
in (match (cfg.close) with
| None -> begin
t
end
| Some (g) -> begin
(g t)
end)))))

let rec is_head_symbol = (fun ( t ) -> (match ((let _68_12262 = (Microsoft_FStar_Absyn_Util.compress_typ t)
in _68_12262.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Typ_const (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_lam (_)) -> begin
true
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_refresh_label ((t, _30_251, _30_253))) -> begin
(is_head_symbol t)
end
| _30_258 -> begin
false
end))

let simplify_then_apply = (fun ( steps ) ( head ) ( args ) ( pos ) -> (let fallback = (fun ( _30_264 ) -> (match (()) with
| () -> begin
(Microsoft_FStar_Absyn_Syntax.mk_Typ_app (head, args) None pos)
end))
in (let simp_t = (fun ( t ) -> (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (fv) when (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.true_lid) -> begin
Some (true)
end
| Microsoft_FStar_Absyn_Syntax.Typ_const (fv) when (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.false_lid) -> begin
Some (false)
end
| _30_272 -> begin
None
end))
in (let simplify = (fun ( arg ) -> (match ((Support.Prims.fst arg)) with
| Support.Microsoft.FStar.Util.Inl (t) -> begin
((simp_t t), arg)
end
| _30_278 -> begin
(None, arg)
end))
in (match ((Support.Prims.pipe_left Support.Prims.op_Negation (Support.List.contains Simplify steps))) with
| true -> begin
(fallback ())
end
| false -> begin
(match (head.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (fv) -> begin
(match ((Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.and_lid)) with
| true -> begin
(match ((Support.Prims.pipe_right args (Support.List.map simplify))) with
| ((Some (true), _)::(_, (Support.Microsoft.FStar.Util.Inl (arg), _))::[]) | ((_, (Support.Microsoft.FStar.Util.Inl (arg), _))::(Some (true), _)::[]) -> begin
arg
end
| ((Some (false), _)::_::[]) | (_::(Some (false), _)::[]) -> begin
Microsoft_FStar_Absyn_Util.t_false
end
| _30_325 -> begin
(fallback ())
end)
end
| false -> begin
(match ((Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.or_lid)) with
| true -> begin
(match ((Support.Prims.pipe_right args (Support.List.map simplify))) with
| ((Some (true), _)::_::[]) | (_::(Some (true), _)::[]) -> begin
Microsoft_FStar_Absyn_Util.t_true
end
| ((Some (false), _)::(_, (Support.Microsoft.FStar.Util.Inl (arg), _))::[]) | ((_, (Support.Microsoft.FStar.Util.Inl (arg), _))::(Some (false), _)::[]) -> begin
arg
end
| _30_370 -> begin
(fallback ())
end)
end
| false -> begin
(match ((Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.imp_lid)) with
| true -> begin
(match ((Support.Prims.pipe_right args (Support.List.map simplify))) with
| (_::(Some (true), _)::[]) | ((Some (false), _)::_::[]) -> begin
Microsoft_FStar_Absyn_Util.t_true
end
| (Some (true), _30_398)::(_30_388, (Support.Microsoft.FStar.Util.Inl (arg), _30_392))::[] -> begin
arg
end
| _30_402 -> begin
(fallback ())
end)
end
| false -> begin
(match ((Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.not_lid)) with
| true -> begin
(match ((Support.Prims.pipe_right args (Support.List.map simplify))) with
| (Some (true), _30_406)::[] -> begin
Microsoft_FStar_Absyn_Util.t_false
end
| (Some (false), _30_412)::[] -> begin
Microsoft_FStar_Absyn_Util.t_true
end
| _30_416 -> begin
(fallback ())
end)
end
| false -> begin
(match (((((Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.forall_lid) || (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.allTyp_lid)) || (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.exists_lid)) || (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.exTyp_lid))) with
| true -> begin
(match (args) with
| ((Support.Microsoft.FStar.Util.Inl (t), _)::[]) | (_::(Support.Microsoft.FStar.Util.Inl (t), _)::[]) -> begin
(match ((let _68_12277 = (Microsoft_FStar_Absyn_Util.compress_typ t)
in _68_12277.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((_30_431::[], body)) -> begin
(match ((simp_t body)) with
| Some (true) -> begin
Microsoft_FStar_Absyn_Util.t_true
end
| Some (false) -> begin
Microsoft_FStar_Absyn_Util.t_false
end
| _30_441 -> begin
(fallback ())
end)
end
| _30_443 -> begin
(fallback ())
end)
end
| _30_445 -> begin
(fallback ())
end)
end
| false -> begin
(fallback ())
end)
end)
end)
end)
end)
end
| _30_447 -> begin
(fallback ())
end)
end)))))

let rec sn_delay = (fun ( tcenv ) ( cfg ) -> (let aux = (fun ( _30_451 ) -> (match (()) with
| () -> begin
(let _68_12303 = (sn tcenv cfg)
in _68_12303.code)
end))
in (let t = (Microsoft_FStar_Absyn_Syntax.mk_Typ_delayed' (Support.Microsoft.FStar.Util.Inr (aux)) None cfg.code.Microsoft_FStar_Absyn_Syntax.pos)
in (let _30_453 = cfg
in {code = t; environment = _30_453.environment; stack = empty_stack; close = _30_453.close; steps = _30_453.steps}))))
and sn = (fun ( tcenv ) ( cfg ) -> (let rebuild = (fun ( config ) -> (let rebuild_stack = (fun ( config ) -> (match ((is_stack_empty config)) with
| true -> begin
config
end
| false -> begin
(let s' = (no_eta config.steps)
in (let args = (Support.Prims.pipe_right config.stack.args (Support.List.map (fun ( _30_4 ) -> (match (_30_4) with
| ((Support.Microsoft.FStar.Util.Inl (t), imp), env) -> begin
(let _68_12315 = (let _68_12314 = (let _68_12313 = (sn tcenv (t_config t env s'))
in _68_12313.code)
in (Support.Prims.pipe_left (fun ( _68_12312 ) -> Support.Microsoft.FStar.Util.Inl (_68_12312)) _68_12314))
in (_68_12315, imp))
end
| ((Support.Microsoft.FStar.Util.Inr (v), imp), env) -> begin
(let _68_12319 = (let _68_12318 = (let _68_12317 = (wne tcenv (e_config v env s'))
in _68_12317.code)
in (Support.Prims.pipe_left (fun ( _68_12316 ) -> Support.Microsoft.FStar.Util.Inr (_68_12316)) _68_12318))
in (_68_12319, imp))
end))))
in (let t = (simplify_then_apply config.steps config.code args config.code.Microsoft_FStar_Absyn_Syntax.pos)
in (let _30_477 = config
in {code = t; environment = _30_477.environment; stack = empty_stack; close = _30_477.close; steps = _30_477.steps}))))
end))
in (let config = (rebuild_stack config)
in (let t = (match (config.close) with
| None -> begin
config.code
end
| Some (f) -> begin
(f config.code)
end)
in (match ((has_eta config)) with
| true -> begin
(let _30_484 = config
in (let _68_12321 = (eta_expand tcenv t)
in {code = _68_12321; environment = _30_484.environment; stack = _30_484.stack; close = _30_484.close; steps = _30_484.steps}))
end
| false -> begin
(let _30_486 = config
in {code = t; environment = _30_486.environment; stack = _30_486.stack; close = _30_486.close; steps = _30_486.steps})
end)))))
in (let wk = (fun ( f ) -> (match ((Support.ST.read cfg.code.Microsoft_FStar_Absyn_Syntax.tk)) with
| Some ({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Kind_type; Microsoft_FStar_Absyn_Syntax.tk = _30_497; Microsoft_FStar_Absyn_Syntax.pos = _30_495; Microsoft_FStar_Absyn_Syntax.fvs = _30_493; Microsoft_FStar_Absyn_Syntax.uvs = _30_491}) -> begin
(f (Some (Microsoft_FStar_Absyn_Syntax.ktype)) cfg.code.Microsoft_FStar_Absyn_Syntax.pos)
end
| _30_502 -> begin
(f None cfg.code.Microsoft_FStar_Absyn_Syntax.pos)
end))
in (let config = (let _30_503 = cfg
in (let _68_12334 = (Microsoft_FStar_Absyn_Util.compress_typ cfg.code)
in {code = _68_12334; environment = _30_503.environment; stack = _30_503.stack; close = _30_503.close; steps = _30_503.steps}))
in (let is_flex = (fun ( u ) -> (match ((Support.Microsoft.FStar.Unionfind.find u)) with
| Microsoft_FStar_Absyn_Syntax.Fixed (_30_509) -> begin
false
end
| _30_512 -> begin
true
end))
in (match (config.code.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_delayed (_30_514) -> begin
(failwith ("Impossible"))
end
| Microsoft_FStar_Absyn_Syntax.Typ_uvar (_30_517) -> begin
(rebuild config)
end
| Microsoft_FStar_Absyn_Syntax.Typ_const (fv) -> begin
(match (((Support.Prims.pipe_right config.steps (Support.List.contains DeltaHard)) || ((Support.Prims.pipe_right config.steps (Support.List.contains Delta)) && (Support.Prims.pipe_left Support.Prims.op_Negation (is_stack_empty config))))) with
| true -> begin
(match ((Microsoft_FStar_Tc_Env.lookup_typ_abbrev tcenv fv.Microsoft_FStar_Absyn_Syntax.v)) with
| None -> begin
(rebuild config)
end
| Some (t) -> begin
(sn tcenv (let _30_524 = config
in {code = t; environment = _30_524.environment; stack = _30_524.stack; close = _30_524.close; steps = _30_524.steps}))
end)
end
| false -> begin
(rebuild config)
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_btvar (a) -> begin
(match ((lookup_env config.environment a.Microsoft_FStar_Absyn_Syntax.v.Microsoft_FStar_Absyn_Syntax.realname.Microsoft_FStar_Absyn_Syntax.idText)) with
| None -> begin
(rebuild config)
end
| Some (T ((_30_530, (t, e)))) -> begin
(sn tcenv (let _30_537 = config
in {code = t; environment = e; stack = _30_537.stack; close = _30_537.close; steps = _30_537.steps}))
end
| _30_540 -> begin
(failwith ("Impossible: expected a type"))
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_app ((head, args)) -> begin
(let args = (Support.List.fold_right (fun ( a ) ( out ) -> ((a, config.environment))::out) args config.stack.args)
in (let stack = (let _30_548 = config.stack
in {args = args})
in (sn tcenv (let _30_551 = config
in {code = head; environment = _30_551.environment; stack = stack; close = _30_551.close; steps = _30_551.steps}))))
end
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((binders, t2)) -> begin
(match (config.stack.args) with
| [] -> begin
(let _30_560 = (sn_binders tcenv binders config.environment config.steps)
in (match (_30_560) with
| (binders, environment) -> begin
(let mk_lam = (fun ( t ) -> (let lam = (Support.Prims.pipe_left wk (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam (binders, t)))
in (match (cfg.close) with
| None -> begin
lam
end
| Some (f) -> begin
(f lam)
end)))
in (let t2_cfg = (let _68_12349 = (let _68_12348 = (no_eta config.steps)
in {code = t2; environment = environment; stack = empty_stack; close = None; steps = _68_12348})
in (sn_delay tcenv _68_12349))
in (let _30_568 = t2_cfg
in (let _68_12350 = (mk_lam t2_cfg.code)
in {code = _68_12350; environment = _30_568.environment; stack = _30_568.stack; close = _30_568.close; steps = _30_568.steps}))))
end))
end
| args -> begin
(let rec beta = (fun ( env_entries ) ( binders ) ( args ) -> (match ((binders, args)) with
| ([], _30_577) -> begin
(let env = (extend_env config.environment env_entries)
in (sn tcenv (let _30_580 = config
in {code = t2; environment = env; stack = (let _30_582 = config.stack
in {args = args}); close = _30_580.close; steps = _30_580.steps})))
end
| (_30_585, []) -> begin
(let t = (Microsoft_FStar_Absyn_Syntax.mk_Typ_lam (binders, t2) None t2.Microsoft_FStar_Absyn_Syntax.pos)
in (let env = (extend_env config.environment env_entries)
in (sn tcenv (let _30_590 = config
in {code = t; environment = env; stack = empty_stack; close = _30_590.close; steps = _30_590.steps}))))
end
| (formal::rest, actual::rest') -> begin
(let m = (match ((formal, actual)) with
| ((Support.Microsoft.FStar.Util.Inl (a), _30_602), ((Support.Microsoft.FStar.Util.Inl (t), _30_607), env)) -> begin
T ((a.Microsoft_FStar_Absyn_Syntax.v, (t, env)))
end
| ((Support.Microsoft.FStar.Util.Inr (x), _30_615), ((Support.Microsoft.FStar.Util.Inr (v), _30_620), env)) -> begin
V ((x.Microsoft_FStar_Absyn_Syntax.v, (v, env)))
end
| _30_626 -> begin
(let _68_12361 = (let _68_12360 = (let _68_12357 = (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.argpos (Support.Prims.fst actual))
in (Support.Microsoft.FStar.Range.string_of_range _68_12357))
in (let _68_12359 = (Microsoft_FStar_Absyn_Print.binder_to_string formal)
in (let _68_12358 = (Support.Prims.pipe_left Microsoft_FStar_Absyn_Print.arg_to_string (Support.Prims.fst actual))
in (Support.Microsoft.FStar.Util.format3 "(%s) Impossible: ill-typed redex\n formal is %s\nactual is %s\n" _68_12360 _68_12359 _68_12358))))
in (failwith (_68_12361)))
end)
in (beta ((m)::env_entries) rest rest'))
end))
in (beta [] binders args))
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_ascribed ((t, _30_630)) -> begin
(sn tcenv (let _30_633 = config
in {code = t; environment = _30_633.environment; stack = _30_633.stack; close = _30_633.close; steps = _30_633.steps}))
end
| _30_636 -> begin
(match (config.code.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_fun ((bs, comp)) -> begin
(let _30_643 = (sn_binders tcenv bs config.environment config.steps)
in (match (_30_643) with
| (binders, environment) -> begin
(let c2 = (sncomp tcenv (c_config comp environment config.steps))
in (let _30_645 = config
in (let _68_12364 = (Support.Prims.pipe_left wk (Microsoft_FStar_Absyn_Syntax.mk_Typ_fun (binders, c2.code)))
in {code = _68_12364; environment = _30_645.environment; stack = _30_645.stack; close = _30_645.close; steps = _30_645.steps})))
end))
end
| Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, t)) -> begin
(match ((let _68_12366 = (let _68_12365 = (Microsoft_FStar_Absyn_Syntax.v_binder x)
in (_68_12365)::[])
in (sn_binders tcenv _68_12366 config.environment config.steps))) with
| ((Support.Microsoft.FStar.Util.Inr (x), _30_654)::[], env) -> begin
(let refine = (fun ( t ) -> (Support.Prims.pipe_left wk (Microsoft_FStar_Absyn_Syntax.mk_Typ_refine (x, t))))
in (sn tcenv {code = t; environment = env; stack = empty_stack; close = (close_with_config config refine); steps = config.steps}))
end
| _30_662 -> begin
(failwith ("Impossible"))
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_pattern ((t, ps))) -> begin
(match ((unmeta config)) with
| true -> begin
(sn tcenv (let _30_668 = config
in {code = t; environment = _30_668.environment; stack = _30_668.stack; close = _30_668.close; steps = _30_668.steps}))
end
| false -> begin
(let pat = (fun ( t ) -> (let ps = (sn_args true tcenv config.environment config.steps ps)
in (Support.Prims.pipe_left wk (Microsoft_FStar_Absyn_Syntax.mk_Typ_meta' (Microsoft_FStar_Absyn_Syntax.Meta_pattern ((t, ps)))))))
in (sn tcenv (let _30_673 = config
in {code = t; environment = _30_673.environment; stack = _30_673.stack; close = (close_with_config config pat); steps = _30_673.steps})))
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_labeled ((t, l, r, b))) -> begin
(match ((unlabel config)) with
| true -> begin
(sn tcenv (let _30_682 = config
in {code = t; environment = _30_682.environment; stack = _30_682.stack; close = _30_682.close; steps = _30_682.steps}))
end
| false -> begin
(let lab = (fun ( t ) -> (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (fv) when ((Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v Microsoft_FStar_Absyn_Const.true_lid) && (Support.Prims.pipe_right config.steps (Support.List.contains Simplify))) -> begin
t
end
| _30_689 -> begin
(match (config.environment.label_suffix) with
| (b', sfx)::_30_691 -> begin
(match (((b' = None) || (Some (b) = b'))) with
| true -> begin
(let _30_696 = (match ((Microsoft_FStar_Tc_Env.debug tcenv Microsoft_FStar_Options.Low)) with
| true -> begin
(let _68_12377 = (Support.Microsoft.FStar.Range.string_of_range sfx)
in (Support.Microsoft.FStar.Util.fprint2 "Stripping label %s because of enclosing refresh %s\n" l _68_12377))
end
| false -> begin
()
end)
in t)
end
| false -> begin
(let _30_698 = (match ((Microsoft_FStar_Tc_Env.debug tcenv Microsoft_FStar_Options.Low)) with
| true -> begin
(let _68_12378 = (Support.Microsoft.FStar.Range.string_of_range sfx)
in (Support.Microsoft.FStar.Util.fprint1 "Normalizer refreshing label: %s\n" _68_12378))
end
| false -> begin
()
end)
in (Support.Prims.pipe_left wk (Microsoft_FStar_Absyn_Syntax.mk_Typ_meta' (Microsoft_FStar_Absyn_Syntax.Meta_labeled ((t, l, sfx, b))))))
end)
end
| _30_701 -> begin
(Support.Prims.pipe_left wk (Microsoft_FStar_Absyn_Syntax.mk_Typ_meta' (Microsoft_FStar_Absyn_Syntax.Meta_labeled ((t, l, r, b)))))
end)
end))
in (sn tcenv (let _30_702 = config
in {code = t; environment = _30_702.environment; stack = _30_702.stack; close = (close_with_config config lab); steps = _30_702.steps})))
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_refresh_label ((t, b, r))) -> begin
(match ((unmeta config)) with
| true -> begin
(sn tcenv (let _30_710 = config
in {code = t; environment = _30_710.environment; stack = _30_710.stack; close = _30_710.close; steps = _30_710.steps}))
end
| false -> begin
(let sfx = (match (b) with
| Some (false) -> begin
r
end
| _30_715 -> begin
Microsoft_FStar_Absyn_Syntax.dummyRange
end)
in (let config = (let _30_717 = config
in {code = t; environment = (let _30_719 = config.environment
in {context = _30_719.context; label_suffix = ((b, sfx))::config.environment.label_suffix}); stack = _30_717.stack; close = _30_717.close; steps = _30_717.steps})
in (sn tcenv config)))
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_slack_formula ((t1, t2, flag))) -> begin
(match ((Support.ST.read flag)) with
| true -> begin
(let _68_12384 = (let _30_728 = config
in (let _68_12383 = (Microsoft_FStar_Absyn_Util.mk_conj t1 t2)
in {code = _68_12383; environment = _30_728.environment; stack = _30_728.stack; close = _30_728.close; steps = _30_728.steps}))
in (sn tcenv _68_12384))
end
| false -> begin
(let c1 = (sn tcenv (t_config t1 config.environment config.steps))
in (let c2 = (sn tcenv (t_config t2 config.environment config.steps))
in (let _68_12386 = (let _30_732 = config
in (let _68_12385 = (Microsoft_FStar_Absyn_Syntax.mk_Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_slack_formula ((c1.code, c2.code, flag))))
in {code = _68_12385; environment = _30_732.environment; stack = _30_732.stack; close = _30_732.close; steps = _30_732.steps}))
in (rebuild _68_12386))))
end)
end
| (Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_named (_))) | (Microsoft_FStar_Absyn_Syntax.Typ_unknown) | (_) -> begin
(let _68_12391 = (let _68_12390 = (let _68_12387 = (Microsoft_FStar_Tc_Env.get_range tcenv)
in (Support.Prims.pipe_right _68_12387 Support.Microsoft.FStar.Range.string_of_range))
in (let _68_12389 = (Microsoft_FStar_Absyn_Print.tag_of_typ config.code)
in (let _68_12388 = (Microsoft_FStar_Absyn_Print.typ_to_string config.code)
in (Support.Microsoft.FStar.Util.format3 "(%s) Unexpected type (%s): %s" _68_12390 _68_12389 _68_12388))))
in (failwith (_68_12391)))
end)
end))))))
and sn_binders = (fun ( tcenv ) ( binders ) ( env ) ( steps ) -> (let rec aux = (fun ( out ) ( env ) ( _30_5 ) -> (match (_30_5) with
| (Support.Microsoft.FStar.Util.Inl (a), imp)::rest -> begin
(let c = (snk tcenv (k_config a.Microsoft_FStar_Absyn_Syntax.sort env steps))
in (let b = (let _68_12402 = (Microsoft_FStar_Absyn_Util.freshen_bvd a.Microsoft_FStar_Absyn_Syntax.v)
in (Microsoft_FStar_Absyn_Util.bvd_to_bvar_s _68_12402 c.code))
in (let btyp = (Microsoft_FStar_Absyn_Util.btvar_to_typ b)
in (let b_for_a = T ((a.Microsoft_FStar_Absyn_Syntax.v, (btyp, empty_env)))
in (aux (((Support.Microsoft.FStar.Util.Inl (b), imp))::out) (extend_env' env b_for_a) rest)))))
end
| (Support.Microsoft.FStar.Util.Inr (x), imp)::rest -> begin
(let c = (sn_delay tcenv (t_config x.Microsoft_FStar_Absyn_Syntax.sort env steps))
in (let y = (let _68_12403 = (Microsoft_FStar_Absyn_Util.freshen_bvd x.Microsoft_FStar_Absyn_Syntax.v)
in (Microsoft_FStar_Absyn_Util.bvd_to_bvar_s _68_12403 c.code))
in (let yexp = (Microsoft_FStar_Absyn_Util.bvar_to_exp y)
in (let y_for_x = V ((x.Microsoft_FStar_Absyn_Syntax.v, (yexp, empty_env)))
in (aux (((Support.Microsoft.FStar.Util.Inr (y), imp))::out) (extend_env' env y_for_x) rest)))))
end
| [] -> begin
((Support.List.rev out), env)
end))
in (aux [] env binders)))
and sncomp = (fun ( tcenv ) ( cfg ) -> (let m = cfg.code
in (match (m.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Comp (ct) -> begin
(let ctconf = (sncomp_typ tcenv (with_new_code cfg ct))
in (let _30_776 = cfg
in (let _68_12406 = (Microsoft_FStar_Absyn_Syntax.mk_Comp ctconf.code)
in {code = _68_12406; environment = _30_776.environment; stack = _30_776.stack; close = _30_776.close; steps = _30_776.steps})))
end
| Microsoft_FStar_Absyn_Syntax.Total (t) -> begin
(match ((Support.List.contains DeltaComp cfg.steps)) with
| true -> begin
(let _68_12410 = (let _68_12409 = (let _68_12408 = (let _68_12407 = (Microsoft_FStar_Absyn_Syntax.mk_Total t)
in (Microsoft_FStar_Absyn_Util.comp_to_comp_typ _68_12407))
in (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.mk_Comp _68_12408))
in (with_new_code cfg _68_12409))
in (Support.Prims.pipe_left (sncomp tcenv) _68_12410))
end
| false -> begin
(let t = (sn tcenv (with_new_code cfg t))
in (let _68_12411 = (Microsoft_FStar_Absyn_Syntax.mk_Total t.code)
in (with_new_code cfg _68_12411)))
end)
end)))
and sncomp_typ = (fun ( tcenv ) ( cfg ) -> (let m = cfg.code
in (let norm = (fun ( _30_785 ) -> (match (()) with
| () -> begin
(let remake = (fun ( l ) ( r ) ( eargs ) ( flags ) -> (let c = {Microsoft_FStar_Absyn_Syntax.effect_name = l; Microsoft_FStar_Absyn_Syntax.result_typ = r; Microsoft_FStar_Absyn_Syntax.effect_args = eargs; Microsoft_FStar_Absyn_Syntax.flags = flags}
in (let _30_792 = cfg
in {code = c; environment = _30_792.environment; stack = _30_792.stack; close = _30_792.close; steps = _30_792.steps})))
in (let res = (let _68_12424 = (sn tcenv (with_new_code cfg m.Microsoft_FStar_Absyn_Syntax.result_typ))
in _68_12424.code)
in (let sn_flags = (fun ( flags ) -> (Support.Prims.pipe_right flags (Support.List.map (fun ( _30_6 ) -> (match (_30_6) with
| Microsoft_FStar_Absyn_Syntax.DECREASES (e) -> begin
(let e = (let _68_12428 = (wne tcenv (e_config e cfg.environment cfg.steps))
in _68_12428.code)
in Microsoft_FStar_Absyn_Syntax.DECREASES (e))
end
| f -> begin
f
end)))))
in (let _30_804 = (let _68_12430 = (sn_flags m.Microsoft_FStar_Absyn_Syntax.flags)
in (let _68_12429 = (sn_args true tcenv cfg.environment cfg.steps m.Microsoft_FStar_Absyn_Syntax.effect_args)
in (_68_12430, _68_12429)))
in (match (_30_804) with
| (flags, args) -> begin
(remake m.Microsoft_FStar_Absyn_Syntax.effect_name res args flags)
end)))))
end))
in (match ((Support.List.contains DeltaComp cfg.steps)) with
| true -> begin
(match ((Microsoft_FStar_Tc_Env.lookup_effect_abbrev tcenv m.Microsoft_FStar_Absyn_Syntax.effect_name)) with
| Some (_30_806) -> begin
(let c = (let _68_12431 = (Microsoft_FStar_Absyn_Syntax.mk_Comp m)
in (weak_norm_comp tcenv _68_12431))
in (sncomp_typ tcenv (let _30_809 = cfg
in {code = c; environment = _30_809.environment; stack = _30_809.stack; close = _30_809.close; steps = _30_809.steps})))
end
| _30_812 -> begin
(norm ())
end)
end
| false -> begin
(norm ())
end))))
and sn_args = (fun ( delay ) ( tcenv ) ( env ) ( steps ) ( args ) -> (Support.Prims.pipe_right args (Support.List.map (fun ( _30_7 ) -> (match (_30_7) with
| (Support.Microsoft.FStar.Util.Inl (t), imp) when delay -> begin
(let _68_12441 = (let _68_12440 = (let _68_12439 = (sn_delay tcenv (t_config t env steps))
in _68_12439.code)
in (Support.Prims.pipe_left (fun ( _68_12438 ) -> Support.Microsoft.FStar.Util.Inl (_68_12438)) _68_12440))
in (_68_12441, imp))
end
| (Support.Microsoft.FStar.Util.Inl (t), imp) -> begin
(let _68_12445 = (let _68_12444 = (let _68_12443 = (sn tcenv (t_config t env steps))
in _68_12443.code)
in (Support.Prims.pipe_left (fun ( _68_12442 ) -> Support.Microsoft.FStar.Util.Inl (_68_12442)) _68_12444))
in (_68_12445, imp))
end
| (Support.Microsoft.FStar.Util.Inr (e), imp) -> begin
(let _68_12449 = (let _68_12448 = (let _68_12447 = (wne tcenv (e_config e env steps))
in _68_12447.code)
in (Support.Prims.pipe_left (fun ( _68_12446 ) -> Support.Microsoft.FStar.Util.Inr (_68_12446)) _68_12448))
in (_68_12449, imp))
end)))))
and snk = (fun ( tcenv ) ( cfg ) -> (let w = (fun ( f ) -> (f cfg.code.Microsoft_FStar_Absyn_Syntax.pos))
in (match ((let _68_12459 = (Microsoft_FStar_Absyn_Util.compress_kind cfg.code)
in _68_12459.Microsoft_FStar_Absyn_Syntax.n)) with
| (Microsoft_FStar_Absyn_Syntax.Kind_delayed (_)) | (Microsoft_FStar_Absyn_Syntax.Kind_lam (_)) -> begin
(failwith ("Impossible"))
end
| (Microsoft_FStar_Absyn_Syntax.Kind_type) | (Microsoft_FStar_Absyn_Syntax.Kind_effect) -> begin
cfg
end
| Microsoft_FStar_Absyn_Syntax.Kind_uvar ((uv, args)) -> begin
(let args = (let _68_12460 = (no_eta cfg.steps)
in (sn_args false tcenv cfg.environment _68_12460 args))
in (let _30_848 = cfg
in (let _68_12462 = (Support.Prims.pipe_left w (Microsoft_FStar_Absyn_Syntax.mk_Kind_uvar (uv, args)))
in {code = _68_12462; environment = _30_848.environment; stack = _30_848.stack; close = _30_848.close; steps = _30_848.steps})))
end
| Microsoft_FStar_Absyn_Syntax.Kind_abbrev (((l, args), {Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Kind_unknown; Microsoft_FStar_Absyn_Syntax.tk = _30_860; Microsoft_FStar_Absyn_Syntax.pos = _30_858; Microsoft_FStar_Absyn_Syntax.fvs = _30_856; Microsoft_FStar_Absyn_Syntax.uvs = _30_854})) -> begin
(let _30_869 = (Microsoft_FStar_Tc_Env.lookup_kind_abbrev tcenv l)
in (match (_30_869) with
| (_30_866, binders, body) -> begin
(let subst = (Microsoft_FStar_Absyn_Util.subst_of_list binders args)
in (let _68_12464 = (let _30_871 = cfg
in (let _68_12463 = (Microsoft_FStar_Absyn_Util.subst_kind subst body)
in {code = _68_12463; environment = _30_871.environment; stack = _30_871.stack; close = _30_871.close; steps = _30_871.steps}))
in (snk tcenv _68_12464)))
end))
end
| Microsoft_FStar_Absyn_Syntax.Kind_abbrev ((_30_874, k)) -> begin
(snk tcenv (let _30_878 = cfg
in {code = k; environment = _30_878.environment; stack = _30_878.stack; close = _30_878.close; steps = _30_878.steps}))
end
| Microsoft_FStar_Absyn_Syntax.Kind_arrow ((bs, k)) -> begin
(let _30_886 = (sn_binders tcenv bs cfg.environment cfg.steps)
in (match (_30_886) with
| (bs, env) -> begin
(let c2 = (snk tcenv (k_config k env cfg.steps))
in (let _30_896 = (match (c2.code.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Kind_arrow ((bs', k)) -> begin
((Support.List.append bs bs'), k)
end
| _30_893 -> begin
(bs, c2.code)
end)
in (match (_30_896) with
| (bs, rhs) -> begin
(let _30_897 = cfg
in (let _68_12466 = (Support.Prims.pipe_left w (Microsoft_FStar_Absyn_Syntax.mk_Kind_arrow (bs, rhs)))
in {code = _68_12466; environment = _30_897.environment; stack = _30_897.stack; close = _30_897.close; steps = _30_897.steps}))
end)))
end))
end
| Microsoft_FStar_Absyn_Syntax.Kind_unknown -> begin
(failwith ("Impossible"))
end)))
and wne = (fun ( tcenv ) ( cfg ) -> (let e = (Microsoft_FStar_Absyn_Util.compress_exp cfg.code)
in (let config = (let _30_903 = cfg
in {code = e; environment = _30_903.environment; stack = _30_903.stack; close = _30_903.close; steps = _30_903.steps})
in (let rebuild = (fun ( config ) -> (match ((is_stack_empty config)) with
| true -> begin
config
end
| false -> begin
(let s' = (no_eta config.steps)
in (let args = (Support.Prims.pipe_right config.stack.args (Support.List.map (fun ( _30_8 ) -> (match (_30_8) with
| ((Support.Microsoft.FStar.Util.Inl (t), imp), env) -> begin
(let _68_12475 = (let _68_12474 = (let _68_12473 = (sn tcenv (t_config t env s'))
in _68_12473.code)
in (Support.Prims.pipe_left (fun ( _68_12472 ) -> Support.Microsoft.FStar.Util.Inl (_68_12472)) _68_12474))
in (_68_12475, imp))
end
| ((Support.Microsoft.FStar.Util.Inr (v), imp), env) -> begin
(let _68_12479 = (let _68_12478 = (let _68_12477 = (wne tcenv (e_config v env s'))
in _68_12477.code)
in (Support.Prims.pipe_left (fun ( _68_12476 ) -> Support.Microsoft.FStar.Util.Inr (_68_12476)) _68_12478))
in (_68_12479, imp))
end))))
in (let _30_923 = config
in (let _68_12480 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_app (config.code, args) None config.code.Microsoft_FStar_Absyn_Syntax.pos)
in {code = _68_12480; environment = _30_923.environment; stack = empty_stack; close = _30_923.close; steps = _30_923.steps}))))
end))
in (match (e.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Exp_delayed (_30_926) -> begin
(failwith ("Impossible"))
end
| (Microsoft_FStar_Absyn_Syntax.Exp_fvar (_)) | (Microsoft_FStar_Absyn_Syntax.Exp_constant (_)) | (Microsoft_FStar_Absyn_Syntax.Exp_uvar (_)) -> begin
(Support.Prims.pipe_right config rebuild)
end
| Microsoft_FStar_Absyn_Syntax.Exp_bvar (x) -> begin
(match ((lookup_env config.environment x.Microsoft_FStar_Absyn_Syntax.v.Microsoft_FStar_Absyn_Syntax.realname.Microsoft_FStar_Absyn_Syntax.idText)) with
| None -> begin
(Support.Prims.pipe_right config rebuild)
end
| Some (V ((_30_941, (vc, env)))) -> begin
(wne tcenv (let _30_948 = config
in {code = vc; environment = env; stack = _30_948.stack; close = _30_948.close; steps = _30_948.steps}))
end
| _30_951 -> begin
(failwith ("Impossible: ill-typed term"))
end)
end
| Microsoft_FStar_Absyn_Syntax.Exp_app ((head, args)) -> begin
(let args = (Support.List.fold_right (fun ( a ) ( out ) -> ((a, config.environment))::out) args config.stack.args)
in (let stack = (let _30_959 = config.stack
in {args = args})
in (wne tcenv (let _30_962 = config
in {code = head; environment = _30_962.environment; stack = stack; close = _30_962.close; steps = _30_962.steps}))))
end
| Microsoft_FStar_Absyn_Syntax.Exp_abs ((binders, body)) -> begin
(let rec beta = (fun ( entries ) ( binders ) ( args ) -> (match ((binders, args)) with
| ([], _30_974) -> begin
(let env = (extend_env config.environment entries)
in (wne tcenv (let _30_977 = config
in {code = body; environment = env; stack = (let _30_979 = config.stack
in {args = args}); close = _30_977.close; steps = _30_977.steps})))
end
| (_30_982, []) -> begin
(let env = (extend_env config.environment entries)
in (let _30_988 = (sn_binders tcenv binders env config.steps)
in (match (_30_988) with
| (binders, env) -> begin
(let mk_abs = (fun ( t ) -> (Microsoft_FStar_Absyn_Syntax.mk_Exp_abs (binders, t) None body.Microsoft_FStar_Absyn_Syntax.pos))
in (let c = (let _68_12492 = (let _30_991 = config
in (let _68_12491 = (no_eta config.steps)
in {code = body; environment = env; stack = (let _30_993 = config.stack
in {args = []}); close = _30_991.close; steps = _68_12491}))
in (wne tcenv _68_12492))
in (let _30_996 = c
in (let _68_12493 = (mk_abs c.code)
in {code = _68_12493; environment = _30_996.environment; stack = _30_996.stack; close = _30_996.close; steps = _30_996.steps}))))
end)))
end
| (formal::rest, actual::rest') -> begin
(let m = (match ((formal, actual)) with
| ((Support.Microsoft.FStar.Util.Inl (a), _30_1008), ((Support.Microsoft.FStar.Util.Inl (t), _30_1013), env)) -> begin
T ((a.Microsoft_FStar_Absyn_Syntax.v, (t, env)))
end
| ((Support.Microsoft.FStar.Util.Inr (x), _30_1021), ((Support.Microsoft.FStar.Util.Inr (v), _30_1026), env)) -> begin
V ((x.Microsoft_FStar_Absyn_Syntax.v, (v, env)))
end
| _30_1032 -> begin
(let _68_12498 = (let _68_12497 = (let _68_12494 = (Support.Prims.pipe_left Microsoft_FStar_Absyn_Syntax.argpos (Support.Prims.fst actual))
in (Support.Microsoft.FStar.Range.string_of_range _68_12494))
in (let _68_12496 = (Microsoft_FStar_Absyn_Print.binder_to_string formal)
in (let _68_12495 = (Support.Prims.pipe_left Microsoft_FStar_Absyn_Print.arg_to_string (Support.Prims.fst actual))
in (Support.Microsoft.FStar.Util.format3 "(%s) Impossible: ill-typed redex\n formal is %s\nactual is %s\n" _68_12497 _68_12496 _68_12495))))
in (failwith (_68_12498)))
end)
in (beta ((m)::entries) rest rest'))
end))
in (beta [] binders config.stack.args))
end
| Microsoft_FStar_Absyn_Syntax.Exp_match ((e1, eqns)) -> begin
(let c_e1 = (wne tcenv (let _30_1038 = config
in {code = e1; environment = _30_1038.environment; stack = empty_stack; close = _30_1038.close; steps = _30_1038.steps}))
in (let wn_eqn = (fun ( _30_1045 ) -> (match (_30_1045) with
| (pat, w, body) -> begin
(let rec pat_vars = (fun ( p ) -> (match (p.Microsoft_FStar_Absyn_Syntax.v) with
| Microsoft_FStar_Absyn_Syntax.Pat_disj ([]) -> begin
[]
end
| Microsoft_FStar_Absyn_Syntax.Pat_disj (p::_30_1051) -> begin
(pat_vars p)
end
| Microsoft_FStar_Absyn_Syntax.Pat_cons ((_30_1056, _30_1058, pats)) -> begin
(Support.List.collect pat_vars pats)
end
| Microsoft_FStar_Absyn_Syntax.Pat_var ((x, _30_1064)) -> begin
(let _68_12503 = (Microsoft_FStar_Absyn_Syntax.v_binder x)
in (_68_12503)::[])
end
| Microsoft_FStar_Absyn_Syntax.Pat_tvar (a) -> begin
(let _68_12504 = (Microsoft_FStar_Absyn_Syntax.t_binder a)
in (_68_12504)::[])
end
| (Microsoft_FStar_Absyn_Syntax.Pat_wild (_)) | (Microsoft_FStar_Absyn_Syntax.Pat_twild (_)) | (Microsoft_FStar_Absyn_Syntax.Pat_constant (_)) | (Microsoft_FStar_Absyn_Syntax.Pat_dot_term (_)) | (Microsoft_FStar_Absyn_Syntax.Pat_dot_typ (_)) -> begin
[]
end))
in (let vars = (pat_vars pat)
in (let norm_bvvar = (fun ( x ) -> (let t = (sn tcenv (t_config x.Microsoft_FStar_Absyn_Syntax.sort config.environment config.steps))
in (let _30_1088 = x
in {Microsoft_FStar_Absyn_Syntax.v = _30_1088.Microsoft_FStar_Absyn_Syntax.v; Microsoft_FStar_Absyn_Syntax.sort = t.code; Microsoft_FStar_Absyn_Syntax.p = _30_1088.Microsoft_FStar_Absyn_Syntax.p})))
in (let norm_btvar = (fun ( a ) -> (let k = (snk tcenv (k_config a.Microsoft_FStar_Absyn_Syntax.sort config.environment config.steps))
in (let _30_1093 = a
in {Microsoft_FStar_Absyn_Syntax.v = _30_1093.Microsoft_FStar_Absyn_Syntax.v; Microsoft_FStar_Absyn_Syntax.sort = k.code; Microsoft_FStar_Absyn_Syntax.p = _30_1093.Microsoft_FStar_Absyn_Syntax.p})))
in (let rec norm_pat = (fun ( p ) -> (match (p.Microsoft_FStar_Absyn_Syntax.v) with
| Microsoft_FStar_Absyn_Syntax.Pat_disj (pats) -> begin
(let _68_12512 = (let _68_12511 = (Support.List.map norm_pat pats)
in Microsoft_FStar_Absyn_Syntax.Pat_disj (_68_12511))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12512 None p.Microsoft_FStar_Absyn_Syntax.p))
end
| Microsoft_FStar_Absyn_Syntax.Pat_cons ((fv, q, pats)) -> begin
(let _68_12515 = (let _68_12514 = (let _68_12513 = (Support.List.map norm_pat pats)
in (fv, q, _68_12513))
in Microsoft_FStar_Absyn_Syntax.Pat_cons (_68_12514))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12515 None p.Microsoft_FStar_Absyn_Syntax.p))
end
| Microsoft_FStar_Absyn_Syntax.Pat_var ((x, b)) -> begin
(let _68_12518 = (let _68_12517 = (let _68_12516 = (norm_bvvar x)
in (_68_12516, b))
in Microsoft_FStar_Absyn_Syntax.Pat_var (_68_12517))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12518 None p.Microsoft_FStar_Absyn_Syntax.p))
end
| Microsoft_FStar_Absyn_Syntax.Pat_tvar (a) -> begin
(let _68_12520 = (let _68_12519 = (norm_btvar a)
in Microsoft_FStar_Absyn_Syntax.Pat_tvar (_68_12519))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12520 None p.Microsoft_FStar_Absyn_Syntax.p))
end
| Microsoft_FStar_Absyn_Syntax.Pat_wild (x) -> begin
(let _68_12522 = (let _68_12521 = (norm_bvvar x)
in Microsoft_FStar_Absyn_Syntax.Pat_wild (_68_12521))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12522 None p.Microsoft_FStar_Absyn_Syntax.p))
end
| Microsoft_FStar_Absyn_Syntax.Pat_twild (a) -> begin
(let _68_12524 = (let _68_12523 = (norm_btvar a)
in Microsoft_FStar_Absyn_Syntax.Pat_twild (_68_12523))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12524 None p.Microsoft_FStar_Absyn_Syntax.p))
end
| Microsoft_FStar_Absyn_Syntax.Pat_constant (_30_1115) -> begin
p
end
| Microsoft_FStar_Absyn_Syntax.Pat_dot_term ((x, e)) -> begin
(let e = (wne tcenv (e_config e config.environment config.steps))
in (let _68_12527 = (let _68_12526 = (let _68_12525 = (norm_bvvar x)
in (_68_12525, e.code))
in Microsoft_FStar_Absyn_Syntax.Pat_dot_term (_68_12526))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12527 None p.Microsoft_FStar_Absyn_Syntax.p)))
end
| Microsoft_FStar_Absyn_Syntax.Pat_dot_typ ((a, t)) -> begin
(let t = (sn tcenv (t_config t config.environment config.steps))
in (let _68_12530 = (let _68_12529 = (let _68_12528 = (norm_btvar a)
in (_68_12528, t.code))
in Microsoft_FStar_Absyn_Syntax.Pat_dot_typ (_68_12529))
in (Microsoft_FStar_Absyn_Util.withinfo _68_12530 None p.Microsoft_FStar_Absyn_Syntax.p)))
end))
in (let env_entries = (Support.List.fold_left (fun ( entries ) ( b ) -> (match ((Support.Prims.fst b)) with
| Support.Microsoft.FStar.Util.Inl (a) -> begin
(let atyp = (Microsoft_FStar_Absyn_Util.btvar_to_typ a)
in (T ((a.Microsoft_FStar_Absyn_Syntax.v, (atyp, empty_env))))::entries)
end
| Support.Microsoft.FStar.Util.Inr (x) -> begin
(let xexp = (Microsoft_FStar_Absyn_Util.bvar_to_exp x)
in (V ((x.Microsoft_FStar_Absyn_Syntax.v, (xexp, empty_env))))::entries)
end)) [] vars)
in (let env = (extend_env config.environment env_entries)
in (let w = (match (w) with
| None -> begin
None
end
| Some (w) -> begin
(let c_w = (wne tcenv (let _30_1140 = config
in {code = w; environment = env; stack = empty_stack; close = _30_1140.close; steps = _30_1140.steps}))
in Some (c_w.code))
end)
in (let c_body = (wne tcenv (let _30_1144 = config
in {code = body; environment = env; stack = empty_stack; close = _30_1144.close; steps = _30_1144.steps}))
in (let _68_12533 = (norm_pat pat)
in (_68_12533, w, c_body.code)))))))))))
end))
in (let eqns = (Support.List.map wn_eqn eqns)
in (let e = (Microsoft_FStar_Absyn_Syntax.mk_Exp_match (c_e1.code, eqns) None e.Microsoft_FStar_Absyn_Syntax.pos)
in (Support.Prims.pipe_right (let _30_1149 = config
in {code = e; environment = _30_1149.environment; stack = _30_1149.stack; close = _30_1149.close; steps = _30_1149.steps}) rebuild)))))
end
| Microsoft_FStar_Absyn_Syntax.Exp_let (((is_rec, lbs), body)) -> begin
(let _30_1181 = (Support.Prims.pipe_right lbs (Support.List.fold_left (fun ( _30_1159 ) ( _30_1164 ) -> (match ((_30_1159, _30_1164)) with
| ((env, lbs), {Microsoft_FStar_Absyn_Syntax.lbname = x; Microsoft_FStar_Absyn_Syntax.lbtyp = t; Microsoft_FStar_Absyn_Syntax.lbeff = eff; Microsoft_FStar_Absyn_Syntax.lbdef = e}) -> begin
(let c = (wne tcenv (let _30_1165 = config
in {code = e; environment = _30_1165.environment; stack = empty_stack; close = _30_1165.close; steps = _30_1165.steps}))
in (let t = (sn tcenv (t_config t config.environment config.steps))
in (let _30_1178 = (match (x) with
| Support.Microsoft.FStar.Util.Inl (x) -> begin
(let y = (let _68_12536 = (match (is_rec) with
| true -> begin
x
end
| false -> begin
(Microsoft_FStar_Absyn_Util.freshen_bvd x)
end)
in (Microsoft_FStar_Absyn_Util.bvd_to_bvar_s _68_12536 t.code))
in (let yexp = (Microsoft_FStar_Absyn_Util.bvar_to_exp y)
in (let y_for_x = V ((x, (yexp, empty_env)))
in (Support.Microsoft.FStar.Util.Inl (y.Microsoft_FStar_Absyn_Syntax.v), (extend_env' env y_for_x)))))
end
| _30_1175 -> begin
(x, env)
end)
in (match (_30_1178) with
| (y, env) -> begin
(let _68_12538 = (let _68_12537 = (Microsoft_FStar_Absyn_Syntax.mk_lb (y, eff, t.code, c.code))
in (_68_12537)::lbs)
in (env, _68_12538))
end))))
end)) (config.environment, [])))
in (match (_30_1181) with
| (env, lbs) -> begin
(let lbs = (Support.List.rev lbs)
in (let c_body = (wne tcenv (let _30_1183 = config
in {code = body; environment = env; stack = empty_stack; close = _30_1183.close; steps = _30_1183.steps}))
in (let e = (Microsoft_FStar_Absyn_Syntax.mk_Exp_let ((is_rec, lbs), c_body.code) None e.Microsoft_FStar_Absyn_Syntax.pos)
in (Support.Prims.pipe_right (let _30_1187 = config
in {code = e; environment = _30_1187.environment; stack = _30_1187.stack; close = _30_1187.close; steps = _30_1187.steps}) rebuild))))
end))
end
| Microsoft_FStar_Absyn_Syntax.Exp_ascribed ((e, t, l)) -> begin
(let c = (wne tcenv (let _30_1194 = config
in {code = e; environment = _30_1194.environment; stack = _30_1194.stack; close = _30_1194.close; steps = _30_1194.steps}))
in (match ((is_stack_empty config)) with
| true -> begin
(let t = (sn tcenv (t_config t config.environment config.steps))
in (let _68_12540 = (let _30_1198 = config
in (let _68_12539 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_ascribed (c.code, t.code, l) None e.Microsoft_FStar_Absyn_Syntax.pos)
in {code = _68_12539; environment = _30_1198.environment; stack = _30_1198.stack; close = _30_1198.close; steps = _30_1198.steps}))
in (rebuild _68_12540)))
end
| false -> begin
c
end))
end
| Microsoft_FStar_Absyn_Syntax.Exp_meta (Microsoft_FStar_Absyn_Syntax.Meta_desugared ((e, info))) -> begin
(let c = (wne tcenv (let _30_1205 = config
in {code = e; environment = _30_1205.environment; stack = _30_1205.stack; close = _30_1205.close; steps = _30_1205.steps}))
in (match ((is_stack_empty config)) with
| true -> begin
(let _68_12542 = (let _30_1208 = config
in (let _68_12541 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_meta (Microsoft_FStar_Absyn_Syntax.Meta_desugared ((c.code, info))))
in {code = _68_12541; environment = _30_1208.environment; stack = _30_1208.stack; close = _30_1208.close; steps = _30_1208.steps}))
in (rebuild _68_12542))
end
| false -> begin
c
end))
end)))))

let norm_kind = (fun ( steps ) ( tcenv ) ( k ) -> (let c = (snk tcenv (k_config k empty_env steps))
in (Microsoft_FStar_Absyn_Util.compress_kind c.code)))

let norm_typ = (fun ( steps ) ( tcenv ) ( t ) -> (let c = (sn tcenv (t_config t empty_env steps))
in c.code))

let norm_exp = (fun ( steps ) ( tcenv ) ( e ) -> (let c = (wne tcenv (e_config e empty_env steps))
in c.code))

let norm_sigelt = (fun ( tcenv ) ( _30_9 ) -> (match (_30_9) with
| Microsoft_FStar_Absyn_Syntax.Sig_let ((lbs, r, l, b)) -> begin
(let e = (let _68_12566 = (let _68_12565 = (Microsoft_FStar_Absyn_Syntax.mk_Exp_constant Microsoft_FStar_Absyn_Syntax.Const_unit None r)
in (lbs, _68_12565))
in (Microsoft_FStar_Absyn_Syntax.mk_Exp_let _68_12566 None r))
in (let e = (norm_exp ((Beta)::[]) tcenv e)
in (match (e.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Exp_let ((lbs, _30_1234)) -> begin
Microsoft_FStar_Absyn_Syntax.Sig_let ((lbs, r, l, b))
end
| _30_1238 -> begin
(failwith ("Impossible"))
end)))
end
| s -> begin
s
end))

let whnf = (fun ( tcenv ) ( t ) -> (let t = (Microsoft_FStar_Absyn_Util.compress_typ t)
in (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| (Microsoft_FStar_Absyn_Syntax.Typ_fun (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_refine (_)) -> begin
t
end
| (Microsoft_FStar_Absyn_Syntax.Typ_btvar (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_const (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_uvar (_)) | (Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_const (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _))) | (Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_btvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _))) -> begin
(let _68_12571 = (eta_expand tcenv t)
in (Support.Prims.pipe_right _68_12571 Microsoft_FStar_Absyn_Util.compress_typ))
end
| (Microsoft_FStar_Absyn_Syntax.Typ_app (({Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _}, _))) | (_) -> begin
(norm_typ ((WHNF)::(Beta)::(Eta)::[]) tcenv t)
end)))

let norm_comp = (fun ( steps ) ( tcenv ) ( c ) -> (let c = (sncomp tcenv (c_config c empty_env steps))
in c.code))

let normalize_kind = (fun ( tcenv ) ( k ) -> (let steps = (Eta)::(Delta)::(Beta)::[]
in (norm_kind steps tcenv k)))

let normalize_comp = (fun ( tcenv ) ( c ) -> (let steps = (Eta)::(Delta)::(Beta)::(SNComp)::(DeltaComp)::[]
in (norm_comp steps tcenv c)))

let normalize = (fun ( tcenv ) ( t ) -> (norm_typ ((DeltaHard)::(Beta)::(Eta)::[]) tcenv t))

let exp_norm_to_string = (fun ( tcenv ) ( e ) -> (let _68_12594 = (norm_exp ((Beta)::(SNComp)::(Unmeta)::[]) tcenv e)
in (Microsoft_FStar_Absyn_Print.exp_to_string _68_12594)))

let typ_norm_to_string = (fun ( tcenv ) ( t ) -> (let _68_12599 = (norm_typ ((Beta)::(SNComp)::(Unmeta)::[]) tcenv t)
in (Microsoft_FStar_Absyn_Print.typ_to_string _68_12599)))

let kind_norm_to_string = (fun ( tcenv ) ( k ) -> (let _68_12604 = (norm_kind ((Beta)::(SNComp)::(Unmeta)::[]) tcenv k)
in (Microsoft_FStar_Absyn_Print.kind_to_string _68_12604)))

let formula_norm_to_string = (fun ( tcenv ) ( f ) -> (let _68_12609 = (norm_typ ((Beta)::(SNComp)::(Unmeta)::[]) tcenv f)
in (Microsoft_FStar_Absyn_Print.formula_to_string _68_12609)))

let comp_typ_norm_to_string = (fun ( tcenv ) ( c ) -> (let _68_12614 = (norm_comp ((Beta)::(SNComp)::(Unmeta)::[]) tcenv c)
in (Microsoft_FStar_Absyn_Print.comp_typ_to_string _68_12614)))

let normalize_refinement = (fun ( env ) ( t0 ) -> (let t = (norm_typ ((Beta)::(WHNF)::(DeltaHard)::[]) env t0)
in (let rec aux = (fun ( t ) -> (let t = (Microsoft_FStar_Absyn_Util.compress_typ t)
in (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_refine ((x, phi)) -> begin
(let t0 = (aux x.Microsoft_FStar_Absyn_Syntax.sort)
in (match (t0.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_refine ((y, phi1)) -> begin
(let _68_12627 = (let _68_12626 = (let _68_12625 = (let _68_12624 = (let _68_12623 = (let _68_12622 = (let _68_12621 = (Microsoft_FStar_Absyn_Util.bvar_to_exp y)
in (x.Microsoft_FStar_Absyn_Syntax.v, _68_12621))
in Support.Microsoft.FStar.Util.Inr (_68_12622))
in (_68_12623)::[])
in (Microsoft_FStar_Absyn_Util.subst_typ _68_12624 phi))
in (Microsoft_FStar_Absyn_Util.mk_conj phi1 _68_12625))
in (y, _68_12626))
in (Microsoft_FStar_Absyn_Syntax.mk_Typ_refine _68_12627 (Some (Microsoft_FStar_Absyn_Syntax.ktype)) t0.Microsoft_FStar_Absyn_Syntax.pos))
end
| _30_1346 -> begin
t
end))
end
| _30_1348 -> begin
t
end)))
in (aux t))))




