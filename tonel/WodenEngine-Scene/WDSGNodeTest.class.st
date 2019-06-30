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
WDSGNodeTest >> testGlobalTransform [
	| parent child |
	parent := WDSGNode new.
	child := WDSGNode new.
	parent addChild: child.
	self assert: (child globalTransform closeTo: WMReversibleAffineTransformF identity).
	parent translateToX: 1.0 y: 2.0 z: 3.0.
	self assert: (child globalTransform translation closeTo: (WMVector3F x: 1.0 y: 2.0 z: 3.0)).

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
