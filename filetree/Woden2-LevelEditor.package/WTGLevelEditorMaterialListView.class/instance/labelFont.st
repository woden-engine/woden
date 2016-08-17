accessing
labelFont
	labelFont ifNil: [ labelFont := self engine fontCache default normal pointSize: 14 ].
	^ labelFont