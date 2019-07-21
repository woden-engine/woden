Class {
	#name : #WDCSurfaceDeformationRenderableMesh,
	#superclass : #WDCMeshWithExtraDeformationRenderable,
	#instVars : [
		'clipMapPeriod'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCSurfaceDeformationRenderableMesh >> clipMapPeriod [
	^ clipMapPeriod
]

{ #category : #accessing }
WDCSurfaceDeformationRenderableMesh >> clipMapPeriod: anObject [
	clipMapPeriod := anObject.
	deformationState ifNotNil: [ 
		deformationState clipMapPeriod: anObject
	].
]
