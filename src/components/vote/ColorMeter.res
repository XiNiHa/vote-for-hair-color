open Bindings
open Types

type opacity = [#0 | #1]

type prevGradientStyle = {
  opacity: opacity,
  style: ReactDOM.Style.t,
}

type gradientStyle = {curr: ReactDOM.Style.t, prev: prevGradientStyle}

let buildBg = (decColorStr, incColorStr) =>
  ReactDOM.Style.make(
    ~background=`linear-gradient(90deg, ${decColorStr} 0%, ${incColorStr} 100%)`,
    (),
  )

@react.component
let make = (
  ~decColor: Color.t,
  ~incColor: Color.t,
  ~candColor: Color.t,
  ~choice: option<incOrDec>,
) => {
  let (decColorStr, incColorStr) = (Color.toString(decColor), Color.toString(incColor))
  let (gradientStyle, setGradientStyle) = React.useState(() => {
    prev: {
      opacity: #1,
      style: buildBg(decColorStr, incColorStr),
    },
    curr: buildBg(decColorStr, incColorStr),
  })
  let setGradientStyleRef = React.useRef(setGradientStyle)
  let circleContainerStyle = ReactDOM.Style.make(
    ~marginLeft={
      switch choice {
      | Some(Decrease) => "0"
      | Some(Increase) => "100%"
      | None => "50%"
      }
    },
    (),
  )
  let circleStyle = ReactDOM.Style.make(~background=Color.toString(candColor), ())

  let patchedStyle = ReactDOM.Style.combine(
    gradientStyle.prev.style,
    ReactDOM.Style.make(
      ~opacity=Js.String.make(gradientStyle.prev.opacity),
      ~visibility=gradientStyle.prev.opacity == #1 ? "hidden" : "unset",
      (),
    ),
  )

  React.useEffect1(() => {
    setGradientStyleRef.current = setGradientStyle
    None
  }, [setGradientStyle])

  React.useEffect2(() => {
    setGradientStyle(old => {
      prev: {
        opacity: #0,
        style: old.curr,
      },
      curr: buildBg(decColorStr, incColorStr),
    })

    let timeout = Js.Global.setTimeout(() => {
      setGradientStyleRef.current(old => {
        ...old,
        prev: {
          ...old.prev,
          opacity: #1,
        },
      })
    }, 500)

    Some(() => Js.Global.clearTimeout(timeout))
  }, (decColorStr, incColorStr))

  <div className="my-4 py-10">
    <div
      className="relative overflow-visible flex items-center h-7 mx-4 rounded-full transition-all duration-500"
      style={gradientStyle.curr}>
      {<div
        className="absolute inset-0 rounded-full transition-opacity duration-500"
        style={patchedStyle}
      />}
      <div className="z-10 transition-all duration-500" style={circleContainerStyle}>
        <div
          className="w-20 h-20 -ml-[50%] rounded-full transition-colors duration-500"
          style={circleStyle}
        />
      </div>
    </div>
  </div>
}
