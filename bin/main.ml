open Core
open Core_bench

open Monad_sig
open Monad_prod
open Monad_cont

module Fib(M : STATE_MONAD with type state = int * int) = struct
  open M

  let rec fib_cmd n =
    match n with
    | 0 | 1 ->
       let* () = set (0 , 0) in
       return n
    | _ ->
       let* b = fib_cmd (n - 1) in
       let* (_ , a) = get in
       let* () = set (a , b) in
       return (a + b)

  let fib n =
    let v , _ = force (fib_cmd n) (0 , 0) in
    v
end

module NoMonad = struct
  let fib n =
    let rec fib n =
      match n with
      | 0 | 1 -> (n , (0 , 0))
      | _ ->
         let (b , (_ , a)) = fib (n - 1) in
         (a + b, (a , b))
    in
    let v , _ = fib n in
    v
end

module S = struct type state = int * int end

module MP = MonadProd(S)
module ProdRaw = Fib(MP)

module MPI = MonadProdInline(S)
module ProdInline = Fib(MPI)

module MPIB = MonadProdInlineBoxed(S)
module ProdInlineBoxed = Fib(MPIB)

module MC = MonadCont(S)
module ContRaw = Fib(MC)

module MCU = MonadContUnbox(S)
module ContUnbox = Fib(MCU)

module MCIU = MonadContInlineUnbox(S)
module ContInlineUnbox = Fib(MCIU)

let () =
  let bench name f = Bench.Test.create ~name (fun () -> f 1000) in
  let cmd =
    Bench.make_command
      [ bench "no monad" NoMonad.fib
      ; bench "prod" ProdRaw.fib
      ; bench "prod inline" ProdInline.fib
      ; bench "prod inline boxed" ProdInlineBoxed.fib
      ; bench "cont" ContRaw.fib
      ; bench "cont unbox" ContUnbox.fib
      ; bench "cont inline unbox" ContInlineUnbox.fib
      ]
  in
  Command_unix.run cmd
