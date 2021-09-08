@react.component
let make = (~candidateColor) => {
  let candidateStyle = ReactDOM.Style.make(~background=Color.toString(candidateColor), ())

  <section className="my-10">
    <div className="mx-auto rounded-full w-24 h-24" style={candidateStyle} />
    <h2 className="text-all-3 font-medium text-2xl"> {React.string(`당신의 투표로...`)} </h2>
    <p className="m-0 font-light text-all-3">{React.string(j`빨간색이 % 합니다.`)}</p>
    <p className="m-0 font-light text-all-3">{React.string(j`초록색이 % 합니다.`)}</p>
    <p className="m-0 font-light text-all-3">{React.string(j`파란색이 % 합니다.`)}</p>
    <p className="m-0 font-light text-all-3">{React.string(j`채도가 % 합니다.`)}</p>
    <p className="m-0 font-light text-all-3">{React.string(j`명도가 % 합니다.`)}</p>
    <button className="rounded-lg bg-myBlue my-4 px-14 py-2 text-all-E text-lg shadow filter hover:brightness-110 focus:brightness-125 transition-all cursor-pointer">
      {React.string(`투표 완료하기`)}
    </button>
  </section>
}
