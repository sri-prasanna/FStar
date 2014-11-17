module RBTree

(*
 * Red black trees, and verification of Okasaki's insertion algorithm
 * (https://wiki.rice.edu/confluence/download/attachments/2761212/Okasaki-Red-Black.pdf)
 *)

(* color: Red or Black *)
type color =
  | R
  | B

(*
 * tree data type
 * either empty (E), or a node with a color, left child, key, and a right child
 *)
type rbtree' =
  | E
  | T: col:color -> left:rbtree' -> key:nat -> right:rbtree' -> rbtree'

val color_of: t:rbtree' -> Tot color
let color_of t = match t with
  | E -> B
  | T c _ _ _ -> c

(*
 * this calculates the black height of the tree
 * ensures that black height of all the leaves is same
 * if not, returns None, else returns the black height
 *)
val black_height: t:rbtree' -> Tot (option nat)
let rec black_height t = match t with
  | E -> Some 0
  | T c a _ b ->
    (*
     * TODO: ideally we should be able to write match (black_height a, black_height b)
     *)
    let hha = black_height a in
    let hhb = black_height b in
    match (hha, hhb) with
      | Some ha, Some hb ->
	if ha = hb then
	  if c = R then Some ha else Some (ha + 1)
	else
	  None
      | _, _ -> None

(* returns the minimum element in a T tree (E tree has no element) *)
val min_elt: t:rbtree' -> Pure nat (requires (is_T t)) (ensures (fun r -> True))
let rec min_elt (T _ a x _) = match a with
  | E -> x
  | _ -> min_elt a

(* returns the maximum element in a T tree *)
val max_elt: t:rbtree' -> Pure nat (requires (is_T t)) (ensures (fun r -> True))
let rec max_elt (T _ _ x b) = match b with
  | E -> x
  | _ -> max_elt b

(*
 * in a red black tree, root of the tree must be black
 *)
val r_inv: t:rbtree' -> Tot bool
let r_inv t = color_of t = B

(*
 * in a red black tree, every red node must have black children
 *)
val c_inv: t:rbtree' -> Tot bool
let rec c_inv t = match t with
  | E -> true
  | T R a _ b -> color_of a = B && color_of b = B && c_inv a && c_inv b
  | T B a _ b -> c_inv a && c_inv b

(*
 * in a red black tree, black height of every leaf must be same
 *)
val h_inv: t:rbtree' -> Tot bool
let h_inv t = is_Some (black_height t)

(*
 * finally, this is the binary search tree invariant
 * i.e. all elements in the left subtree are smaller than the root key
 * and all elements in the right subtree are greater than the root key
 *)
val k_inv: t:rbtree' -> Tot bool
let rec k_inv t = match t with
  | E -> true
  | T _ E x E -> true
  | T _ E x b  ->
    let b_min = min_elt b in
    k_inv b && b_min > x
  | T _ a x E ->
    let a_max = max_elt a in
    k_inv a && x > a_max
  | T _ a x b ->
    let a_max = max_elt a in
    let b_min = min_elt b in
    k_inv a && k_inv b && x > a_max && b_min > x

(*
 * Okasaki's insertion algorithm inserts the element at its bst place
 * in a red node, and then uses a balance function to re-establish
 * the red black tree invariants.
 * 
 * not_c_inv represents violation of c_inv property, i.e. when a red node
 * may have a red child either on left branch or right branch.
 *)
type not_c_inv (t:rbtree') =
    (is_T t) /\ (T.col t = R) /\ (((is_T (T.left t) /\ T.col (T.left t) = R)) \/
                                  ((is_T (T.right t) /\ T.col (T.right t) = R)))

(*
 * in Okasaki's algorithm the re-establishment of invariants takes place
 * bottom up, meaning although the invariants may be violated at top,
 * the subtrees still satisfy c_inv.
 *)
type lr_c_inv (t:rbtree') = is_T t /\ c_inv (T.left t) /\ c_inv (T.right t)

(*
 * this is the predicate satisfied by a tree before call to balance
 *)
type pre_balance (c:color) (lt:rbtree') (ky:nat) (rt:rbtree') =
    (* 
     * lt satisfies k_inv, rt satisfies k_inv, and key is a candidate root key for
     * a tree with lt as left branch and rt as right.
     *)
    (
    k_inv lt /\ k_inv rt /\
    (is_E lt \/ (is_T lt /\ ky > (max_elt lt))) /\
    (is_E rt \/ (is_T rt /\ (min_elt rt) > ky))
    )

    /\
    
    (*
     * lt and rt satisfy h_inv, moreover, their black heights is same.
     * the second condition ensures that if resulting tree has (lt k rt), it
     * satisfies h_inv
     *)
    (h_inv lt /\ h_inv rt /\ Some.v (black_height lt) = Some.v (black_height rt))

    /\

    (*
     * either lt and rt satisfy c_inv (in which case c can be R or B)
     * or if they don't satisfy c_inv, c has to be B. this is a property
     * ensures by Okasaki's algorithm. Following is basically a formula for
     * cases in Fig. 1 of Okasaki's paper.
     *)

    (
    (c = B /\ not_c_inv lt /\ lr_c_inv lt /\ c_inv rt) \/
    (c = B /\ not_c_inv rt /\ lr_c_inv rt /\ c_inv lt) \/
    (c_inv lt /\ c_inv rt)
    )

(*
 * balance function
 * similar to pre_balance, post condition specifies invariants for
 * k_inv, h_inv, and c_inv
 *)
val balance: c:color -> lt:rbtree' -> ky:nat -> rt:rbtree' ->
             Pure rbtree'
             (requires (pre_balance c lt ky rt))
	     (ensures (fun r ->
	      (* TODO: this should come from requires *)
	      is_Some (black_height lt) /\
              
	      (* returned tree is a T tree *)
	      (is_T r) /\
	       
	      (*
	       * returned tree satisfies k_inv
	       * in addition, either lt is E and ky is min elt in r OR
	       * min elt in returned tree is same as min elt in lt
	       * (resp. for max elt and rt)
	       *)
	      (k_inv r /\
	      ((is_E lt /\ min_elt r = ky) \/ (is_T lt /\ min_elt r = min_elt lt)) /\
              ((is_E rt /\ max_elt r = ky) \/ (is_T rt /\ max_elt r = max_elt rt))) /\

	      (*
	       * returned tree satisfies h_inv
	       * in addition, black height of returned tree is either same as or
	       * one more than lt (and hence rt) depending on c = R or c = B
	       *)
		 
              ((h_inv r) /\
	      ((c = B /\ Some.v(black_height r) = Some.v(black_height lt) + 1) \/
               (c = R /\ Some.v(black_height r) = Some.v(black_height lt)))) /\

              
	      (*
	       * returned tree either satisfies c_inv OR
	       * if it doesn't, it must be the case that c (and hence T.col r) = R
	       *)
	      (c_inv r  \/
	      (T.col r = R /\ c = R /\ not_c_inv r /\ lr_c_inv r)))
	     )
(* it's pretty cool that the spec is proved easily without any hints ! *)	     
let balance c lt ky rt =
  match (c, lt, ky, rt) with
    | (B, (T R (T R a x b) y c), z, d)
    | (B, (T R a x (T R b y c)), z, d)
    | (B, a, x, (T R (T R b y c) z d))
    | (B, a, x, (T R b y (T R c z d))) -> T R (T B a x b) y (T B c z d)
    | _ -> T c lt ky rt

(*
 * a helper function that inserts a red node with new key, and calls
 * balance to re-establish red black tree invariants
 *)
val ins: t:rbtree' -> k:nat ->
         Pure rbtree'
         (requires (c_inv t /\ h_inv t /\ k_inv t))
	 (ensures (fun r ->
	          
          (* returned tree is a T *)         
	  (is_T r) /\

	  (*
	   * returned tree satisfies k_inv
	   * moreover, min elt in returned tree is either k (the new key)
	   * or same as the min elt in input t (resp. for max element)
	   * if t is E, then min (and max) elt in returned tree must be k
	   *)
	     
	  (k_inv r /\
	  (min_elt r = k \/ (is_T t /\ min_elt r = min_elt t)) /\
	  (max_elt r = k \/ (is_T t /\ max_elt r = max_elt t))) /\

          (*
	   * returned tree satisfies h_inv
	   * and has same black height as the input tree
	   * (the new node is introduced at color R, and no node is re-colored)
	   *)
          (h_inv r /\ black_height r = black_height t) /\
          
          
	  (*
	   * these are copied from post condition of balance
	   *)
	  (c_inv r \/
	  (is_T t /\ T.col r = R /\ T.col t = R /\ not_c_inv r /\ lr_c_inv r))))
(* once again, very cool that spec is verified without any hints in the code *)
let rec ins t x =
  match t with
    | E -> T R E x E
    | T c a y b ->      
      if x < y then
	(* TODO: ideally we would have inlined this call in the balance call *)
	let lt = ins a x in
	balance c lt y b
      else if x = y then
	t
      else
	let rt = ins b x in	
	balance c a y rt

(*
 * a red black tree is balanced if it satisfies r_inv, h_inv, c_inv, and k_inv
 *)
type balanced_rbtree' (t:rbtree') = r_inv t /\ h_inv t /\ c_inv t /\ k_inv t

(*
 * make black blackens the root of a tree
 *)
val make_black: t:rbtree' -> Pure rbtree'
                            (requires (is_T t /\ c_inv t /\ h_inv t /\ k_inv t))
                            (ensures (fun r -> balanced_rbtree' r))
let make_black (T _ a x b) = T B a x b

(*
 * and finally, the beautiful spec of insert function :)
 *)
val insert: t:rbtree' -> nat -> Pure rbtree' (requires (balanced_rbtree' t)) 
                                             (ensures (fun r -> balanced_rbtree' r))
let insert t x =
  let r = ins t x in  
  let r' = make_black r in
  r'

(* TODO: make rbtree polymorphic *)
(*
type rbtree =
  | Mk: tr:rbtree'{balanced_rbtree' tr} -> rbtree

val proj: rbtree -> Pure rbtree' (requires True) (ensures (fun r -> balanced_rbtree' r))
let proj tr = Mk.tr tr
*)