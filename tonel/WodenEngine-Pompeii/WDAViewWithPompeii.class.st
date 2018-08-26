Class {
	#name : #WDAViewWithPompeii,
	#superclass : #WDAView,
	#instVars : [
		'pompeiiDefaultFont',
		'commandList',
		'surface'
	],
	#category : #'WodenEngine-Pompeii-Vesuvius'
}

{ #category : #rendering }
WDAViewWithPompeii >> drawOnPompeiiCanvas: canvas [
]

{ #category : #accessing }
WDAViewWithPompeii >> pompeiiDefaultFont [
	^ pompeiiDefaultFont ifNil: [ pompeiiDefaultFont := engine pompeiiDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #'rendering process stages' }
WDAViewWithPompeii >> prepareRendering [
	super prepareRendering.
	surface := window validResolveRenderTarget validPompeiiSurface.	
	commandList := surface drawToWodenWindow: window during: [ :canvas |
		self drawOnPompeiiCanvas: canvas
	] 
]

{ #category : #'rendering process stages' }
WDAViewWithPompeii >> sendRenderingCommands [
	super sendRenderingCommands.
	commandList ifNil: [ ^ self ].
	engine graphicsQueue addCommandList: commandList validHandle.
]
