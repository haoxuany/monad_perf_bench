
module type MONAD = sig
  type 'a m

  val bind : 'a m -> ('a -> 'b m) -> 'b m
  val ( let* ) : 'a m -> ('a -> 'b m) -> 'b m
  val return : 'a -> 'a m
end

module type STATE_MONAD = sig
  type state

  include MONAD

  val get : state m
  val set : state -> unit m

  val force : 'a m -> state -> 'a * state
end
