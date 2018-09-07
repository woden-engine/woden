Class {
	#name : #WDCImageReadWriterTextureReader,
	#superclass : #WDCTextureReader,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #testing }
WDCImageReadWriterTextureReader class >> canLoadExtension: anExtension [
	^ ImageReadWriter allTypicalFileExtensions includes: anExtension
]

{ #category : #initialization }
WDCImageReadWriterTextureReader class >> loadFromFileReference: aFileReference withQuery: textureFileAndQuery [
	^ ImageReadWriter formFromFileNamed: aFileReference
]
