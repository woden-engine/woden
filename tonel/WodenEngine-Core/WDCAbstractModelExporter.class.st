Class {
	#name : #WDCAbstractModelExporter,
	#superclass : #Object,
	#classVars : [
		'AgpuPrimitiveTypeMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter class >> exporterForExtension: anExtension [
	self withAllSubclassesDo: [ :sc |
		sc extension = anExtension ifTrue: [ ^ sc ]
	].

	^ nil
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter class >> extension [
	^ nil
]

{ #category : #'class initialization' }
WDCAbstractModelExporter class >> initialize [
	AgpuPrimitiveTypeMap := Dictionary newFromPairs: { 
		AGPU_POINTS . #points.
		AGPU_LINES . #lines.
		AGPU_TRIANGLES . #triangles.
	}
]

{ #category : #accessing }
WDCAbstractModelExporter >> beginLight [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> beginMesh [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> beginNode [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> beginScene [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> beginSubmesh [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> beginVertex [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> color: color [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> endLight [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> endMesh [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> endNode [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> endScene [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> endSubmesh [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> endVertex [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> firstIndex: firstIndex [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> index: anIndex [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> indexCount: indexCount [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> indices: aListOfIndices [
	aListOfIndices do: [ :each | self index: each ]
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> lightWith: aBlock [
	self beginLight.
	[
		aBlock cull: self
	] ensure: [ self endLight ]
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> meshWith: aBlock [
	self beginMesh.
	[
		aBlock cull: self
	] ensure: [ self endMesh ]
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> name: entityName [
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> nodeWith: aBlock [
	self beginNode.
	[
		aBlock cull: self
	] ensure: [ self endNode ]
]

{ #category : #accessing }
WDCAbstractModelExporter >> normal: normal [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> position: position [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> primitiveType: primitiveType [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> renderable: aRenderable [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> scaleFactor: scaleFactor [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> sceneWith: aBlock [
	self beginScene.
	[
		aBlock cull: self
	] ensure: [ self endScene ]
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> submeshWith: aBlock [
	self beginSubmesh.
	[
		aBlock cull: self
	] ensure: [ self endSubmesh ]
]

{ #category : #accessing }
WDCAbstractModelExporter >> tangent4: tangent4 [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> texcoord: texcoord [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> transform: nodeTransform [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> vertexBoneIndices: boneIndices [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractModelExporter >> vertexBoneWeights: boneIndices [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModelExporter >> vertexWith: aBlock [
	self beginVertex.
	[
		aBlock cull: self
	] ensure: [ self endVertex ]
]

{ #category : #accessing }
WDCAbstractModelExporter >> visible: aBoolean [
	self subclassResponsibility
]

{ #category : #writing }
WDCAbstractModelExporter >> writeToFileNamed: aFileName [
	self subclassResponsibility
]
