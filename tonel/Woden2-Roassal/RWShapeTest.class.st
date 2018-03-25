"
A RWShapeTest is a test class for testing the behavior of RWShape
"
Class {
	#name : #RWShapeTest,
	#superclass : #TestCase,
	#instVars : [
		'cube',
		'element'
	],
	#category : 'Woden2-Roassal-Tests'
}

{ #category : #running }
RWShapeTest >> setUp [

	super setUp.
	cube := RWCube new.
	element := RWElement new.

]

{ #category : #tests }
RWShapeTest >> testBasic [

	self assert: (cube colorFor: element) class equals: Color.
	self assert: cube isOpaque.
	self deny: cube isTranslucent.
	self deny: cube isAlphaOverTranslucent.
]

{ #category : #tests }
RWShapeTest >> testMakeAlphaOverTranslucent [

	self assert: cube isOpaque.
	cube alphaOverTranslucent.
	self deny: cube isOpaque.
	self deny: cube isTranslucent.
	self assert: cube isAlphaOverTranslucent.

]

{ #category : #tests }
RWShapeTest >> testMakeTranslucent [

	self assert: cube isOpaque.
	cube translucent.
	self deny: cube isOpaque.
	self assert: cube isTranslucent.

]

{ #category : #tests }
RWShapeTest >> testSettingPharoColor [

	cube color: Color black.
	self assert: (cube colorFor: element) class equals: Color
]

{ #category : #tests }
RWShapeTest >> testSettingWDColor [

	cube color: Color black.
	self assert: (cube colorFor: element) class equals: Color
]
