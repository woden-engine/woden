Class {
	#name : #WDCFrameRenderingMetrics,
	#superclass : #Object,
	#instVars : [
		'renderedObjectCount'
	],
	#category : #'WodenEngine-Core-Engine'
}

{ #category : #accessing }
WDCFrameRenderingMetrics >> renderedObjectCount [
	^ renderedObjectCount
]

{ #category : #accessing }
WDCFrameRenderingMetrics >> renderedObjectCount: anObject [
	renderedObjectCount := anObject
]

{ #category : #initialization }
WDCFrameRenderingMetrics >> reset [
	renderedObjectCount := 0.
]
