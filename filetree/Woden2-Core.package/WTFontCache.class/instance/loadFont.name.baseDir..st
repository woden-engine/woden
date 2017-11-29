as yet unclassified
loadFont: fontData name: fontName baseDir: baseDir
	| faces face font |
	faces := fontData at: 'faces' ifAbsent: [ ^ self ].
	font := WTFont new name: fontName.
	faces keysAndValuesDo: [ :faceName :faceData |
		face := self loadFontFace: faceData name: faceName baseDir: baseDir.
		face ifNotNil: [ 
			font addFace: face.
		]
	].

	fonts at: font name put: font