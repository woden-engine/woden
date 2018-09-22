Class {
	#name : #WDAViewWithBabylon,
	#superclass : #WDAView,
	#instVars : [
		'pompeiiDefaultFont',
		'commandList',
		'surface'
	],
	#category : #'WodenEngine-Babylon-Vesuvius'
}

{ #category : #accessing }
WDAViewWithBabylon >> babylonDefaultFont [
	^ pompeiiDefaultFont ifNil: [ pompeiiDefaultFont := engine babylonDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #rendering }
WDAViewWithBabylon >> drawOnBabylonCanvas: canvas [
]

{ #category : #'rendering process stages' }
WDAViewWithBabylon >> prepareRendering [
	super prepareRendering.
	surface := window validResolveRenderTarget validPompeiiSurface.	
	commandList := surface drawToWodenWindow: window during: [ :canvas |
		self drawOnBabylonCanvas: canvas
	] 
]

{ #category : #'rendering process stages' }
WDAViewWithBabylon >> sendRenderingCommands [
	super sendRenderingCommands.
	commandList ifNil: [ ^ self ].
	engine graphicsQueue addCommandList: commandList validHandle.
]
