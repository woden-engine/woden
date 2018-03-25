Class {
	#name : #WTGSBehaviorScript,
	#superclass : #WTGSBehavior,
	#instVars : [
		'spawnCode',
		'spawnMethod'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'as yet unclassified' }
WTGSBehaviorScript class >> compileScript: aSourceCode [
	^ Smalltalk compiler
		class: WTGSBehavior;
		compile: aSourceCode
]

{ #category : #'as yet unclassified' }
WTGSBehaviorScript class >> jsonTypeName [
	^ 'behavior-script'
]

{ #category : #serialization }
WTGSBehaviorScript >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'type' . 'behavior-script' .
		'spaw-code' . spawnCode
	}
]

{ #category : #initialization }
WTGSBehaviorScript >> initialize [
	super initialize.
	spawnCode := ''
]

{ #category : #serialization }
WTGSBehaviorScript >> loadFromJson: jsonData [
	self spawnCode: (jsonData at: 'spawn-code' ifAbsent: [''] )
]

{ #category : #'map events' }
WTGSBehaviorScript >> spawn [
	spawnMethod ifNil: [ ^ self ].
	spawnMethod valueWithReceiver: self arguments: #()

]

{ #category : #accessing }
WTGSBehaviorScript >> spawnCode [
	^ spawnCode
]

{ #category : #accessing }
WTGSBehaviorScript >> spawnCode: aSourceCode [
	spawnMethod := self class compileScript: aSourceCode. 
	spawnCode := aSourceCode.
]
