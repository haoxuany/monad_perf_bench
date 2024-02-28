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
  [@@inline always]
  [@@specialize always]

module MonadProdHere = struct
  type state = int * int

  type 'a m = state -> 'a * state

  let bind f bnd state =
    let v , state = f state in
    bnd v state
    [@@specialize]
    [@@inline always]

  let ( let* ) = bind
    [@@specialize]

  let return v state = (v , state)
    [@@specialize]
    [@@inline always]

  let get v = (v , v)
    [@@specialize]
    [@@inline always]

  let set v _ = ( () , v )
    [@@specialize]
    [@@inline always]

  let force m state = m state
    [@@specialize]
    [@@inline always]
end

module FibDefun : sig val fib : int -> int end = struct
  open MonadProdHere

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
    [@@specialize]
    [@@inline always]

  let fib n =
    let v , _ = force (fib_cmd n) (0 , 0) in
    v
    [@@specialize]
    [@@inline always]
end


module ManualInlineMonad = struct
  let fib n =
    let rec fib_cmd (n : int) : (int * int) -> int * (int * int) = 
      match n with
      | 0 | 1 ->
         fun (_state : int * int) ->
         let (() , (a , b)) = (() , (0 , 0)) in
         (n , (a , b))
      | _ ->
         fun (state : int * int) ->
         let (b , state) = fib_cmd (n - 1) state in
         let ((_ , a) , state) = (state , state) in
         let (() , state) = (() , (a , b)) in
         (a + b , state)
    in
    let v , _ = fib_cmd n (0 , 0) in
    v
end

module ManualInlineMonadEta = struct
  let fib n =
    let rec fib_cmd n state =
      match n with
      | 0 | 1 ->
         let (a , b) = (0 , 0) in
         (n , (a , b))
      | _ ->
         let (b , state) = fib_cmd (n - 1) state in
         let (_ , a) = state in
         let state = (a , b) in
         (a + b , state)
    in
    let v , _ = fib_cmd n (0 , 0) in
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

module Iterative = struct
  let fib n =
    let (_ , _ , v) = 
      Iter.(
        0 -- n
        (* off by 1, but we only care about performance benchmarks *)
        |> fold (fun (_ , a , b) _ -> (a , b , a + b)) (0 , 0 , 1)
      )
    in
    v
end

module Imperative = struct
  let fib n =
    let state = ref (0 , 0) in
    let rec fib n =
      match n with
      | 0 | 1 ->
         begin
           state := (0 , 0);
           n
         end
      | _ ->
         let b = fib (n - 1) in
         let (_ , a) = !state in
         let () = state := (a , b) in
         a + b
    in
    fib n
end

module ImperativeSplit = struct
  let fib n =
    let a = ref 0 in
    let b = ref 0 in
    let rec fib n =
      match n with
      | 0 | 1 ->
         begin
           a := 0;
           b := 0;
           n
         end
      | _ ->
         let b' = fib (n - 1) in
         let a' = !b in
         let () = a := a' in
         let () = b := b' in
         a' + b'
    in
    fib n
end

module S = struct type state = int * int end

module MP = MonadProd(S) [@@inlined always]
module ProdRaw = Fib(MP) [@@inlined always]

module ProdHere = Fib(MonadProdHere)

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
  let bench name f = Bench.Test.create ~name (fun () -> f 8000) in
  let cmd =
    Bench.make_command
      [ bench "no monad" NoMonad.fib
      ; bench "imperative" Imperative.fib
      ; bench "imperative (split product)" ImperativeSplit.fib
      ; bench "iter library" Iterative.fib
      ; bench "prod" ProdRaw.fib
      ; bench "prod inline" ProdInline.fib
      ; bench "prod inline boxed" ProdInlineBoxed.fib
      ; bench "prod defun" FibDefun.fib
      ; bench "prod manual inline" ManualInlineMonad.fib
      ; bench "prod manual inline (eta expanded)" ManualInlineMonadEta.fib
      ; bench "prod here" ProdHere.fib
      ; bench "cont" ContRaw.fib
      ; bench "cont unbox" ContUnbox.fib
      ; bench "cont inline unbox" ContInlineUnbox.fib
      ]
  in
  Command_unix.run cmd
