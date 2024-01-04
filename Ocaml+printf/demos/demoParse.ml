(** Copyright 2023, aartdem *)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Ocaml_printf_lib

let () =
  let s = Stdio.In_channel.input_all Stdlib.stdin in
  match Ocaml_printf_lib.Parser.run_parser_program s with
  | Result.Ok ast -> Format.printf "%a\n%!" Ast.pp_program ast
  | Error msg -> Format.printf "Error %s\n" msg
;;
