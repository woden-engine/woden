rendering dispatch
renderLodenFont: font characters: aString from: start to: end
	| color |
	color := currentCanvas paint isColor ifTrue: [ currentCanvas paint ] ifFalse: [ Color black ].
	^ self renderLodenFont: font color: color characters: aString from: start to: end