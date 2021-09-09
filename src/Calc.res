open Bindings
open Types

let numsToValue = (total, inc) => {
  (Belt.Float.fromInt(inc) /. Belt.Float.fromInt(total) *. 255.0)->Belt.Float.toInt
}

let currColor = result => {
  Color.rgb(
    numsToValue(result.redVotes, result.redInc),
    numsToValue(result.greenVotes, result.greenInc),
    numsToValue(result.blueVotes, result.blueInc),
  )
}

let getIndecColors = (candColor, result) => {
  {
    red: {
      onDecrease: Color.setRed(candColor, numsToValue(result.redVotes + 1, result.redInc)),
      onIncrease: Color.setRed(candColor, numsToValue(result.redVotes + 1, result.redInc + 1)),
    },
    green: {
      onDecrease: Color.setGreen(candColor, numsToValue(result.greenVotes + 1, result.greenInc)),
      onIncrease: Color.setGreen(
        candColor,
        numsToValue(result.greenVotes + 1, result.greenInc + 1),
      ),
    },
    blue: {
      onDecrease: Color.setBlue(candColor, numsToValue(result.blueVotes + 1, result.blueInc)),
      onIncrease: Color.setBlue(candColor, numsToValue(result.blueVotes + 1, result.blueInc + 1)),
    },
  }
}

let getCandidateColor = (result, choices: choices) => {
  let getValue = (choice, totalVotes, incVotes) => {
    switch choice {
    | Some(Increase) => numsToValue(totalVotes + 1, incVotes + 1)
    | Some(Decrease) => numsToValue(totalVotes + 1, incVotes)
    | None => numsToValue(totalVotes, incVotes)
    }
  }

  Color.rgb(
    getValue(choices.red, result.redVotes, result.redInc),
    getValue(choices.green, result.greenVotes, result.greenInc),
    getValue(choices.blue, result.blueVotes, result.blueInc),
  )
}

let getStatistics = (currColor, candColor) => {
  let getAsFloat = (color, getter) => color->getter->Belt.Float.fromInt
  let buildChange = changeInInt => {
    perc: Js.Math.abs_int(changeInInt),
    direction: changeInInt >= 0 ? Increase : Decrease,
  }

  {
    red: (getAsFloat(candColor, Color.getRed) /.
    getAsFloat(currColor, Color.getRed) *. 100.0 -. 100.0)
    ->Belt.Float.toInt
    ->buildChange,
    green: (getAsFloat(candColor, Color.getGreen) /.
    getAsFloat(currColor, Color.getGreen) *. 100.0 -. 100.0)
    ->Belt.Float.toInt
    ->buildChange,
    blue: (getAsFloat(candColor, Color.getBlue) /.
    getAsFloat(currColor, Color.getBlue) *. 100.0 -. 100.0)
    ->Belt.Float.toInt
    ->buildChange,
    saturation: (getAsFloat(candColor, Color.getSaturationL) /.
    getAsFloat(currColor, Color.getSaturationL) *. 100.0 -. 100.0)
    ->Belt.Float.toInt
    ->buildChange,
    lightness: (getAsFloat(candColor, Color.getLightness) /.
    getAsFloat(currColor, Color.getLightness) *. 100.0 -. 100.0)
    ->Belt.Float.toInt
    ->buildChange,
  }
}
