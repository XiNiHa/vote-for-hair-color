open Bindings

type incOrDec = Increase | Decrease

type timestamp = {
  seconds: float,
  nanoseconds: float
}

type voteResult = {
  redInc: int,
  redVotes: int,
  greenInc: int,
  greenVotes: int,
  blueInc: int,
  blueVotes: int,
  voteEndAt: timestamp,
}

type choices = {
  red: option<incOrDec>,
  green: option<incOrDec>,
  blue: option<incOrDec>,
}

type indecColor = {
  onDecrease: Color.t,
  onIncrease: Color.t,
}

type indecColors = {
  red: indecColor,
  green: indecColor,
  blue: indecColor,
}

type change = {
  perc: int,
  direction: incOrDec,
}

type statistics = {
  red: change,
  green: change,
  blue: change,
  saturation: change,
  lightness: change,
}

type cookieData = {
  votedAt: Js.Date.t,
  colorAtVote: Color.t,
}

let mapCookie = dict => {
  let votedAtStr = Js.Dict.get(dict, "votedAt")
  let colorAtVoteStr = Js.Dict.get(dict, "colorAtVote")

  switch (votedAtStr, colorAtVoteStr) {
  | (Some(votedAtStr), Some(colorAtVoteStr)) =>
    Some({
      votedAt: Js.Date.fromString(votedAtStr),
      colorAtVote: Color.fromString(colorAtVoteStr)
    })
  | _ => None
  }
}
