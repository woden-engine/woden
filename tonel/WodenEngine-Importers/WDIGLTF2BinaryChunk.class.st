"
I represent a single chunk in a GLTF 2 binary file.
"
Class {
	#name : #WDIGLTF2BinaryChunk,
	#superclass : #Object,
	#instVars : [
		'type',
		'content'
	],
	#pools : [
		'WDIGLTF2Constants'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #accessing }
WDIGLTF2BinaryChunk >> content [
	^ content
]

{ #category : #accessing }
WDIGLTF2BinaryChunk >> content: anObject [
	content := anObject
]

{ #category : #testing }
WDIGLTF2BinaryChunk >> isBinary [
	^ type = "'BIN ' asByteArray" #[66 73 78 0]
]

{ #category : #testing }
WDIGLTF2BinaryChunk >> isJSON [
	^ type = "'JSON' asByteArray" #[74 83 79 78]
]

{ #category : #accessing }
WDIGLTF2BinaryChunk >> type [
	^ type
]

{ #category : #accessing }
WDIGLTF2BinaryChunk >> type: anObject [
	type := anObject
]

{ #category : #'as yet unclassified' }
WDIGLTF2BinaryChunk >> utf8ReadStream [
	^ ZnCharacterReadStream on: content readStream encoding: 'utf8'
]
