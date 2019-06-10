Class {
	#name : #WDCImageReadWriterTextureReader,
	#superclass : #WDCTextureReader,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #testing }
WDCImageReadWriterTextureReader class >> canLoadExtension: anExtension [
	^ ImageReadWriter allTypicalFileExtensions includes: anExtension
]

{ #category : #testing }
WDCImageReadWriterTextureReader class >> canLoadMimeType: aMimeType [
	^ #('image/png' 'image/jpeg') includes: aMimeType
]

{ #category : #initialization }
WDCImageReadWriterTextureReader class >> loadFromFileReference: aFileReference withQuery: textureFileAndQuery [
	^ ImageReadWriter formFromFileNamed: aFileReference
]

{ #category : #initialization }
WDCImageReadWriterTextureReader class >> loadFromStream: aBinaryStream [
	^ ImageReadWriter formFromStream: aBinaryStream
]
