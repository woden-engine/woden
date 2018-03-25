"
I am the super class of a model used by a scene node.
"
Class {
	#name : #WTSNodeModel,
	#superclass : #Object,
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #testing }
WTSNodeModel >> visibleForView: aView [
	^ true
]
