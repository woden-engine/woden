"
I represent a generic submesh.
"
Class {
	#name : #WDCGenericSubmesh,
	#superclass : #Object,
	#instVars : [
		'firstIndex',
		'indexCount',
		'primitiveType',
		'material'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #comparing }
WDCGenericSubmesh >> = other [
	^ self class = other class and:
		[ firstIndex = other firstIndex and:
		[ indexCount = other indexCount and:
		[ material = other material and:
		[ primitiveType = other primitiveType ]]]]
]

{ #category : #accessing }
WDCGenericSubmesh >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
WDCGenericSubmesh >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #comparing }
WDCGenericSubmesh >> hash [
	^ self class hash bitXor:
		(firstIndex hash bitXor:
		(indexCount hash bitXor:
		(material hash bitXor:
		 primitiveType hash)))
]

{ #category : #accessing }
WDCGenericSubmesh >> indexCount [
	^ indexCount
]

{ #category : #accessing }
WDCGenericSubmesh >> indexCount: anObject [
	indexCount := anObject
]

{ #category : #accessing }
WDCGenericSubmesh >> material [
	^ material
]

{ #category : #accessing }
WDCGenericSubmesh >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WDCGenericSubmesh >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WDCGenericSubmesh >> primitiveType: anObject [
	primitiveType := anObject
]

{ #category : #rendering }
WDCGenericSubmesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	material ifNil: [ ^ self ].
	(stateTracker activateMaterial: material) ifFalse: [ ^ self].
	stateTracker
		primitiveType: primitiveType;
		drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance
]

{ #category : #rendering }
WDCGenericSubmesh >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	material ifNil: [ ^ self ].
	(material activateOn: listBuilder primitiveType: primitiveType mode: renderMode submode: submode) ifFalse: [ ^ self].
	listBuilder drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance
]
