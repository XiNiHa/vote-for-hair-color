@react.component
let make = (~voteEndAt) => {
  <section>
    <h2 className="font-medium text-all-3">
      {React.string(`투표 진행 방식 및 유의사항`)}
    </h2>
    <ul className="list-none p-0">
      <GuideItem no={1}>
        {React.string(`
투표는 R(빨강), G(초록), B(파랑)의 값에 대해 
각 값을 증가시킬지, 감소시킬지를 투표하는 
방식으로 이루어집니다.
        `)}
      </GuideItem>
      <GuideItem no={2}>
        {React.string(`
최종 색깔은 
(각 값의 증가 투표수 / 각 값의 전체 투표수)를
조합하여 결정되며, 투표를 제출하기 이전에
자신의 투표로 색깔이 어떻게 바뀌게 될지를
미리 확인해 볼 수 있습니다.
        `)}
      </GuideItem>
      <GuideItem no={3}>
        {React.string(`
투표는 ${voteEndAt->Js.Date.toLocaleString} 에 종료되며, 
최종 결과를 메인 페이지에서 확인하실 수 있습니다. 
또한, 각종 SNS를 통해서도 공지할 예정입니다.
        `)}
      </GuideItem>
      <GuideItem no={4}>
        {React.string(`
기본적으로 어떠한 투표 결과가 나오더라도 
해당 색으로 염색을 진행할 예정이지만, 
머리카락 염색의 특성상 머리가 녹을 위험이 있는 
과도하게 밝은 계통의 색이 선정될 경우 
비슷한 종류의 색 중 머리가 녹지 않는 선의 
밝기를 가진 색을 대신 선택하여 
염색을 진행할 것임을 안내드립니다.
        `)}
      </GuideItem>
      <GuideItem no={5}>
        {React.string(`
개인의 투표 기록은 쿠키를 통해서 판별하기 때문에, 
만약 저의 머리색에 진심이신 분들은 
브라우저 쿠키 초기화를 통해 투표를 
여러 번 진행할 수 있음을 알려드립니다.
        `)}
      </GuideItem>
    </ul>
  </section>
}
