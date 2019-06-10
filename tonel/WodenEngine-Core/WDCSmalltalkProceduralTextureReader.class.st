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
	| script scriptEvaluatorClass |
	script := aFileReference contents.
	^ WDCResourceCache cachedValueFor: { #sttextEval . textureFileAndQuery . '|' . script } ifAbsentPut: [
		scriptEvaluatorClass := WDCPharoProceduralScriptContext.
		(script beginsWith: '"!GPU') ifTrue: [ 
			scriptEvaluatorClass := WDCPharoProceduralGPUScriptContext
		].
	
		Smalltalk compiler
			receiver: (scriptEvaluatorClass new
				parameters: textureFileAndQuery);
			evaluate: script
	]
]
