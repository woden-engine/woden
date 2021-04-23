Class {
	#name : #RWDatasetCode,
	#superclass : #Object,
	#instVars : [
		'classes',
		'packages'
	],
	#category : #'WodenEngine-Roassal-Dataset-Code'
}

{ #category : #'as yet unclassified' }
RWDatasetCode class >> buildFromClasses: classes [
	^ self new buildFromClasses: classes; yourself
]

{ #category : #'as yet unclassified' }
RWDatasetCode class >> buildFromPackages: packages [
	^ self new buildFromPackages: packages; yourself
]

{ #category : #serialization }
RWDatasetCode class >> loadFromJson: filename [
	^ self new loadFromJson: filename; yourself
]

{ #category : #'as yet unclassified' }
RWDatasetCode >> buildFromClasses: pharoClasses [
	classes addAll: (pharoClasses collect: [ :each |
		RWDatasetCodeClass buildFrom: each
	])
]

{ #category : #'as yet unclassified' }
RWDatasetCode >> buildFromPackages: rpackages [
	packages addAll: (rpackages collect: [ :each |
		RWDatasetCodePackage buildFrom: each
	])
]

{ #category : #accessing }
RWDatasetCode >> classes [

	^ classes
]

{ #category : #accessing }
RWDatasetCode >> classes: anObject [

	classes := anObject
]

{ #category : #initialization }
RWDatasetCode >> decodeFromJSON: jsonObject [
	jsonObject at: #classes ifPresent: [ :found |
		classes addAll: (found collect: [ :each | RWDatasetCodeClass decodeFromJSON: each ])
	].

	jsonObject at: #packages ifPresent: [ :found |
		packages addAll: (found collect: [ :each | RWDatasetCodePackage decodeFromJSON: each ])
	].
]

{ #category : #initialization }
RWDatasetCode >> encodeForJSON [
	^ OrderedDictionary newFromPairs: { 
		#classes . (classes collect: [:each | each encodeForJSON ]).
		#packages . (packages collect: [:each | each encodeForJSON ]).
	}
]

{ #category : #initialization }
RWDatasetCode >> initialize [
	super initialize.
	classes := OrderedCollection new.
	packages := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
RWDatasetCode >> loadFromJson: filename [
	self decodeFromJSON: (NeoJSONReader fromString: filename asFileReference contents)
]

{ #category : #accessing }
RWDatasetCode >> packages [

	^ packages
]

{ #category : #accessing }
RWDatasetCode >> packages: anObject [

	packages := anObject
]

{ #category : #'as yet unclassified' }
RWDatasetCode >> saveToJson: filename [
	| encodedJson |
	encodedJson := NeoJSONWriter toString: self encodeForJSON.
	filename asFileReference writeStreamDo: [ :out |
		out truncate; nextPutAll: encodedJson
	]
]
