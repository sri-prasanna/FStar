(*
   Copyright 2008-2014 Nikhil Swamy and Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
#light "off"

module Microsoft.FStar.ToSMT.Term

open System.Diagnostics
open Microsoft.FStar
open Microsoft.FStar.Absyn.Syntax
open Microsoft.FStar.Absyn
open Microsoft.FStar.Util

let ssl (sl:string list) : string = String.concat "." sl
let string_of_bvd bvd = bvd.realname.idText

type sort =
  | Bool_sort 
  | Int_sort 
  | Kind_sort 
  | Type_sort 
  | Term_sort 
  | String_sort
  | Ref_sort
  | Array of sort * sort
  | Arrow of sort * sort
  | Ext of string
  
let rec strSort = function
  | Bool_sort  -> "Bool" 
  | Int_sort  -> "Int"
  | Kind_sort -> "Kind"
  | Type_sort -> "Type"
  | Term_sort -> "Term" 
  | String_sort -> "String"
  | Ref_sort -> "Ref"
  | Array(s1, s2) -> format2 "(Array %s %s)" (strSort s1) (strSort s2)
  | Arrow(s1, s2) -> format2 "(%s -> %s)" (strSort s1) (strSort s2)
  | Ext s -> s

type assumptionId =
  | ABindingVar    of int
  | ABindingMatch  of int
  | AName          of string

let strOfAssumptionId = function
  | ABindingVar i     -> format1 "ABindingVar %s" <| string_of_int i
  | ABindingMatch i   -> format1 "ABindingMatch %s" <| string_of_int i
  | AName s           -> s

type caption = string
type var = int
type withsort<'a> = {tm:'a; tmsort:sort}

type term' =
  | True
  | False
  | Funsym     of string
  | Integer    of int
  | BoundV     of int * sort * string 
  | FreeV      of string * sort
  | PP         of term * term
  | App        of string * sort * array<term>
  | Not        of term
  | And        of term * term
  | Or         of term * term
  | Imp        of term * term
  | Iff        of term * term
  | Eq         of term * term
  | LT         of term * term
  | LTE        of term * term
  | GT         of term * term
  | GTE        of term * term
  | Add        of term * term
  | Sub        of term * term
  | Div        of term * term
  | Mul        of term * term
  | Minus      of term
  | Mod        of term * term
  | IfThenElse of term * term * term * option<term>
  | Forall     of list<pat> * array<sort> * array<(either<btvdef,bvvdef> * termref)> * term 
  | Exists     of list<pat> * array<sort> * array<(either<btvdef,bvvdef> * termref)> * term 
  | Select     of term * term 
  | Update     of term * term * term
  | ConstArray of string * sort * term 
  | Cases      of list<term>
  | Function   of int * sort * term
and term   = withsort<term'>
and termref = ref<option<term>>
and pat = term

type binders = sort list
let rec fold_term (f:binders -> 'b -> term -> 'b) binders (b:'b) (t:term) : 'b = 
  let b = f binders b t in 
  match t.tm with 
    | Funsym _
    | True _
    | False _
    | Integer _
    | BoundV _
    | FreeV _ -> b
    | App(_, _, tms) -> Array.fold (fold_term f binders) b tms
    | ConstArray(_,_,t) 
    | Minus t
    | Not t -> fold_term f binders b t
    | PP(t1, t2) 
    | And(t1, t2)
    | Or(t1, t2)
    | Imp(t1, t2)
    | Iff(t1, t2)
    | Eq(t1, t2)
    | LT(t1, t2)
    | LTE(t1, t2)
    | GT(t1, t2)
    | GTE(t1, t2)
    | Add(t1, t2)
    | Sub(t1, t2)
    | Div(t1, t2)
    | Mul(t1, t2)
    | Mod(t1, t2) 
    | Select(t1, t2) -> List.fold_left (fold_term f binders) b [t1;t2]
    | IfThenElse(t1, t2, t3, None) 
    | Update(t1, t2, t3) -> List.fold_left (fold_term f binders) b [t1;t2;t3]
    | Forall(pats, binders', _, body) 
    | Exists(pats, binders', _, body) -> 
      let binders = binders@(List.ofArray binders') in 
      List.fold_left (fold_term f binders) b (pats@[body])
    | Cases tms -> 
      List.fold_left (fold_term f binders) b tms      
    | Function(_, sort, body) -> 
      fold_term f (binders@[sort]) b body

let free_bvars t = 
  let folder binders (bvars:list<(int * term)>) t = match t.tm with 
    | BoundV(i, _, _) -> 
      let level = i - List.length binders in 
      if level >= 0 && not (List.exists (fun (l', _) -> l'=level) bvars)
      then (level, t)::bvars
      else bvars
    | _ -> bvars in 
  fold_term folder [] [] t

let termref () = ref None
let asBool tm = {tm=tm; tmsort=Bool_sort}
let asInt tm = {tm=tm; tmsort=Int_sort}
let asType tm = {tm=tm; tmsort=Type_sort}
let asTerm tm = {tm=tm; tmsort=Term_sort}
let withSort s tm = {tm=tm; tmsort=s}
let asKind tm = {tm=tm; tmsort=Kind_sort}

let BoundV (i,j,x) = withSort j <| BoundV(i,j,x)
let True () = asBool True
let False () = asBool False
let Integer i = asInt <| Integer i
let PP (a,p) = withSort a.tmsort <| PP(a,p)
let FreeV (n,s) = withSort s <| FreeV(n,s)
let Not t = asBool <| Not t
let Function(x,s,t) = withSort (Arrow(s,t.tmsort)) <| Function(x,s,t)
let arrowSort result tms = List.fold_right (fun tm out -> Arrow(tm.tmsort, out)) tms result

#if CHECKED
let And(t1,t2) = 
  if t1.tmsort<>Bool_sort || t2.tmsort<>Bool_sort 
  then raise (Bad(spr "Expected bool sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| And(t1,t2)

let Or(t1,t2) = 
  if t1.tmsort<>Bool_sort || t2.tmsort<>Bool_sort 
  then raise (Bad(spr "Expected bool sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| Or(t1,t2) 
let Imp(t1,t2) = 
  if t1.tmsort<>Bool_sort || t2.tmsort<>Bool_sort 
  then raise (Bad(spr "Expected bool sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| Imp(t1,t2)
let Iff(t1,t2) =   
  if t1.tmsort<>Bool_sort || t2.tmsort<>Bool_sort 
  then raise (Bad(spr "Expected bool sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| Iff(t1,t2) 
let Eq(t1,t2) = 
  if t1.tmsort<>t2.tmsort
  then raise (Bad(spr "Expected equal sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| Eq(t1,t2)
let LT(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| LT(t1,t2)
let LTE(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| LTE(t1,t2)
let GT(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| GT(t1,t2)
let GTE(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asBool <| GTE(t1,t2)
let Minus(t1) = 
  if t1.tmsort<>Int_sort
  then raise (Bad(spr "Expected int sorts; got %A" t1.tmsort))
  else asInt <| Minus(t1)
let Add(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asInt <| Add(t1,t2)
let Sub(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asInt <| Sub(t1,t2)
let Mul(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asInt <| Mul(t1,t2)
let Div(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asInt <| Div(t1,t2)
let Mod(t1,t2) = 
  if t1.tmsort<>Int_sort || t2.tmsort<>Int_sort 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else asInt <| Mod(t1,t2)
let IfThenElse(t1,t2,t3,t4) = 
  if t1.tmsort<>Bool_sort || (t2.tmsort <> t3.tmsort) 
  then raise (Bad(spr "Expected int sorts; got %A,%A" t1.tmsort t2.tmsort))
  else withSort t3.tmsort <| IfThenElse(t1,t2,t3,t4)
let Forall(p,s,x,t) = 
  if t.tmsort <> Bool_sort
  then raise (Bad(spr "Expected bool sort; got %A" t.tmsort))
  else asBool <| Forall(p,s,x,t)
let Exists(p,s,x,t) = 
  if t.tmsort <> Bool_sort
  then raise (Bad(spr "Expected bool sort; got %A" t.tmsort))
  else asBool <| Exists(p,s,x,t)
let Update(t1,t2,t3) = 
  match t1.tmsort with
    | Array(s1,s2) when t2.tmsort=s1 && t3.tmsort=s2 -> 
        withSort t1.tmsort <| Update(t1,t2,t3)
    | _ -> raise (Bad(spr "Ill-sorted update term: %A, %A, %A" t1.tmsort t2.tmsort t3.tmsort))
let ConstArray(n,s,t) = withSort (Array(s,t.tmsort)) <| ConstArray(n,s,t)
let Cases tl = 
  List.iter (fun t -> if t.tmsort <> Bool_sort then raise (Bad (spr "Expected Bool_sort in cases; got %A;\n %s\n" t.tmsort (t.ToString()))) else ()) tl;
  asBool <| Cases tl

let Application(t1,t2) = match t1.tmsort with
    | Arrow(s1, s2) when s1=t2.tmsort -> withSort s2 <| Application(t1,t2)
    | _ -> raise (Bad(spr "Expected sort Arrow(%A,_) got %A" t2.tmsort t1.tmsort))
let Appl(f,s,tms) = 
  let sort  = tms |> List.fold_left (fun out {tmsort=s} -> match out with 
                        | Arrow(s1, out) when s1=s -> out
                        | _ -> raise (Bad(spr "Expected sort Arrow(%A, _); got %A" s out))) s  in
    withSort sort <| App(f,s,Array.ofList tms)
let App(f,s,tms) =
   let sort  = (List.ofArray tms) |> List.fold_left (fun out {tmsort=s} -> match out with 
                        | Arrow(s1, out) when s1=s -> out
                        | _ -> raise (Bad(spr "Expected sort Arrow(%A, _); got %A" s out))) s  in
    withSort sort <| App(f,s,tms)
let Select(t1,t2) = match t1.tmsort with 
    | Array(s1,s2) when s1=t2.tmsort -> withSort s2 <| Select(t1,t2)
    | _ -> raise (Bad(spr "Expected sort Arrary(%A, _); got %A" t2.tmsort t1.tmsort))
#else
let unsort = Ext "Un"
let withSort' x = withSort unsort x
let And(t1,t2) = withSort' <| And(t1,t2)
let Or(t1,t2) =  withSort' <| Or(t1,t2) 
let Imp(t1,t2) = withSort' <| Imp(t1,t2)
let Iff(t1,t2) = withSort' <| Iff(t1,t2) 
let Eq(t1,t2) = withSort' <| Eq(t1,t2)
let LT(t1,t2) = withSort' <| LT(t1,t2)
let LTE(t1,t2) = withSort' <| LTE(t1,t2)
let GT(t1,t2) =  withSort' <| GT(t1,t2)
let GTE(t1,t2) = withSort' <| GTE(t1,t2)
let Minus(t1) = withSort' <| Minus(t1)
let Add(t1,t2) = withSort' <| Add(t1,t2)
let Sub(t1,t2) = withSort' <| Sub(t1,t2)
let Mul(t1,t2) = withSort' <| Mul(t1,t2)
let Div(t1,t2) = withSort' <| Div(t1,t2)
let Mod(t1,t2) = withSort' <| Mod(t1,t2)
let IfThenElse(t1,t2,t3,t4) = withSort' <| IfThenElse(t1,t2,t3,t4)
let Forall(p,s,x,t) = withSort' <| Forall(p,s,x,t)
let Exists(p,s,x,t) = withSort' <| Exists(p,s,x,t)
let Update(t1,t2,t3) = withSort' <| Update(t1,t2,t3)
let ConstArray(n,s,t) = withSort' <| ConstArray(n,s,t)
let Cases tl = withSort' <| Cases tl
let Appl(f,s,tms) = withSort' <| App(f,s,Array.ofList tms)
let App(f,s,tms) = withSort' <| App(f,s,tms)
let Select(t1,t2) = withSort' <| Select(t1,t2)
#endif

type constr = {cname:string;
               tester:string;
               projectors:list<string>;
               sorts:list<either<sort, string>>;
               recindexes:list<uint32>}
type decl =
  | DefPrelude of string
  | DefData    of list<(string * list<constr>)>
  | DefSort    of sort   * option<caption>
  | DefPred    of string * array<sort> * option<caption>
  | DeclFun    of string * array<sort> * sort * option<caption>
  | DefineFun  of string * (string * sort) array * sort * term * option<caption>
  | Assume     of term   * option<caption> * assumptionId
  | Query      of term
  | Comment    of caption
  | Echo       of string
  | Eval       of term
type decls = list<decl>

let rec termEq (x:term) (y:term) =
  match x.tm, y.tm with 
    | PP(a, _), _ -> termEq a y
    | _, PP(b, _) -> termEq x b
    | Funsym s, Funsym t -> s=t
    | True, True
    | False, False -> true
    | Integer i, Integer j -> i=j
    | BoundV(i, s, _), BoundV(j, t, _) -> i=j  && s=t
    | FreeV(x,s), FreeV(y,t) -> x=y && s=t
    | App(f,_,tl), App(g,_,sl) when tl.Length=sl.Length ->
        f=g && (Array.forall2 termEq tl sl)
    | Minus(t), Minus(s)
    | Not(t), Not(s) -> termEq t (s)
    | And(t1,t2), And(s1,s2)
    | Imp(t1,t2), Imp(s1,s2)
    | Iff(t1,t2), Iff(s1,s2)
    | Or(t1,t2), Or(s1,s2)
    | Eq(t1,t2), Eq(s1,s2)
    | LT(t1,t2), LT(s1,s2)
    | GT(t1,t2), GT(s1,s2)
    | GTE(t1,t2), GTE(s1,s2) 
    | Add(t1,t2), Add(s1,s2) 
    | Sub(t1,t2), Sub(s1,s2) 
    | Mul(t1,t2), Mul(s1,s2) 
    | Div(t1,t2), Div(s1,s2) 
    | Mod(t1,t2), Mod(s1,s2) 
    | Select(t1,t2), Select(s1,s2) -> termEq t1 (s1) && termEq t2 (s2)
    | Update(t1,t2,t3), Update(s1,s2,s3)
    | IfThenElse(t1, t2, t3, _), IfThenElse(s1, s2, s3, _) ->
        termEq t1 (s1) && termEq t2 (s2) && termEq t3 (s3)
    | Forall(pl, sorts, _, t), Forall(ql, sorts', _, s) 
    | Exists(pl, sorts, _, t), Forall(ql, sorts', _, s) -> 
        (List.forall2 termEq pl ql) &&
          sorts=sorts' &&
        termEq t (s)
    | ConstArray(str, sort, t), ConstArray(str', sort', s) -> 
        termEq t (s) && str=str' && sort=sort'
    | Cases(tl), Cases(sl) when tl.Length=sl.Length -> 
        List.forall2 termEq tl sl
    | Function(x, _, t1), Function(y,_,t2) -> termEq t1 t2 && x=y
    | _ -> false


let incrBoundV increment tm = 
  let rec aux ix tm = match tm.tm with 
    | True
    | False
    | Integer _ 
    | FreeV _ -> tm
    | BoundV(i,s,xopt) -> 
      if i >= ix then BoundV(i+increment, s, xopt) else tm
    | App(s,sort, tms) -> App(s, sort, Array.map (aux ix) tms)
    | Minus tm -> Minus (aux ix tm)
    | Not tm -> Not (aux ix tm)
    | PP(a,p) -> PP(aux ix a, aux ix p)
    | And(t1,t2) -> And(aux ix t1, aux ix t2)
    | Or(t1,t2) -> Or(aux ix t1, aux ix t2)
    | Imp(t1,t2) -> Imp(aux ix t1, aux ix t2)
    | Iff(t1,t2) -> Iff(aux ix t1, aux ix t2)
    | Eq(t1,t2) -> Eq(aux ix t1, aux ix t2)
    | LT(t1,t2) -> LT(aux ix t1, aux ix t2)
    | GT(t1,t2) -> GT(aux ix t1, aux ix t2)
    | LTE(t1,t2) -> LTE(aux ix t1, aux ix t2)
    | GTE(t1,t2) -> GTE(aux ix t1, aux ix t2)
    | Add(t1,t2) -> Add(aux ix t1, aux ix t2)
    | Sub(t1,t2) -> Sub(aux ix t1, aux ix t2)
    | Mul(t1,t2) -> Mul(aux ix t1, aux ix t2)
    | Div(t1,t2) -> Div(aux ix t1, aux ix t2)
    | Mod(t1,t2) -> Mod(aux ix t1, aux ix t2)
    | Select(t1, t2) -> Select(aux ix t1, aux ix t2) 
    | Update(t1, t2, t3) -> Update(aux ix t1, aux ix t2, aux ix t3)
    | IfThenElse(t1, t2, t3, None) ->  
        IfThenElse(aux ix t1, aux ix t2, aux ix t3, None)
    | IfThenElse(t1, t2, t3, Some t4) ->  
        IfThenElse(aux ix t1, aux ix t2, aux ix t3, Some (aux ix t4))
    | Forall(pats, sorts, names, tm) ->
        let ix = ix + Array.length sorts in 
          Forall(List.map (aux ix) pats, sorts, names, aux ix tm)
    | Exists(pats, sorts, names, tm) ->
        let ix = ix + Array.length sorts in 
          Exists(List.map (aux ix) pats, sorts, names, aux ix tm)
    | ConstArray(s, t, tm) -> ConstArray(s, t, aux ix tm)
    | Cases tl -> Cases (List.map (aux ix) tl)
    | Function(x,s,tm) -> Function(x, s, aux ix tm)
  in aux 0 tm

let flatten_forall fa =  
  let rec aux (binders, pats) = fun tm -> match tm.tm with 
    | Imp(guard, {tm=Forall(pats', sorts, names, body)}) -> 
        let guard = incrBoundV (sorts.Length) guard in 
          aux ((sorts, names)::binders, pats'@pats) (Imp(guard, body))
    | Forall (pats', sorts, names, body) -> 
        aux ((sorts, names)::binders, pats'@pats) body
    | _ -> 
        let sorts, names = List.unzip (List.rev binders) in
        let pats = List.rev pats in
          Forall(pats, Array.concat sorts, Array.concat names, tm) in
    aux ([],[]) fa

let flatten_exists ex = 
  let rec aux (binders, pats) = fun tm -> match tm.tm with
    | Exists (pats', sorts, names, body) -> 
        aux ((sorts, names)::binders, pats'@pats) body
    | _ -> 
        let sorts, names = List.unzip (List.rev binders) in
        let pats = List.rev pats in
          Exists(pats, Array.concat sorts, Array.concat names, tm) in
    aux ([],[]) ex  

let flatten_imp tm = 
  let mkAnd terms = match terms with 
    | [] -> raise Impos
    | hd::tl ->  List.fold_left (fun out term -> And(out, term)) hd tl in
  let rec aux out = fun tm -> match tm.tm with
    | Imp(x, y) -> aux (x::out) y
    | _ -> Imp(mkAnd (List.rev out), tm) in
    aux [] tm

let flatten_arrow = fun q -> match q.tm with 
  | Forall _ -> flatten_forall q
  | Exists _ -> flatten_exists q
  | Imp _ -> flatten_imp q
  | _ -> q
      
let flatten_and tm =
  let rec aux out = fun tm -> match tm.tm with 
    | And(x, y) -> 
        let out = aux out x in 
          aux out y
    | _ -> tm::out in
    List.rev (aux [] tm)
      
let flatten_or tm = 
  let rec aux out = fun tm -> match tm.tm with 
    | Or(x, y) -> 
        let out = aux out x in 
          aux out y
    | _ -> tm::out in
    List.rev (aux [] tm)


(*****************************************************)
(* Pretty printing terms and decls in SMT Lib format *)
(*****************************************************)
type info          = { binders: list<either<btvdef,bvvdef>>; pp_name_map:smap<string>}
let init_info z3 m = { binders = []; pp_name_map=m }

let map_pp info f = 
  if !Options.print_real_names 
  then f
  else match Util.smap_try_find info.pp_name_map f with 
    | Some g -> g
    | _ -> f 

let string_of_either_bvd = function
  | Inl x -> Print.strBvd x
  | Inr x -> Print.strBvd x

let rec termToSmt (info:info) tm = 
  let tm = flatten_arrow tm in
  match tm.tm with
  | True          -> "true"
  | False         -> "false"
  | Integer i     -> 
    if i < 0 then Util.format1 "(- %d)" (string_of_int -i) 
    else string_of_int i
  | PP(_,q) -> 
    termToSmt info q
  | BoundV(i,_,_) as tm  -> 
    if (i < List.length info.binders) 
    then string_of_either_bvd (List.nth info.binders i)
    else failwith "Bad index for bound variable in formula" 
  | FreeV(x,_)    -> map_pp info x 
  | App(f,_,es) when (es.Length=0) -> map_pp info f
  | App(f,_, es)     -> 
    let f = map_pp info f in
    let a = Array.map (termToSmt info) es in
    let s = String.concat " " (Array.to_list a) in
    format2 "(%s %s)" f s
  | Not(x) -> 
    format1 "(not %s)" (termToSmt info x)
  | And(x,y) -> 
    format1 "(and %s)" (String.concat "\n" (List.map (termToSmt info) (flatten_and tm)))
  | Or(x,y) -> 
    format1 "(or %s)" (String.concat "\n" (List.map (termToSmt info) (flatten_or tm)))
  | Imp(x,y) -> 
    format2 "(implies %s\n %s)"(termToSmt info x)(termToSmt info y)
  | Iff(x,y) -> 
    format2 "(iff %s\n %s)" (termToSmt info x) (termToSmt info y)
  | Eq(x,y) -> 
    format2 "(= %s\n %s)" (termToSmt info x) (termToSmt info y)
  | LT(x,y) -> 
    format2 "(< %s %s)" (termToSmt info x) (termToSmt info y)
  | GT(x,y) -> 
    format2 "(> %s %s)" (termToSmt info x) (termToSmt info y)
  | LTE(x,y) -> 
    format2 "(<= %s %s)" (termToSmt info x) (termToSmt info y)
  | GTE(x,y) -> 
    format2 "(>= %s %s)" (termToSmt info x) (termToSmt info y)
  | Minus(t1) -> 
    format1 "(- %s)" (termToSmt info t1)
  | Add(t1,t2) -> 
    format2 "(+ %s\n %s)" (termToSmt info t1) (termToSmt info t2)
  | Sub(t1,t2) -> 
    format2 "(- %s\n %s)" (termToSmt info t1) (termToSmt info t2)
  | Mul(t1,t2) -> 
    format2 "(* %s\n %s)" (termToSmt info t1) (termToSmt info t2)
  | Div(t1,t2) -> 
    format2 "(div %s\n %s)" (termToSmt info t1) (termToSmt info t2)
  | Mod(t1,t2) -> 
    format2 "(mod %s\n %s)" (termToSmt info t1) (termToSmt info t2)
  | Select(h,l) -> 
    format2 "(select %s %s)" (termToSmt info h) (termToSmt info l)
  | Update(h,l,v) -> 
    format3 "(store %s %s %s)" (termToSmt info h) (termToSmt info l) (termToSmt info v)
  | IfThenElse(_, _, _, Some t4) -> 
    termToSmt info t4
  | IfThenElse(t1, t2, t3, _) -> 
    format3 "(ite %s %s %s)" (termToSmt info t1) (termToSmt info t2) (termToSmt info t3)
  | Cases tms -> 
    format1 "(and %s)" (String.concat " " (List.map (termToSmt info) tms))
  | Forall(pats,x,y,z)
  | Exists(pats,x,y,z) as q -> 
      if Array.length x <> Array.length y 
      then failwith "Unequal number of bound variables and their sorts"
      else
        let s = String.concat " "
          (Array.map (fun (a,b) -> format2 "(%s %s)" (string_of_either_bvd <| fst a) (strSort b))
             (Array.zip y x)) in
        let binders' = (List.rev (Array.to_list (Array.map fst y))) @ info.binders in
        let info' = { info with binders=binders' } in
          format3 "\n\n(%s (%s)\n\n %s)" (strQuant q) s
            (if pats.Length <> 0 
             then format2 "(! %s\n %s)" (termToSmt info' z) (patsToSmt info' pats)
             else termToSmt info' z)
  | ConstArray(s, _, tm) -> 
    format2 "((as const %s) %s)" s (termToSmt info tm)
  | _ -> 
    failwith "Unexpected term form"

and strQuant = function 
  | Forall _ -> "forall"
  | Exists _ -> "exists" 
  | _ -> raise Impos

and patsToSmt info  = function 
  | [] -> ""
  | pats -> format1 "\n:pattern (%s)" (String.concat " " (List.map (fun p -> format1 "%s" (termToSmt info p)) pats))
    
let strOfStrOpt = function Some x -> x | _ -> ""

let declToSmt info decl = match decl with
  | DefPrelude p -> p
  | DefSort(tiio, msg_opt) -> 
    format2 "\n(declare-sort %s) ; %s" (strSort tiio) (strOfStrOpt msg_opt)
  | Query(t) -> 
    format1 "\n(assert (not %s)) \n (check-sat)" (termToSmt info t)
  | Comment(c) -> 
    format1 "\n; %s" c
  | DefPred(f,sorts,_) ->
    let f = map_pp info f in 
    let l = Array.to_list (Array.map strSort sorts) in
    format2 "\n(declare-fun %s (%s) Bool)" f (String.concat " " l)
  | DefData dts -> 
    format1 "(declare-datatypes () (%s))"
      (String.concat "\n" <|
         (dts |> List.map (fun (d, constrs) -> 
                     let constrs = constrs |> List.map 
                         (fun c -> 
                           let cargs = List.map2 
                            (fun pname sort -> match sort with 
                               | Inl s -> format2 "(%s %s)" pname (strSort s)
                               | Inr s -> format2 "(%s %s)" pname s)
                            c.projectors c.sorts in 
                           let cargs = String.concat " " cargs in 
                             format2 "(%s %s)" c.cname cargs) in
                       format2 "(%s %s)" d (String.concat "\n" constrs))))

  | DeclFun(f,argsorts,retsort,_) ->
    let f = map_pp info f in  
    let l = Array.to_list (Array.map strSort argsorts) in
    format3 "(declare-fun %s (%s) %s)" f (String.concat " " l) (strSort retsort)
  | DefineFun(f,args,retsort,body,_) ->
    let f = map_pp info f in  
    let l = Array.to_list (Array.map (fun (nm,s) -> format2 "(%s %s)" nm (strSort s)) args) in
    let info = args |> List.ofArray |> List.fold_left 
        (fun info (x,s) -> let x = mk_ident(x,dummyRange) in {info with binders=(Inl (Util.mkbvd (x,x)))::info.binders})
        info  in
    format4 "(define-fun %s (%s) %s\n %s)" f (String.concat " " l) (strSort retsort) (termToSmt info body)
  | Assume(t,co,aid) ->
    let s = strOfAssumptionId aid in
    let c = match co with 
      | Some c -> format2 ";;;;;;;;;;; %s (aid %s)\n" c s
      | None -> format1 ";;;;;;;;;;; (aid %s)\n" s in
    format2 "%s (assert %s)" c (termToSmt info t)
  | Echo s -> format1 "(echo \"%s\")" s
  | Eval t -> format1 "(eval %s)" (termToSmt info t)

(****************************************************************************)
(* Z3 Specifics                                                             *)
(****************************************************************************)
let ini_params = 
  format1 "%s \
       AUTO_CONFIG=false \
       MBQI=false \
       MODEL=true \
       MODEL_ON_TIMEOUT=true \
       RELEVANCY=2 \
       ARRAY_DELAY_EXP_AXIOM=false \
       ARRAY_EXTENSIONAL=false" (match !Options.z3timeout with None -> "" | Some s -> format1 "/T:%s" (string_of_int <| (int_of_string s) / 1000))

type z3status = 
    | SAT 
    | UNSAT 
    | UNKNOWN 
    | TIMEOUT

let status_to_string = function
    | SAT  -> "sat"
    | UNSAT -> "unsat"
    | UNKNOWN -> "unknown"
    | TIMEOUT -> "timeout"
    
let doZ3Exe ini_params (input:string) = 
  let parse (z3out:string) = 
    let lines = List.ofArray (z3out.Split([|'\n'|])) |> List.map (fun l -> l.Trim()) in 
    let rec lblnegs lines = match lines with 
      | lname::"false"::rest -> lname::lblnegs rest
      | lname::_::rest -> lblnegs rest
      | _ -> [] in
    let rec result = function
      | "timeout"::tl -> TIMEOUT, []
      | "unknown"::tl -> UNKNOWN, lblnegs tl
      | "sat"::tl -> SAT, lblnegs tl
      | "unsat"::tl -> UNSAT, []
      | _::tl -> result tl 
      | _ -> failwith <| format1 "Got output lines: %s\n" (String.concat "\n" (List.map (fun (l:string) -> format1 "<%s>" (l.Trim())) lines)) in
      result lines in
  let cmdargs = format1 "%s /in" ini_params in 
  let result, stdout, stderr = Util.run_proc "z3.exe" cmdargs input in    
  let x = String.trim in
  if result 
  then let status, lblnegs = parse (Util.trim_string stdout) in
       status, lblnegs, cmdargs
  else failwith (format1 "Z3 returned an error: %s\n" stderr)
      
let callZ3Exe info (theory:decls) labels = 
  let theory = labels |> List.fold_left (fun decls (lname, t) -> decls@[Echo lname; Eval t]) theory in
  let input = List.map (declToSmt info) theory |> String.concat "\n" in
  let rec proc_result again (status, lblnegs, cmdargs) = 
    match status with 
      | UNSAT -> true
      | _ -> 
          print_string <| format2 "Called z3.exe %s\nZ3 says: %s\n" cmdargs (status_to_string status);
          match status with 
            | UNKNOWN -> 
                if again
                then proc_result false (doZ3Exe (ini_params ^ " MBQI=true") input)
                else (print_string <| format1 "Failing assertions: %s\n" (String.concat "\n\t" lblnegs); false)
            | _ -> 
                print_string <| format1 "Failing assertions: %s\n" (String.concat "\n\t" lblnegs);
                false in 
    proc_result true (doZ3Exe ini_params input)

//(* Builders ... lifted from basic.fs *)
//let btvName =  "Typ_btvar"
//let btvInv =  "Typ_btvar_inv"
//let mk_Typ_btvar i = App(btvName, Arrow(Int_sort, Type_sort), [| Integer i |])
//let mk_Typ_btvar_term t = App(btvName, Arrow(Int_sort, Type_sort), [| t |])
//let mkBtvInv t = App(btvInv, Arrow(Type_sort, Int_sort), [| t |])
//
//let bvName =  "Exp_bvar"
//let bvInv =  "Exp_bvar_proj_0"
//let mk_Exp_bvar i = App(bvName, Arrow(Int_sort, Term_sort), [| Integer i |])
//let mk_Exp_bvar_term t = App(bvName, Arrow(Int_sort, Term_sort), [| t |])
//let mkBvInv t = App(bvInv, Arrow(Term_sort, Int_sort), [| t|])
//
//let mkTerm name = FreeV(name, Term_sort)
//let mkType name = FreeV(name, Type_sort)
////let mkApp term terms = App(term, Array.ofList terms)
//let mkAnd (terms:list<term<'a>>) : term<'a> = match terms with 
//  | [] -> raise Impos
//  | hd::tl ->  List.fold_left (fun out term -> And(out, term)) hd tl
//let mkOr terms = match terms with 
//  | [] -> raise Impos
//  | hd::tl ->  List.fold_left (fun out term -> Or(out, term)) hd tl
//let check_pat_vars r pats sorts = 
//  if List.length pats = 0 
//  then ()
//  else 
//    let bvars = List.collect free_bvars pats in 
//    sorts |> List.iteri (fun i sort -> 
//      if not (List.exists (fun (i',_) -> i=i') bvars)
//      then raise (Error(spr "Pattern does not include bound variable %d of sort %A\n%s" i sort 
//                          (String.concat "; " (List.map (fun t -> t.ToString()) pats)), r)))
//let mkPatsForall r pats sorts names guard_opt body = 
//  check_pat_vars r pats sorts;
//  let body = match guard_opt with 
//    | Some tm -> Imp(tm,body)
//    | _ -> body in 
//   Forall(pats, Array.ofList sorts, Array.ofList names, body)
//let mkForall sorts names guard_opt body : term<'a> = 
//  mkPatsForall dummyRange [] sorts names guard_opt body
//let mkPatsExists r pats sorts names guard_opt body = 
//  check_pat_vars r pats sorts;
//  let body = match guard_opt with 
//    | Some tm -> And(tm,body)
//    | _ -> body in 
//    Exists(pats, Array.ofList sorts, Array.ofList names, body)
//let mkExists sorts names guard_opt body = 
//  mkPatsExists dummyRange [] sorts names guard_opt body 
//let mkFunSym name argSorts sort = DeclFun(name, Array.ofList argSorts, sort, None)
//let mkConstant name sort = DeclFun(name, [| |], sort, None)
//let mkPred name argSorts = DefPred(name, Array.ofList argSorts, None)
//let mkAssumption name phi = 
//  let n = spr "assumption::%s" name in 
//    Assume(phi, None, AName n)
//let funPPNameOfBvar bv = spr "Term_%s" ((bvar_ppname bv).idText)
//
//(* let funNameOfBvar bv = spr "Term_fvarold_%s" ((bvar_real_name bv).idText) *)
//(* let funNameOfBvdef bvd sfx = spr "Term_fvarold_%s__%d" (string_of_bvd bvd) sfx *)
//(* let funNameOfLid lid =  *)
//(*   spr "Term_fvarold_%s"  *)
//(*     (if Const.is_tuple_data_lid lid *)
//(*      then Pretty.str_of_lident Const.tuple_UU_lid *)
//(*      else Sugar.text_of_lid lid) *)
//
//let cleanString b = 
//  let chars = Util.unicodeEncoding.GetChars(b) in
//  if chars |> Array.forall (fun c -> System.Char.IsDigit(c) || System.Char.IsLetter(c) || c='_')
//  then new System.String(chars)
//  else System.Convert.ToBase64String(b)
//    
//let clean_id (str:string) = str.Replace("'", "/") (* / is a valid identifier char in smt2 but not '; vice versa for F* *)
//let invName str ix = spr "%s_proj_%d" str ix
//let predNameOfLid lid = spr "Pred_%s" (clean_id (Sugar.text_of_lid lid))
//let typePPNameOfBvar bv = spr "Type_%s" (clean_id ((bvar_ppname bv).idText))
//let typeNameOfUvar uv = spr "Type_uv_%d" (Unionfind.uvar_id uv)
//let typeNameOfBtvar btv = spr "Type_%s" (clean_id ((bvar_real_name btv).idText))
//let typeNameOfBvdef bvd sfx = spr "Type_%s__%d" (clean_id (string_of_bvd bvd)) sfx
//let typeNameOfLid lid = spr "Type_name_%s" (clean_id (Sugar.text_of_lid lid))
//let recordConstrName lid = spr "Term_constr_make_%s" (clean_id (Sugar.text_of_lid lid))
//let recordConstrLid lid = asLid [ident(spr "make_%s" (Sugar.text_of_lid lid), 0L)]
//let arrConstrName lid = spr "Term_arr_%s" (clean_id (Sugar.text_of_lid lid))
//
//let funNameOfBvar bv = spr "Term_bvar_%s" (clean_id ((bvar_real_name bv).idText))
//let funNameOfBvdef bvd  = spr "Term_bvar_%s" (clean_id (string_of_bvd bvd) )
//let funNameOfBvdef_sfx bvd sfx  = spr "Term_bvar_%s_%d" (clean_id (string_of_bvd bvd)) sfx
//let funNameOfFvar lid = 
//  spr "Term_fvar_%s" 
//    (if Const.is_tuple_data_lid lid
//     then Pretty.str_of_lident Const.tuple_UU_lid
//     else clean_id (Sugar.text_of_lid lid))
//let funNameOfConstr lid = 
//  spr "Term_constr_%s" 
//    (if Const.is_tuple_data_lid lid
//     then Pretty.str_of_lident Const.tuple_UU_lid
//     else clean_id (Sugar.text_of_lid lid))
//    
//let tfunNameOfLid lid = 
//  spr "Type_fun_%s" (clean_id (Sugar.text_of_lid lid))
//
//open KindAbbrevs
//let mkEq env e1 e2 = 
//  let eqK = Tcenv.lookup_typ_lid env Const.eq_lid in 
//  let eqT = twithsort (Typ_const(twithsort Const.eq_lid eqK, None)) eqK in 
//    setsort (AbsynUtils.mkTypApp eqT [AbsynUtils.unrefine e1.sort] [e1;e2]) Kind_erasable 
//
//
//let destruct tenv typ lid = 
//  match AbsynUtils.flattenTypAppsAndDeps (AbsynUtils.strip_pf_typ typ) with 
//    | {v=Typ_const(tc,_)}, args when Sugar.lid_equals tc.v lid -> Some args
//    | _ -> None
//
//let rec norm tcenv t = 
//  let t = 
//    if AbsynUtils.is_pf_typ t 
//    then norm tcenv (AbsynUtils.strip_pf_typ t)
//    else t in
//    alpha_convert <| Tcutil.reduce_typ_delta_beta tcenv t
//