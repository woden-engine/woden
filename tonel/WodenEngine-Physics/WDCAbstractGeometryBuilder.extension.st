Extension { #name : #WDCAbstractGeometryBuilder }

{ #category : #'*WodenEngine-Physics' }
WDCAbstractGeometryBuilder >> createAABoxCollisionShape: aabox [
	| center halfExtent shape |
	center := aabox center.
	halfExtent := aabox halfExtent.
	shape := WDPhyBoxCollisionShape new halfExtent: halfExtent.
	
	(center closeTo: (WMVector3F zero)) ifFalse: [ 
		shape := WDPhyCompoundCollisionShapeComponent new
			translation: center;
			shape: shape;
			yourself
	].

	^ shape
]

{ #category : #'*WodenEngine-Physics' }
WDCAbstractGeometryBuilder >> createCompoundCollisionShape: shapes [
	(shapes size = 1 and: [ shapes first isCompoundCollisionShapeComponent not ]) ifTrue: [ ^ shapes first ].
	^ WDPhyCompoundCollisionShape new
		components: (shapes collect: #asCompoundCollisionShapeComponent)
]

{ #category : #'*WodenEngine-Physics' }
WDCAbstractGeometryBuilder >> createConvexHullCollisionShape: points [
	^ WDPhyConvexHullCollisionShape new points: points
]
