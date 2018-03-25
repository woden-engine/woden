Class {
	#name : #RWNullShape,
	#superclass : #RWSimpleShape,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #hooks }
RWNullShape >> buildRenderableFor: anElement view: aView [
	"Do nothing"
	^ WTNullRenderable new
]

{ #category : #hooks }
RWNullShape >> changedElement: element sceneNode: sceneNode renderable: renderable [
	"Do nothing"
]
