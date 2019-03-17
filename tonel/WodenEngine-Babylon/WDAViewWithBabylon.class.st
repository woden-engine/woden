Class {
	#name : #WDAViewWithBabylon,
	#superclass : #WDAView,
	#instVars : [
		'pompeiiDefaultFont',
		'commandList',
		'surface'
	],
	#category : #'WodenEngine-Babylon-Cyrus'
}

{ #category : #accessing }
WDAViewWithBabylon >> babylonDefaultFont [
	^ pompeiiDefaultFont ifNil: [ pompeiiDefaultFont := engine babylonDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #'rendering process stages' }
WDAViewWithBabylon >> constructRenderingCommandLists [
	super constructRenderingCommandLists.
	surface := window validResolveRenderTarget validPompeiiSurface.	
	commandList := surface drawToWodenWindow: window during: [ :canvas |
		self drawOnBabylonCanvas: canvas
	] 
]

{ #category : #rendering }
WDAViewWithBabylon >> drawOnBabylonCanvas: canvas [
]

{ #category : #'rendering process stages' }
WDAViewWithBabylon >> sendRenderingCommands [
	super sendRenderingCommands.
	commandList ifNil: [ ^ self ].
	engine graphicsQueue addCommandList: commandList validHandle.
]
