(*--build-config
    options:--admit_fsi OrdSet --admit_fsi OrdMap;
    variables:LIB=../../lib;
    other-files:$LIB/ordset.fsi $LIB/ordmap.fsi
 --*)

module AST

open OrdMap

open OrdSet

type other_info = nat

type varname = string

type prin = nat

val p_cmp: prin -> prin -> Tot bool
let p_cmp p1 p2 = p1 <= p2

type prins = s:ordset prin p_cmp{not (s = empty)}

type eprins = ordset prin p_cmp

type const =
  | C_prin : c:prin -> const
  | C_prins: c:prins -> const

  | C_unit : const
  | C_nat  : c:nat -> const
  | C_bool : c:bool -> const

type exp' =
  | E_aspar     : ps:exp -> e:exp -> exp'
  | E_assec     : ps:exp -> e:exp -> exp'
  | E_unbox     : e:exp  -> exp'
  | E_mkwire    : e1:exp -> e2:exp -> exp'
  | E_projwire  : e1:exp -> e2:exp -> exp'
  | E_concatwire: e1:exp -> e2:exp -> exp'

  | E_const     : c:const -> exp'
  | E_var       : x:varname -> exp'
  | E_let       : x:varname -> e1:exp -> e2:exp -> exp'
  | E_abs       : x:varname -> e:exp -> exp'
  | E_fix       : f:varname -> x:varname -> e:exp -> exp'
  | E_empabs    : x:varname -> e:exp -> exp'
  | E_app       : e1:exp -> e2:exp -> exp'
  | E_ffi       : fn:string -> args:list exp -> exp'
  | E_match     : e:exp -> pats:list (pat * exp) -> exp'

and pat =
  | P_const: c:const -> pat

and exp =
  | Exp: e:exp' -> info:option other_info -> exp

type canbox = | Can_b | Cannot_b

val canbox_const: c:const -> Tot canbox
let canbox_const c = match c with
  | C_prin _
  | C_prins _ -> Cannot_b
  
  | C_unit
  | C_nat _
  | C_bool _  -> Can_b

(* if empty, Can_b then can_wire *)
type v_meta = eprins * canbox

type value: v_meta -> Type =
  | V_const   : c:const -> value (empty, canbox_const c)

  | V_box     : #meta:v_meta -> ps:prins
                -> v:value meta{subset (fst meta) ps /\ (snd meta) = Can_b}
                -> value (ps, Can_b)
                
  | V_wire    : eps:eprins -> m:v_wire eps -> value (empty, Cannot_b)

  | V_clos    : en:env -> x:varname -> e:exp -> value (empty, Cannot_b)
  
  | V_fix_clos: en:env -> f:varname -> x:varname -> e:exp -> value (empty, Cannot_b)

  | V_emp_clos: x:varname -> e:exp -> value (empty, Can_b)

  (* bomb value, comes up in target only *)
  | V_emp     : value (empty, Can_b)

and v_wire (eps:eprins) =
  m:ordmap prin (value (empty, Can_b)) p_cmp{forall p. mem p eps = contains p m}

and dvalue:Type =
  | D_v: meta:v_meta -> v:value meta -> dvalue

and env = varname -> Tot (option dvalue)

assume val preceds_axiom: en:env -> x:varname -> Lemma (ensures (en x << en))

type redex =
  | R_aspar     : #meta:v_meta -> ps:prins -> v:value meta -> redex
  | R_assec     : #meta:v_meta -> ps:prins -> v:value meta -> redex
  | R_box       : #meta:v_meta -> ps:prins -> v:value meta -> redex
  | R_unbox     : #meta:v_meta -> v:value meta -> redex
  | R_mkwire    : #mps:v_meta -> #mv:v_meta -> vps:value mps -> v:value mv -> redex
  | R_projwire  : #meta:v_meta -> p:prin -> v:value meta -> redex
  | R_concatwire: #meta1:v_meta -> #meta2:v_meta -> v1:value meta1 -> v2:value meta2 -> redex
  | R_let       : #meta:v_meta -> x:varname -> v:value meta -> e:exp -> redex
  | R_app       : #meta1:v_meta -> #meta2:v_meta -> v1:value meta1 -> v2:value meta2
                  -> redex
  | R_ffi       : fn:string -> args:list dvalue -> redex
  | R_match     : #meta:v_meta -> v:value meta -> pats:list (pat * exp) -> redex

val empty_env: env
let empty_env = fun _ -> None

val update_env: #meta:v_meta -> env -> varname -> value meta -> Tot env
let update_env #meta en x v = fun y -> if y = x then Some (D_v meta v) else en y

type as_mode =
  | Par
  | Sec

type mode =
  | Mode: m:as_mode -> ps:prins -> mode

type frame' =
  | F_aspar_ps     : e:exp -> frame'
  | F_aspar_e      : ps:prins -> frame'
  | F_assec_ps     : e:exp -> frame'
  | F_assec_e      : ps:prins -> frame'
  | F_assec_ret    : frame'
  | F_box_e        : ps:prins -> frame'
  | F_unbox        : frame'
  | F_mkwire_ps    : e:exp -> frame'
  | F_mkwire_e     : #meta:v_meta -> v:value meta -> frame'
  | F_projwire_p   : e:exp -> frame'
  | F_projwire_e   : p:prin -> frame'
  | F_concatwire_e1: e:exp -> frame'
  | F_concatwire_e2: #meta:v_meta -> v:value meta -> frame'
  | F_let          : x:varname -> e2:exp -> frame'
  | F_app_e1       : e2:exp -> frame'
  | F_app_e2       : #meta:v_meta -> v:value meta -> frame'
  | F_ffi          : fn:string -> es:list exp -> vs:list dvalue -> frame'
  | F_match        : pats:list (pat * exp) -> frame'

type frame =
  | Frame: m:mode -> en:env -> f:frame'-> frame

type stack = list frame

type term =
  | T_exp     : e:exp -> term
  | T_red     : r:redex -> term
  | T_val     : #meta:v_meta -> v:value meta -> term

  | T_sec_wait: term

type level = | Source | Target

val src: level -> Tot bool
let src = is_Source

type mode_inv (m:mode) (l:level) =
  (is_Target l /\ Mode.m m = Par) ==> is_singleton (Mode.ps m)

val is_sec_frame: f':frame' -> Tot bool
let is_sec_frame f' =
  not (is_F_aspar_ps f' || is_F_aspar_e f' || is_F_box_e f')

val stack_source_inv: stack -> mode -> Tot bool
let rec stack_source_inv s (Mode as_m ps) = match s with
  | []                  -> not (as_m = Sec)
  | (Frame m' _ f')::tl ->
    let Mode as_m' ps' = m' in
    (not (as_m = Par) || as_m' = Par)                              &&
    (not (as_m = Par) || not (is_F_assec_ret f'))                  &&
    (not (as_m = Sec) || (not (as_m' = Par) || is_F_assec_ret f')) &&
    (not (as_m' = Sec) || (is_sec_frame f' && is_Cons tl))         &&
    (not (is_F_box_e f') || (ps = F_box_e.ps f'))                  &&
    (ps = ps' || (subset ps ps' && is_F_box_e f'))                 &&
    stack_source_inv tl m'

val stack_target_inv: stack -> mode -> Tot bool
let rec stack_target_inv s m = match s with
  | []                  -> true
  | (Frame m' _ f')::tl ->
    m = m'                                             &&
    (not (Mode.m m' = Par) || not (is_F_assec_ret f')) &&
    (not (Mode.m m' = Sec) || is_sec_frame f')         &&
    stack_target_inv tl m

val stack_inv: stack -> mode -> level -> Tot bool
let rec stack_inv s m l =
  if is_Source l then stack_source_inv s m else stack_target_inv s m

val is_sec_redex: redex -> Tot bool
let is_sec_redex r = not (is_R_aspar r || is_R_box r)

val term_inv: term -> mode -> level -> Tot bool
let term_inv t m l =
  (not (is_Source l) || not (t = T_sec_wait)) &&
  (not (is_T_red t && Mode.m m = Sec) || is_sec_redex (T_red.r t))

type config =
  | Conf: l:level -> m:mode{mode_inv m l} -> s:stack{stack_inv s m l}
          -> en:env -> t:term{term_inv t m l} -> config

type sconfig = c:config{is_Source (Conf.l c)}
type tconfig = c:config{is_Target (Conf.l c)}

val is_sframe: c:config -> f:(frame' -> Tot bool) -> Tot bool
let is_sframe (Conf _ _ s _ _) f = is_Cons s && f (Frame.f (Cons.hd s))

val is_value: c:config -> Tot bool
let is_value c = is_T_val (Conf.t c)

val is_value_ps: c:config -> Tot bool
let is_value_ps c = match c with
  | Conf _ _ _ _ (T_val (V_const (C_prins _))) -> true
  | _                                          -> false

val is_value_p: c:config -> Tot bool
let is_value_p c = match c with
  | Conf _ _ _ _ (T_val (V_const (C_prin _))) -> true
  | _                                         -> false

val c_value: c:config{is_value c} -> Tot dvalue
let c_value (Conf _ _ _ _ (T_val #meta v)) = D_v meta v

val c_value_ps: c:config{is_value_ps c} -> Tot prins
let c_value_ps c = match c with
  | Conf _ _ _ _ (T_val (V_const (C_prins ps))) -> ps

val c_value_p: c:config{is_value_p c} -> Tot prin
let c_value_p c = match c with
  | Conf _ _ _ _ (T_val (V_const (C_prin p))) -> p

val is_par: config -> Tot bool
let is_par c = is_Par (Mode.m (Conf.m c))

val is_sec: config -> Tot bool
let is_sec c = is_Sec (Mode.m (Conf.m c))
