Class {
	#name : #RWLineTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #tests }
RWLineTest >> testColor [

	| l |
	l := RWLine new.
	self assert: (l colorFor: nil) equals: l defaultColor
]
