"
I am a generic mesh that is also deformed by an armature.
"
Class {
	#name : #WDCSkinnedRenderableMesh,
	#superclass : #WDCAnimatedRenderable,
	#instVars : [
		'mesh',
		'armature',
		'actions',
		'pose'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCSkinnedRenderableMesh >> actions [
	^ actions
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> armature [
	^ armature
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> armature: anObject [
	armature := anObject
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> boundingBox [
	^ mesh boundingBox
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> createAnimationState [
	^ WDCSkinnedMeshAnimationState new
		mesh: self;
		pose: armature bones copy;
		setRestPoseAndMatrices;
		engine: engine;
		yourself
]

{ #category : #'as yet unclassified' }
WDCSkinnedRenderableMesh >> engine: newEngine [
	mesh engine: newEngine.
	super engine: newEngine
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> mesh [
	^ mesh
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> mesh: anObject [
	mesh := anObject
]

{ #category : #'extra per object rendering data' }
WDCSkinnedRenderableMesh >> poseStateSize [
	^ WMMatrix4F structureSize * armature bones size alignedTo: 256.
]

{ #category : #copying }
WDCSkinnedRenderableMesh >> postCopy [
	super postCopy.
	mesh := mesh copyForResourceCacheInstancing.
]

{ #category : #rendering }
WDCSkinnedRenderableMesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	stateTracker useShaderResources: animationState currentRenderableStateBinding.
	mesh renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
]
