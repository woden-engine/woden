Class {
	#name : #RWAbstractVisitor,
	#superclass : #Object,
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWAbstractVisitor >> visitAndCollectObjects: aCollectionOfObjects [
	^ aCollectionOfObjects collect: [:object | self visitObject: object ]
]

{ #category : #visiting }
RWAbstractVisitor >> visitCamera: element [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitConeShape: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitCubeShape: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitCylinderShape: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitDirectionalLight: element [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitEdge: element [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitElement: element [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitHighlightableInteraction: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitLight: element [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitLineShape: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitMenuActivableInteraction: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitMeshShape: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitNullShape: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitObject: object [
	^ object accept: self
]

{ #category : #visiting }
RWAbstractVisitor >> visitPointLight: element [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitPopupInteraction: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitPyramidShape: shape [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitSpotLight: element [
	self subclassResponsibility
]

{ #category : #visiting }
RWAbstractVisitor >> visitUVSphereShape: shape [
	self subclassResponsibility
]
