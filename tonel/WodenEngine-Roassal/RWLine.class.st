Class {
	#name : #RWLine,
	#superclass : #RWAbstractLineShape,
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWLine >> accept: aVisitor [
	^ aVisitor visitLineShape: self
]

{ #category : #hooks }
RWLine >> createComponentRenderableFor: edge [
	| component |
	component := WDCLineMeshComponent new.
	self updateMeshComponent: component forElement: edge.
	^ component
]

{ #category : #hooks }
RWLine >> updateMeshComponent: meshComponent forElement: edge [
	meshComponent
		startPoint: edge fromPosition;
		endPoint: edge toPosition.
]
