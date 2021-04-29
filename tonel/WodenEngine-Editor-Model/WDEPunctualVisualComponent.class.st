Class {
	#name : #WDEPunctualVisualComponent,
	#superclass : #WDEVisualComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEPunctualVisualComponent >> createEntitySystemComponentWithTransform: componentTransform for: gameEntity [
	^ nil
]

{ #category : #testing }
WDEPunctualVisualComponent >> isPunctualVisualComponent [
	^ true
]
