%%raw("import 'virtual:windi.css'")

switch ReactDOM.querySelector("#root") {
| Some(root) =>
  ReactDOM.render(
    <React.StrictMode>
      <FirebaseContext.Provider> <App /> </FirebaseContext.Provider>
    </React.StrictMode>,
    root,
  )
| None => ()
}
