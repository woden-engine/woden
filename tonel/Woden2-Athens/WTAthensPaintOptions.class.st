Class {
	#name : #WTAthensPaintOptions,
	#superclass : #Object,
	#instVars : [
		'surface'
	],
	#category : 'Woden2-Athens'
}

{ #category : #'instance creation' }
WTAthensPaintOptions class >> on: anAthensSurface [
	^ self new surface: anAthensSurface
]

{ #category : #modes }
WTAthensPaintOptions >> add [
	surface blendMode: #add.
]

{ #category : #modes }
WTAthensPaintOptions >> atop [
	"Set 'atop' painting mode "
	
	self notAvailable
]

{ #category : #capabilities }
WTAthensPaintOptions >> availableModes [

	"Answer a collection of paint mode names, currently supported by backend. 
	Different backends may support different sets of paint modes.
	
	You may need to structure your code depending on modes available"
	
	^ #()
]

{ #category : #modes }
WTAthensPaintOptions >> clear [
	surface blendMode: #clear.
]

{ #category : #modes }
WTAthensPaintOptions >> colorBurn [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> colorDodge [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> composeAdd [
	surface blendMode: #add.
]

{ #category : #modes }
WTAthensPaintOptions >> composeClear [
	surface blendMode: #clear.
]

{ #category : #modes }
WTAthensPaintOptions >> composeDefault [
	self composeOver
]

{ #category : #modes }
WTAthensPaintOptions >> composeDest [
	surface blendMode: #dest.
]

{ #category : #modes }
WTAthensPaintOptions >> composeDestOver [
	surface blendMode: #destOver.
]

{ #category : #modes }
WTAthensPaintOptions >> composeMultiply [
	surface blendMode: #multiply.
]

{ #category : #modes }
WTAthensPaintOptions >> composeOver [
	surface blendMode: #over.
]

{ #category : #modes }
WTAthensPaintOptions >> composeSource [
	surface blendMode: #source.
]

{ #category : #modes }
WTAthensPaintOptions >> darken [
	self notAvailable
]

{ #category : #'default mode' }
WTAthensPaintOptions >> default [
	"Set the default paint mode. The default paint mode in Athens, is 'over' "
	^ self over
]

{ #category : #modes }
WTAthensPaintOptions >> dest [
	surface blendMode: #dest.
]

{ #category : #modes }
WTAthensPaintOptions >> destAtop [
	
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> destIn [
	
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> destOut [
	
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> destOver [
	surface blendMode: #destOver.
]

{ #category : #modes }
WTAthensPaintOptions >> difference [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> exclusion [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> hardLight [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> hslColor [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> hslHue [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> hslLuminosity [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> hslSaturation [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> in [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> lighten [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> multiply [
	surface blendMode: #multiply.
]

{ #category : #errors }
WTAthensPaintOptions >> notAvailable [
	^ self error: 'A requested paint mode is not supported by backend'
]

{ #category : #modes }
WTAthensPaintOptions >> out [
	"Set 'out' painting mode "
	
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> over [
	surface blendMode: #over.
]

{ #category : #modes }
WTAthensPaintOptions >> overlay [
	self notAvailable
]

{ #category : #convenience }
WTAthensPaintOptions >> restoreAfter: aBlock [

	"restore current paint mode after evaluating a block"
	
	self subclassResponsibility
]

{ #category : #modes }
WTAthensPaintOptions >> saturate [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> screen [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> softLight [
	self notAvailable
]

{ #category : #modes }
WTAthensPaintOptions >> source [
	surface blendMode: #source.
]

{ #category : #accessing }
WTAthensPaintOptions >> surface: anObject [
	surface := anObject
]

{ #category : #modes }
WTAthensPaintOptions >> xor [
	self notAvailable
]
