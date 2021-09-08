open Types

@react.component
let make = (~title, ~decColor, ~incColor, ~candColor, ~choice, ~onIncrease=?, ~onDecrease=?) => {
  let callIfSome = target => {
    e => {
      switch target {
      | Some(f) => f(e)
      | None => ()
      }
    }
  }

  let (incBgClass, decBgClass) = switch choice {
  | Some(Increase) => ("bg-green-300", "bg-red-100 hover:bg-red-200")
  | Some(Decrease) => ("bg-green-100 hover:bg-green-200", "bg-red-300")
  | None => ("bg-green-100 hover:bg-green-200", "bg-red-100 hover:bg-red-200")
  }

  <section className="text-center py-4">
    <ColorMeter decColor={decColor} incColor={incColor} candColor={candColor} choice={choice} />
    <h2 className="font-medium text-2xl text-all-3"> {React.string(title)} </h2>
    <div className="flex justify-center my-2">
      <button
        className={"rounded-l-full shadow mx-2 w-2/5 py-1 text-all-5s transition-colors " ++
        decBgClass}
        onClick={callIfSome(onDecrease)}>
        {React.string(`감소`)}
      </button>
      <button
        className={"rounded-r-full shadow mx-2 w-2/5 py-1 text-all-5 transition-colors " ++
        incBgClass}
        onClick={callIfSome(onIncrease)}>
        {React.string(`증가`)}
      </button>
    </div>
  </section>
}
