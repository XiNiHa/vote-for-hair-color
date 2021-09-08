@react.component
let make = (~no: int, ~children=React.null) => {
  <li className="block flex flex-col items-center">
    <div
      className="bg-myBlue w-16 h-16 my-3 rounded-full shadow text-all-E flex items-center justify-center text-2xl">
      {React.int(no)}
    </div>
    <p className="my-3 text-sm text-all-3"> {children} </p>
  </li>
}
