Class {
	#name : #WTAthensTxCharacterSpanDisplayCommand,
	#superclass : #TxCharacterSpanDisplayCommand,
	#category : 'Woden2-Athens'
}

{ #category : #'as yet unclassified' }
WTAthensTxCharacterSpanDisplayCommand >> renderOn: renderer [

	| canvas glyphRenderer |
	canvas := renderer canvas.
	glyphRenderer := canvas setFont: (span getAttribute: TxFontAttribute).
	canvas setPaint: (span getAttribute: TxForeColorAttribute).
	
	glyphRenderer renderCharacters: span characters from: start to: stop.
	
	renderer advance:advance.
]
