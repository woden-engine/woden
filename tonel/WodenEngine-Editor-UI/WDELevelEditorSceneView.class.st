Class {
	#name : #WDELevelEditorSceneView,
	#superclass : #WDASceneViewWithBabylon,
	#instVars : [
		'activeToolMode',
		'activeEditionMode',
		'cameraAngle'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #accessing }
WDELevelEditorSceneView >> activeEditionMode [
	^ activeEditionMode ifNil: [ activeEditionMode := WDELevelEditorViewObjectEditionMode for: self  ]
]

{ #category : #accessing }
WDELevelEditorSceneView >> activeToolMode: anObject [
	activeToolMode := anObject
]

{ #category : #accessing }
WDELevelEditorSceneView >> activeToolModeOrEditionMode [
	^ activeToolMode ifNil: [ self activeEditionMode ]
]

{ #category : #visiting }
WDELevelEditorSceneView >> elementInPosition: aPoint [
	^ self elementInPositionWithRayPicking: aPoint

]

{ #category : #visiting }
WDELevelEditorSceneView >> elementInPositionWithRayPicking: aPoint [
	| nx ny extent |
	extent := self drawingSurfaceExtent.
	nx := aPoint x / extent x asFloat.
	ny := 1.0 - (aPoint y / extent y).
	^ self rayPickNormalizedPosition: nx @ ny.

]

{ #category : #initialization }
WDELevelEditorSceneView >> initialize [
	super initialize.

	cameraAngle := Float32x3 new.

]

{ #category : #visiting }
WDELevelEditorSceneView >> rayPickNormalizedPosition: aPoint [
	| ray distanceElement |
	ray := self camera ifNil: [ ^ nil ] ifNotNil: [:c | self worldRayAtWindowCoordinate: aPoint fromCamera: c].
	ray ifNil: [ ^ nil ].
	
	distanceElement := model rayCast: ray.
	^ distanceElement value ifNil: [ nil ]
	
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> rotateCameraWithAngles: deltaAngles [
	cameraAngle := cameraAngle + deltaAngles.
]

{ #category : #'as yet unclassified' }
WDELevelEditorSceneView >> translateCameraBy: translation [
	self camera translateBy: (self camera transform matrix * translation)
]

{ #category : #initialization }
WDELevelEditorSceneView >> updateForFrameDelta: delta [
	| orientation cameraTransform cameraPosition |
	super updateForFrameDelta: delta.
	camera := self camera.
	cameraPosition := self camera transform translation.
	
	orientation := screenDisplayMode isVR ifTrue: [ 
		Float32x3x3 yRotation: cameraAngle y.
	] ifFalse: [ 
		(Float32x3x3 yRotation: cameraAngle y) * (Float32x3x3 xRotation: cameraAngle x).
	].
	cameraTransform := ReversibleAffineTransform3dF32 identity orthonormal: orientation translation: cameraPosition.
	
	self camera transform: cameraTransform
	
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitKeyDownEvent: event [
	^ self activeToolModeOrEditionMode onKeyDown: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitKeyUpEvent: event [
	^ self activeToolModeOrEditionMode onKeyUp: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseButtonPressEvent: event [
	^ self activeToolModeOrEditionMode onMouseButtonPress: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseButtonReleaseEvent: event [
	^ self activeToolModeOrEditionMode onMouseButtonRelease: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseMoveEvent: event [
	^ self activeToolModeOrEditionMode onMouseMove: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> visitMouseWheelEvent: event [
	^ self activeToolModeOrEditionMode onMouseWheel: event
]

{ #category : #visiting }
WDELevelEditorSceneView >> worldRayAtWindowCoordinate: point fromCamera: aCamera [
	| ray frustum |
	frustum := aCamera frustum.
	frustum leftBottomFar ifNil: [ ^ nil ].
	
	ray := frustum rayForNormalizedPoint: point.
	^ ray transformedWith: aCamera globalTransform
]
