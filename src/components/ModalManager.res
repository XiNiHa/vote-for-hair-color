@react.component
let make = (~children) => {
  let (modal, setModal) = React.useState(() => None)

  <div className="relative">
    <ModalContext.Provider value={{modal: modal, setModal: setModal}}>
      {children}
    </ModalContext.Provider>
    <div
      className="z-50 fixed inset-0 bg-black bg-opacity-40 flex justify-center items-center transition-opacity duration-300"
      style={ReactDOM.Style.make(~display=Belt.Option.isSome(modal) ? "flex" : "none", ())}
      onClick={e => setModal(_ => None)}>
      {switch modal {
      | Some(modal) =>
        <section
          className="rounded-xl bg-white shadow-lg p-10 min-w-[20vw] min-h-[20vh] flex flex-col items-center justify-center"
          onClick={ReactEvent.Mouse.stopPropagation}>
          {modal}
        </section>
      | None => React.null
      }}
    </div>
  </div>
}
