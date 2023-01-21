(**************************************************************************)
(*                                                                        *)
(*    Copyright 2020 OCamlPro & Origin Labs                               *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

(*
val opam_raw : unit
val opam_init : unit
*)
val opam :
  ?y:bool ->
  ?error:exn option ref ->
  ?switch:string ->
  ?edition:string -> string list -> string list -> unit

(* Run "opam exec -- dune ARGS" with the given arguments *)
val dune : string list -> unit
