
type aref =
| Ref of unit * Obj.t ref

let is_Ref = (fun ( _discr_ ) -> (match (_discr_) with
| Ref (_) -> begin
true
end
| _ -> begin
false
end))

let sel = (fun ( _ ) ( _ ) -> (failwith ("Not yet implemented:Heap.sel")))

let upd = (fun ( _ ) ( _ ) ( _ ) -> (failwith ("Not yet implemented:Heap.upd")))

let emp = ()

let contains = (fun ( _ ) ( _ ) -> (failwith ("Not yet implemented:Heap.contains")))

let equal = (fun ( _ ) ( _ ) -> (failwith ("Not yet implemented:Heap.equal")))

let restrict = (fun ( _ ) ( _ ) -> (failwith ("Not yet implemented:Heap.restrict")))

let concat = (fun ( _ ) ( _ ) -> (failwith ("Not yet implemented:Heap.concat")))

type (' r, ' p, ' h) l__On =
' p

type (' refs, ' h0, ' h1) fresh =
(Obj.t ref, (unit Support.Prims.b2t, (unit Support.Prims.b2t, unit Support.Prims.b2t) Support.Prims.l_and) Support.Prims.l_imp) Support.Prims.l__Forall Support.Prims.l__ForallTyp

type (' mods, ' h, ' h') modifies =
unit Support.Prims.b2t

let only = (fun ( x ) -> (Set.singleton (Ref ((), (Obj.magic x)))))

let op_Hat_Plus_Plus = (fun ( r ) ( s ) -> (Set.union (Set.singleton (Ref ((), (Obj.magic r)))) s))

let op_Plus_Plus_Hat = (fun ( s ) ( r ) -> (Set.union s (Set.singleton (Ref ((), (Obj.magic r))))))

let op_Hat_Plus_Hat = (fun ( r1 ) ( r2 ) -> (Set.union (Set.singleton (Ref ((), (Obj.magic r1)))) (Set.singleton (Ref ((), (Obj.magic r2))))))




