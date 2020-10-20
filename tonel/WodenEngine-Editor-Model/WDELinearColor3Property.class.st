Class {
	#name : #WDELinearColor3Property,
	#superclass : #WDEProperty,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #parsing }
WDELinearColor3Property >> parseText: text [
	| components |
	components := (text splitOn: ' ') collect: [ :each | each asNumber ].
	self assert: components size = 3.
	^ Float32x3 x: components first y: components second z: components third
]
