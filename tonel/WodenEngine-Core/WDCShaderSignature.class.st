Class {
	#name : #WDCShaderSignature,
	#superclass : #Object,
	#instVars : [
		'engine',
		'handle'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #compiling }
WDCShaderSignature class >> compileShaderSignatureElementNewFor: spec [
	spec elements do: [ :element | element compileShaderSignatureElementNewIn: self ]
]

{ #category : #compiling }
WDCShaderSignature class >> compileShaderSignatureInstantiateFor: spec [
	| code |
	code := ByteString streamContents: [ :out |
		out << 'createHandleForDevice: device'; cr.
		out tab << '^ device createShaderSignatureBuilder'; cr; cr.
		spec elements do: [ :element | element writeCreateHandleCodeOn: out ].

		out tab tab << 'build'; cr.
	].

	self compileShaderSignatureMethod: code
]

{ #category : #compiling }
WDCShaderSignature class >> compileShaderSignatureMethod: code [
	Author useAuthor: 'WodenEngine' during: [ 
		self compile: code classified: self shaderSignatureMethodCategory
	]
]

{ #category : #'instance creation' }
WDCShaderSignature class >> for: aWDCEngine [
	^ aWDCEngine getOrCreateShaderSignature: self
]

{ #category : #accessing }
WDCShaderSignature class >> handle: aHandle [
	^ self new handle: aHandle
]

{ #category : #parsing }
WDCShaderSignature class >> parseSpec [
	| spec |
	spec := WDCShaderSignatureSpec new.
	self signatureSpec: spec.
	^ spec
]

{ #category : #'as yet unclassified' }
WDCShaderSignature class >> rebuildShaderSignatureMethods [
	| spec |
	spec := self parseSpec.
	self removeShaderSignatureMethods.
	self
		compileShaderSignatureInstantiateFor: spec;
		compileShaderSignatureElementNewFor: spec
	
]

{ #category : #removing }
WDCShaderSignature class >> removeShaderSignatureMethods [
	| protocol |
	protocol := (self organization protocolNamed: self shaderSignatureMethodCategory).
	protocol ifNil: [ ^ self ].
	protocol methods asArray do: [ :method |
		self removeSelector: method
	]
]

{ #category : #'instance creation' }
WDCShaderSignature class >> shaderSignatureFor: aWDCEngine [
	^ self for: aWDCEngine
]

{ #category : #'as yet unclassified' }
WDCShaderSignature class >> shaderSignatureMethodCategory [
	^ 'generated shader signature methods'
]

{ #category : #'as yet unclassified' }
WDCShaderSignature class >> signatureSpec: spec [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCShaderSignature >> activeOnStateTracker: stateTracker [
	stateTracker shaderSignature: self
]

{ #category : #'generated shader signature methods' }
WDCShaderSignature >> createHandleForDevice: device [
	self subclassResponsibility
]

{ #category : #accessing }
WDCShaderSignature >> engine [
	^ engine
]

{ #category : #accessing }
WDCShaderSignature >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCShaderSignature >> handle [
	^ handle
]

{ #category : #accessing }
WDCShaderSignature >> handle: anObject [
	handle := anObject
]

{ #category : #path }
WDCShaderSignature >> sessionChanged [
	self handle: (self createHandleForDevice: engine device)
]

{ #category : #'instance creation' }
WDCShaderSignature >> shaderSignatureFor: aWDCEngine [
	self assert: engine == aWDCEngine.
	^ self
]
