Class {
	#name : #WDCAbstractSceneNode,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #enumerating }
WDCAbstractSceneNode >> allChildrenDo: aBlock [
	self childrenDo: [ :child |
		aBlock value: child.
		child allChildrenDo: aBlock
	]
]

{ #category : #drawing }
WDCAbstractSceneNode >> buildMeshOn: aMeshBuilder [
]

{ #category : #enumerating }
WDCAbstractSceneNode >> childrenDo: aBlock [
]

{ #category : #enumerating }
WDCAbstractSceneNode >> withAllChildrenDo: aBlock [
	aBlock value: self.
	self childrenDo: aBlock.
]
