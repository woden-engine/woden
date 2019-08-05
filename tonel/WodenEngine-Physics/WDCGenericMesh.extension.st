Extension { #name : #WDCGenericMesh }

{ #category : #'*WodenEngine-Physics' }
WDCGenericMesh >> createCollisionTriangleMeshAccessors [
	^ submeshes collect: [ :sm | sm createCollisionTriangleMeshAccessorFor: self ] thenSelect: #isNotNil
]
