@react.component
let make = (~no: int, ~children=React.null) => {
  <li className="block flex flex-col items-center">
    <div
      className="bg-myBlue w-12 h-12 my-3 rounded-full shadow text-all-E flex items-center justify-center text-xl">
      {React.int(no)}
    </div>
    <p className="my-3 text-sm text-all-3"> {children} </p>
  </li>
}
