(**************************************************************************)
(*                                                                        *)
(*    Copyright 2020 OCamlPro & Origin Labs                               *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

open Ez_file.V1
open EzFile.OP

let opam_raw ?(y = false) cmd args =
  Unix.putenv "OPAMCLI" "2.0" ;
  Misc.call
    (Array.of_list
       ( [ "opam" ] @ cmd
       @ ( if y then
           [ "-y" ]
         else
           [] )
       @ args ) )

let opam_init ?y ?switch ?edition () =
  let opam_root = Globals.opam_root () in

  if not (Sys.file_exists opam_root) then
    let args =
      match switch with
      | None -> [ "--bare" ]
      | Some switch -> [ "--comp"; switch ]
    in
    opam_raw ?y [ "init" ] args
  else
    match switch with
    | None -> ()
    | Some switch ->
      if Filename.is_relative switch then
        if not (Sys.file_exists (opam_root // switch)) then
          opam_raw ?y [ "switch"; "create" ]
            ( match edition with
            | None -> [ switch ]
            | Some edition -> [ switch; edition ] )

let opam ?y ?error ?switch ?edition cmd args =
  opam_init ?y ?switch ?edition ();
  match error with
  | None -> opam_raw ?y cmd args
  | Some error -> (
    try opam_raw ?y cmd args with
    | exn -> error := Some exn )

let dune args =
  opam [ "exec" ]
    ( [ "--"; "dune" ] @ args @
      match !Globals.verbosity with
      | 0 -> [ "--display=quiet" ]
      | 1 -> []
      | 2 -> [ "--display=short" ]
      | _ -> [ "--display=verbose" ] );
