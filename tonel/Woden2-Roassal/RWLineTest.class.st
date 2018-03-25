Class {
	#name : #RWLineTest,
	#superclass : #TestCase,
	#category : 'Woden2-Roassal-Tests'
}

{ #category : #tests }
RWLineTest >> testColor [

	| l |
	l := RWLine new.
	self assert: (l colorFor: nil) equals: l defaultColor
]
