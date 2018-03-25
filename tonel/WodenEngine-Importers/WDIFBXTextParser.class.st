Class {
	#name : #WDIFBXTextParser,
	#superclass : #WDIFBXTextGrammar,
	#category : 'WodenEngine-Importers'
}

{ #category : #accessing }
WDIFBXTextParser >> attributes [
	^ super attributes ==> [ :tokens | { tokens first } , (tokens second collect: #second) ]
]

{ #category : #accessing }
WDIFBXTextParser >> identifier [
	^ super identifier ==> [ :token | token inputValue asSymbol ]
]

{ #category : #accessing }
WDIFBXTextParser >> node [
	^ super node ==> [ :tokens |
		WDIFBXNode new
			type: tokens first;
			attributes: tokens third;
			children: tokens fourth;
			yourself
	]
]

{ #category : #accessing }
WDIFBXTextParser >> number [
	^ super number ==> [ :token |
		| val |
		val := token inputValue.
		(val first = $+ ifTrue: [ val allButFirst ] ifFalse: [ val ]) asNumber
	]
]

{ #category : #accessing }
WDIFBXTextParser >> optionalAttributes [
	^ super optionalAttributes ==> [ :attr | attr ifNil: [ #() ] ]
]

{ #category : #accessing }
WDIFBXTextParser >> optionalNodeBody [
	^ super optionalNodeBody ==> [ :tokens |
		tokens ifNil: [ #() ] ifNotNil: [ tokens second ]
	]
]

{ #category : #accessing }
WDIFBXTextParser >> start [
	^ super start ==> [ :tokens |
			WDIFBXNode new
			type: #'__Root__';
			children: tokens first;
			yourself
	]
]

{ #category : #accessing }
WDIFBXTextParser >> string [
	^ super string ==> [ :token |
		| val |
		val := token inputValue.
		val copyFrom: 2 to: val size - 1
	]
]
