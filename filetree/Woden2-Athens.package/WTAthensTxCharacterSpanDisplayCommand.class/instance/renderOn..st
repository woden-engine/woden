as yet unclassified
renderOn: renderer

	| canvas glyphRenderer |
	canvas := renderer canvas.
	glyphRenderer := canvas setFont: (span getAttribute: TxFontAttribute).
	canvas setPaint: (span getAttribute: TxForeColorAttribute).
	
	glyphRenderer renderCharacters: span characters from: start to: stop.
	
	renderer advance:advance.