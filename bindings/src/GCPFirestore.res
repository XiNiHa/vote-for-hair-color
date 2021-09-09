type t
type collectionRef
type docRef

type config = {projectId: string}

@module("@google-cloud/firestore") @new external firestore: config => t = "Firestore"
@send external collection: (t, string) => collectionRef = "collection"
@send external doc: (collectionRef, string) => docRef = "doc"

@send external set: (docRef, 'a) => Promise.t<'b> = "set"
@send external update: (docRef, 'a) => Promise.t<'b> = "update"

module FieldValue = {
  type t

  @module("@google-cloud/firestore") @scope("FieldValue")
  external increment: int => t = "increment"
}
