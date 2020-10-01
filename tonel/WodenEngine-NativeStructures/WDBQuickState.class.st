Class {
	#name : #WDBQuickState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#modelViewMatrixIndex => Int32',
		'#projectionMatrixIndex => Int32',
		'#colorRampIndex => Int32',
		'#colorRampSize => Int32'
	],
	#category : #'WodenEngine-NativeStructures-Babylon'
}

{ #category : #accessing }
WDBQuickState >> colorRampIndex [
	^ colorRampIndex
]

{ #category : #accessing }
WDBQuickState >> colorRampIndex: anObject [
	colorRampIndex := anObject
]

{ #category : #accessing }
WDBQuickState >> colorRampSize [
	^ colorRampSize
]

{ #category : #accessing }
WDBQuickState >> colorRampSize: anObject [
	colorRampSize := anObject
]

{ #category : #accessing }
WDBQuickState >> modelViewMatrixIndex [
	^ modelViewMatrixIndex
]

{ #category : #accessing }
WDBQuickState >> modelViewMatrixIndex: anObject [
	modelViewMatrixIndex := anObject
]

{ #category : #accessing }
WDBQuickState >> projectionMatrixIndex [
	^ projectionMatrixIndex
]

{ #category : #accessing }
WDBQuickState >> projectionMatrixIndex: anObject [
	projectionMatrixIndex := anObject
]
