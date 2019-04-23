Class {
	#name : #RWNullShape,
	#superclass : #RWSimpleShape,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWNullShape >> accept: aVisitor [
	^ aVisitor visitNullShape: self
]

{ #category : #hooks }
RWNullShape >> buildRenderableFor: anElement view: aView [
	"Do nothing"
	^ WDCNullRenderable new
]

{ #category : #hooks }
RWNullShape >> changedElement: element sceneNode: sceneNode renderable: renderable [
	"Do nothing"
]
