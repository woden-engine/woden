"
A WTGSEntityTest is a test class for testing the behavior of WTGSEntity
"
Class {
	#name : #WTGSEntityTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-GameSystem-Tests'
}

{ #category : #tests }
WTGSEntityTest >> testAddComponent [
	| entity component |
	entity := WTGSEntity new.
	component := WTGSComponent new.
	entity addComponent: component.
	self assert: entity numberOfComponents equals: 1.
	self assert: component entity equals: entity.
	
]

{ #category : #tests }
WTGSEntityTest >> testNew [
	| entity |
	entity := WTGSEntity new.
	self assert: entity numberOfComponents equals: 0.
]
