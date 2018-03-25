"
A RWPopupTest is a test class for testing the behavior of RWPopup
"
Class {
	#name : #RWPopupTest,
	#superclass : #TestCase,
	#category : 'Woden2-Roassal-Tests'
}

{ #category : #tests }
RWPopupTest >> testBasic [

	| popup |
	popup := RWPopup new.
	self assert: (popup textFor: (RWElement new model: 'hello')) equals: 'hello'.
]

{ #category : #tests }
RWPopupTest >> testBasicOnNil [

	| popup |
	popup := RWPopup new.
	self assert: (popup textFor: RWElement new) equals: 'nil'.
]
