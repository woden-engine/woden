Class {
	#name : #WDCSmalltalkProceduralTextureReader,
	#superclass : #WDCTextureReader,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #accessing }
WDCSmalltalkProceduralTextureReader class >> extension [
	^ 'sttex'
]

{ #category : #initialization }
WDCSmalltalkProceduralTextureReader class >> loadFromFileReference: aFileReference withQuery: textureFileAndQuery [
	| script |
	script := aFileReference contents.
	^ WDCResourceCache cachedValueFor: { #sttextEval . textureFileAndQuery . '|' . script } ifAbsentPut: [
		Smalltalk compiler
			receiver: (WDCSmalltalkProceduralScriptContext new parameters: textureFileAndQuery);
			evaluate: script
	]
]
