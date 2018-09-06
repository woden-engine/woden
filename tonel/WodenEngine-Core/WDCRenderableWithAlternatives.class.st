"
I am a renderable with different alternatives.
"
Class {
	#name : #WDCRenderableWithAlternatives,
	#superclass : #WDCRenderable,
	#instVars : [
		'alternatives'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #adding }
WDCRenderableWithAlternatives >> addAlternative: alternative submode: submode [
	^ alternatives at: submode put: alternative
]

{ #category : #adding }
WDCRenderableWithAlternatives >> addDefaultAlternative: alternative [
	^ self addAlternative: alternative submode: #default
]

{ #category : #'as yet unclassified' }
WDCRenderableWithAlternatives >> alternativeForSubmode: submode [
	^ alternatives at: submode ifAbsent: [ self defaultAlternative ]
]

{ #category : #'extra per object rendering data' }
WDCRenderableWithAlternatives >> createSceneDependentDataFor: engine into: objectStateBindings [
	^ self defaultAlternative createSceneDependentDataFor: engine into: objectStateBindings
]

{ #category : #'as yet unclassified' }
WDCRenderableWithAlternatives >> defaultAlternative [
	^ alternatives at: #default ifAbsentPut: [ WDCNullRenderable new ]
]

{ #category : #initialization }
WDCRenderableWithAlternatives >> initialize [
	super initialize.
	alternatives := Dictionary new.
]

{ #category : #'extra per object rendering data' }
WDCRenderableWithAlternatives >> performGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData [
	^ self defaultAlternative performGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData
]

{ #category : #rendering }
WDCRenderableWithAlternatives >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	| alternative |
	alternative := self alternativeForSubmode: stateTracker submode.
	^ alternative renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
]

{ #category : #rendering }
WDCRenderableWithAlternatives >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	| alternative |
	alternative := self alternativeForSubmode: submode.
	^ alternative renderOn: listBuilder mode: renderMode submode: #full instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
]
