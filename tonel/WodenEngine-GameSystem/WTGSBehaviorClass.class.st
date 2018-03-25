Class {
	#name : #WTGSBehaviorClass,
	#superclass : #WTGSBehavior,
	#instVars : [
		'behaviorClassName'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #serialization }
WTGSBehaviorClass class >> jsonTypeName [
	^ 'behavior-class'
]

{ #category : #serialization }
WTGSBehaviorClass >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'type' . 'behavior-class' .
		'class' . behaviorClassName
	}
]

{ #category : #accessing }
WTGSBehaviorClass >> behaviorClassName [
	^ behaviorClassName
]

{ #category : #accessing }
WTGSBehaviorClass >> behaviorClassName: anObject [
	behaviorClassName := anObject asSymbol
]

{ #category : #'as yet unclassified' }
WTGSBehaviorClass >> bucket [
	^ #'behavior-factory'
]

{ #category : #initialization }
WTGSBehaviorClass >> initialize [
	super initialize.
	behaviorClassName := '' asSymbol.
]

{ #category : #serialization }
WTGSBehaviorClass >> loadFromJson: jsonData [
	self behaviorClassName: (jsonData at: 'class' ifAbsent: [''])
]

{ #category : #'map events' }
WTGSBehaviorClass >> spawn [
	| behaviorClass behavior |
	behaviorClass := Smalltalk at: behaviorClassName ifAbsent: [ ^ self ].
	behavior := behaviorClass new.
	entity addComponent: behavior.
	behavior spawn.
]
