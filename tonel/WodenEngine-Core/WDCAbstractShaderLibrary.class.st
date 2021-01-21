Class {
	#name : #WDCAbstractShaderLibrary,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'source'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #accessing }
WDCAbstractShaderLibrary >> getComputeStage: entryPoint [
	^ self getStage: #compute withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> getFragmentStage: entryPoint [
	^ self getStage: #fragment withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> getGeometryStage: entryPoint [
	^ self getStage: #geometry withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> getStage: stageName withEntryPoint: entryPoint [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> getTessellationControlStage: entryPoint [
	^ self getStage: #tcontrol withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> getTessellationEvaluationStage: entryPoint [
	^ self getStage: #teval withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> getVertexStage: entryPoint [
	^ self getStage: #vertex withEntryPoint: entryPoint
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> source [
	^ source
]

{ #category : #accessing }
WDCAbstractShaderLibrary >> source: anObject [
	source := anObject.
	self sourceChanged.
]
