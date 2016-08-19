*WodenMath-Core
encodeSRGBComponent
	"
	From: https://en.wikipedia.org/wiki/SRGB
	"
	| a |
	a := 0.055.
	^ self <= 0.0031308 ifTrue: [ self * 12.92 ] ifFalse: [ ((1.0 + a) * (self raisedTo: 1.0 / 2.4)) - a ]