open Bindings
open Types

type previewMode = BeforeSubmit(ReactEvent.Mouse.t => unit) | AfterVote

@react.component
let make = (~prevColor, ~currColor, ~previewMode) => {
  let currStyle = ReactDOM.Style.make(~background=Color.toString(currColor), ())

  let statistics = Calc.getStatistics(prevColor, currColor)

  let buildDesc = (nameWithJosa, change) => {
    let {perc, direction} = change
    let directionMsg = switch direction {
    | Increase => `증가`
    | Decrease => `감소`
    }
    let ending = switch previewMode {
    | BeforeSubmit(_) => `합니다`
    | AfterVote => `했습니다`
    }

    <p className="m-0 font-light text-all-3">
      {React.string(j`${nameWithJosa} $perc% ${directionMsg}${ending}.`)}
    </p>
  }

  <section className="my-10">
    <div
      className="mx-auto rounded-full w-24 h-24 transition-colors duration-500" style={currStyle}
    />
    <h2 className="text-all-3 font-medium text-2xl">
      {switch previewMode {
      | BeforeSubmit(_) => React.string(`당신의 투표로...`)
      | AfterVote => React.string(`투표하신 이후로...`)
      }}
    </h2>
    {buildDesc(`빨간색이`, statistics.red)}
    {buildDesc(`초록색이`, statistics.green)}
    {buildDesc(`파란색이`, statistics.blue)}
    {buildDesc(`채도가`, statistics.saturation)}
    {buildDesc(`명도가`, statistics.lightness)}
    {switch previewMode {
    | BeforeSubmit(onSubmit) =>
      <button
        className="rounded-lg bg-myBlue my-4 px-14 py-2 text-all-E text-lg shadow filter hover:brightness-110 focus:brightness-125 transition-all cursor-pointer"
        onClick={onSubmit}>
        {React.string(`투표 완료하기`)}
      </button>
    | AfterVote => React.null
    }}
  </section>
}
