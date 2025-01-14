(*--build-config
    options:--admit_fsi Set --admit_fsi Map;
    other-files:set.fsi heap.fst map.fsi list.fst
 --*)
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
module HyperHeap
open Map
open Heap
type rid = list int
type t = Map.t rid heap
new_effect STATE = STATE_h t
opaque val root : rid
let root = []

private type rref (id:rid) (a:Type) = Prims.ref a
val as_ref : #a:Type -> #id:rid -> r:rref id a -> GTot (ref a)
let as_ref id r = r

private val ref_as_rref : #a:Type -> i:rid -> r:ref a -> GTot (rref i a)
let ref_as_rref i r = r

val lemma_as_ref_inj: #a:Type -> #i:rid -> r:rref i a
    -> Lemma (requires (True))
             (ensures ((ref_as_rref i (as_ref r) = r)))
       [SMTPat (as_ref r)]
let lemma_as_ref_inj i r = ()

effect ST (a:Type) (pre:t -> Type) (post:t -> a -> t -> Type) =
       STATE a (fun 'p m0 -> pre m0 /\ (forall x m1. post m0 x m1 ==> 'p x m1))
               (fun 'p m0 ->  (forall x m1. pre m0 /\ post m0 x m1 ==> 'p x m1))

val includes : rid -> rid -> Tot bool
let rec includes r1 r2 =
  if r1=r2 then true
  else if List.length r2 > List.length r1
  then includes r1 (Cons.tl r2)
  else false

let disjoint (i:rid) (j:rid) =
  not (includes i j) && not (includes j i)

private val lemma_aux: k:rid -> i:rid
      -> Lemma  (requires
                    List.length k > 0
                    /\ List.length k <= List.length i
                    /\ includes k i
                    /\ not (includes (Cons.tl k) i))
                 (ensures False)
                 (decreases (List.length i))
let rec lemma_aux k i = lemma_aux k (Cons.tl i)

val lemma_disjoint_includes: i:rid -> j:rid -> k:rid ->
  Lemma (requires (disjoint i j /\ includes j k))
        (ensures (disjoint i k))
        (decreases (List.length k))
        [SMTPat (disjoint i j);
         SMTPat (includes j k)]
let rec lemma_disjoint_includes i j k =
  if List.length k <= List.length j
  then ()
  else (lemma_disjoint_includes i j (Cons.tl k);
        if List.length i <= List.length (Cons.tl k)
        then ()
        else (if includes k i
              then lemma_aux k i
              else ()))

val extends: rid -> rid -> Tot bool
let extends r0 r1 = is_Cons r0 && Cons.tl r0 = r1

val lemma_includes_refl: i:rid
                      -> Lemma (requires (True))
                               (ensures (includes i i))
                               [SMTPat (includes i i)]
let lemma_includes refl i = ()

val lemma_extends_includes: i:rid -> j:rid ->
  Lemma (requires (extends j i))
        (ensures (includes i j /\ not(includes j i)))
        [SMTPat (extends j i)]
let lemma_extends_includes i j = ()

val lemma_extends_disjoint: i:rid -> j:rid -> k:rid ->
    Lemma (requires (extends j i /\ extends k i /\ j<>k))
          (ensures (disjoint j k))
let lemma_extends_disjoint i j k = ()

let test0 = assert (includes [1;0] [2;1;0])
let test1 (r1:rid) (r2:rid{includes r1 r2}) = assert (includes r1 (0::r2))

type fresh_region (i:rid) (m0:t) (m1:t) =
 (forall j. includes i j ==> not (Map.contains m0 j))
 /\ Map.contains m1 i

let sel (#a:Type) (#i:rid) (m:t) (r:rref i a) = Heap.sel (Map.sel m i) (as_ref r)
let upd (#a:Type) (#i:rid) (m:t) (r:rref i a) (v:a) = Map.upd m i (Heap.upd (Map.sel m i) (as_ref r) v)

assume val new_region: r0:rid -> ST rid
      (requires (fun m -> True))
      (ensures (fun (m0:t) (r1:rid) (m1:t) ->
                           extends r1 r0
                        /\ fresh_region r1 m0 m1
                        /\ m1=Map.upd m0 r1 Heap.emp))

assume val ralloc: #a:Type -> i:rid -> init:a -> ST (rref i a)
    (requires (fun m -> True))
    (ensures (fun m0 x m1 ->
                    Let (Map.sel m0 i) (fun region_i ->
                    not (Heap.contains region_i (as_ref x))
                    /\ m1=Map.upd m0 i (Heap.upd region_i (as_ref x) init))))

assume val op_Colon_Equals: #a:Type -> #i:rid -> r:rref i a -> v:a -> ST unit
  (requires (fun m -> True))
  (ensures (fun m0 _u m1 -> m1=Map.upd m0 i (Heap.upd (Map.sel m0 i) (as_ref r) v)))

assume val op_Bang:#a:Type -> #i:rid -> r:rref i a -> ST a
  (requires (fun m -> True))
  (ensures (fun m0 x m1 -> m1=m0 /\ x=Heap.sel (Map.sel m0 i) (as_ref r)))

assume val get: unit -> ST t
  (requires (fun m -> True))
  (ensures (fun m0 x m1 -> m0=x /\ m1=m0))

assume val mod_set : Set.set rid -> Tot (Set.set rid)
assume Mod_set_def: forall (x:rid) (s:Set.set rid). {:pattern Set.mem x (mod_set s)}
                    Set.mem x (mod_set s) <==> (exists (y:rid). Set.mem y s /\ includes y x)

opaque logic type modifies (s:Set.set rid) (m0:t) (m1:t) =
  Map.Equal m1 (Map.concat m1 (Map.restrict (Set.complement (mod_set s)) m0))

val lemma_modifies_trans: m1:t -> m2:t -> m3:t
                       -> s1:Set.set rid -> s2:Set.set rid
                       -> Lemma (requires (modifies s1 m1 m2 /\ modifies s2 m2 m3))
                                (ensures (modifies (Set.union s1 s2) m1 m3))
let lemma_modifies_trans m1 m2 m3 s1 s2 = ()

assume val lemma_includes_trans: i:rid -> j:rid -> k:rid
                        -> Lemma (requires (includes i j /\ includes j k))
                                 (ensures (includes i k))
                                 [SMTPat (includes i j);
                                  SMTPat (includes j k)]
val lemma_modset: i:rid -> j:rid
                  -> Lemma (requires (includes j i))
                           (ensures (Set.subset (mod_set (Set.singleton i)) (mod_set (Set.singleton j))))
let lemma_modset i j = ()

val lemma_modifies_includes: m1:t -> m2:t
                       -> i:rid -> j:rid
                       -> Lemma (requires (modifies (Set.singleton i) m1 m2 /\ includes j i))
                                (ensures (modifies (Set.singleton j) m1 m2))
let lemma_modifies_includes m1 m2 s1 s2 = ()

val lemma_modifies_includes2: m1:t -> m2:t
                       -> s1:Set.set rid -> s2:Set.set rid
                       -> Lemma (requires (modifies s1 m1 m2 /\ (forall x. Set.mem x s1 ==> (exists y. Set.mem y s2 /\ includes y x))))
                                (ensures (modifies s2 m1 m2))
let lemma_modifies_includes2 m1 m2 s1 s2 = ()

type contains_ref (#a:Type) (#i:rid) (r:rref i a) (m:t) =
    Map.contains m i /\ Heap.contains (Map.sel m i) (as_ref r)

type fresh_rref (#a:Type) (#i:rid) (r:rref i a) (m0:t) (m1:t) =
  not (Heap.contains (Map.sel m0 i) (as_ref r))
  /\  (Heap.contains (Map.sel m1 i) (as_ref r))

kind STPost (a:Type) = a -> t -> Type
kind STWP (a:Type) = STPost a -> t -> Type

sub_effect
  DIV   ~> STATE = fun (a:Type) (wp:PureWP a) (p:STPost a) (h:t) -> wp (fun a -> p a h)

  (*opaque type modifies1 (s:Set.set rid) (m0:t) (m1:t) =
    (forall (id:rid). Map.contains m0 id ==> Map.contains m1 id)
    /\ (forall (id:rid).//{:pattern (Map.sel m1 id)}
              Map.contains m0 id
              /\ (forall (mod:rid). Set.mem mod s ==> not (includes mod id))
              ==> Map.sel m1 id = Map.sel m0 id)*)
