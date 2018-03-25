Class {
	#name : #WTModelArmature,
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
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WTModelArmature >> boneParents [
	^ boneParents
]

{ #category : #accessing }
WTModelArmature >> boneParents: anObject [
	boneParents := anObject
]

{ #category : #accessing }
WTModelArmature >> bones [
	^ bones
]

{ #category : #accessing }
WTModelArmature >> bones: anObject [
	bones := anObject.
	restPoseMatrices := nil.
	restPoseForwardMatrices := nil.
	restPoseInverseMatrices := nil.
]

{ #category : #'as yet unclassified' }
WTModelArmature >> computeRestPose [
	| identity |
	restPoseMatrices := SLVMNativeArray for: WMMatrix4F new: bones size.
	identity := WMMatrix4F identity.
	1 to: restPoseMatrices size do: [ :i |
		restPoseMatrices at: i put: identity
	]
]

{ #category : #'as yet unclassified' }
WTModelArmature >> computeRestPoseForwardAndInverse [
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
WTModelArmature >> names [
	^ names
]

{ #category : #accessing }
WTModelArmature >> names: anObject [
	names := anObject
]

{ #category : #accessing }
WTModelArmature >> restPoseForwardMatrices [
	restPoseForwardMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseForwardMatrices
]

{ #category : #accessing }
WTModelArmature >> restPoseInverseMatrices [
	restPoseInverseMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseInverseMatrices
]

{ #category : #accessing }
WTModelArmature >> restPoseMatrices [
	restPoseMatrices ifNil: [ self computeRestPose ].
	^ restPoseMatrices
]
