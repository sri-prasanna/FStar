(*
   Copyright 2015 Michael Hicks, Microsoft Research

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

(** Stack operations

    The functions here are for allocating Caml values on a
    manually-managed, growable stack. 

    This library is unsafe. To avoid memory errors, programs must
    satisfy two constraints:

    1) No data allocated on a frame, and no data in the OCaml heap
    reachable from the frame, will be used by the program after the
    frame is popped. (To do so would result in a dangling pointer
    dereference.)

    2) No pointers into the OCaml heap will be installed by mutation
    of a stack-allocated object UNLESS the location that was mutated
    was initially registered, when created, as possibly
    pointer-containing.  (To do so would create a GC root into the
    OCaml heap that is not tracked by the stack implementation.)
*)

external push_frame : int -> unit = "stack_push_frame";;
(** [Camlstack.push_frame n] pushes a frame onto the stack that has at least
    [n] contiguous bytes. The frame will grow, if necessary. 
    (An argument of 0 is acceptable.) 
    Raise [Invalid_argument "Camlstack.push_frame"] if [n] is negative. *)

external pop_frame : unit -> unit = "stack_pop_frame";;
(** Pops the topmost stackframe. This means that all of that data is
    now free, and the program must take care not to access it.
    In addition, Caml heap data reachable only from that data will be
    subsequently GCed.
    Raise [Failure "Camlstack.pop_frame"] if the stack has no frames. *)

external mkpair : 'a -> 'b -> 'a*'b = "stack_mkpair";;
(** [Camlstack.mkpair x y] allocates a pair (x,y) on the stack.
    Raise [Failure "Camlstack.mkpair"] if the stack has no frames. *)

external mktuple3 : 'a -> 'b -> 'c -> 'a*'b*'c = "stack_mktuple3";;
(** [Camlstack.mktuple3 x y z] allocates a triple (x,y,z) on the stack.
    Raise [Failure "Camlstack.mktuple3"] if the stack has no frames. *)

external mktuple4 : 'a -> 'b -> 'c -> 'd -> 'a*'b*'c*'d = "stack_mktuple4";;
(** [Camlstack.mktuple4 x y z w] allocates a pair (x,y,z,w) on the stack.
    Raise [Failure "Camlstack.mktuple4"] if the stack has no frames. *)

external cons: 'a -> 'a list -> 'a list = "stack_mkpair";;
(** [Camlstack.cons x y] allocates a cons cell [x::y] on the stack.
    Raise [Failure "Camlstack.cons"] if the stack has no frames. *)

external mkref: 'a -> 'a ref = "stack_mkref";;
(** [Camlstack.mkref x] allocates a ref cell on the stack,
    initializing it with x.  Raise [Failure "Camlstack.cons"] if the
    stack has no frames. *)

external mkbytes : int -> bytes = "stack_mkbytes";;
(** [Camlstack.mkbytes n] constructs a byte array of length n.
    The contents are uninitialized. Note that a byte array can be 
    coerced to a string by Bytes.unsafe_to_string (but only after
    it's fully initialized and won't change anymore).
    Raise [Failure "Camlstack.mkbytes"] if the stack has no frames. 
    Raise [Invalid_argument "Camlstack.mkbytes"] if [n] is non-positive. *)

external mkarray : int -> 'a -> 'a array = "stack_mkarray";;
(** [Camlstack.mkarray n v] allocates an array of length [n] with each
    element initialized to [v]. 
    Raise [Failure "Camlstack.mkarray"] if the stack has no frames. 
    Raise [Invalid_argument "Camlstack.mkarray"] if [n] is non-positive,
    or if you try to make an array of floats, which is not yet supported. *)

(** DEBUGGING **)

external print_mask : unit -> unit = "print_mask";;
(** [Camlstack.print_mask ()] is a debugging function. It prints
    a list of Caml heap pointers that occur on the stack, and should
    be scanned by the GC. *)

external inspect : 'a -> unit = "inspect";;
(** [Camlstack.inspect x] is a debugging function. It prints
    out the structure of the run-time value x that is passed to it. *)
