"
A WTGSMapTest is a test class for testing the behavior of WTGSMap
"
Class {
	#name : #WTGSMapTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-GameSystem-Tests'
}

{ #category : #tests }
WTGSMapTest >> testAddEntity [
	| map entity |
	map := WTGSMap new.
	entity := WTGSEntity new.
	map addEntity: entity.
	self assert: map numberOfEntities equals: 1.
	self assert: map entities first equals: entity.
	self assert: entity map equals: map.
]

{ #category : #tests }
WTGSMapTest >> testNew [
	| map |
	map := WTGSMap new.
	self assert: map numberOfEntities equals: 0.
]
