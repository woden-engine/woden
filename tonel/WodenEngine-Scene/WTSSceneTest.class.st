"
A WTSSceneTest is a test class for testing the behavior of WTSScene
"
Class {
	#name : #WTSSceneTest,
	#superclass : #TestCase,
	#category : 'WodenEngine-Scene-Tests'
}

{ #category : #'as yet unclassified' }
WTSSceneTest >> testAddRoot [
	| scene root |
	scene := WTSScene new.
	root := WTSNode new.
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.
]

{ #category : #'as yet unclassified' }
WTSSceneTest >> testAddRootAndChild [
	| scene root child |
	scene := WTSScene new.
	root := WTSNode new.
	child := WTSNode new.
	
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.

	self assert: child scene equals: nil.
	root addChild: child.
	self assert: child scene equals: scene.
]

{ #category : #'as yet unclassified' }
WTSSceneTest >> testAddRootWithChildren [
	| scene root child |
	scene := WTSScene new.
	root := WTSNode new.
	child := WTSNode new.
	root addChild: child.
	
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.
	self assert: child scene equals: scene.
]

{ #category : #'as yet unclassified' }
WTSSceneTest >> testNew [
	| scene |
	scene := WTSScene new.
	self assert: scene numberOfRoots equals: 0.
	self assert: scene backgroundColor isColor.
]
