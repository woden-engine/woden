Class {
	#name : #WDEQuaternionProperty,
	#superclass : #WDEStringProperty,
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #'as yet unclassified' }
WDEQuaternionProperty >> formatValue: value [
	^ '{1} {2} {3} {4}' format: {value x . value y . value z . value w}
]

{ #category : #parsing }
WDEQuaternionProperty >> parseText: text [
	| components |
	components := (text splitOn: ' ') collect: [ :each | each asNumber ].
	self assert: components size = 4.
	^ QuaternionF32 x: components first y: components second z: components third w: components fourth
]
