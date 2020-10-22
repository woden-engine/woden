Class {
	#name : #WDELinearColor4Property,
	#superclass : #WDELinearColor3Property,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #'as yet unclassified' }
WDELinearColor4Property >> formatValue: value [
	^ '{1} {2} {3} {4}' format: {value x . value y . value z . value w}
]

{ #category : #parsing }
WDELinearColor4Property >> parseText: text [
	| components |
	components := (text splitOn: ' ') collect: [ :each | each asNumber ].
	self assert: components size = 4.
	^ Float32x4 x: components first y: components second z: components third w: components fourth
]
