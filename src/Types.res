open Bindings

type incOrDec = Increase | Decrease

type voteResult = {
  redInc: int,
  redVotes: int,
  greenInc: int,
  greenVotes: int,
  blueInc: int,
  blueVotes: int,
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
