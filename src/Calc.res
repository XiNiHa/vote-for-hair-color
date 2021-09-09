open Bindings
open Types

let numsToValue = (total, inc) => {
  (Belt.Float.fromInt(inc) /. Belt.Float.fromInt(total) *. 255.0)->Belt.Float.toInt
}

let currColor = result => {
  Color.rgb(
    numsToValue(result.total, result.red),
    numsToValue(result.total, result.green),
    numsToValue(result.total, result.blue),
  )
}

let getIndecColors = (candColor, result) => {
  {
    red: {
      onDecrease: Color.setRed(candColor, numsToValue(result.total + 1, result.red)),
      onIncrease: Color.setRed(candColor, numsToValue(result.total + 1, result.red + 1)),
    },
    green: {
      onDecrease: Color.setGreen(candColor, numsToValue(result.total + 1, result.green)),
      onIncrease: Color.setGreen(
        candColor,
        numsToValue(result.total + 1, result.green + 1),
      ),
    },
    blue: {
      onDecrease: Color.setBlue(candColor, numsToValue(result.total + 1, result.blue)),
      onIncrease: Color.setBlue(candColor, numsToValue(result.total + 1, result.blue + 1)),
    },
  }
}

let getCandidateColor = (result, choices: choices) => {
  let getValue = (choice, voteData) => {
    switch choice {
    | Some(Increase) => numsToValue(result.total + 1, voteData + 1)
    | Some(Decrease) => numsToValue(result.total + 1, voteData)
    | None => numsToValue(result.total, voteData)
    }
  }

  Color.rgb(
    getValue(choices.red, result.red),
    getValue(choices.green, result.green),
    getValue(choices.blue, result.blue),
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
