"
A WTSNodeTest is a test class for testing the behavior of WTSNode
"
Class {
	#name : #WTSNodeTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Scene-Tests'
}

{ #category : #tests }
WTSNodeTest >> testAddChild [
	| node child |
	node := WTSNode new.
	child := WTSNode new.
	node addChild: child.
	self assert: node numberOfChildren equals: 1.
]

{ #category : #tests }
WTSNodeTest >> testNew [
	| node |
	node := WTSNode new.
	self assert: node numberOfChildren equals: 0.
	self assert: node transform isNotNil.
	self assert: node scene isNil.
	self assert: node visible.
]
