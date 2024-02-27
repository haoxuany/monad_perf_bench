open Monad_sig

module MonadProd(M : sig type state end) : STATE_MONAD with type state = M.state = struct
  type state = M.state

  type 'a m = state -> 'a * state

  let bind f bnd state =
    let v , state = f state in
    bnd v state

  let ( let* ) = bind

  let return v state = (v , state)

  let get v = (v , v)

  let set v _ = ( () , v )

  let force m state = m state
end

module MonadProdInline(M : sig type state end) : STATE_MONAD with type state = M.state = struct
  type state = M.state

  type 'a m = state -> 'a * state

  let bind f bnd state =
    let v , state = f state in
    bnd v state
    [@@specialize]
    [@@inline always]

  let ( let* ) f bnd state =
    let v , state = f state in
    bnd v state
    [@@specialize]
    [@@inline always]

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

module MonadProdInlineBoxed(M : sig type state end) : STATE_MONAD with type state = M.state = struct
  type state = M.state

  type 'a m = state -> 'a * state
    [@@boxed]

  let bind f bnd state =
    let v , state = f state in
    bnd v state
    [@@specialize]
    [@@inline always]

  let ( let* ) f bnd state =
    let v , state = f state in
    bnd v state
    [@@specialize]
    [@@inline always]

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
