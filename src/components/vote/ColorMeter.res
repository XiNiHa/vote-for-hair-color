@react.component
let make = (~decColor: Color.t, ~incColor: Color.t, ~currColor: Color.t) => {
  let decColorStr = Color.toString(decColor)
  let incColorStr = Color.toString(incColor)
  let gradientStyle = ReactDOM.Style.make(
    ~background=`linear-gradient(90deg, ${decColorStr} 0%, ${incColorStr} 100%)`,
    (),
  )
  let circleStyle = ReactDOM.Style.make(~background=Color.toString(currColor), ())

  <div className="my-4 py-10">
    <div
      className="overflow-visible flex justify-center items-center h-7 mx-4 rounded-full"
      style={gradientStyle}>
      <div className="w-20 h-20 rounded-full" style={circleStyle} />
    </div>
  </div>
}
