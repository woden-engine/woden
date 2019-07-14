Class {
	#name : #WDESBehaviorComponent,
	#superclass : #WDESComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #testing }
WDESBehaviorComponent >> isBehaviorComponent [
	^ true
]

{ #category : #'as yet unclassified' }
WDESBehaviorComponent >> sendInputEvent: inputEventSelector with: anEvent [
	"By default, we ignore these messages."
]
