open Bindings
open Types

type state = {
  voteResult: option<voteResult>,
  choices: choices,
  currColor: Color.t,
  candColor: Color.t,
  indecColors: indecColors,
}

@react.component
let make = () => {
  let db = React.useContext(FirebaseContext.context)
  let (state, setState) = React.useState(() => {
    voteResult: None,
    choices: {
      red: None,
      green: None,
      blue: None,
    },
    currColor: Color.rgb(127, 127, 127),
    candColor: Color.rgb(127, 127, 127),
    indecColors: {
      red: {
        onIncrease: Color.rgb(127, 127, 127),
        onDecrease: Color.rgb(127, 127, 127),
      },
      green: {
        onIncrease: Color.rgb(127, 127, 127),
        onDecrease: Color.rgb(127, 127, 127),
      },
      blue: {
        onIncrease: Color.rgb(127, 127, 127),
        onDecrease: Color.rgb(127, 127, 127),
      },
    },
  })

  React.useEffect1(() => {
    let unsub = Firestore.onSnapshot(Firestore.doc(db, "main", "voteResult"), (
      doc: Firestore.documentSnapshot<voteResult>,
    ) => {
      setState(prev => {...prev, voteResult: Firestore.data(doc)})
    })

    Some(() => unsub())
  }, [db])

  React.useEffect2(() => {
    Belt.Option.forEach(state.voteResult, voteResult => {
      let currColor = Calc.currColor(voteResult)
      let candColor = Calc.getCandidateColor(voteResult, state.choices)
      let indecColors = Calc.getIndecColors(candColor, voteResult)

      setState(old => {
        ...old,
        currColor: currColor,
        candColor: candColor,
        indecColors: indecColors,
      })
    })

    None
  }, (state.voteResult, state.choices))

  let getRedUpdater = React.useCallback1(incOrDec => {
    _ => setState(old => {...old, choices: {...old.choices, red: Some(incOrDec)}})
  }, [setState])
  let getGreenUpdater = React.useCallback1(incOrDec => {
    _ => setState(old => {...old, choices: {...old.choices, green: Some(incOrDec)}})
  }, [setState])
  let getBlueUpdater = React.useCallback1(incOrDec => {
    _ => setState(old => {...old, choices: {...old.choices, blue: Some(incOrDec)}})
  }, [setState])

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
      decColor={state.indecColors.red.onDecrease}
      incColor={state.indecColors.red.onIncrease}
      candColor={state.candColor}
      choice={state.choices.red}
      onIncrease={getRedUpdater(Increase)}
      onDecrease={getRedUpdater(Decrease)}
    />
    <VoteItem
      title={`G (초록)`}
      decColor={state.indecColors.green.onDecrease}
      incColor={state.indecColors.green.onIncrease}
      candColor={state.candColor}
      choice={state.choices.green}
      onIncrease={getGreenUpdater(Increase)}
      onDecrease={getGreenUpdater(Decrease)}
    />
    <VoteItem
      title={`B (파랑)`}
      decColor={state.indecColors.blue.onDecrease}
      incColor={state.indecColors.blue.onIncrease}
      candColor={state.candColor}
      choice={state.choices.blue}
      onIncrease={getBlueUpdater(Increase)}
      onDecrease={getBlueUpdater(Decrease)}
    />
    <Separator />
    <Preview currentColor={state.currColor} candidateColor={state.candColor} />
  </main>
}
