open Bindings

@val @scope("import.meta.env") external apiKey: string = "VITE_FIREBASE_API_KEY"
@val @scope("import.meta.env") external authDomain: string = "VITE_FIREBASE_AUTH_DOMAIN"
@val @scope("import.meta.env") external projectId: string = "VITE_FIREBASE_PROJECT_ID"

let app = Firebase.initializeApp(Firebase.buildAppOptions(~apiKey, ~authDomain, ~projectId, ()))
let db = Firestore.getFirestore(~app, ())

let context = React.createContext(db)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    React.createElement(provider, {"value": db, "children": children})
  }
}
