open Bindings
open Types

@val @scope("import.meta.env") external functionURL: string = "VITE_FIREBASE_FUNCTION_URL"

type state = {
  voteResult: option<voteResult>,
  voteEndAt: Js.Date.t,
  choices: choices,
  currColor: Color.t,
  candColor: Color.t,
  indecColors: indecColors,
}

exception FetchFailed(int, string)

@react.component
let make = () => {
  let db = React.useContext(FirebaseContext.context)
  let {setModal} = React.useContext(ModalContext.context)

  let (state, setState) = React.useState(() => {
    voteResult: None,
    voteEndAt: Js.Date.fromFloat(1631718000000.0),
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
        voteEndAt: Js.Date.fromFloat(voteResult.voteEndAt.seconds *. 1000.0),
        currColor: currColor,
        candColor: candColor,
        indecColors: indecColors,
      })
    })

    None
  }, (state.voteResult, state.choices))

  let getRedUpdater = React.useCallback1(incOrDec => {
    _ =>
      setState(old => {
        if old.choices.red === Some(incOrDec) {
          {...old, choices: {...old.choices, red: None}}
        } else {
          {...old, choices: {...old.choices, red: Some(incOrDec)}}
        }
      })
  }, [setState])
  let getGreenUpdater = React.useCallback1(incOrDec => {
    _ =>
      setState(old => {
        if old.choices.green === Some(incOrDec) {
          {...old, choices: {...old.choices, green: None}}
        } else {
          {...old, choices: {...old.choices, green: Some(incOrDec)}}
        }
      })
  }, [setState])
  let getBlueUpdater = React.useCallback1(incOrDec => {
    _ =>
      setState(old => {
        if old.choices.blue === Some(incOrDec) {
          {...old, choices: {...old.choices, blue: None}}
        } else {
          {...old, choices: {...old.choices, blue: Some(incOrDec)}}
        }
      })
  }, [setState])

  let choiceToBool = choice => Belt.Option.map(choice, choice => choice == Types.Increase)

  let onSubmit = React.useCallback2(_ => {
    setModal(_ => Some(<Spinner />))
    Fetch.fetchWithInit(
      functionURL,
      Fetch.RequestInit.make(
        ~method_=Post,
        ~body=Fetch.BodyInit.make(
          {
            "red": state.choices.red->choiceToBool,
            "green": state.choices.green->choiceToBool,
            "blue": state.choices.blue->choiceToBool,
          }
          ->Js.Json.stringifyAny
          ->Belt.Option.getUnsafe,
        ),
        (),
      ),
    )
    ->Promise.then(res => {
      if Fetch.Response.ok(res) {
        Fetch.Response.json(res)
      } else {
        Promise.reject(FetchFailed(Fetch.Response.status(res), Fetch.Response.statusText(res)))
      }
    })
    ->Promise.thenResolve(response =>
      response
      ->Js.Json.decodeObject
      ->Belt.Option.getUnsafe
      ->Js.Dict.unsafeGet("success")
      ->(
        success => {
          if Js.Json.decodeBoolean(success)->Belt.Option.getWithDefault(false) {
            DocumentCookie.d.cookie = Cookie.serialize(
              ~name="votedAt",
              ~value=Js.Date.make()->Js.Date.toISOString,
              (),
            )
            DocumentCookie.d.cookie = Cookie.serialize(
              ~name="colorAtVote",
              ~value=state.candColor->Color.toString,
              (),
            )
            setModal(_ => Some(
              <p className="text-center text-lg">
                {React.string(`투표가 완료되었습니다.`)}
              </p>,
            ))
          }
          ()
        }
      )
    )
    ->Promise.catch(e =>
      switch e {
      | FetchFailed(410, _) =>
        Promise.resolve(
          setModal(_ => Some(
            <p className="text-center text-lg">
              {React.string(`투표가 이미 종료되었습니다.`)}
              <br />
              {React.string(`새로고침하여 결과를 확인해 주세요.`)}
            </p>,
          )),
        )
      | _ =>
        Promise.resolve(
          setModal(_ => Some(
            <p className="text-center text-lg">
              {React.string(`투표 완료 중 에러가 발생하였습니다.`)}
              <br />
              {React.string(`다시 시도해 주세요.`)}
            </p>,
          )),
        )
      }
    )
    ->ignore
    ()
  }, (state, setModal))

  let cookieData = Cookie.parse(~str=DocumentCookie.d.cookie, ())->mapCookie
  let voteEnded = state.voteEndAt->Js.Date.getTime <= Js.Date.now()

  <main
    className="mx-auto px-2 py-32 max-w-xl text-center font-sans keep-words w-screen overflow-x-hidden">
    {switch (voteEnded, cookieData) {
    | (true, _) => <Result finalColor={state.currColor} voteResult={state.voteResult} />
    | (false, Some(cookieData)) =>
      <Status currentColor={state.currColor} cookieData={cookieData} voteEndAt={state.voteEndAt} />
    | (false, None) => <>
        <picture>
          <source srcSet="https://firebasestorage.googleapis.com/v0/b/vote-for-hair-color.appspot.com/o/KakaoTalk_Photo_2021-09-13-19-56-34.webp?alt=media&token=d04a02ae-ca6a-40b9-935f-4bb6aa82815f" type_="image/webp" />
          <source srcSet="https://firebasestorage.googleapis.com/v0/b/vote-for-hair-color.appspot.com/o/KakaoTalk_Photo_2021-09-13-19-56-34.png?alt=media&token=ef47c35f-bf2d-4461-80b0-f8cea3f54ad9" type_="image/png" />
          <img
            src="https://firebasestorage.googleapis.com/v0/b/vote-for-hair-color.appspot.com/o/KakaoTalk_Photo_2021-09-13-19-56-34.png?alt=media&token=ef47c35f-bf2d-4461-80b0-f8cea3f54ad9"
            width="2379"
            height="1784"
            className="w-full h-min object-contain" />
        </picture>
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
        <Guide voteEndAt={state.voteEndAt} />
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
        <Preview
          prevColor={state.currColor}
          currColor={state.candColor}
          previewMode={Preview.BeforeSubmit(onSubmit)}
        />
      </>
    }}
  </main>
}
