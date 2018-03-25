Class {
	#name : #WDCShaderSignatureSpecBank,
	#superclass : #Object,
	#instVars : [
		'index',
		'name',
		'elements',
		'maxBindings',
		'totalBindingPointCount'
	],
	#category : 'WodenEngine-Core-Shaders'
}

{ #category : #'as yet unclassified' }
WDCShaderSignatureSpecBank class >> defaultMaxBindings [
	^ 1000
]

{ #category : #building }
WDCShaderSignatureSpecBank >> addElement: elementName type: elementType count: bindingPointCount [
	elements add: (WDCShaderSignatureSpecDescriptor new
			name: elementName;
			index: totalBindingPointCount;
			type: elementType;
			count: bindingPointCount;
			yourself).
	totalBindingPointCount := totalBindingPointCount + bindingPointCount
]

{ #category : #'code generation' }
WDCShaderSignatureSpecBank >> compileShaderSignatureElementNewIn: aClass [
	| code |
	code := ByteString streamContents: [ :out |
		out << 'new' << name; cr.
		out tab << '^ engine createShaderSignature: self resourceBinding: ' << index << ' elements: ' << totalBindingPointCount
	].
	aClass compileShaderSignatureMethod: code
]

{ #category : #accessing }
WDCShaderSignatureSpecBank >> elements [
	^ elements
]

{ #category : #accessing }
WDCShaderSignatureSpecBank >> index [
	^ index
]

{ #category : #accessing }
WDCShaderSignatureSpecBank >> index: anObject [
	index := anObject
]

{ #category : #initialization }
WDCShaderSignatureSpecBank >> initialize [
	super initialize.
	elements := OrderedCollection new.
	maxBindings := self class defaultMaxBindings.
	totalBindingPointCount := 0.
]

{ #category : #accessing }
WDCShaderSignatureSpecBank >> maxBindings [
	^ maxBindings
]

{ #category : #accessing }
WDCShaderSignatureSpecBank >> maxBindings: anObject [
	maxBindings := anObject
]

{ #category : #accessing }
WDCShaderSignatureSpecBank >> name [
	^ name
]

{ #category : #accessing }
WDCShaderSignatureSpecBank >> name: anObject [
	name := anObject
]

{ #category : #building }
WDCShaderSignatureSpecBank >> sampler: elementName [
	^ self sampler: elementName count: 1
]

{ #category : #building }
WDCShaderSignatureSpecBank >> sampler: elementName count: count [
	^ self addElement: elementName type: #sampler count: count
]

{ #category : #building }
WDCShaderSignatureSpecBank >> storage: elementName [
	^ self addElement: elementName type: #storage count: 1
]

{ #category : #building }
WDCShaderSignatureSpecBank >> storage: elementName count: count [
	^ self addElement: elementName type: #storage count: count
]

{ #category : #building }
WDCShaderSignatureSpecBank >> texture: elementName [
	^ self texture: elementName count: 1
]

{ #category : #building }
WDCShaderSignatureSpecBank >> texture: elementName count: count [
	^ self addElement: elementName type: #texture count: count
]

{ #category : #building }
WDCShaderSignatureSpecBank >> uniform: elementName [
	^ self uniform: elementName count: 1
]

{ #category : #building }
WDCShaderSignatureSpecBank >> uniform: elementName count: count [
	^ self addElement: elementName type: #uniform count: count
]

{ #category : #'code generation' }
WDCShaderSignatureSpecBank >> writeCreateHandleCodeOn: out [
	out tab tab << '"' << name << '"'; cr.
	out tab tab << 'beginBindingBank: ' << maxBindings << ';'; cr.
	elements do: [ :el | el writeCreateHandleCodeOn: out ].
	out cr
]
