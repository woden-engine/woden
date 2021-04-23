Class {
	#name : #RWDatasetCodeClass,
	#superclass : #RWDatasetCodeElement,
	#instVars : [
		'name',
		'instanceVariables',
		'methods',
		'meta'
	],
	#category : #'WodenEngine-Roassal-Dataset-Code'
}

{ #category : #building }
RWDatasetCodeClass >> buildFrom: pharoClass [
	name := pharoClass name.
	pharoClass isMeta ifFalse: [ meta := self class buildFrom: pharoClass class ].
	instanceVariables addAll: (pharoClass slots collect: [ :each | RWDatasetCodeInstanceVariable buildFrom: each ]).
	methods addAll: (pharoClass localMethods collect: [ :each | RWDatasetCodeMethod buildFrom: each ])
]

{ #category : #serialization }
RWDatasetCodeClass >> decodeFromJSON: jsonObject [
	name := jsonObject at: #name ifAbsent: [ '' ].
	jsonObject at: #methods ifPresent: [ :found |
		methods addAll: (found collect: [ :each | RWDatasetCodeMethod decodeFromJSON: each ])
	].
	jsonObject at: #instanceVariables ifPresent: [ :found |
		instanceVariables addAll: (found collect: [ :each | RWDatasetCodeInstanceVariable decodeFromJSON: each ])
	].
	jsonObject at: #meta ifPresent: [ :found |
		found ifNotNil: [ 
			meta := self class decodeFromJSON: found
		]
	].
]

{ #category : #serialization }
RWDatasetCodeClass >> encodeForJSON [
	^ OrderedDictionary newFromPairs: { 
		#name . name.
		#instanceVariables . (instanceVariables collect: [:each | each encodeForJSON ]).
		#methods . (methods collect: [:each | each encodeForJSON ]).
		#meta . (meta ifNotNil: [meta encodeForJSON]).
	}
]

{ #category : #initialization }
RWDatasetCodeClass >> initialize [
	super initialize.
	methods := OrderedCollection new.
	instanceVariables := OrderedCollection new.
]

{ #category : #accessing }
RWDatasetCodeClass >> instanceVariables [

	^ instanceVariables
]

{ #category : #accessing }
RWDatasetCodeClass >> instanceVariables: anObject [

	instanceVariables := anObject
]

{ #category : #'source code management' }
RWDatasetCodeClass >> linesOfCode [ 
	| lines |
	lines := methods inject: 0 into: [ :sum :each | sum + each linesOfCode ].
	meta ifNotNil: [ lines := lines + meta linesOfCode ].
	^ lines
]

{ #category : #accessing }
RWDatasetCodeClass >> meta [

	^ meta
]

{ #category : #accessing }
RWDatasetCodeClass >> meta: anObject [

	meta := anObject
]

{ #category : #accessing }
RWDatasetCodeClass >> methods [

	^ methods
]

{ #category : #accessing }
RWDatasetCodeClass >> methods: anObject [

	methods := anObject
]

{ #category : #accessing }
RWDatasetCodeClass >> name [

	^ name
]

{ #category : #accessing }
RWDatasetCodeClass >> name: anObject [

	name := anObject
]

{ #category : #private }
RWDatasetCodeClass >> numberOfMethods [
	^ methods size + (meta ifNil: [0] ifNotNil: [meta methods size])
]

{ #category : #printing }
RWDatasetCodeClass >> printOn: aStream [
	aStream nextPutAll: 'Class '; nextPutAll: name
]
