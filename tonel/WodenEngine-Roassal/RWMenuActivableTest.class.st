Class {
	#name : #RWMenuActivableTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-Roassal-Tests'
}

{ #category : #tests }
RWMenuActivableTest >> testHasInteraction [

	| e |
	e := RWElement new.
	self deny: (e hasInteraction: RWMenuActivable).
	e @ RWMenuActivable.
	self assert: (e hasInteraction: RWMenuActivable).
]
