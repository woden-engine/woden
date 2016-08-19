*WodenMath-Core
decodeSRGBComponent
	"
	From: https://en.wikipedia.org/wiki/SRGB
	"
	| a |
	a := 0.055.
	^ self <= 0.04045 ifTrue: [ self / 12.92 ] ifFalse: [ ((self + a) / (1.0 + a)) raisedTo: 2.4 ]