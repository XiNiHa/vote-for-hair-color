type t = {
  modal: option<React.element>,
  setModal: (option<React.element> => option<React.element>) => unit
}

let context = React.createContext({
  modal: None,
  setModal: _ => ()
})

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children, ~value: t) => {
    React.createElement(provider, {"value": value, "children": children})
  }
}
