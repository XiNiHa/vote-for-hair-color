type t

@module("color") external rgb: (int, int, int) => t = "rgb"

@send external toString: t => string = "string"
