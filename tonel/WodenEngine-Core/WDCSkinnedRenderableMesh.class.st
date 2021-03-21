"
I am a generic mesh that is also deformed by an armature.
"
Class {
	#name : #WDCSkinnedRenderableMesh,
	#superclass : #WDCMeshWithExtraDeformationRenderable,
	#instVars : [
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
WDCSkinnedRenderableMesh >> armature [
	^ armature
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> armature: anObject [
	armature := anObject
]

{ #category : #accessing }
WDCSkinnedRenderableMesh >> createDeformationState [
	^ WDCSkinnedMeshAnimationState new
		mesh: self;
		setRestPoseAndMatrices;
		engine: engine;
		yourself
]

{ #category : #'as yet unclassified' }
WDCSkinnedRenderableMesh >> engine: newEngine [
	mesh engine: newEngine.
	super engine: newEngine
]

{ #category : #initialization }
WDCSkinnedRenderableMesh >> initialize [
	super initialize.
	boundingBox := nil.
]

{ #category : #testing }
WDCSkinnedRenderableMesh >> isSkinnedRenderable [
	^ true
]

{ #category : #'extra per object rendering data' }
WDCSkinnedRenderableMesh >> poseStateSize [
	^ Float32x4x4 instanceSize * armature skinJointCount alignedTo: 256.
]
