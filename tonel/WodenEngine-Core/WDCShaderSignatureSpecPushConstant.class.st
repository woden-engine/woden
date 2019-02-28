Class {
	#name : #WDCShaderSignatureSpecPushConstant,
	#superclass : #Object,
	#instVars : [
		'index',
		'name',
		'offset',
		'size'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #compiling }
WDCShaderSignatureSpecPushConstant >> compileShaderSignatureElementNewIn: aClass [
	| code |
	code := ByteString streamContents: [ :out |
		out << 'constant' << name << 'Offset'; cr.
		out tab << '^ ' << offset printString
	].
	aClass compileShaderSignatureMethod: code.
	
	code := ByteString streamContents: [ :out |
		out << 'constant' << name << 'Size'; cr.
		out tab << '^ ' << size printString
	].
	aClass compileShaderSignatureMethod: code
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> index [
	^ index
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> index: anObject [
	index := anObject
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> name [
	^ name
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> offset [
	^ offset
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> size [
	^ size
]

{ #category : #accessing }
WDCShaderSignatureSpecPushConstant >> size: anObject [
	size := anObject
]

{ #category : #writing }
WDCShaderSignatureSpecPushConstant >> writeCreateHandleCodeOn: out [

	self flag: 'TODO: Cleanup this API call.'.
	1 to: size // 4 do: [ :i |
		out tab tab << 'addBindingConstant; "' << name << '"' ; cr.
	]
]
