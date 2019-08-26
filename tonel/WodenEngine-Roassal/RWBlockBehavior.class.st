Class {
	#name : #RWBlockBehavior,
	#superclass : #RWElementBehavior,
	#instVars : [
		'block'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWBlockBehavior >> block [
	^ block
]

{ #category : #accessing }
RWBlockBehavior >> block: anObject [
	block := anObject
]

{ #category : #'time simulation' }
RWBlockBehavior >> simulateTime: delta onElement: anElement [
	block cull: delta cull: anElement
]
