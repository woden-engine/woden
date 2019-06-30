Class {
	#name : #WDPhyDebugDrawingParser,
	#superclass : #WDCAbstractRenderable,
	#instVars : [
		'meshBuilder',
		'in'
	],
	#classVars : [
		'OpcodeDispatchTable'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #initialization }
WDPhyDebugDrawingParser class >> initialize [
	OpcodeDispatchTable := Array new: 256.
	
	OpcodeDispatchTable
		at: 1 put: #drawNop;
		at: 2 put: #drawLine;
		at: 3 put: #drawLineGradient;
		at: 4 put: #triangleFlag;
		at: 5 put: #triangleGradient;
		at: 6 put: #triangleLighted;
		at: 7 put: #triangleOpContactPoint;
		yourself.
		
	(OpcodeDispatchTable at: 8 put: #errorMessage) ifNotNil: [ 
	
	] ifNil: [
	 OpcodeDispatchTable at: 9 put: #'3d'
	]
]

{ #category : #'as yet unclassified' }
WDPhyDebugDrawingParser >> drawLine [
	| from to color |
	from := self nextVector3.
	to := self nextVector3.
	color := self nextColor3.
	meshBuilder
		currentColor: color;
		addLineFrom: from to: to
   
]

{ #category : #accessing }
WDPhyDebugDrawingParser >> meshBuilder [
	^ meshBuilder
]

{ #category : #accessing }
WDPhyDebugDrawingParser >> meshBuilder: anObject [
	meshBuilder := anObject
]

{ #category : #'as yet unclassified' }
WDPhyDebugDrawingParser >> nextColor3 [
	^ WMVector4F xyz: self nextVector3 w: 1.0.
]

{ #category : #'as yet unclassified' }
WDPhyDebugDrawingParser >> nextVector3 [
	^ WMVector3F x: in nextFloat32 y: in nextFloat32 z: in nextFloat32
]

{ #category : #parsing }
WDPhyDebugDrawingParser >> parse: aByteArray [
	in := WDCBinaryLittleEndianReadStream on: aByteArray readStream.
	[in atEnd] whileFalse: [
		self parseNextOpcode
	]
]

{ #category : #parsing }
WDPhyDebugDrawingParser >> parseNextOpcode [
	| opcode |
	opcode := in next.
	(OpcodeDispatchTable at: opcode + 1) ifNotNil: [ :selector | self perform: selector ]
]
