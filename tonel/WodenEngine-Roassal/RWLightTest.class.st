"
A RWLightTest is a test class for testing the behavior of RWLight
"
Class {
	#name : #RWLightTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #'as yet unclassified' }
RWLightTest >> testCastShadows [
	| light |
	light := RWSpotLight new.
	light castShadows: true.
	self assert: light castShadows
]

{ #category : #'as yet unclassified' }
RWLightTest >> testChangeColor [
	| light |
	light := RWSpotLight new.
	light color: Color red.
	self assert: (light color closeTo: Color red).
	self assert: (light diffuse closeTo: Color red).
	self assert: (light specular closeTo: Color red).

]

{ #category : #'as yet unclassified' }
RWLightTest >> testNew [
	| light |
	light := RWSpotLight new.
	self assert: (light diffuse closeTo: Color lightGray).
	self assert: (light specular closeTo: Color lightGray).
	self assert: light castShadows not.
	self assert: light influenceRadius > 0.
]
