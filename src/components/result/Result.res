open Bindings

@react.component
let make = (~finalColor, ~voteResult: option<Types.voteResult>) => {
  let finalStyle = ReactDOM.Style.make(~background=Color.toString(finalColor), ())

  <>
    <div
      className="mx-auto rounded-full w-24 h-24 transition-colors duration-500" style={finalStyle}
    />
    <h1 className="m-0 my-4 text-2xl font-bold text-all-3">
      {React.string(`투표가 종료되었습니다.`)}
    </h1>
    <p className="text-all-9">
      {React.string(`선정된 색은 "${finalColor->Color.toString}"입니다.`)}
    </p>
    <p className="text-all-9">
      {React.string(`투표 결과는 다음과 같습니다:`)}
      <br />
      {switch voteResult {
      | Some(voteResult) => {
          let redInc = voteResult.redInc
          let redDec = voteResult.redVotes - redInc
          let greenInc = voteResult.greenInc
          let greenDec = voteResult.greenVotes - greenInc
          let blueInc = voteResult.blueInc
          let blueDec = voteResult.blueVotes - blueInc

          <>
            {React.string(j`빨강: 증가 $redInc회, 감소 $redDec회`)}
            <br />
            {React.string(j`초록: 증가 $greenInc회, 감소 $greenDec회`)}
            <br />
            {React.string(j`파랑: 증가 $blueInc회, 감소 $blueDec회`)}
            <br />
          </>
        }
      | None => React.null
      }}
    </p>
  </>
}
