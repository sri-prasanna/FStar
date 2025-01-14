
type ' a seq =
| MkSeq of Support.Prims.nat * (Support.Prims.nat  ->  ' a)

let is_MkSeq = (fun ( _discr_ ) -> (match (_discr_) with
| MkSeq (_) -> begin
true
end
| _ -> begin
false
end))

let length = (fun ( s ) -> 
match s with
| MkSeq (l,_) ->l 
)

let mkSeqContents = (fun ( s ) ( n ) -> 
match s with
| MkSeq (_,c) -> c n
)

let create = (fun ( len ) ( v ) -> MkSeq (len, (fun ( i ) -> v)))

let exFalso0 = (Obj.magic (fun ( n ) -> ()))

let createEmpty = MkSeq (0, (fun ( i ) -> (exFalso0 i)))

let index = (fun ( s ) ( i ) -> (mkSeqContents s i))

let upd = (fun ( s ) ( n ) ( v ) -> MkSeq ((length s), (fun ( i ) -> (match ((i = n)) with
| true -> begin
v
end
| false -> begin
(mkSeqContents s i)
end))))

let append = (fun ( s1 ) ( s2 ) -> MkSeq (((length s1) + (length s2)), (fun ( x ) -> (match ((x < (length s1))) with
| true -> begin
(index s1 x)
end
| false -> begin
(index s2 (x - (length s1)))
end))))

let slice = (fun ( s ) ( i ) ( j ) -> MkSeq ((j - i), (fun ( x ) -> (index s (x + i)))))

let lemma_create_len = (fun ( n ) ( i ) -> ())

let lemma_len_upd = (fun ( n ) ( v ) ( s ) -> ())

let lemma_len_append = (fun ( s1 ) ( s2 ) -> ())

let lemma_len_slice = (fun ( s ) ( i ) ( j ) -> ())

let lemma_index_create = (fun ( n ) ( v ) ( i ) -> ())

let lemma_index_upd1 = (fun ( n ) ( v ) ( s ) -> ())

let lemma_index_upd2 = (fun ( n ) ( v ) ( s ) ( i ) -> ())

let lemma_index_app1 = (fun ( s1 ) ( s2 ) ( i ) -> ())

let lemma_index_app2 = (fun ( s2 ) ( s2 ) ( i ) -> ())

let lemma_index_slice = (fun ( s ) ( i ) ( j ) ( k ) -> ())

type (' a, ' s1, ' s2) l__Eq =
(unit Support.Prims.b2t, (int, (' a, ' a, unit, unit) Support.Prims.l__Eq2) Support.Prims.l__Forall) Support.Prims.l_and

let lemma_eq_intro = (fun ( s1 ) ( s2 ) -> ())

let lemma_eq_refl = (fun ( s1 ) ( s2 ) -> ())

let lemma_eq_elim = (fun ( s1 ) ( s2 ) -> ())




