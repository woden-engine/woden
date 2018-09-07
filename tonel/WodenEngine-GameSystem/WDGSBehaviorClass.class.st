Class {
	#name : #WDGSBehaviorClass,
	#superclass : #WDGSBehavior,
	#instVars : [
		'behaviorClassName'
	],
	#category : #'WodenEngine-GameSystem-Level'
}

{ #category : #serialization }
WDGSBehaviorClass class >> jsonTypeName [
	^ 'behavior-class'
]

{ #category : #serialization }
WDGSBehaviorClass >> asJsonData [
	^ OrderedDictionary newFromPairs: { 
		'type' . 'behavior-class' .
		'class' . behaviorClassName
	}
]

{ #category : #accessing }
WDGSBehaviorClass >> behaviorClassName [
	^ behaviorClassName
]

{ #category : #accessing }
WDGSBehaviorClass >> behaviorClassName: anObject [
	behaviorClassName := anObject asSymbol
]

{ #category : #'as yet unclassified' }
WDGSBehaviorClass >> bucket [
	^ #'behavior-factory'
]

{ #category : #initialization }
WDGSBehaviorClass >> initialize [
	super initialize.
	behaviorClassName := '' asSymbol.
]

{ #category : #serialization }
WDGSBehaviorClass >> loadFromJson: jsonData [
	self behaviorClassName: (jsonData at: 'class' ifAbsent: [''])
]

{ #category : #'map events' }
WDGSBehaviorClass >> spawn [
	| behaviorClass behavior |
	behaviorClass := Smalltalk at: behaviorClassName ifAbsent: [ ^ self ].
	behavior := behaviorClass new.
	entity addComponent: behavior
]
