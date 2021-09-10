open Types

@react.component
let make = (~currentColor, ~cookieData) => {
  <>
    <h1 className="m-0 text-2xl font-bold text-all-3">
      {React.string(`투표에 참여해주셔서 감사합니다!`)}
    </h1>
    <p className="text-all-9">
      {React.string(`투표 참여 일시: ` ++ Js.Date.toLocaleString(cookieData.votedAt))}
      <br />
      {React.string(`투표는 9월 16일 0시에 종료됩니다.`)}
    </p>
    <Preview
      prevColor={cookieData.colorAtVote} currColor={currentColor} previewMode={Preview.AfterVote}
    />
  </>
}
