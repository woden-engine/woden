"
I am a model loader that uses fuel for loading models.
"
Class {
	#name : #WDCFuelModelLoader,
	#superclass : #WDCModelLoader,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCFuelModelLoader class >> extension [
	^ 'fmdl'
]

{ #category : #loading }
WDCFuelModelLoader >> loadFromFileReference: fileReference [
	^ FLMaterializer materializeFromFileNamed: fileReference fullName
]
