"
I am the super class of a model used by a scene node.
"
Class {
	#name : #WDSGNodeModel,
	#superclass : #Object,
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #testing }
WDSGNodeModel >> visibleForView: aView [
	^ true
]
