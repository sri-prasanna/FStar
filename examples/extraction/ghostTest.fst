(*--build-config
  variables:LIB=../../lib;
  other-files: $LIB/ghost.fst $LIB/list.fst
  --*)


module GhostTest

open Ghost
open List
type sizedListNonGhost =
| MkSListNG: maxsize:nat->  cont:(list int){length cont < (maxsize)} -> sizedListNonGhost

val aSizedListNG :  sizedListNonGhost
let aSizedListNG = MkSListNG ( 2) [1]

type sizedList =
| MkSList: maxsize:(erased nat)->  cont:(list int){length cont < (reveal maxsize)} -> sizedList

val aSizedList : sizedList
let aSizedList =  MkSList (hide 2) [1]
