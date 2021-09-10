open Bindings
open Express

exception VoteEnded(float)

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

  let handleExn = e => {
    Js.log(e)
    switch e {
    | VoteEnded(voteEndedAt) =>
      res->cors->status(410)->json({"success": false, "voteEndedAt": voteEndedAt})
    | _ => res->cors->status(500)->json({"success": false})
    }
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

    let docRef = db->GCPFirestore.collection("main")->GCPFirestore.doc("voteResult")

    docRef
    ->GCPFirestore.get
    ->Promise.then(data => {
      let voteEndAt =
        data
        ->GCPFirestore.data
        ->Js.Dict.get("voteEndAt")
        ->Belt.Option.map(timestamp => Js.Date.fromFloat(timestamp["seconds"] *. 1000.0))

      let ended = switch voteEndAt {
      | Some(voteEndAt) => Js.Date.now() >= Js.Date.getTime(voteEndAt)
      | None => true
      }

      if ended {
        Promise.reject(VoteEnded(voteEndAt->Belt.Option.getUnsafe->Js.Date.getTime))
      } else {
        docRef
        ->GCPFirestore.update(updateDict)
        ->Promise.thenResolve(() => res->cors->status(200)->json({"success": true}))
      }
    })
    ->Promise.catch(e => {
      e->handleExn->Promise.resolve
    })
  } catch {
  | e => e->handleExn->Promise.resolve
  }
}
