Class {
	#name : #WDIGLTF2BinaryImporter,
	#superclass : #WDIGLTF2Importer,
	#instVars : [
		'chunks'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #accessing }
WDIGLTF2BinaryImporter class >> extension [
	^ 'glb'
]

{ #category : #loading }
WDIGLTF2BinaryImporter >> getBinaryDataChunkWithIndex: binaryChunkIndex [
	| chunk |
	chunk := (chunks at: binaryChunkIndex + 1).
	chunk isBinary ifFalse: [ 
		self error: 'Expected a binary chunk.'
	].

	^ chunk content
]

{ #category : #loading }
WDIGLTF2BinaryImporter >> loadFromFileReference: fileReference [
	| version length gltfJson |
	chunks := OrderedCollection new.
	
	fileReference binaryReadStreamDo: [ :in |
		(in next: 4) = 'glTF' asByteArray ifFalse: [ 
			self error: 'glTF binary with invalid magic number.'.
		].
		version := in nextLittleEndianNumber: 4.
		length := in nextLittleEndianNumber: 4.
		version = 2 ifFalse: [ 
			self error: 'Unsupported glTF version ', version asString , '.'
		].
	
		self readGLTFChunksFrom: in until: in position + length - 12
	].

	chunks first isJSON ifFalse: [ 
		self error: 'The first chunk of a GLTF 2 binary file is expected to be a JSON.'
	].

	gltfJson := (NeoJSONReader on: chunks first utf8ReadStream) next.
	^ self
		loadingDirectory: fileReference asAbsolute parent;
		processGLTFJson: gltfJson
]

{ #category : #loading }
WDIGLTF2BinaryImporter >> readGLTFChunkFrom: in [
	| chunkLength chunkType chunkPayload |
	chunkLength := in nextLittleEndianNumber: 4.
	chunkType := in next: 4.
	chunkPayload := in next: chunkLength.
	chunks add: (WDIGLTF2BinaryChunk new
		type: chunkType;
		content: chunkPayload;
		yourself
	)
]

{ #category : #loading }
WDIGLTF2BinaryImporter >> readGLTFChunksFrom: in until: targetPosition [
	[in position < targetPosition] whileTrue: [ 
		self readGLTFChunkFrom: in
	]
]
