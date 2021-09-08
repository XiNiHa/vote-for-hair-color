@react.component
let make = () => {
  <main className="mx-auto px-2 py-32 max-w-xl text-center font-sans keep-words">
    <SuggestionBoxIcon width="100" />
    <hgroup className="my-3">
      <h1 className="m-0 text-2xl font-bold text-all-3"> {React.string(`선택 2021:`)} </h1>
      <h2 className="m-0 text-lg leading-loose font-normal text-all-5">
        {React.string(`신의하의 머리색에 투표하세요`)}
      </h2>
    </hgroup>
    <Separator />
    <p className="text-sm text-all-5">
      {React.string(`마지막 탈색 이후 검은 머리가 너무 많이 자라서 염색을 하려고 하던 중이었는데, 색을 뭐로 하면 좋을지 모르겠어서 추천을 받아보려다 아예 투표를 하면 재밌겠다 싶어 진행하게 되었습니다.`)}
    </p>
    <Separator />
    <Guide />
    <Separator />
    <VoteItem
      title={`R (빨강)`}
      decColor={Color.rgb(0, 0, 0)}
      incColor={Color.rgb(255, 0, 0)}
      currColor={Color.rgb(127, 0, 0)}
    />
    <VoteItem
      title={`G (초록)`}
      decColor={Color.rgb(0, 0, 0)}
      incColor={Color.rgb(0, 255, 0)}
      currColor={Color.rgb(0, 127, 0)}
    />
    <VoteItem
      title={`B (파랑)`}
      decColor={Color.rgb(0, 0, 0)}
      incColor={Color.rgb(0, 0, 255)}
      currColor={Color.rgb(0, 0, 127)}
    />
    <Separator />
    <Preview candidateColor={Color.rgb(127, 127, 127)} />
  </main>
}
