open Bindings
open Express

let db = GCPFirestore.firestore({
  projectId: "vote-for-hair-color",
})

let vote = (req, res) => {
  let cors = res => {
    set(res, "Access-Control-Allow-Origin", "*")
    set(res, "Access-Control-Allow-Methods", "POST")
    set(res, "Access-Control-Allow-Headers", "*")
    set(res, "Access-Control-Allow-Max-Age", "30000")
    res
  }

  try {
    let body: Js.Dict.t<Js.Json.t> = req->body->Js.Json.deserializeUnsafe

    let increase = (obj, key) => {
      switch Js.Dict.get(body, key)->Belt.Option.map(Js.Json.decodeBoolean) {
      | Some(Some(vote)) => {
          Js.Dict.set(obj, key ++ "Votes", GCPFirestore.FieldValue.increment(1))
          if vote {
            Js.Dict.set(obj, key ++ "Inc", GCPFirestore.FieldValue.increment(1))
          }
          obj
        }
      | _ => obj
      }
    }

    let updateDict = Js.Dict.empty()
    updateDict->increase("red")->increase("green")->increase("blue")->ignore

    db
    ->GCPFirestore.collection("main")
    ->GCPFirestore.doc("voteResult")
    ->GCPFirestore.update(updateDict)
    ->Promise.thenResolve(() => res->cors->status(200)->json({"success": true}))
    ->Promise.catch(e => {
      Js.log(e)
      res->cors->status(500)->json({"success": false})->Promise.resolve
    })
  } catch {
  | e => {
      Js.log(e)
      res->cors->status(500)->json({"success": false})->Promise.resolve
    }
  }
}
