"
A WTGSMapTest is a test class for testing the behavior of WTGSMap
"
Class {
	#name : #WDGSMapTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-OldGameSystem-Tests'
}

{ #category : #tests }
WDGSMapTest >> testAddEntity [
	| map entity |
	map := WDGSMap new.
	entity := WDGSEntity new.
	map addEntity: entity.
	self assert: map numberOfEntities equals: 1.
	self assert: map entities first equals: entity.
	self assert: entity map equals: map.
]

{ #category : #tests }
WDGSMapTest >> testNew [
	| map |
	map := WDGSMap new.
	self assert: map numberOfEntities equals: 0.
]
