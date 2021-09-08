type firestore
type documentReference<'a>
type documentSnapshot<'a>

type unsub = unit => unit

@module("firebase/firestore")
external getFirestore: (~app: Firebase.app=?, unit) => firestore = "getFirestore"
@module("firebase/firestore")
external doc: (firestore, string, string) => documentReference<'a> = "doc"
@module("firebase/firestore")
external onSnapshot: (documentReference<'a>, documentSnapshot<'a> => unit) => unsub = "onSnapshot"

@send external data: (documentSnapshot<'a>) => option<'a> = "data"
