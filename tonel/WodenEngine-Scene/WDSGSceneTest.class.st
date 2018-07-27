"
A WTSSceneTest is a test class for testing the behavior of WTSScene
"
Class {
	#name : #WDSGSceneTest,
	#superclass : #TestCase,
	#category : #'WodenEngine-Scene-Tests'
}

{ #category : #'as yet unclassified' }
WDSGSceneTest >> testAddRoot [
	| scene root |
	scene := WDSGScene new.
	root := WDSGNode new.
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.
]

{ #category : #'as yet unclassified' }
WDSGSceneTest >> testAddRootAndChild [
	| scene root child |
	scene := WDSGScene new.
	root := WDSGNode new.
	child := WDSGNode new.
	
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.

	self assert: child scene equals: nil.
	root addChild: child.
	self assert: child scene equals: scene.
]

{ #category : #'as yet unclassified' }
WDSGSceneTest >> testAddRootWithChildren [
	| scene root child |
	scene := WDSGScene new.
	root := WDSGNode new.
	child := WDSGNode new.
	root addChild: child.
	
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.
	self assert: child scene equals: scene.
]

{ #category : #'as yet unclassified' }
WDSGSceneTest >> testNew [
	| scene |
	scene := WDSGScene new.
	self assert: scene numberOfRoots equals: 0.
	self assert: scene backgroundColor isColor.
]
