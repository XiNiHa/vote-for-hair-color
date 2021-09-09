%%raw("import 'virtual:windi.css'")

switch ReactDOM.querySelector("#root") {
| Some(root) =>
  ReactDOM.render(
    <React.StrictMode>
      <FirebaseContext.Provider>
        <ModalManager>
          <App />
        </ModalManager>
      </FirebaseContext.Provider>
    </React.StrictMode>,
    root,
  )
| None => ()
}
