open Bindings
open Types

let numsToValue = (total, inc) => {
  (Belt.Float.fromInt(inc) /. Belt.Float.fromInt(total) *. 255.0)->Belt.Float.toInt
}

let currColor = result => {
  Color.rgb(
    numsToValue(result.total, result.red.increase),
    numsToValue(result.total, result.green.increase),
    numsToValue(result.total, result.blue.increase),
  )
}

let getIndecColors = (candColor, result) => {
  {
    red: {
      onDecrease: Color.setRed(candColor, numsToValue(result.total + 1, result.red.increase)),
      onIncrease: Color.setRed(candColor, numsToValue(result.total + 1, result.red.increase + 1)),
    },
    green: {
      onDecrease: Color.setGreen(candColor, numsToValue(result.total + 1, result.green.increase)),
      onIncrease: Color.setGreen(
        candColor,
        numsToValue(result.total + 1, result.green.increase + 1),
      ),
    },
    blue: {
      onDecrease: Color.setBlue(candColor, numsToValue(result.total + 1, result.blue.increase)),
      onIncrease: Color.setBlue(candColor, numsToValue(result.total + 1, result.blue.increase + 1)),
    },
  }
}

let getCandidateColor = (result, choices: choices) => {
  let getValue = (choice, voteData) => {
    switch choice {
    | Some(Increase) => numsToValue(result.total + 1, voteData.increase + 1)
    | Some(Decrease) => numsToValue(result.total + 1, voteData.increase)
    | None => numsToValue(result.total, voteData.increase)
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
