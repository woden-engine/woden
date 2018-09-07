Class {
	#name : #WDPhyConvexHullCollisionShape,
	#superclass : #WDPhyCollisionShape,
	#instVars : [
		'points'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #visiting }
WDPhyConvexHullCollisionShape >> accept: aVisitor [
	^ aVisitor visitConvexHullShape: self
]

{ #category : #accessing }
WDPhyConvexHullCollisionShape >> points [
	^ points
]

{ #category : #accessing }
WDPhyConvexHullCollisionShape >> points: anObject [
	points := anObject
]
