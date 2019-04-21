Class {
	#name : #WDCSimpleModelArmature,
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
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #accessing }
WDCSimpleModelArmature >> boneParents [
	^ boneParents
]

{ #category : #accessing }
WDCSimpleModelArmature >> boneParents: anObject [
	boneParents := anObject
]

{ #category : #accessing }
WDCSimpleModelArmature >> bones [
	^ bones
]

{ #category : #accessing }
WDCSimpleModelArmature >> bones: anObject [
	bones := anObject.
	restPoseMatrices := nil.
	restPoseForwardMatrices := nil.
	restPoseInverseMatrices := nil.
]

{ #category : #'as yet unclassified' }
WDCSimpleModelArmature >> computeRestPose [
	| identity |
	restPoseMatrices := SLVMNativeArray for: WMMatrix4F new: bones size.
	identity := WMMatrix4F identity.
	1 to: restPoseMatrices size do: [ :i |
		restPoseMatrices at: i put: identity
	]
]

{ #category : #'as yet unclassified' }
WDCSimpleModelArmature >> computeRestPoseForwardAndInverse [
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
WDCSimpleModelArmature >> names [
	^ names
]

{ #category : #accessing }
WDCSimpleModelArmature >> names: anObject [
	names := anObject
]

{ #category : #accessing }
WDCSimpleModelArmature >> restPoseForwardMatrices [
	restPoseForwardMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseForwardMatrices
]

{ #category : #accessing }
WDCSimpleModelArmature >> restPoseInverseMatrices [
	restPoseInverseMatrices ifNil: [ self computeRestPoseForwardAndInverse ].
	^ restPoseInverseMatrices
]

{ #category : #accessing }
WDCSimpleModelArmature >> restPoseMatrices [
	restPoseMatrices ifNil: [ self computeRestPose ].
	^ restPoseMatrices
]
