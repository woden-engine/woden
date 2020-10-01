Class {
	#name : #WDCSkinnedGenericVertexF32,
	#superclass : #WDCVertexDataStructure,
	#instVars : [
		'#position => CompactFloat32x3 location: 0',
		'#normal => CompactFloat32x3 location: 3',
		'#texcoord => Float32x2 location: 1',
		'#tangent4 => Float32x4 location: 4',
		'#color => Float32x4 location: 2',
		'#compressedBoneWeights => UInt16x4 location: 5',
		'#boneIndices => UInt16x4 location: 6'
	],
	#category : #'WodenEngine-NativeStructures-Core-Mesh'
}
