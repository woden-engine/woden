rendering dispatch
fillTextSegments: firstSegment withSolidColor: aColor
	| currentSegment font string |
	currentSegment := firstSegment.
	[ currentSegment isNotNil ] whileTrue: [
		currentSegment isTextSegment ifTrue: [
			font := currentSegment font asLodenFontFor: engine.
			string := currentSegment string.
			pathTransform restoreAfter: [
				pathTransform translateBy: currentSegment endPoint.
				self renderLodenFont: font color: aColor characters: string from: 1 to: string size
			]
		].
	 
		currentSegment := currentSegment next
	]