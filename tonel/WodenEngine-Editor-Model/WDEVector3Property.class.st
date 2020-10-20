Class {
	#name : #WDEVector3Property,
	#superclass : #WDEStringProperty,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #'as yet unclassified' }
WDEVector3Property >> formatValue: value [
	^ '{1} {2} {3}' format: {value x . value y . value z}
]

{ #category : #parsing }
WDEVector3Property >> parseText: text [
	| components |
	components := (text splitOn: ' ') collect: [ :each | each asNumber ].
	self assert: components size = 3.
	^ Float32x3 x: components first y: components second z: components third
]
