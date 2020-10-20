Class {
	#name : #WDEVector2Property,
	#superclass : #WDEStringProperty,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #'as yet unclassified' }
WDEVector2Property >> formatValue: value [
	^ '{1} {2}' format: {value x . value y}
]

{ #category : #parsing }
WDEVector2Property >> parseText: text [
	| components |
	components := (text splitOn: ' ') collect: [ :each | each asNumber ].
	self assert: components size = 2.
	^ Float32x2 x: components first y: components second
]
