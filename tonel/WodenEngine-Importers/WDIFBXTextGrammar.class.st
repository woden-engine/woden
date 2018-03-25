Class {
	#name : #WDIFBXTextGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'newline',
		'singleLineComment',
		'ignorable',
		'nodeBody',
		'node',
		'identifier',
		'colon',
		'attributes',
		'optionalNodeBody',
		'identStart',
		'identInner',
		'comma',
		'lbracket',
		'rbracket',
		'attribute',
		'string',
		'number',
		'optionalAttributes'
	],
	#category : 'WodenEngine-Importers'
}

{ #category : #accessing }
WDIFBXTextGrammar >> attribute [
	^ string / number / identifier
]

{ #category : #accessing }
WDIFBXTextGrammar >> attributes [
	^ attribute , (comma , attribute) star
]

{ #category : #accessing }
WDIFBXTextGrammar >> colon [
	^ self token: $: asParser
]

{ #category : #accessing }
WDIFBXTextGrammar >> comma [
	^ self token: $, asParser
]

{ #category : #accessing }
WDIFBXTextGrammar >> identInner [
	^ identStart / #digit asParser
]

{ #category : #accessing }
WDIFBXTextGrammar >> identStart [
	^ #letter asParser / $_ asParser
]

{ #category : #accessing }
WDIFBXTextGrammar >> identifier [
	^ self token: identStart , identInner star
]

{ #category : #ignorables }
WDIFBXTextGrammar >> ignorable [
	^ singleLineComment / #space asParser
]

{ #category : #accessing }
WDIFBXTextGrammar >> lbracket [
	^ self token: ${ asParser
]

{ #category : #ignorables }
WDIFBXTextGrammar >> newline [
	^ String crlf asParser / String cr asParser / String lf asParser
]

{ #category : #accessing }
WDIFBXTextGrammar >> node [
	^ identifier  , colon, optionalAttributes , optionalNodeBody
]

{ #category : #accessing }
WDIFBXTextGrammar >> nodeBody [
	^ node star
]

{ #category : #accessing }
WDIFBXTextGrammar >> number [
	^ self token: ($+ asParser / $- asParser) optional , #digit asParser plus, 
		($. asParser, #digit asParser plus) optional,
		(($e asParser / $E asParser) , ($+ asParser / $- asParser) optional, #digit asParser plus) optional
]

{ #category : #accessing }
WDIFBXTextGrammar >> optionalAttributes [
	^ attributes optional
]

{ #category : #accessing }
WDIFBXTextGrammar >> optionalNodeBody [
	^ (lbracket , nodeBody , rbracket) optional
]

{ #category : #accessing }
WDIFBXTextGrammar >> rbracket [
	^ self token: $} asParser
]

{ #category : #ignorables }
WDIFBXTextGrammar >> singleLineComment [
	^ $; asParser, newline negate star, newline
]

{ #category : #accessing }
WDIFBXTextGrammar >> start [
	^ nodeBody , #eof asParser
]

{ #category : #accessing }
WDIFBXTextGrammar >> string [
	^ self token: ($" asParser ,
		(($\ asParser, #any asParser) / $" asParser negate) star, 
		$" asParser
	)
	
]

{ #category : #'operators-mapping' }
WDIFBXTextGrammar >> token: aParser [
	^ aParser token trim: ignorable
]
