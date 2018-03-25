Class {
	#name : #WTGSBehavior,
	#superclass : #WTGSComponent,
	#classVars : [
		'Box3D',
		'Complex',
		'Quaternion',
		'ReversibleAffineTransform',
		'Vector2',
		'Vector3',
		'Vector4'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WTGSBehavior class >> initialize [
		
	Vector2 := WMVector2D.
	Vector3 := WMVector3D.
	Vector4 := WMVector4D.
	Complex := WMComplexD.
	Quaternion := WMQuaternionD.

	ReversibleAffineTransform := WMReversibleAffineTransformD.
	
	Box3D := WMBox3DD.

]

{ #category : #accessing }
WTGSBehavior >> bucket [
	^ #behavior
]

{ #category : #'resource loading' }
WTGSBehavior >> loadMesh: modelName [
	^ self engine resourceCache loadMesh: modelName
]

{ #category : #utility }
WTGSBehavior >> setBoundingBox: aBox [
	entity spatialDescription localBoundingBox: aBox asWMBox3DD
]

{ #category : #utility }
WTGSBehavior >> setMeshNamed: meshName [
	| mesh |
	mesh := self loadMesh: meshName.
	entity ensureSpatialObject node renderable: mesh.
	^ mesh
]

{ #category : #behaviors }
WTGSBehavior >> subscribeToTouchEvents [
	entity subscribeToTouchEvents
]

{ #category : #events }
WTGSBehavior >> touch: anEntity [
]
