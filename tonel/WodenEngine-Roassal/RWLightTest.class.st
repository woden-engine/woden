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
	self assert: (light color asColor closeTo: Color red).
	self assert: (light diffuse asColor closeTo: Color red).
	self assert: (light specular asColor closeTo: Color red).

]

{ #category : #'as yet unclassified' }
RWLightTest >> testNew [
	| light |
	light := RWSpotLight new.
	self assert: (light diffuse asColor closeTo: Color white).
	self assert: (light specular asColor closeTo: Color white).
	self assert: light castShadows not.
	self assert: light influenceRadius > 0.
]
