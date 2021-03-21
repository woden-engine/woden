Class {
	#name : #WDCSkinnedModelArmature,
	#superclass : #Object,
	#instVars : [
		'name',
		'bones',
		'restPoseMatrices',
		'restPoseInverseMatrices',
		'restPoseForwardMatrices',
		'jointIndexToBoneIndexPermutationTable',
		'rootMatrix'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #accessing }
WDCSkinnedModelArmature >> bones [
	^ bones
]

{ #category : #accessing }
WDCSkinnedModelArmature >> bones: anObject [
	| identityMatrixArray |
	bones := anObject.
	identityMatrixArray := (Array new: bones size) atAllPut: Float32x4x4 identity.
	restPoseMatrices := identityMatrixArray as: (StdnVector for: Float32x4x4).
	restPoseForwardMatrices := identityMatrixArray.
	restPoseInverseMatrices := identityMatrixArray.
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelArmature >> computeForwardMatricesWithPoseMatrices: poseMatrices [
	| result matrix |
	self assert: poseMatrices size = bones size.
	result := Array new: bones size.
	bones doWithIndex: [ :bone :boneIndex |
		matrix := poseMatrices at: boneIndex.
		bone parentIndex >= 0 ifTrue: [
			matrix := (result at: bone parentIndex + 1) * matrix
		] ifFalse: [ 
			matrix := rootMatrix * matrix
		].
	
		result at: boneIndex put: matrix
	].
	^ result
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelArmature >> computeForwardMatricesWithPoseTransforms: poseTransforms [
	^ self computeForwardMatricesWithPoseMatrices: (poseTransforms collect: [ :each | each matrix4 ])
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelArmature >> computeRestPoseForwardMatrices [
	restPoseForwardMatrices := self computeForwardMatricesWithPoseMatrices: (bones collect: [:each | each matrix]).
	
	self computeSkinningMatricesWithForwardMatrices: restPoseForwardMatrices.
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelArmature >> computeSkinningMatricesWithForwardMatrices: forwardMatrices [
	| result permutation |
	self assert: forwardMatrices size = bones size.
	permutation := self jointIndexToBoneIndexPermutationTable.
	result := (StdnVector for: Float32x4x4) new: permutation size.
	permutation do: [ :boneIndex |
		| permuttedIndex |
		permuttedIndex := boneIndex + 1.
		result add: (forwardMatrices at: permuttedIndex) * (restPoseInverseMatrices at: permuttedIndex)
	].

	^ result
]

{ #category : #initialization }
WDCSkinnedModelArmature >> initialize [
	super initialize.
	rootMatrix := Float32x4x4 identity.
]

{ #category : #accessing }
WDCSkinnedModelArmature >> jointIndexToBoneIndexPermutationTable [

	^ jointIndexToBoneIndexPermutationTable ifNil: [ ^ 0 to: bones size ]
]

{ #category : #accessing }
WDCSkinnedModelArmature >> jointIndexToBoneIndexPermutationTable: anObject [

	jointIndexToBoneIndexPermutationTable := anObject
]

{ #category : #accessing }
WDCSkinnedModelArmature >> name [
	^ name
]

{ #category : #accessing }
WDCSkinnedModelArmature >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCSkinnedModelArmature >> restPoseForwardMatrices [
	^ restPoseForwardMatrices
]

{ #category : #accessing }
WDCSkinnedModelArmature >> restPoseForwardMatrices: anObject [
	restPoseForwardMatrices := anObject
]

{ #category : #accessing }
WDCSkinnedModelArmature >> restPoseInverseMatrices [
	^ restPoseInverseMatrices
]

{ #category : #accessing }
WDCSkinnedModelArmature >> restPoseInverseMatrices: anObject [
	restPoseInverseMatrices := anObject
]

{ #category : #accessing }
WDCSkinnedModelArmature >> restPoseMatrices [
	^ restPoseMatrices
]

{ #category : #accessing }
WDCSkinnedModelArmature >> restPoseMatrices: anObject [
	restPoseMatrices := anObject
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelArmature >> restPoseState [
	^ bones collect: [ :each | WDCSkinnedModelBoneState new loadStateFrom: each ]
]

{ #category : #accessing }
WDCSkinnedModelArmature >> rootMatrix [

	^ rootMatrix
]

{ #category : #accessing }
WDCSkinnedModelArmature >> rootMatrix: anObject [

	rootMatrix := anObject
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelArmature >> skinJointCount [
	^ jointIndexToBoneIndexPermutationTable size
]
