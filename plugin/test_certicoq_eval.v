From CertiCoq.Plugin Require Import Loader.
From CertiCoq.Plugin Require Import CertiCoq.
From MetaCoq.Utils Require Import utils.

Open Scope bs_scope.

Class Show (A : Type) := show : A -> string.

#[export] Instance nat_show : Show nat := string_of_nat.
Local Open Scope bs.
Definition string_of_bool b :=
  if (b : bool) then "true" else "false".
#[export] Instance bool_show : Show bool := string_of_bool.

#[export] Instance list_show {A} {SA : Show A} : Show (list A) := string_of_list show.
From MetaCoq.Common Require Import Primitive.
From Coq Require Import PrimFloat PrimInt63.
#[export] Instance float_show : Show PrimFloat.float := string_of_float.
#[export] Instance prim_int_show : Show PrimInt63.int := string_of_prim_int.

Import SpecFloat.
Definition string_of_specfloat (f : SpecFloat.spec_float) :=
  match f with
  | S754_zero sign => if sign then "-0" else "0"
  | S754_infinity sign => if sign then "-infinity" else "infinity"
  | S754_nan => "nan"
  | S754_finite sign p z => 
  let num := string_of_positive p ++ "p" ++ string_of_Z z in
  if sign then "-" ++ num else num
  end.

#[export] Instance show_specfloat : Show SpecFloat.spec_float := string_of_specfloat.
#[export] Instance show_positive : Show positive := string_of_positive.
#[export] Instance show_Z : Show Z := string_of_Z.

Definition certicoqc2 := 5.
Definition certicoqc3 := coq_msg_notice ("Hello world! " ++ show 100%nat).
 (* show (0%float == (-0)%float)). *)

Definition certicoqc4 := show (List.map S [26; 20]).

Time Eval compute in certicoqc4.
Set Warnings "-primitive-turned-into-axiom".
Set Warnings "backtrace".
(* CertiCoq Eval -time certicoqc4. *)

Goal True.
  intros.
  certicoq_eval -build_dir "_build" certicoqc4 ltac:(fun c => assert (certicoqc4 = c) by reflexivity).