Class {
	#name : #WDCCylinderLineMeshComponent,
	#superclass : #WDCLineMeshComponent,
	#instVars : [
		'radius',
		'capStart',
		'capEnd',
		'slices'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #drawing }
WDCCylinderLineMeshComponent >> buildMeshOn: meshBuilder [
	| vector rotation height transform |
	(startPoint closeTo: endPoint) ifTrue: [ ^ self ].
	vector := endPoint - startPoint.
	rotation := QuaternionF32 rotationFromVector: (Float32x3 y: 1.0) into: vector.
	height := vector length.
	
	transform := (ReversibleAffineTransform3dF32 new
			orthonormal: rotation asFloat32x3x3 translation: startPoint;
			yourself).
	meshBuilder
		useDefaultMaterial;
		withTransform: transform do: [ 
			meshBuilder addCylinderRadius: radius height: height segments: 2 slices: slices capBottom: capStart capTop: capEnd
		].

]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> capEnd [
	^ capEnd
]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> capEnd: anObject [
	capEnd := anObject
]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> capStart [
	^ capStart
]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> capStart: anObject [
	capStart := anObject
]

{ #category : #initialization }
WDCCylinderLineMeshComponent >> initialize [
	super initialize.
	radius := 0.1.
	slices := 16.
	capStart := true.
	capEnd := true.
]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> radius [
	^ radius
]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> radius: anObject [
	radius := anObject
]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> slices [
	^ slices
]

{ #category : #accessing }
WDCCylinderLineMeshComponent >> slices: anObject [
	slices := anObject
]
