"
I am a sample scene view that uses first person shooter game style controls for movement.
"
Class {
	#name : #WDAFPSSceneView,
	#superclass : #WDASceneViewWithBabylon,
	#instVars : [
		'cameraVelocity',
		'cameraSpeed',
		'cameraAngle',
		'cameraAngularVelocity',
		'cameraAngularSpeed',
		'cameraPosition',
		'trackedDevicesDisplay',
		'dragging'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #accessing }
WDAFPSSceneView >> cameraAngle [
	^ cameraAngle
]

{ #category : #accessing }
WDAFPSSceneView >> cameraAngle: anObject [
	cameraAngle := anObject
]

{ #category : #accessing }
WDAFPSSceneView >> cameraAngularSpeed [
	^ cameraAngularSpeed
]

{ #category : #accessing }
WDAFPSSceneView >> cameraAngularSpeed: anObject [
	cameraAngularSpeed := anObject
]

{ #category : #accessing }
WDAFPSSceneView >> cameraAngularVelocity [
	^ cameraAngularVelocity
]

{ #category : #accessing }
WDAFPSSceneView >> cameraAngularVelocity: anObject [
	cameraAngularVelocity := anObject
]

{ #category : #accessing }
WDAFPSSceneView >> cameraSpeed [
	^ cameraSpeed
]

{ #category : #accessing }
WDAFPSSceneView >> cameraSpeed: anObject [
	cameraSpeed := anObject
]

{ #category : #accessing }
WDAFPSSceneView >> cameraVelocity [
	^ cameraVelocity
]

{ #category : #accessing }
WDAFPSSceneView >> cameraVelocity: anObject [
	cameraVelocity := anObject
]

{ #category : #vr }
WDAFPSSceneView >> ensureVRTrackedDeviceDisplay: cameraTransform [

	| meshBuilder mesh cube interestingDevices |
	interestingDevices := engine vrSystem trackedDevices select: [:dev | dev isNotNil and: [dev isHeadMountedDisplay not]].
	
	(trackedDevicesDisplay isNil or: [trackedDevicesDisplay size ~= interestingDevices size]) ifTrue: [
		trackedDevicesDisplay ifNotNil: [ 
			trackedDevicesDisplay do: [ :oldDevice | oldDevice second removeFromScene ]
		].
	
		meshBuilder := WDCGenericMeshBuilder for: engine.
		meshBuilder addCubeWithWidth: 0.1 height: 0.1 depth: 0.1.
		mesh := meshBuilder mesh.

		trackedDevicesDisplay :=  interestingDevices collect: [:device |
			cube := WDSGSpatialObject new.
			cube renderable: mesh.
			model scene add: cube.
			
			{ device . cube }
		]
	].

	trackedDevicesDisplay do: [ :deviceAndNode |
		deviceAndNode second transform: (cameraTransform transformTransform: deviceAndNode first currentPose deviceToAbsoluteTransform)
	 ]
	

]

{ #category : #initialization }
WDAFPSSceneView >> initialize [
	super initialize.

	cameraVelocity := WMVector3F new.
	cameraSpeed := 1.0.
	
	cameraAngle := WMVector3F new.
	cameraAngularVelocity := WMVector3F new.
	cameraAngularSpeed := 1.0.
	dragging := false.
]

{ #category : #'rendering process stages' }
WDAFPSSceneView >> updateForFrameDelta: delta [
	| orientation cameraTransform |
	super updateForFrameDelta: delta.
	camera := self camera.
	camera isNotControlledByTheUser ifTrue: [ ^ self ].
	
	cameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	cameraPosition ifNil: [ cameraPosition := self camera transform translation ].
	
	orientation := screenDisplayMode isVR ifTrue: [ 
		WMMatrix3F yrot: cameraAngle y.
	] ifFalse: [ 
		(WMMatrix3F yrot: cameraAngle y) * (WMMatrix3F xrot: cameraAngle x).
	].

	cameraPosition := cameraPosition + (orientation transformVector3: (cameraVelocity * (cameraSpeed * delta))).

	cameraTransform := WMReversibleAffineTransformF identity orthonormal: orientation translation: cameraPosition.

	self isInVirtualReality ifTrue: [ 
		self ensureVRTrackedDeviceDisplay: cameraTransform.

		cameraTransform := cameraTransform transformTransform: engine vrSystem hmdTrackedDevice currentPose deviceToAbsoluteTransform.
	].
	
	self camera transform: cameraTransform
	
]

{ #category : #visiting }
WDAFPSSceneView >> visitKeyDownEvent: anEvent [
	anEvent repeat > 0 ifTrue: [ ^ 0 ].
	anEvent symbol = OSK_F1 ifTrue: [ sceneRenderer debugNextRenderTarget ].
	anEvent symbol = OSK_F2 ifTrue: [ sceneRenderer debugRenderNextShadowMapViewport ].
	anEvent symbol = OSK_F11 ifTrue: [ self toggleFullscreen ].

	anEvent symbol = OSK_a ifTrue: [ cameraVelocity x: -1.0 ].
	anEvent symbol = OSK_d ifTrue: [ cameraVelocity x: 1.0 ].
	anEvent symbol = OSK_w ifTrue: [ cameraVelocity z: -1.0 ].
	anEvent symbol = OSK_s ifTrue: [ cameraVelocity z: 1.0 ].
	anEvent symbol = OSK_LCTRL ifTrue: [ cameraVelocity y: -1.0 ].
	anEvent symbol = OSK_SPACE ifTrue: [ cameraVelocity y: 1.0 ].

	anEvent symbol = OSK_UP ifTrue: [ cameraAngularVelocity x: 1.0 ].
	anEvent symbol = OSK_DOWN ifTrue: [ cameraAngularVelocity x: -1.0 ].
	anEvent symbol = OSK_LEFT ifTrue: [ cameraAngularVelocity y: 1.0 ].
	anEvent symbol = OSK_RIGHT ifTrue: [ cameraAngularVelocity y: -1.0 ].
	
	anEvent symbol = OSK_LSHIFT ifTrue: [ cameraSpeed := 3.0 ].
	
	(anEvent modifiers leftAlt and: [ anEvent symbol = OSK_i ]) ifTrue: [ self inspect ].
]

{ #category : #visiting }
WDAFPSSceneView >> visitKeyUpEvent: anEvent [
	anEvent symbol = OSK_a ifTrue: [ cameraVelocity x < 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	anEvent symbol = OSK_d ifTrue: [ cameraVelocity x > 0 ifTrue: [ cameraVelocity x: 0.0 ] ].
	anEvent symbol = OSK_w ifTrue: [ cameraVelocity z < 0 ifTrue: [ cameraVelocity z: 0.0 ] ].
	anEvent symbol = OSK_s ifTrue: [ cameraVelocity z > 0 ifTrue: [ cameraVelocity z: 0.0 ] ].

	anEvent symbol = OSK_UP ifTrue: [ cameraAngularVelocity x > 0 ifTrue: [ cameraAngularVelocity x: 0.0 ] ].
	anEvent symbol = OSK_DOWN ifTrue: [ cameraAngularVelocity x < 0 ifTrue: [ cameraAngularVelocity x: 0.0 ] ].
	anEvent symbol = OSK_LEFT ifTrue: [ cameraAngularVelocity y > 0 ifTrue: [ cameraAngularVelocity y: 0.0 ] ].
	anEvent symbol = OSK_RIGHT ifTrue: [ cameraAngularVelocity y < 0 ifTrue: [ cameraAngularVelocity y: 0.0 ] ].
	
	anEvent symbol = OSK_LCTRL ifTrue: [ cameraVelocity y < 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	anEvent symbol = OSK_SPACE ifTrue: [ cameraVelocity y > 0 ifTrue: [ cameraVelocity y: 0.0 ] ].
	anEvent symbol = OSK_LSHIFT ifTrue: [ cameraSpeed := 1.0 ].
]

{ #category : #visiting }
WDAFPSSceneView >> visitMouseButtonPressEvent: anEvent [
	dragging := true
]

{ #category : #visiting }
WDAFPSSceneView >> visitMouseButtonReleaseEvent: anEvent [
	dragging := false
]

{ #category : #visiting }
WDAFPSSceneView >> visitMouseMoveEvent: anEvent [
	dragging ifTrue: [ 
		cameraAngle := cameraAngle + ((WMVector3F x: anEvent delta y negated asFloat y: anEvent delta negated x asFloat z: 0.0) * 0.01)
	].

]
