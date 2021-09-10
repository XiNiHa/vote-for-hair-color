type t

@module("color") external rgb: (int, int, int) => t = "rgb"
@module("color") external fromString: string => t = "default"

@send external toString: t => string = "string"

@send external setRed: (t, int) => t = "red"
@send external getRed: t => int = "red"
@send external setGreen: (t, int) => t = "green"
@send external getGreen: t => int = "green"
@send external setBlue: (t, int) => t = "blue"
@send external getBlue: t => int = "blue"
@send external getSaturationL: t => int = "saturationl"
@send external getLightness: t => int = "lightness"
