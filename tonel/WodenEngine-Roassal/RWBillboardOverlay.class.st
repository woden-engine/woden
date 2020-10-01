Class {
	#name : #RWBillboardOverlay,
	#superclass : #RWOverlay,
	#instVars : [
		'position',
		'drawingBlock'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #rendering }
RWBillboardOverlay >> drawOnScaledBabylonCanvas: canvas [
	| viewPos4 projectedPosition ndcPosition surfaceExtent x y |
	viewPos4 := view camera transform inverseMatrix4 transformVector4: (Float32x4 xyz: position w: 1.0).
	projectedPosition := view camera frustum matrix transformVector4: viewPos4.
	projectedPosition w <= 0.0 ifTrue: [ ^ self ].
	ndcPosition := (Float32x2 x: projectedPosition x y: projectedPosition y) / projectedPosition w.
	surfaceExtent := canvas surface extent.
	x := (ndcPosition x * 0.5 + 0.5) * surfaceExtent x.
	y := (ndcPosition y * 0.5 + 0.5).
	view engine hasTopLeftNDCOrigin ifFalse: [
		y := 1.0 - y
	].
	y := y * surfaceExtent y.
	canvas transform restoreAfter: [
		canvas transform translateBy: (canvas physicalToLogicalTransformPoint: x@y).
		drawingBlock cull: canvas
	]

]

{ #category : #accessing }
RWBillboardOverlay >> drawingBlock [
	^ drawingBlock
]

{ #category : #accessing }
RWBillboardOverlay >> drawingBlock: anObject [
	drawingBlock := anObject
]

{ #category : #accessing }
RWBillboardOverlay >> position [
	^ position
]

{ #category : #accessing }
RWBillboardOverlay >> position: anObject [
	position := anObject
]
