(** Copyright 2021-2023, Efim Perevalov *)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)


open FSharpUnitsOfMeasure_lib
open Ast
open Parser

let parsed_result str parser show =
  match parse_str parser str with
  | Ok res -> Format.printf "%s" (show res)
  | Error e -> Format.printf "%s" e
;;

(** Types test *)

let%expect_test _ =
  parsed_result "777" parse_types show_types;
  [%expect {| (FInt 777) |}]
;;

let%expect_test _ =
  parsed_result "-777" parse_types show_types;
  [%expect {| (FInt -777) |}]
;;

let%expect_test _ =
  parsed_result "777.777" parse_types show_types;
  [%expect {| (FFloat 777.777) |}]
;;

let%expect_test _ =
  parsed_result "-777.777" parse_types show_types;
  [%expect {| (FFloat -777.777) |}]
;;

let%expect_test _ =
  parsed_result "true" parse_types show_types;
  [%expect {| (FBool true) |}]
;;

let%expect_test _ =
  parsed_result "false" parse_types show_types;
  [%expect {| (FBool false) |}]
;;

let%expect_test _ =
  parsed_result "\"Test to string\"" parse_types show_types;
  [%expect {| (FString "Test to string") |}]
;;

let%expect_test _ =
  parsed_result "()" parse_types show_types;
  [%expect {| FUnit |}]
;;

let%expect_test _ =
  parsed_result "[]" parse_types show_types;
  [%expect {| FNil |}]
;;

let%expect_test _ =
  parsed_result "[<Measure>] type cm" parse_types show_types;
  [%expect {| (Measure (Measure_single "cm")) |}]
;;

let%expect_test _ =
  parsed_result 
  "[<Measure>] type m" parse_types show_types;
  [%expect {| (Measure (Measure_single "m")) |}]
;;

let%expect_test _ =
  parsed_result 
  "[<Measure>] type spped = m/sec" parse_types show_types;
  [%expect {|
    (Measure_multiple ((Measure_single "spped"),
       (Measure_double ((Measure_single "m"), Div, (Measure_single "sec"))))) |}]
;;

let%expect_test _ =
  parsed_result "7.77 <sec>" parse_types show_types;
  [%expect {| (Measure_float ((FFloat 7.77), (Measure_single "sec"))) |}]
;;

let%expect_test _ =
  parsed_result "7.77 <m/sec>" parse_types show_types;
  [%expect {|
    (Measure_float ((FFloat 7.77),
       (Measure_double ((Measure_single "m"), Div, (Measure_single "sec"))))) |}]
;;

let%expect_test _ =
  parsed_result "7.77" parse_types show_types;
  [%expect {| (FFloat 7.77) |}]
;;

(** Pattern test *)

let%expect_test _ =
  parsed_result "1" parse_pattern show_pattern;
  [%expect {| (PConst (FInt 1)) |}]
;;

let%expect_test _ =
  parsed_result "a" parse_pattern show_pattern;
  [%expect {| (PVar "a") |}]
;;

let%expect_test _ =
  parsed_result "a, b" parse_pattern show_pattern;
  [%expect {| (PTuple [(PVar "a"); (PVar "b")]) |}]
;;

let%expect_test _ =
  parsed_result "((a, b), c)" parse_pattern show_pattern;
  [%expect {| (PTuple [(PTuple [(PVar "a"); (PVar "b")]); (PVar "c")]) |}]
;;

let%expect_test _ =
  parsed_result "((a, 1), c)" parse_pattern show_pattern;
  [%expect {| (PTuple [(PTuple [(PVar "a"); (PConst (FInt 1))]); (PVar "c")]) |}]
;;

let%expect_test _ =
  parsed_result "a :: b" parse_pattern show_pattern;
  [%expect {| (PCons ((PVar "a"), (PVar "b"))) |}]
;;

let%expect_test _ =
  parsed_result "() :: []" parse_pattern show_pattern;
  [%expect {| (PCons ((PConst FUnit), (PConst FNil))) |}]
;;

let%expect_test _ =
  parsed_result "[5]" parse_pattern show_pattern;
  [%expect {| (PList [(PConst (FInt 5))]) |}]
;;

let%expect_test _ =
  parsed_result "[1; 2]" parse_pattern show_pattern;
  [%expect {| (PList [(PConst (FInt 1)); (PConst (FInt 2))]) |}]
;;

let%expect_test _ =
  parsed_result "[ 1; 2]" parse_pattern show_pattern;
  [%expect {| (PList [(PConst (FInt 1)); (PConst (FInt 2))]) |}]
;;

let%expect_test _ =
  parsed_result "[ 1; 2 ]" parse_pattern show_pattern;
  [%expect {| (PList [(PConst (FInt 1)); (PConst (FInt 2))]) |}]
;;

let%expect_test _ =
  parsed_result "[1; 2; a]" parse_pattern show_pattern;
  [%expect {| (PList [(PConst (FInt 1)); (PConst (FInt 2)); (PVar "a")]) |}]
;;

(** Expressions with constant *)

let%expect_test _ =
  parsed_result "777" parse_expression show_expression;
  [%expect {| (EConst (FInt 777)) |}]
;;

let%expect_test _ =
  parsed_result "-777" parse_expression show_expression;
  [%expect {| (EConst (FInt -777)) |}]
;;

let%expect_test _ =
  parsed_result "777.777" parse_expression show_expression;
  [%expect {| (EConst (FFloat 777.777)) |}]
;;

let%expect_test _ =
  parsed_result "-777.777" parse_expression show_expression;
  [%expect {| (EConst (FFloat -777.777)) |}]
;;

let%expect_test _ =
  parsed_result "true" parse_expression show_expression;
  [%expect {| (EConst (FBool true)) |}]
;;

let%expect_test _ =
  parsed_result "false" parse_expression show_expression;
  [%expect {| (EConst (FBool false)) |}]
;;

let%expect_test _ =
  parsed_result "\"Test to string\"" parse_expression show_expression;
  [%expect {| (EConst (FString "Test to string")) |}]
;;

let%expect_test _ =
  parsed_result "()" parse_expression show_expression;
  [%expect {| (EConst FUnit) |}]
;;

let%expect_test _ =
  parsed_result "[]" parse_expression show_expression;
  [%expect {| (EConst FNil) |}]
;;

let%expect_test _ =
  parsed_result "[<Measure>] type cm" parse_expression show_expression;
  [%expect {| (EConst (Measure (Measure_single "cm"))) |}]
;;

let%expect_test _ =
  parsed_result 
  "[<Measure>] type m" parse_expression show_expression;
  [%expect {| (EConst (Measure (Measure_single "m"))) |}]
;;

let%expect_test _ =
  parsed_result 
  "[<Measure>] type spped = m/sec" parse_expression show_expression;
  [%expect {|
    (EConst
       (Measure_multiple ((Measure_single "spped"),
          (Measure_double ((Measure_single "m"), Div, (Measure_single "sec")))))) |}]
;;

let%expect_test _ =
  parsed_result "7.77 <sec>" parse_expression show_expression;
  [%expect {| (EConst (Measure_float ((FFloat 7.77), (Measure_single "sec")))) |}]
;;

let%expect_test _ =
  parsed_result "7.77 <m/sec>" parse_expression show_expression;
  [%expect {|
    (EConst
       (Measure_float ((FFloat 7.77),
          (Measure_double ((Measure_single "m"), Div, (Measure_single "sec")))))) |}]
;;

let%expect_test _ =
  parsed_result "7.77" parse_expression show_expression;
  [%expect {| (EConst (FFloat 7.77)) |}]
;;

(** Expressions with binary operations test *)

let%expect_test _ =
  parsed_result "1 - 2" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Sub), (EApp ((EConst (FInt 1)), (EConst (FInt 2)))))) |}]
;;

let%expect_test _ =
  parsed_result "z * v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mul), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z / v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Div), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z % v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mod), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z && v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp And), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z || v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Or), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z = v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Eq), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z < v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Less), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z > v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Gre), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z <= v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Leq), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "z >= v" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Greq), (EApp ((EVar "z"), (EVar "v"))))) |}]
;;

let%expect_test _ =
  parsed_result "1     *    2" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mul), (EApp ((EConst (FInt 1)), (EConst (FInt 2)))))) |}]
;;

let%expect_test _ =
  parsed_result "1     *    +2" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mul), (EApp ((EConst (FInt 1)), (EConst (FInt 2)))))) |}]
;;

let%expect_test _ =
  parsed_result "    1     *    +   2    " parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mul), (EApp ((EConst (FInt 1)), (EConst (FInt 2)))))) |}]
;;

let%expect_test _ =
  parsed_result "1     *   -2" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mul), (EApp ((EConst (FInt 1)), (EConst (FInt -2)))))) |}]
;;

let%expect_test _ =
  parsed_result "1     *   -         2" parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mul), (EApp ((EConst (FInt 1)), (EConst (FInt -2)))))) |}]
;;

let%expect_test _ =
  parsed_result "     1     *   -         2      " parse_expression show_expression;
  [%expect {| (EApp ((EBinaryOp Mul), (EApp ((EConst (FInt 1)), (EConst (FInt -2)))))) |}]
;;

let%expect_test _ =
  parsed_result "z * (v / y)" parse_expression show_expression;
  [%expect 
  {| 
  (EApp ((EBinaryOp Mul),
     (EApp ((EVar "z"),
        (EApp ((EBinaryOp Div), (EApp ((EVar "v"), (EVar "y")))))))
     )) 
     |}]
;;

let%expect_test _ =
  parsed_result "(z && v) || x" parse_expression show_expression;
  [%expect 
  {|
     (EApp ((EBinaryOp Or),
        (EApp ((EApp ((EBinaryOp And), (EApp ((EVar "z"), (EVar "v"))))),
           (EVar "x")))
        )) 
        |}]
;;

let%expect_test _ =
  parsed_result "1 + 3 - 5" parse_expression show_expression;
  [%expect {|
    (EApp ((EBinaryOp Sub),
       (EApp (
          (EApp ((EBinaryOp Add), (EApp ((EConst (FInt 1)), (EConst (FInt 3)))))),
          (EConst (FInt 5))))
       )) |}]
;;

let%expect_test _ =
  parsed_result "(3 + 1) * (4 - 2) * (9 / 3)" parse_expression show_expression;
  [%expect 
  {|
     (EApp ((EBinaryOp Mul),
        (EApp (
           (EApp ((EBinaryOp Mul),
              (EApp (
                 (EApp ((EBinaryOp Add),
                    (EApp ((EConst (FInt 3)), (EConst (FInt 1)))))),
                 (EApp ((EBinaryOp Sub),
                    (EApp ((EConst (FInt 4)), (EConst (FInt 2))))))
                 ))
              )),
           (EApp ((EBinaryOp Div), (EApp ((EConst (FInt 9)), (EConst (FInt 3))))))
           ))
        ))
        |}]
;;

(** Expressions with tuple test *)

let%expect_test _ =
  parsed_result "(1.1, 5)" parse_expression show_expression;
  [%expect {| (ETuple [(EConst (FFloat 1.1)); (EConst (FInt 5))]) |}]
;;

let%expect_test _ =
  parsed_result "((a, 69.96), c)" parse_expression show_expression;
  [%expect {| (ETuple [(ETuple [(EVar "a"); (EConst (FFloat 69.96))]); (EVar "c")]) |}]
;;

let%expect_test _ =
  parsed_result "((a, 1), c)" parse_expression show_expression;
  [%expect {| (ETuple [(ETuple [(EVar "a"); (EConst (FInt 1))]); (EVar "c")]) |}]
;;

let%expect_test _ =
  parsed_result "((a, 1), ((1.2, b), (c, 3.44)))" parse_expression show_expression;
  [%expect {|
    (ETuple
       [(ETuple [(EVar "a"); (EConst (FInt 1))]);
         (ETuple
            [(ETuple [(EConst (FFloat 1.2)); (EVar "b")]);
              (ETuple [(EVar "c"); (EConst (FFloat 3.44))])])
         ]) |}]
;;

(** Expressions with list test *)

let%expect_test _ =
  parsed_result "[1; 5]" parse_expression show_expression;
  [%expect {| (EList [(EConst (FInt 1)); (EConst (FInt 5))]) |}]
;;

let%expect_test _ =
  parsed_result "[1.1; 5]" parse_expression show_expression;
  [%expect {| (EList [(EConst (FFloat 1.1)); (EConst (FInt 5))]) |}]
;;

let%expect_test _ =
  parsed_result "[[69.96 ; b]; c]" parse_expression show_expression;
  [%expect {| (EList [(EList [(EConst (FFloat 69.96)); (EVar "b")]); (EVar "c")]) |}]
;;

let%expect_test _ =
  parsed_result "[[a; 1]; c]" parse_expression show_expression;
  [%expect {| (EList [(EList [(EVar "a"); (EConst (FInt 1))]); (EVar "c")]) |}]
;;

let%expect_test _ =
  parsed_result "[[a; 1]; [[1.2; b]; [c; 3]]]" parse_expression show_expression;
  [%expect {|
    (EList
       [(EList [(EVar "a"); (EConst (FInt 1))]);
         (EList
            [(EList [(EConst (FFloat 1.2)); (EVar "b")]);
              (EList [(EVar "c"); (EConst (FInt 3))])])
         ]) |}]
;;

(** Expressions with list + tuple test *)

let%expect_test _ =
  parsed_result "[(69.69, b); (1, d); []; ()]" parse_expression show_expression;
  [%expect {|
    (EList
       [(ETuple [(EConst (FFloat 69.69)); (EVar "b")]);
         (ETuple [(EConst (FInt 1)); (EVar "d")]); (EConst FNil); (EConst FUnit)]) |}]
;;

let%expect_test _ =
  parsed_result "([69.69; b], [1; d], [], ())" parse_expression show_expression;
  [%expect {|
    (ETuple
       [(EList [(EConst (FFloat 69.69)); (EVar "b")]);
         (EList [(EConst (FInt 1)); (EVar "d")]); (EConst FNil); (EConst FUnit)]) |}]
;;

(** Expression with if ... then ... else ...*)

let%expect_test _ =
  parsed_result 
  "if true then 2 else 1" 
  parse_expression 
  show_expression;
  [%expect {| (EIfElse ((EConst (FBool true)), (EConst (FInt 2)), (EConst (FInt 1)))) |}]
;;

(** Expressions with match test *)

let%expect_test _ =
  parsed_result 
  "match x with \n\ 
  \ | a -> b 
  \ | _ -> c" 
  parse_expression 
  show_expression;
  [%expect {|
    (EMatch ((EVar "x"), [((PVar "a"), (EVar "b")); (PWild, (EVar "c"))])) |}]
;;

let%expect_test _ =
  parsed_result 
  "let num x = 
    match x with 
     | 1 -> 1 
     | _ -> 2" 
  parse_expression 
  show_expression;
  [%expect {|
    (ELet (false, "num",
       (EFun ((PVar "x"),
          (EMatch ((EVar "x"),
             [((PConst (FInt 1)), (EConst (FInt 1))); (PWild, (EConst (FInt 2)))]
             ))
          ))
       )) |}]
;;

(** Expressions with fun test *)

let%expect_test _ =
  parsed_result "fun z -> v" parse_expression show_expression;
  [%expect {|
    (EFun ((PVar "z"), (EVar "v"))) |}]
;;

let%expect_test _ =
  parsed_result "fun z -> 6.66" parse_expression show_expression;
  [%expect {|
    (EFun ((PVar "z"), (EConst (FFloat 6.66)))) |}]
;;

let%expect_test _ =
  parsed_result "(fun x -> x) 5" parse_expression  show_expression;
  [%expect {| (EApp ((EFun ((PVar "x"), (EVar "x"))), (EConst (FInt 5)))) |}]
;;

(** Expressions with let test *)

let%expect_test _ =
  parsed_result 
  "let x = 5" 
  parse_expression 
  show_expression;
  [%expect {| (ELet (false, "x", (EConst (FInt 5)))) |}]
;;

let%expect_test _ =
  parsed_result 
  "let number x = x " 
  parse_expression 
  show_expression;
  [%expect {| (ELet (false, "number", (EFun ((PVar "x"), (EVar "x"))))) |}]
;;

let%expect_test _ =
  parsed_result 
  "number 5 " 
  parse_expression 
  show_expression;
  [%expect {| (EApp ((EVar "number"), (EConst (FInt 5)))) |}]
;;

let%expect_test _ =
  parsed_result "let sum z = fun v -> z + v" parse_expression show_expression;
  [%expect {|
    (ELet (false, "sum",
       (EFun ((PVar "z"),
          (EFun ((PVar "v"),
             (EApp ((EBinaryOp Add), (EApp ((EVar "z"), (EVar "v")))))))
          ))
       )) |}]
;;

(** Expressions with measure test *)

let%expect_test _ =
  parsed_result 
  "[<Measure>] \n\
  \ type m"
  parse_expression 
  show_expression;
  [%expect {| (EConst (Measure (Measure_single "m"))) |}]
;;

let%expect_test _ =
  parsed_result 
  "[<Measure>] type sec" parse_expression show_expression;
  [%expect {| (EConst (Measure (Measure_single "sec"))) |}]
;;

let%expect_test _ =
  parsed_result 
  "[<Measure>] type speed = m/sec" parse_expression show_expression;
  [%expect {|
    (EConst
       (Measure_multiple ((Measure_single "speed"),
          (Measure_double ((Measure_single "m"), Div, (Measure_single "sec")))))) |}]
;;

let%expect_test _ =
  parsed_result 
  "let x = 1.0 <m>" parse_expression show_expression;
  [%expect {|
    (ELet (false, "x",
       (EConst (Measure_float ((FFloat 1.), (Measure_single "m")))))) |}]
;;

let%expect_test _ =
  parsed_result 
  "7.77 <m> + 7.73 <m>" parse_expression show_expression ;
  [%expect {|
    (EApp ((EBinaryOp Add),
       (EApp ((EConst (Measure_float ((FFloat 7.77), (Measure_single "m")))),
          (EConst (Measure_float ((FFloat 7.73), (Measure_single "m"))))))
       )) |}]
;;

(** Factorial test *)

let%expect_test _ =
  parsed_result "let rec fact n = if n = 1 then 1 else n * (fact ( n - 1 ))" parse_expression show_expression;
  [%expect
  {|
  (ELet (true, "fact",
     (EFun ((PVar "n"),
        (EIfElse (
           (EApp ((EBinaryOp Eq), (EApp ((EVar "n"), (EConst (FInt 1)))))),
           (EConst (FInt 1)),
           (EApp ((EBinaryOp Mul),
              (EApp ((EVar "n"),
                 (EApp ((EVar "fact"),
                    (EApp ((EBinaryOp Sub),
                       (EApp ((EVar "n"), (EConst (FInt 1))))))
                    ))
                 ))
              ))
           ))
        ))
     )) 
     |}]
;;

(** Fibonacci test*)

let%expect_test _ =
  parsed_result 
  "let rec fib n = if n <= 1 then 1 else fib (n - 1) + fib (n - 2)" 
  parse_expression 
  show_expression;
  [%expect {|
    (ELet (true, "fib",
       (EFun ((PVar "n"),
          (EIfElse (
             (EApp ((EBinaryOp Leq), (EApp ((EVar "n"), (EConst (FInt 1)))))),
             (EConst (FInt 1)),
             (EApp (
                (EApp ((EVar "fib"),
                   (EApp ((EBinaryOp Add),
                      (EApp (
                         (EApp ((EBinaryOp Sub),
                            (EApp ((EVar "n"), (EConst (FInt 1)))))),
                         (EVar "fib")))
                      ))
                   )),
                (EApp ((EBinaryOp Sub), (EApp ((EVar "n"), (EConst (FInt 2))))))
                ))
             ))
          ))
       )) |}]
;;