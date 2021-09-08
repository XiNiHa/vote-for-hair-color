type appOptions = {
  apiKey: option<string>,
  authDomain: option<string>,
  databaseURL: option<string>,
  projectId: option<string>,
  storageBucket: option<string>,
  messagingSenderId: option<string>,
  appId: option<string>,
  measurementId: option<string>,
}

type app

@module("firebase/app") external initializeApp: appOptions => app = "initializeApp"

let buildAppOptions = (
  ~apiKey=?,
  ~authDomain=?,
  ~databaseURL=?,
  ~projectId=?,
  ~storageBucket=?,
  ~messagingSenderId=?,
  ~appId=?,
  ~measurementId=?,
  (),
) => {
  apiKey: apiKey,
  authDomain: authDomain,
  databaseURL: databaseURL,
  projectId: projectId,
  storageBucket: storageBucket,
  messagingSenderId: messagingSenderId,
  appId: appId,
  measurementId: measurementId,
}
