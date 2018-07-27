"
A WTSNodeTest is a test class for testing the behavior of WTSNode
"
Class {
	#name : #WDSGNodeTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-Scene-Tests'
}

{ #category : #tests }
WDSGNodeTest >> testAddChild [
	| node child |
	node := WDSGNode new.
	child := WDSGNode new.
	node addChild: child.
	self assert: node numberOfChildren equals: 1.
]

{ #category : #tests }
WDSGNodeTest >> testNew [
	| node |
	node := WDSGNode new.
	self assert: node numberOfChildren equals: 0.
	self assert: node transform isNotNil.
	self assert: node scene isNil.
	self assert: node visible.
]
