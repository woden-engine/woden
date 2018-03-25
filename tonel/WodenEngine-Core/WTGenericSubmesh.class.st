Class {
	#name : #WTGenericSubmesh,
	#superclass : #Object,
	#instVars : [
		'firstIndex',
		'indexCount',
		'primitiveType',
		'material'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #comparing }
WTGenericSubmesh >> = other [
	^ self class = other class and:
		[ firstIndex = other firstIndex and:
		[ indexCount = other indexCount and:
		[ material = other material and:
		[ primitiveType = other primitiveType ]]]]
]

{ #category : #accessing }
WTGenericSubmesh >> firstIndex [
	^ firstIndex
]

{ #category : #accessing }
WTGenericSubmesh >> firstIndex: anObject [
	firstIndex := anObject
]

{ #category : #comparing }
WTGenericSubmesh >> hash [
	^ self class hash bitXor:
		(firstIndex hash bitXor:
		(indexCount hash bitXor:
		(material hash bitXor:
		 primitiveType hash)))
]

{ #category : #accessing }
WTGenericSubmesh >> indexCount [
	^ indexCount
]

{ #category : #accessing }
WTGenericSubmesh >> indexCount: anObject [
	indexCount := anObject
]

{ #category : #accessing }
WTGenericSubmesh >> material [
	^ material
]

{ #category : #accessing }
WTGenericSubmesh >> material: anObject [
	material := anObject
]

{ #category : #accessing }
WTGenericSubmesh >> primitiveType [
	^ primitiveType
]

{ #category : #accessing }
WTGenericSubmesh >> primitiveType: anObject [
	primitiveType := anObject
]

{ #category : #rendering }
WTGenericSubmesh >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	material ifNil: [ ^ self ].
	(stateTracker activateMaterial: material) ifFalse: [ ^ self].
	stateTracker
		primitiveType: primitiveType;
		drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance
]

{ #category : #rendering }
WTGenericSubmesh >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	material ifNil: [ ^ self ].
	(material activateOn: listBuilder primitiveType: primitiveType mode: renderMode submode: submode) ifFalse: [ ^ self].
	listBuilder drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance
]
