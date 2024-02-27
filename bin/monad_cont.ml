open Monad_sig

module MonadCont(M : sig type state end) : STATE_MONAD with type state = M.state = struct
  type state = M.state

  type 'a m =
    { f : 'b. ('a -> state -> 'b) -> state -> 'b }

  let bind { f } bnd =
    { f =
        fun cont state ->
        f
          begin
            fun a state ->
            (bnd a).f
              cont
              state
          end
          state
    }

  let ( let* ) = bind

  let return v =
    { f =
        fun cont state ->
          cont v state
    }

  let get =
    { f = fun cont state -> cont state state }

  let set v =
    { f = fun cont _ -> cont () v }

  let force { f } state =
    f (fun a state -> (a , state)) state
end

module MonadContUnbox(M : sig type state end) : STATE_MONAD with type state = M.state = struct
  type state = M.state

  type 'a m =
    { f : 'b. ('a -> state -> 'b) -> state -> 'b }
      [@@unbox]

  let bind { f } bnd =
    { f =
        fun cont state ->
        f
          begin
            fun a state ->
            (bnd a).f
              cont
              state
          end
          state
    }

  let ( let* ) = bind

  let return v =
    { f =
        fun cont state ->
          cont v state
    }

  let get =
    { f = fun cont state -> cont state state }

  let set v =
    { f = fun cont _ -> cont () v }

  let force { f } state =
    f (fun a state -> (a , state)) state
end

module MonadContInlineUnbox(M : sig type state end) : STATE_MONAD with type state = M.state = struct
  type state = M.state

  type 'a m =
    { f : 'b. ('a -> state -> 'b) -> state -> 'b }
      [@@unbox]

  let bind { f } bnd =
    { f =
        fun cont state ->
        f
          begin
            fun a state ->
            (bnd a).f
              cont
              state
          end
          state
    }
    [@@specialize]
    [@@inline always]

  let ( let* ) = bind
    [@@specialize]

  let return v =
    { f =
        fun cont state ->
          cont v state
    }
    [@@specialize]
    [@@inline always]

  let get =
    { f = fun cont state -> cont state state }
    [@@specialize]
    [@@inline always]

  let set v =
    { f = fun cont _ -> cont () v }
    [@@specialize]
    [@@inline always]

  let force { f } state =
    f (fun a state -> (a , state)) state
    [@@specialize]
    [@@inline always]
end
