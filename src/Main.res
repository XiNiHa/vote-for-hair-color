%%raw("import 'virtual:windi.css'")

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<React.StrictMode> <App /> </React.StrictMode>, root)
| None => ()
}
