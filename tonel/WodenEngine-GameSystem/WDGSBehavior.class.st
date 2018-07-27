Class {
	#name : #WDGSBehavior,
	#superclass : #WDGSComponent,
	#classVars : [
		'Box3D',
		'Complex',
		'Quaternion',
		'ReversibleAffineTransform',
		'Vector2',
		'Vector3',
		'Vector4'
	],
	#category : #'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WDGSBehavior class >> initialize [
		
	Vector2 := WMVector2D.
	Vector3 := WMVector3D.
	Vector4 := WMVector4D.
	Complex := WMComplexD.
	Quaternion := WMQuaternionD.

	ReversibleAffineTransform := WMReversibleAffineTransformD.
	
	Box3D := WMBox3DD.

]

{ #category : #accessing }
WDGSBehavior >> bucket [
	^ #behavior
]

{ #category : #'resource loading' }
WDGSBehavior >> loadMesh: modelName [
	^ self engine resourceCache loadMesh: modelName
]

{ #category : #utility }
WDGSBehavior >> setBoundingBox: aBox [
	entity spatialDescription localBoundingBox: aBox asWMBox3DD
]

{ #category : #utility }
WDGSBehavior >> setMeshNamed: meshName [
	| mesh |
	mesh := self loadMesh: meshName.
	entity ensureSpatialObject node renderable: mesh.
	^ mesh
]

{ #category : #behaviors }
WDGSBehavior >> subscribeToTouchEvents [
	entity subscribeToTouchEvents
]

{ #category : #events }
WDGSBehavior >> touch: anEntity [
]
