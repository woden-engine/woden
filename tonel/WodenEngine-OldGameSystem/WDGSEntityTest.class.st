"
A WTGSEntityTest is a test class for testing the behavior of WTGSEntity
"
Class {
	#name : #WDGSEntityTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-OldGameSystem-Tests'
}

{ #category : #tests }
WDGSEntityTest >> testAddComponent [
	| entity component |
	entity := WDGSEntity new.
	component := WDGSComponent new.
	entity addComponent: component.
	self assert: entity numberOfComponents equals: 1.
	self assert: component entity equals: entity.
	
]

{ #category : #tests }
WDGSEntityTest >> testNew [
	| entity |
	entity := WDGSEntity new.
	self assert: entity numberOfComponents equals: 0.
]
