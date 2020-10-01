Class {
	#name : #WDBColorRampEntry,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#edge => Float32',
		'#color => Float32x4'
	],
	#category : #'WodenEngine-NativeStructures-Babylon'
}

{ #category : #accessing }
WDBColorRampEntry >> color [
	^ color
]

{ #category : #accessing }
WDBColorRampEntry >> color: anObject [
	color := anObject
]

{ #category : #accessing }
WDBColorRampEntry >> edge [
	^ edge
]

{ #category : #accessing }
WDBColorRampEntry >> edge: anObject [
	edge := anObject
]
