﻿(* -------------------------------------------------------------------- *)
#light "off"

module Microsoft.FStar.Backends.OCaml.ASTTrans

open System
open System.Text

open Microsoft.FStar
open Microsoft.FStar.Util
open Microsoft.FStar.Range
open Microsoft.FStar.Absyn.Syntax
open Microsoft.FStar.Absyn.Util
open Microsoft.FStar.Backends.ML.Syntax
open FSharp.Format


(* -------------------------------------------------------------------- *)
type mlenv = { mle_name : mlpath; }

let mk_mlenv (name : mlpath) = { mle_name = name; }

(* -------------------------------------------------------------------- *)
let outmod = [
    ["Prims"];
    ["System"];
    ["ST"];
    ["Option"];
    ["String"];
    ["Char"];
    ["Bytes"];
    ["List"];
    ["Array"];
    ["Set"];
    ["Map"];
    ["Heap"];
    ["DST"];
    ["IO"];
    ["Tcp"];
    ["Crypto"];
    ["Collections"];
    ["Microsoft"; "FStar"; "Bytes"];
    ["Microsoft"; "FStar"; "Platform"];
    ["Microsoft"; "FStar"; "Util"];
    ["Microsoft"; "FStar"; "Getopt"];
    ["Microsoft"; "FStar"; "Unionfind"];
    ["Microsoft"; "FStar"; "Range"];
    ["Microsoft"; "FStar"; "Parser"; "Util"];
]

(* -------------------------------------------------------------------- *)
(* A table to remember the names of the fields of constructors *)
let record_constructors = smap_create<list<ident>>(17)
(* A table to remember the arity of algebraic constructors *)
let algebraic_constructors = smap_create<(int * list<string>)>(40)
let _ign = smap_add algebraic_constructors "Prims.Some" (1, ["v"])

let rec in_ns = function
| [], _ -> true
| x1::t1, x2::t2 when (x1 = x2) -> in_ns (t1, t2)
| _, _ -> false

(* -------------------------------------------------------------------- *)
let path_of_ns mlenv ns =
    let ns = List.map (fun x -> x.idText) ns in
    let outsupport = fun (ns1,ns2) -> if ns1 = ns2 then [] else [String.concat "_" ns2]
    
    (*function
    | x1 :: p1, x2 :: p2 when x1 = x2 -> outsupport (p1, p2)
    | _, p -> p
    *)
    in let chkin sns = if in_ns (sns, ns) then Some sns else None
    in match List.tryPick chkin outmod with
    | None -> 
        (match List.tryPick chkin (!Microsoft.FStar.Options.codegen_libs) with
         | None -> outsupport ((fst mlenv.mle_name) @ [snd mlenv.mle_name], ns)
         | _ -> ns)
    | Some sns -> "Support" :: ns

let mlpath_of_lident (mlenv : mlenv) (x : lident) : mlpath =
    match x.str with
    | "Prims.Some" -> ([], "Some")
    | "Prims.None" -> ([], "None")
    | "Prims.failwith" -> ([], "failwith")
    | "ST.alloc" -> ([], "ref")
    | "ST.read" -> (["Support";"Prims"], "op_Bang")
    | "ST.op_ColonEquals" -> (["Support";"Prims"], "op_ColonEquals")
    | _ ->
      begin
        let ns = x.ns in
        let x  = x.ident.idText in
        (path_of_ns mlenv ns, x)
      end

(* -------------------------------------------------------------------- *)
type error =
| Unexpected      of string
| Unsupported     of string
| UnboundVar      of string
| UnboundTyVar    of string
| DuplicatedLocal of string * string

exception OCamlFailure of Range.range * error

let string_of_error (error : error) =
    match error with
    | Unexpected      s -> "unexpected: "^ s
    | Unsupported     s -> "unsupported: "^ s
    | UnboundVar      s -> "unbound-var: "^ s
    | UnboundTyVar    s -> "unbound-ty-var: "^ s
    | DuplicatedLocal _ -> "duplicated-local"

let unexpected (rg : range) (what : string) =
    raise (OCamlFailure (rg, Unexpected what))

let unsupported (rg : range) (what : string) =
    raise (OCamlFailure (rg, Unsupported what))

let unbound_var (rg : range) (x : ident) =
    raise (OCamlFailure (rg, UnboundVar x.idText))

let unbound_ty_var (rg : range) (x : ident) =
    raise (OCamlFailure (rg, UnboundTyVar x.idText))

let duplicated_local (rg : range) (x : string * string) =
    raise (OCamlFailure (rg, DuplicatedLocal x))

(* -------------------------------------------------------------------- *)
let fresh = let c = mk_ref 0 in                                            
            fun x -> (incr c; (x, !c))

(* -------------------------------------------------------------------- *)
let tyvar_of_int =
    let tyvars = "abcdefghijklmnopqrstuvwxyz" in
    let rec aux n =
        let s = string_of_char (String.get tyvars (n % 26)) in (* FIXME *)
        if n >= (String.length tyvars) 
        then (aux (n/26)) ^ s 
        else s
    in fun n -> "'" ^ (aux n)

(* -------------------------------------------------------------------- *)
type lenv = | LEnv of  smap<mlident> 

(* -------------------------------------------------------------------- *)
let lempty : lenv =
    LEnv (smap_create 0)

(* -------------------------------------------------------------------- *)
let lenv_of_mlenv (_ : mlenv) : lenv =
    lempty

(* -------------------------------------------------------------------- *)
let lpush (LEnv lenv) (real : ident) (pp : ident) =
(* FIXME
    if Map.containsKey real.idText lenv then
        duplicated_local real.idRange (real.idText, pp.idText);
*)
    let mlid = fresh pp.idText in
    smap_add lenv real.idText mlid;
    (LEnv lenv, mlid)

(* -------------------------------------------------------------------- *)
let lresolve (LEnv lenv) (x : ident) =
    match smap_try_find lenv x.idText with
    | None   -> unbound_var x.idRange x
    | Some x -> x

(* -------------------------------------------------------------------- *)
(*what is the purpose of this smap?*)
type tenv = | TEnv of smap< mlident>

(* -------------------------------------------------------------------- *)
let tempty : tenv =
    TEnv (smap_create 0)

(* -------------------------------------------------------------------- *)
let tvsym (x,n) = if Util.starts_with x "'" then (x,n) else ("'"^x,n)

let tenv_of_tvmap tvs =
    let rec fresh_tyvar used i =
        let pp = tyvar_of_int 0 in

        if set_mem pp used then
            fresh_tyvar used (i+1)
        else
            (set_add pp used, pp) in

    let freshen used pp =
        match pp with
        | Some pp when not (set_mem pp.idText used) ->
            (set_add pp.idText used, pp.idText)
        | _ ->
            fresh_tyvar used 0 in

    let _, tvs =
        let for1 used tv =
            match tv with
            | Some (real, pp) ->
                let (used, pp) = freshen used (Some pp) in 
                (used, (fresh pp, Some real.idText))
            | None ->
                let (used, pp) = freshen used None in
                (used, (fresh pp, None)) in

        Util.fold_map for1 (new_set (fun (x:string) y -> if x = y then 0 else 1) (fun x -> 0)) tvs
            in
    
    let tparams = List.map (fun (x, _) -> tvsym x) tvs in
    let tvs = List.choose (fun (x, y) ->
        match y with None -> None | Some y -> Some (y, tvsym x))
        tvs
    in

    (TEnv (smap_of_list tvs), tparams)

(* -------------------------------------------------------------------- *)
let tvar_of_btvar (TEnv tenv) (x : bvar<typ, knd>) =
    let name = x.v.realname.idText in

    match smap_try_find tenv name with
    | None   -> ("",0) //unbound_ty_var x.p x.v.ppname
    | Some x -> tvsym x


(* -------------------------------------------------------------------- *)
let is_prim_ns (ns : list<ident>) =
    match ns with
    | [{ idText = "Prims" }] -> true
    | _ -> false

(* -------------------------------------------------------------------- *)
type tprims =
| Tuple of int
| Exn

(* -------------------------------------------------------------------- *)
let as_tprims (id : lident) : option<tprims> =
    if is_prim_ns id.ns then
        match id.ident.idText with
        | "Tuple2" | "DTuple2" -> Some (Tuple 2)
        | "Tuple3" | "DTuple3" -> Some (Tuple 3)
        | "Tuple4" | "DTuple4" -> Some (Tuple 4)
        | "Tuple5" | "DTuple5" -> Some (Tuple 5)
        | "Tuple6" | "DTuple6" -> Some (Tuple 6)
        | "Tuple7" | "DTuple7" -> Some (Tuple 7)
        | "exn"    -> Some Exn
        | _        -> None
    else
        None

(* -------------------------------------------------------------------- *)
let is_xtuple (x : lident) =
    if is_prim_ns x.ns then
        match x.ident.idText with
        | "MkTuple2" | "MkDTuple2" -> Some 2
        | "MkTuple3" | "MkDTuple3" -> Some 3
        | "MkTuple4" | "MkDTuple4" -> Some 4
        | "MkTuple5" | "MkDTuple5" -> Some 5
        | "MkTuple6" | "MkDTuple6" -> Some 6
        | "MkTuple7" | "MkDTuple7" -> Some 7
        | _          -> None
    else
        None

(* -------------------------------------------------------------------- *)
let is_etuple (e : exp) =
    match (Absyn.Util.compress_exp e).n with
    | Exp_app({n=Exp_fvar (x, _)}, args) ->
        let args = List.collect (function (Inl _, _) -> [] | Inr e, _ -> [e]) args in
        begin match is_xtuple x.v with
        | Some k when (k = List.length args) -> Some k
        | _ -> None
        end
    | _ -> None

(* -------------------------------------------------------------------- *)
let is_ptuple (p : pat) =
    match p.v with
    | Pat_cons (x, _, args) ->
        let args = args |> List.collect (fun p -> match p.v with 
            | Pat_dot_term _ | Pat_dot_typ _ -> []
            | _ -> [p])
        in
        begin match is_xtuple x.v with
        | Some k -> if k = List.length args then Some k else None
        | _ -> None
        end
    | _ -> None
    
(* -------------------------------------------------------------------- *)
let mlkind_of_kind (tps : list<binder>) (k : knd) =
    let mltparam_of_tparam = function
        | Inl ({v=x; sort={n=Kind_type}}), _ -> Some (x.realname, x.ppname)
//        | Inr ({v=x}), _ -> Some (x.realname, x.ppname)
//        | Inr ({sort={n=Typ_const {v=x; sort={n=Kind_type}}}}), _ -> Some (x.ident, x.ident)
        | x -> None // Util.print_any x; None
    in

    let rec aux acc (k : knd) =
        match (Absyn.Util.compress_kind k).n with
        | Kind_type    -> Some (List.rev acc)
        | Kind_unknown -> Some (List.rev acc) (* FIXME *)

        | Kind_arrow([], k) -> aux acc k

        | Kind_arrow((Inl x, _)::rest, k2) -> begin
            match aux [] x.sort with
            | Some [] ->
                let x = if is_null_binder (Inl x, None)
                        then None
                        else Some (x.v.realname, x.v.ppname) in
                aux (x  :: acc) (mk_Kind_arrow(rest, k2) k.pos)
            | _ -> None
        end

        | _ -> None in

    let aout = List.choose mltparam_of_tparam tps in

//    if List.length aout <> List.length tps then
//        None
//    else
        let some x = Some x in
        aux (List.rev (List.map some aout)) k

(* -------------------------------------------------------------------- *)
let rec mlty_of_ty_core (mlenv : mlenv) (tenv : tenv) ((rg, ty) : range * typ) =
    let rg = ty.pos in
    let ty = Absyn.Util.compress_typ ty in
    match ty.n with
    | Typ_btvar x ->
        MLTY_Var (tvar_of_btvar tenv x)

    | Typ_refine ({sort=ty}, _) ->
        mlty_of_ty mlenv tenv (rg, ty)

    | Typ_ascribed (ty, _) ->
        mlty_of_ty mlenv tenv (rg, ty)

    | Typ_fun([], c) -> 
       mlty_of_ty mlenv tenv (rg, comp_result c)
    | Typ_fun ((Inr {v=x; sort=t1},  _)::rest, c) -> 
        let t2 = match rest with 
            | [] -> comp_result c 
            | _ -> mk_Typ_fun(rest, c) None ty.pos in
        let mlt1 = mlty_of_ty mlenv tenv (rg, t1) in
        let mlt2 = mlty_of_ty mlenv tenv (rg, t2) in
        MLTY_Fun (mlt1, Keep, mlt2)
    | Typ_fun((Inl _, _)::rest, c) ->
        let r = match rest with
            | [] -> comp_result c
            | _ -> mk_Typ_fun(rest, c) None ty.pos in
        mlty_of_ty mlenv tenv (rg, r)

    | Typ_const   _ -> unexpected  rg "type-constant"

    | Typ_app(t, []) ->
       mlty_of_ty mlenv tenv (rg, t)
    | Typ_app (t1, (Inl t2,  _)::rest) ->
        let t2 = match rest with
            | [] -> t2
            | _ -> mk_Typ_app(t2,rest) None ty.pos in

        let mlt1 = mlty_of_ty mlenv tenv (rg, t1) in
        let mlt2 = mlty_of_ty mlenv tenv (rg, t2) in
        MLTY_App (mlt1, mlt2)
    | Typ_app (t, (Inr _,  _)::rest) -> 
        let r = match rest with
            | [] -> t
            | _ -> mk_Typ_app(t,rest) None ty.pos in
        mlty_of_ty mlenv tenv (rg, r)

    | Typ_lam     _ -> unsupported rg "type-fun"
    | Typ_meta    _ -> unexpected  rg "type-meta"
    | Typ_uvar    _ -> unexpected  rg "type-uvar"
    | Typ_unknown   -> unexpected  rg "type-unknown"
    | Typ_delayed _ -> unexpected  rg "type-delayed"

(* -------------------------------------------------------------------- *)
and maybe_named (mlenv : mlenv) (tenv : tenv) ((rg, ty) : range * typ) =
    let rg = ty.pos in
    let rec aux acc (rg, ty) =
        match (Absyn.Util.compress_typ ty).n with
        | Typ_const c ->
            Some (mlpath_of_lident mlenv c.v, acc)

        | Typ_app(head, args) -> 
           if args |> Util.for_some (function Inr _, _ -> true | _ -> false)
           then None
           else let tys = args |> List.map (function
             | (Inl t, _) -> mlty_of_ty mlenv tenv (rg, t)
             | _ -> failwith "impos")
           in aux (tys@acc) (rg, head)

        | Typ_refine ({sort=ty}, _)        -> aux acc (rg, ty)
        | Typ_ascribed (ty, _)         -> aux acc (rg, ty)
      
        | _ -> None

    in aux [] (rg, ty)

(* -------------------------------------------------------------------- *)
and maybe_tuple (mlenv : mlenv) (tenv : tenv) ((rg, ty) : range * typ) =
    let rg = ty.pos in
    let rec unfun n ty =
        if n <= 0 then Some ty else
            match (Absyn.Util.compress_typ ty).n with
            | Typ_lam (bs, ty) -> unfun (n - List.length bs) ty
            | Typ_ascribed (ty, _) -> unfun n ty
            | _ -> None
    in

    let rec aux acc ty =
        match (Absyn.Util.compress_typ ty).n with
        | Typ_const c -> begin
            match as_tprims c.v with
            | Some (Tuple n) ->
                // let acc = List.choose id (List.mapi unfun acc) in
                if List.length acc <> n then None else
                Some (List.map (fun ty -> mlty_of_ty mlenv tenv (rg, ty)) acc)
            | _ -> None
        end

        | Typ_app (head, args) ->
            if args |> Util.for_some (function (Inr _, _) -> true | Inl t, _ -> false) then None else
            let tys = args |> List.map (function (Inl t, _) -> t | _ -> failwith "impos") in
            aux (tys@acc) head

        | Typ_ascribed (ty, _) ->
            aux acc ty

        | _ -> None
    in

    aux [] ty

(* -------------------------------------------------------------------- *)
and mlty_of_ty (mlenv : mlenv) (tenv : tenv) (rgty : range * typ) : mlty =
    match maybe_tuple mlenv tenv rgty with
    | Some x -> MLTY_Tuple x
    | None   -> begin
        match maybe_named mlenv tenv rgty with
        | Some x -> MLTY_Named (snd x, fst x)
        | None   -> mlty_of_ty_core mlenv tenv rgty
    end

(* -------------------------------------------------------------------- *)
let mltycons_of_mlty (ty : mlty) =
    let rec aux acc ty =
        match ty with
        | MLTY_Fun (dom, _, codom) ->
            aux (dom :: acc) codom
        | _ ->
            (List.rev acc, ty)
    in aux [] ty

(* -------------------------------------------------------------------- *)
let rec strip_polymorphism acc rg ty =
    let rg = ty.pos in
    match (Absyn.Util.compress_typ ty).n with
    | Typ_fun(bs, c) -> begin
        let ts, vs = bs |> List.partition (function Inl {v=x; sort={n=Kind_type}}, _ -> true | _ -> false)  in
        let ts = ts |> List.collect (function (Inl x, _) -> [(x.v.realname, x.v.ppname)] | _ -> []) in
        match vs, c.n with
        | [], Total ty -> ts, rg, ty
        | [], Comp c   -> ts, rg, c.result_typ
        | _ , _        -> ts, rg, mk_Typ_fun(vs, c) None ty.pos
    end
    
    | _ ->
        (List.rev acc, rg, ty)

(* -------------------------------------------------------------------- *)
let mlscheme_of_ty (mlenv : mlenv) (rg : range) (ty : typ) : mltyscheme =
    let tparams, rg, ty = strip_polymorphism [] rg ty in
    let some x = Some x in 
    let tenv, tparams   = tenv_of_tvmap (List.map some tparams) in

    (tparams, mlty_of_ty mlenv tenv (rg, ty))

(* -------------------------------------------------------------------- *)
let mlconst_of_const (sctt : sconst) =
  match sctt with
  | Const_unit         -> MLC_Unit
  | Const_char   c     -> MLC_Char  c
  | Const_uint8  c     -> MLC_Byte  c
  | Const_int    c     -> MLC_Int32 (Util.int32_of_int (Util.int_of_string c))
  | Const_int32  i     -> MLC_Int32 i
  | Const_int64  i     -> MLC_Int64 i
  | Const_bool   b     -> MLC_Bool  b
  | Const_float  d     -> MLC_Float d

  | Const_bytearray (bytes, _) ->
      MLC_Bytes bytes

  | Const_string (bytes, _) ->
      MLC_String (string_of_unicode (bytes))


(* -------------------------------------------------------------------- *)
let rec mlpat_of_pat (mlenv : mlenv) (rg : range) (le : lenv) (p : pat) : lenv * mlpattern =
    match p.v with
    | Pat_cons (x, _, ps) -> begin
        let ps = ps |> List.filter (fun p -> match p.v with 
            | Pat_dot_term _ | Pat_dot_typ _ -> false
            | _ -> true)
        in

        if is_xtuple x.v = Some (List.length ps) then
            let le, ps = Util.fold_map (fun le pat -> mlpat_of_pat mlenv pat.p le pat) le ps in
            (le, MLP_Tuple ps)
        else
          let le, ps = Util.fold_map (mlpat_of_pat mlenv rg) le ps in
          let p =
            match smap_try_find record_constructors x.v.str with
              | Some f -> MLP_Record (path_of_ns mlenv x.v.ns, List.zip (List.map (fun x -> x.idText) f) ps)
              | None -> MLP_CTor (mlpath_of_lident mlenv x.v, ps) in
          (le, p)
    end

    | Pat_var (x, _) ->
        let le, mlid = lpush le x.v.realname x.v.ppname in
        (le, MLP_Var mlid)

    | Pat_constant c ->
        (le, MLP_Const (mlconst_of_const c))

    | Pat_disj ps ->
        let le, ps = Util.fold_map (mlpat_of_pat mlenv rg) le ps in
        (le, MLP_Branch ps)

    | Pat_wild _ ->
        le, MLP_Wild

    | Pat_dot_term _ -> unsupported rg "top-level-dot-patterns"
    | Pat_dot_typ  _ -> unsupported rg "top-level-dot-patterns"
    | Pat_tvar     _ -> unsupported rg "pattern-type-variable"
    | Pat_twild    _ -> unsupported rg "pattern-type-wild"

(* -------------------------------------------------------------------- *)
let rec mlexpr_of_expr (mlenv : mlenv) (rg : range) (lenv : lenv) (e : exp) =
    let rg = e.pos in
    let e = Absyn.Util.compress_exp e in

    let rec eta_expand_dataconst ct args nvars =
      let ctr = mk_ref 0 in
      let rec bvs = function
        | 0 -> []
        | n -> incr ctr; ((("__dataconst_"^(Util.string_of_int !ctr)), !ctr), None) :: (bvs (n-1)) in
      let vs = bvs nvars in
      let fapp = MLE_CTor (ct, args @ (List.map (fun (x,_) -> MLE_Var(x)) vs)) in
      MLE_Fun(vs, fapp)
    in

    let mkCTor c args =
      match smap_try_find record_constructors c.str with
        | Some f -> MLE_Record (path_of_ns mlenv c.ns, List.zip (List.map (fun x -> x.idText) f) args)
        | None ->
          begin
            match smap_try_find algebraic_constructors c.str with
            | Some (n,_) when (n > List.length args) -> eta_expand_dataconst (mlpath_of_lident mlenv c) args (n-List.length args)
            | _ -> MLE_CTor (mlpath_of_lident mlenv c, args)
          end
      in

    match e.n with
    | Exp_app(sube, args) ->
(*       (match sube.n with Exp_fvar (c, false) -> Util.print_string (c.v.str^"\n") | _ -> ()); *)
       (match sube.n, args with
          | Exp_fvar (c, None), [_;_;(Inr a1,_);a2] when (c.v.ident.idText = "pipe_left") ->
             mlexpr_of_expr mlenv rg lenv ({e with n = Exp_app (a1, [a2])})
          | Exp_fvar (c, None), [_;_;a1;(Inr a2,_)] when (c.v.ident.idText = "pipe_right") ->
             mlexpr_of_expr mlenv rg lenv ({e with n = Exp_app (a2, [a1])})
          | Exp_fvar (c, None), _ when (c.v.str = "Prims.Assume" || c.v.str = "Prims.Assert" || c.v.str = "Prims.erase" || Util.starts_with c.v.ident.idText "l__") ->
             MLE_Const (MLC_Unit)
          | _, _ ->
       begin
        match is_etuple e with
        | Some k ->
            let args = List.collect (function Inl _, _ -> [] | Inr e, _ -> [mlexpr_of_expr mlenv rg lenv e]) args in
            MLE_Tuple args
        | _ ->
            let args = List.collect (function (Inl _, _) -> [] | Inr e, _ -> [mlexpr_of_expr mlenv rg lenv e]) args in

            match sube with
            | { n = Exp_fvar (c, Some Data_ctor) } 
            | { n = Exp_fvar (c, Some (Record_ctor _)) } -> mkCTor c.v args
            | { n = Exp_fvar (c, _) } ->
                let subns = String.concat "." (List.map (fun x -> x.idText) c.v.ns) in
                let rn, subnsl = match List.rev c.v.ns with [] -> "", [] | h::t -> h.idText, List.rev t in
                (match smap_try_find record_constructors subns, args with
                | Some _, [arg] ->
                    MLE_Proj (arg, (path_of_ns mlenv subnsl, c.v.ident.idText))
                | Some _, arg::args ->
                    MLE_App (MLE_Proj (arg, (path_of_ns mlenv subnsl, c.v.ident.idText)), args)
                | _ -> MLE_App (mlexpr_of_expr mlenv rg lenv sube, args))
            | _ -> MLE_App (mlexpr_of_expr mlenv rg lenv sube, args)
       end)

    | _ -> begin
        match e.n with
        | Exp_bvar x ->
            MLE_Var (lresolve lenv x.v.realname)

        | Exp_fvar (x, Some Data_ctor) ->
           mkCTor x.v []
            (* MLE_CTor (mlpath_of_lident mlenv x.v, []) *)

        | Exp_fvar (x, _) ->
            let fid = x.v.ident.idText in
            if Util.starts_with fid "is_" && String.length fid > 3 && Util.is_upper (Util.char_at fid 3) then
                let sub = Util.substring_from fid 3 in
                let mlid = fresh "_discr_" in
                let rid = {x.v with ident = {x.v.ident with idText = sub}; str = sub} in
                MLE_Fun([(mlid, None)], MLE_Match(MLE_Name([], idsym mlid), [
                    MLP_CTor(mlpath_of_lident mlenv rid, [MLP_Wild]), None, MLE_Const(MLC_Bool true);
                    MLP_Wild, None, MLE_Const(MLC_Bool false)]))
            else begin
                match smap_try_find algebraic_constructors x.v.nsstr with
                | Some (_, projs) ->
                    let mlid = fresh "_proj_" in
                    let cargs = List.map (fun x -> MLP_Var(fresh x)) projs in
                    let cn::cr = List.rev x.v.ns in
                    let crstr = List.map (fun x->x.idText) cr in
                    let rid = {ns=cr; ident={x.v.ident with idText=cn.idText}; nsstr=String.concat "." crstr; str=x.v.nsstr} in
                    let cn = cn.idText in
                    MLE_Fun([(mlid,None)], MLE_Match(MLE_Name([], idsym mlid), [
                        MLP_CTor(mlpath_of_lident mlenv rid, cargs), None, MLE_Name ([], x.v.ident.idText);
                    ]))
                | None -> MLE_Name (mlpath_of_lident mlenv x.v)
            end


        | Exp_constant c ->
            MLE_Const (mlconst_of_const c)

        | Exp_abs([], e) -> 
           mlexpr_of_expr mlenv rg lenv e 

        | Exp_abs ((Inl _, _)::rest, e) ->
           (* FIXME: should only occur after a let-binding *)
           mlexpr_of_expr mlenv rg lenv (if List.isEmpty rest then e else mk_Exp_abs(rest, e) None e.pos)

        | Exp_abs ((Inr x, _)::rest, e) ->
            let lenv, mlid = lpush lenv x.v.realname x.v.ppname in
            let e = mlexpr_of_expr mlenv rg lenv (if List.isEmpty rest then e else mk_Exp_abs(rest, e) None e.pos) in
            mlfun mlid e

        | Exp_match (x, [(p, None, e)]) when (Absyn.Util.is_wild_pat p) ->
            (match x.n with 
              | Exp_fvar _ -> mlexpr_of_expr mlenv rg lenv e
              | Exp_bvar _ -> mlexpr_of_expr mlenv rg lenv e
              | _ -> failwith "Impossible")
            

        | Exp_match (e, bs) -> begin
            match bs with
            | [({v=Pat_constant (Const_bool true )}, None, e1);
               ({v=Pat_constant (Const_bool false)}, None, e2)]

            | [({v=Pat_constant (Const_bool false)}, None, e1);
               ({v=Pat_constant (Const_bool true )}, None, e2)] ->

               let e  = mlexpr_of_expr mlenv rg lenv e  in
               let e1 = mlexpr_of_expr mlenv rg lenv e1 in
               let e2 = mlexpr_of_expr mlenv rg lenv e2 in

               mlif e (e1, e2)

            | _ ->
                let e  = mlexpr_of_expr mlenv rg lenv e in
                let bs = List.map (mlbranch_of_branch mlenv rg lenv) bs in

                MLE_Match (e, bs)
        end

        | Exp_let ((rec_, lb), body) ->
            let lenv, bindings = mllets_of_lets mlenv rg lenv (rec_, lb) in
            let body = mlexpr_of_expr mlenv rg lenv body in
            MLE_Let ((rec_, bindings), body)

        | Exp_meta (Meta_desugared (e, Data_app)) ->
            assert false;
            let (c, args) =
                match e.n with
                | Exp_app({n=Exp_fvar (c, Some Data_ctor)}, args)
                | Exp_app({n=Exp_fvar (c, Some (Record_ctor _))}, args) -> (c, args)
                | _ -> unexpected rg "meta-data-app-without-fvar"
            in
            
            let args = args |> List.collect (function Inr e, _ -> [e] | _ -> [])in
            let args = List.map (mlexpr_of_expr mlenv rg lenv) args in

            mkCTor c.v args
            (* MLE_CTor (mlpath_of_lident mlenv c.v, args) *)
            
        | Exp_meta (Meta_desugared (e, Sequence)) -> begin
            match e.n with
            | Exp_let ((false, [({lbname=Inl _; lbdef=e1})]), e2) ->
                let d1 = mlexpr_of_expr mlenv rg lenv e1 in
                let d2 = mlexpr_of_expr mlenv rg lenv e2 in
                mlseq d1 d2

            | _ -> unexpected rg "expr-seq-mark-without-let"
        end

        | Exp_meta (Meta_desugared (e, Primop)) ->
             mlexpr_of_expr mlenv rg lenv e
      
        | Exp_ascribed (e, _, _) ->
            mlexpr_of_expr mlenv rg lenv e

        | Exp_meta (Meta_desugared (e, MaskedEffect)) ->
            mlexpr_of_expr mlenv rg lenv e

        | Exp_app     _ -> unexpected rg "expr-app"
        | Exp_uvar    _ -> unexpected rg "expr-uvar"
        | Exp_delayed _ -> unexpected rg "expr-delayed"
    end

(* -------------------------------------------------------------------- *)
and mllets_of_lets (mlenv : mlenv) (rg : range) (lenv : lenv) (rec_, lbs) =    
    let downct lb =
        match lb.lbname with
        | Inl x -> (x, lb.lbdef)
        | Inr _ -> unexpected rg "expr-let-in-with-fvar" in


    let lbs = List.map downct lbs in

    let lenvb, mlids =
        Util.fold_map
            (fun lenv (x, _) -> lpush lenv x.realname x.ppname)
            lenv lbs in

    let es =
        let inlenv = if rec_ then lenvb else lenv in
        List.map (fun (x, e) ->
            let mlid = lresolve lenvb x.realname in
            (mlid, None, [], mlexpr_of_expr mlenv rg inlenv e)) lbs
    in

    (lenvb, es)

(* -------------------------------------------------------------------- *)
and mlbranch_of_branch (mlenv : mlenv) (rg : range) (lenv : lenv) (pat, when_, body) =
    let lenv, pat = mlpat_of_pat mlenv rg lenv pat in
    let when_ = Option.map (mlexpr_of_expr mlenv rg lenv) when_ in
    let body  = mlexpr_of_expr mlenv rg lenv body in
    (pat, when_, body)

(* -------------------------------------------------------------------- *)
type mode    = | Sig | Struct
type mlitem1 = either<mlsig1, mlmodule1>

let mlitem1_ty mode args =
    match mode with
    | Sig    -> Inl (MLS_Ty args)
    | Struct -> Inr (MLM_Ty args)

let mlitem1_exn mode args =
    match mode with
    | Sig    -> Inl (MLS_Exn args)
    | Struct -> Inr (MLM_Exn args)

(* -------------------------------------------------------------------- *)
type mldtype = mlsymbol * mlidents * mltybody

type fstypes = | DT of string * list<lident> * list<mlident> * range | Rec of string * list<ident> * list<lident> * list<mlident> * range | Abb of string * typ * (tenv * list<mlident>) * range

let mldtype_of_indt (mlenv : mlenv) (indt : list<sigelt>) : list<mldtype> =
  let rec getRecordFieldsFromType = function
    | [] -> None
    | (RecordType f)::_ -> Some (f |> List.map (fun l -> l.ident))
    | _::qualif -> getRecordFieldsFromType qualif in

  let rec comp_vars ct = match ct with
    | Total(t) -> type_vars t.n
    | Comp(ct) -> type_vars ct.result_typ.n

  and type_vars ty = match ty with
    | Typ_fun(bs,c) -> (bs |> List.collect (function 
       | Inr x, _ -> 
        let tl = type_vars x.sort.n in
        let hd = if is_null_binder (Inr x, None) then None else Some x.v in
        hd::[] (*tl*)
       | _ -> [])) @ (comp_vars c.n)
    | Typ_lam(_,t) | Typ_refine({sort=t}, _) | Typ_app(t, _) 
    | Typ_ascribed(t,_)
    | Typ_meta(Meta_pattern(t,_))
    | Typ_meta(Meta_named(t,_)) -> type_vars t.n
    | _ -> []
   in

    let (ts, cs) =
        let fold1 sigelt (types, ctors) =
            match sigelt with
            | Sig_tycon (x, tps, k, ts, cs, qualif, rg) ->
              if List.contains Logic qualif then (types, ctors)
              else begin
                let ar =
                    match mlkind_of_kind tps k with
                    | None    -> unsupported rg "not-an-ML-kind"
                    | Some ar -> ar in
                let ty =
                  match getRecordFieldsFromType qualif, cs with
                    | Some f, [c] ->
                       (smap_add record_constructors c.str f;
                        Rec (x.ident.idText, f, cs, snd (tenv_of_tvmap ar), rg)) // parsing a record from a Sig_tycon. the record data lies in the qualifiers of the tycon. one can ignore the rest
                    | _, _ -> DT (x.ident.idText, cs, snd (tenv_of_tvmap ar), rg) in
                (ty :: types, ctors)
              end

            | Sig_datacon (x, ty, pr, _, _, rg) ->
               let actr = Util.mk_ref 0 in
               let anames = List.map (function
                    | None -> Util.incr actr;  "_"^(Util.string_of_int !actr)
                    | Some x -> Util.incr actr; x.ppname.idText) (type_vars ty.n) in
               smap_add algebraic_constructors x.str (List.length anames, anames);
               (types, (x.ident.idText, (ty, pr)) :: ctors)

            | Sig_typ_abbrev (x, tps, k, body, _, rg) ->
                let ar =
                    match mlkind_of_kind tps k with
                    | None    -> unsupported rg "not-an-ML-kind"
                    | Some ar -> ar in
                ((Abb (x.ident.idText, body, tenv_of_tvmap ar, rg)) :: types, ctors)

            | _ ->
                unexpected
                    (Absyn.Util.range_of_sigelt sigelt)
                    "no-dtype-or-abbrvs-in-bundle"
        in

        let (ts, cs) = List.fold_right fold1 indt ([], []) in

        (ts, smap_of_list cs)
    in

    let cons_args cname tparams rg x =
      let (c, _) = smap_try_find cs cname.ident.idText |> Util.must in
      let cparams, rgty, c = strip_polymorphism [] rg c in

      if List.length cparams <> List.length tparams then
        unexpected rg "invalid-number-of-ctor-params";

      let cparams = List.map (fun (x, _) -> x.idText) cparams in

      let tenv = List.zip cparams tparams in
      let tenv = TEnv (smap_of_list tenv) in

      let c = mlty_of_ty mlenv tenv (rgty, c) in
      let (args, name) = mltycons_of_mlty c in

      match name with
        | MLTY_Named (tyargs, name) when (snd name = x) ->
           let check x mty = match mty with | MLTY_Var mtyx -> x = mtyx | _ -> false in

           if List.length tyargs <> List.length cparams then
             unexpected rg "dtype-invalid-ctor-result";
           if not (List.forall2 check tparams tyargs) then
             unsupported rg "dtype-invalid-ctor-result";
           args

        | _ -> unexpected rg "dtype-invalid-ctor-result" in

    let fortype ty =
        match ty with
        | DT (x, tcs, tparams, rg) -> begin
            let mldcons_of_cons cname =
              let args = cons_args cname tparams rg x in
              (cname.ident.idText, args)
            in (x, tparams, MLTD_DType (List.map mldcons_of_cons tcs))
        end

        | Rec (x, f, tcs, tparams, rg) -> begin
          let args =
            match tcs with
              | [cname] -> cons_args cname tparams rg x
              | _ -> unexpected rg "records-should-have-one-single-constructor" in

          let mldproj_of_proj name c : (mlsymbol * mlty) = (name.idText, c) in

          if List.length f <> List.length args
          then unexpected rg (Util.format4 "%s, %s, %s fields, %s args" x (List.hd tcs).str (List.map (fun f -> f.idText) f |> String.concat ", ") (List.length args |> Util.string_of_int));
          (x, tparams, MLTD_Record (List.map2 mldproj_of_proj f args)) // generation of ML code for records
        end

        | Abb (x, body, (tenv, tparams), rg) -> begin
            let body = mlty_of_ty mlenv tenv (rg, body) in
            (x, tparams, MLTD_Abbrev body)
        end

    in List.map fortype ts

(* -------------------------------------------------------------------- *)
let mlmod1_of_mod1 mode (mlenv : mlenv) (modx : sigelt) : option<mlitem1> =
    let export_val qal =
        let export_val1 = function
        | Discriminator _ | Projector _ | Logic | Private -> false
        | _ -> true
        in List.for_all export_val1 qal
    in

    match modx with
    | Sig_pragma _ -> None

    | Sig_val_decl (x, ty, qal, rg) when (export_val qal && mode = Sig) ->
(*        Printf.printf "translating val decl %s\n" x.ident.idText; *)
        let tparams, ty = mlscheme_of_ty mlenv rg ty in
        Some (Inl (MLS_Val (x.ident.idText, (tparams, ty))))

    | Sig_val_decl (x, ty, qal, rg) when (mode = Sig) ->
(*        Printf.printf "skipping val decl %s\n" x.ident.idText; *)
        None

    | Sig_let ((rec_, lbs), rg, _, _) when (mode = Struct) ->
        let downct lb = 
            match lb.lbname with
            | Inr x -> (x, lb.lbdef)
            | Inl _ -> unexpected rg "expr-top-let-with-bvar" in

        let lbs = List.map downct lbs in
        let lbs = List.map (fun (x, e) ->
            ((x.ident.idText, -1), None, [], mlexpr_of_expr mlenv rg (lenv_of_mlenv mlenv) e))
            lbs
        in

        Some (Inr (MLM_Let (rec_, lbs)))


    | Sig_main (e, rg) when (mode = Struct) ->
        let lenv = lenv_of_mlenv mlenv in
        Some (Inr (MLM_Top (mlexpr_of_expr mlenv rg lenv e)))

    | Sig_typ_abbrev (_, _, _, _, qal, _) when (not (export_val qal)) -> None
    | Sig_typ_abbrev (t, tps, k, ty, _, rg) -> begin
        let ar =
            match mlkind_of_kind tps k with
            | None    -> unsupported rg "not-an-ML-kind"
            | Some ar -> ar in

        let tenv, tparams = tenv_of_tvmap ar in
        let ty = mlty_of_ty mlenv tenv (rg, ty) in
        let ty = MLTD_Abbrev ty in

        Some (mlitem1_ty mode [t.ident.idText, tparams, Some ty])
    end

    | Sig_tycon (t, tps, k, [], [], [], rg) ->
        let ar =
            match mlkind_of_kind tps k with
            | None    -> unsupported rg "not-an-ML-kind"
            | Some ar -> ar
        in

        let _tenv, tparams = tenv_of_tvmap ar in

        Some (mlitem1_ty mode [t.ident.idText, tparams, None])

    | Sig_new_effect _
    | Sig_kind_abbrev _
    | Sig_effect_abbrev _
    | Sig_sub_effect _ -> None

    | Sig_bundle ([Sig_datacon (_, _, _, qal, _, _)], _, _, _) when (not (export_val qal)) -> None
    | Sig_bundle ([Sig_datacon (x, ty, (tx, _, _), qal, _, rg)], _, _, _) when (as_tprims tx = Some Exn) -> begin
        let rec aux acc ty =
            match (Absyn.Util.compress_typ ty).n with
            | Typ_fun(bs, c) -> 
                let tys = bs |> List.collect (function Inl _, _ -> [] | Inr x, _ -> [x.sort]) in
                tys
            | Typ_const x when (as_tprims x.v = Some Exn) ->
                List.rev acc
            | _ ->
                unexpected rg "invalid-exn-type"
        in

        let args = aux [] ty in
        let tenv = fst (tenv_of_tvmap []) in
        let args = List.map (fun ty -> mlty_of_ty mlenv tenv (rg, ty)) args in

        Some (mlitem1_exn mode (x.ident.idText, args))
    end

    | Sig_bundle (indt, _, _, _) -> begin
        let aout = mldtype_of_indt mlenv indt in
        let aout = List.map (fun (x, y, z) -> (x, y, Some z)) aout in

        match mode with
        | Sig    -> Some (Inl (MLS_Ty aout))
        | Struct -> Some (Inr (MLM_Ty aout))
    end

    | Sig_assume         _ -> None
    | Sig_tycon          _ -> None
    | Sig_datacon        _ -> None
    | Sig_val_decl       _ -> None
    | Sig_let            _ -> None
    | Sig_main           _ -> None

(* -------------------------------------------------------------------- *)
let mlmod_of_mod (mlenv : mlenv) (modx : list<sigelt>) : mlmodule =
    let asright = function Inr x -> x | Inl _ -> failwith "asright" in
    List.choose (fun x -> Option.map asright (mlmod1_of_mod1 Struct mlenv x)) modx

(* -------------------------------------------------------------------- *)
let mlsig_of_sig (mlenv : mlenv) (modx : list<sigelt>) : mlsig =
    let asleft = function Inl x -> x | Inr _ -> failwith "asleft" in
    List.choose (fun x -> Option.map asleft (mlmod1_of_mod1 Sig mlenv x)) modx


(* -------------------------------------------------------------------- *)
let mlmod_of_fstar (fmod_ : modul) =
    let name = Backends.ML.Syntax.mlpath_of_lident fmod_.name in
    fprint1 "OCaml extractor : %s\n" fmod_.name.ident.idText;
    //printfn "%A\n" (fmod_.declarations);
    //fprint1 "%s\n\n\n\n\n\n\n\n\n" "end";
   // let ms =  extractInductives NewExtaction.emptyContext (*instead of being empty, it should be initialized with the constants from the imported modules*) 
    //                           (fmod_.declarations) in
    //printfn "%A\n" ms;
    let mod_ : mlmodule = mlmod_of_mod (mk_mlenv name) fmod_.declarations in
    let sig_ : mlsig = mlsig_of_sig (mk_mlenv name) fmod_.declarations in
    //fprint1 "%s\n\n" "original";
    //printfn "%A\n" sig_;

    (name, sig_, mod_)

let mlmod_of_iface (fmod_ : modul) =
    let name = Backends.ML.Syntax.mlpath_of_lident fmod_.name in
    fprint1 "OCaml skip: %s\n" fmod_.name.ident.idText;
    mlsig_of_sig (mk_mlenv name) fmod_.declarations |> ignore
    

(* -------------------------------------------------------------------- *)
let mllib_empty : mllib =
    MLLib []

(* -------------------------------------------------------------------- *)
let rec mllib_add (MLLib mllib) ((path : mlpath), sig_, mod_) =
    let n = String.concat "_" ((fst path)@[snd path]) in
    let rec aux = function
        | [] ->
            [n, Some (sig_, mod_), mllib_empty]
        | ((name, None, sublibs)) :: tl ->
            let the = (name,None,sublibs) in  (* Need to use "as" here, but it is currently unsupported by f* *)
            if name = snd path then begin
                (name, Some (sig_, mod_), sublibs) :: tl
            end else
                the :: (aux tl)
        | ((name, Some (ssig, mmod), sublibs)) :: tl ->
            let the = (name, Some(ssig,mmod),sublibs) in
            if name = snd path then begin
                (name, Some (ssig, mod_), sublibs) :: tl
            end else
                the :: (aux tl)

        in MLLib (aux mllib)
   

(*
    match fst path with
    | [] ->
        let rec aux = function
        | [] ->
            [snd path, Some (sig_, mod_), mllib_empty]
        | ((name, sigmod, sublibs) as the) :: tl ->
            if name = snd path then begin
                (name, Some (sig_, mod_), sublibs) :: tl
            end else
                the :: (aux tl)

        in MLLib (aux mllib)

    | x :: subns ->
        let subpath = (subns, snd path) in

        let rec aux = function
        | [] ->
            let sub = mllib_add mllib_empty (subpath, sig_, mod_) in
            [x, None, sub]
        | ((name, sigmod, sublibs) as the) :: tl ->
            if name = x then
                let aout = (name, sigmod, mllib_add sublibs (subpath, sig_, mod_)) in
                aout :: tl
            else
                the :: (aux tl)
                
        in MLLib (aux mllib)
*)
(* -------------------------------------------------------------------- *)
let mlmod_of_fstars (fmods : list<modul>) =
    let in_std_ns x = Util.for_some (fun y -> in_ns (y,x)) !Microsoft.FStar.Options.codegen_libs in
    let fmods = List.filter (fun x -> 
        Util.fprint1 "Extract module: %s\n" x.name.str;
        not (in_std_ns (List.map (fun y->y.idText) x.name.ns))) fmods in
    let stdlib = List.map (fun x -> Util.concat_l "." x) outmod in
    let extlib = List.map (fun x -> Util.concat_l "." x) !Microsoft.FStar.Options.codegen_libs in
    let fmods = List.filter (fun x -> not (List.contains x.name.str stdlib)) fmods in
    let fmods = List.choose (fun x -> if List.contains x.name.str extlib then (mlmod_of_iface x; None) else Some (mlmod_of_fstar x)) fmods in
    let for1 mllib the = 
        let (path, sig_, mod_) = the in
        let modname = (fst path) @ [snd path] in
        let rec checkname modname fbd =
            match modname, fbd with
            | _, [] -> true
            | (x1 :: t1), (x2 :: t2) when (x1 = x2) -> checkname t1 t2
            | _ -> false
        in

        let aout =
(*
            if List.filter (checkname ((fst path) @ [snd path])) outmod <> [] then (* want to use List.exists here, but "exists" is a keyword in f* *)
                mllib
            else
*)
                mllib_add mllib the
        in aout

    in List.fold_left for1 mllib_empty fmods
