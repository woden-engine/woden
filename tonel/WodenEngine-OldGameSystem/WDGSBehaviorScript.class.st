Class {
	#name : #WDGSBehaviorScript,
	#superclass : #WDGSBehavior,
	#instVars : [
		'spawnCode',
		'spawnMethod'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'as yet unclassified' }
WDGSBehaviorScript class >> compileScript: aSourceCode [
	^ Smalltalk compiler
		class: WDGSBehavior;
		compile: aSourceCode
]

{ #category : #'as yet unclassified' }
WDGSBehaviorScript class >> jsonTypeName [
	^ 'behavior-script'
]

{ #category : #serialization }
WDGSBehaviorScript >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'type' . 'behavior-script' .
		'spaw-code' . spawnCode
	}
]

{ #category : #initialization }
WDGSBehaviorScript >> initialize [
	super initialize.
	spawnCode := ''
]

{ #category : #serialization }
WDGSBehaviorScript >> loadFromJson: jsonData [
	self spawnCode: (jsonData at: 'spawn-code' ifAbsent: [''] )
]

{ #category : #'map events' }
WDGSBehaviorScript >> spawn [
	spawnMethod ifNil: [ ^ self ].
	spawnMethod valueWithReceiver: self arguments: #()

]

{ #category : #accessing }
WDGSBehaviorScript >> spawnCode [
	^ spawnCode
]

{ #category : #accessing }
WDGSBehaviorScript >> spawnCode: aSourceCode [
	spawnMethod := self class compileScript: aSourceCode. 
	spawnCode := aSourceCode.
]
