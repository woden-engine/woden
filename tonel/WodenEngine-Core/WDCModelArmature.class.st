Class {
	#name : #WDCModelArmature,
	#superclass : #Object,
	#instVars : [
		'names',
		'boneParents',
		'bones',
		'restPoseInverseMatrices',
		'restPoseForwardMatrices',
		'restPoseMatrices'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCModelArmature >> boneParents [
	^ boneParents
]

{ #category : #accessing }
WDCModelArmature >> boneParents: anObject [
	boneParents := anObject
]

{ #category : #accessing }
WDCModelArmature >> bones [
	^ bones
]

{ #category : #accessing }
WDCModelArmature >> bones: anObject [
	bones := anObject.
	restPoseMatrices := nil.
	restPoseForwardMatrices := nil.
	restPoseInverseMatrices := nil.
]

{ #category : #'as yet unclassified' }
WDCModelArmature >> computeRestPose [
	| identity |
	restPoseMatrices := SLVMNativeArray for: WMMatrix4F new: bones size.
	identity := WMMatrix4F identity.
	1 to: restPoseMatrices size do: [ :i |
		restPoseMatrices at: i put: identity
	]
]

{ #category : #'as yet unclassified' }
WDCModelArmature >> computeRestPoseForwardAndInverse [
	| bone parentIndex parentInverseMatrix parentForwardMatrix forwardMatrix inverseMatrix |
	restPoseForwardMatrices := SLVMNativeArray for: WMMatrix4F new: bones size.
	restPoseInverseMatrices := SLVMNativeArray for: WMMatrix4F new: bones size.
	1 to: bones size do: [ :i |
		bone := bones at: i.
		parentIndex := boneParents at: i.
		forwardMatrix := bone forwardMatrix.
		inverseMatrix := bone inverseMatrix.
				
		parentIndex >= 0 ifTrue: [
			parentForwardMatrix := restPoseForwardMatrices at: parentIndex + 1.
			parentInverseMatrix := restPoseInverseMatrices at: parentIndex + 1.
			
			forwardMatrix := parentForwardMatrix * forwardMatrix.
			inverseMatrix := inverseMatrix * parentInverseMatrix.
		].
	
		restPoseForwardMatrices at: i put: forwardMatrix.
		restPoseInverseMatrices at: i put: inverseMatrix.
	]
]

{ #category : #accessing }
WDCModelArmature >> names [
	^ names
]

{ #category : #accessing }
WDCModelArmature >> names: anObject [
	names := anObject
]

{ #category : #accessing }
WDCModelArmature >> restPoseForwardMatrices [
	restPoseForwardMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseForwardMatrices
]

{ #category : #accessing }
WDCModelArmature >> restPoseInverseMatrices [
	restPoseInverseMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseInverseMatrices
]

{ #category : #accessing }
WDCModelArmature >> restPoseMatrices [
	restPoseMatrices ifNil: [ self computeRestPose ].
	^ restPoseMatrices
]
