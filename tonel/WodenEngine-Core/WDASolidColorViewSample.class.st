"
I am a sample Woden application with a single solid color view.

| model |
model := WDAModel new.
model openInMorphicWith: WDASolidColorViewSample.
"
Class {
	#name : #WDASolidColorViewSample,
	#superclass : #WDAView,
	#instVars : [
		'color',
		'commandList',
		'renderPass',
		'perFrameCommandLists'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #accessing }
WDASolidColorViewSample >> color [
	^ color
]

{ #category : #accessing }
WDASolidColorViewSample >> color: anObject [
	color := anObject
]

{ #category : #initialization }
WDASolidColorViewSample >> initialize [
	super initialize.
	color := Color blue
]

{ #category : #'rendering process stages' }
WDASolidColorViewSample >> prepareRendering [
	| resolveFramebuffer renderTarget resolveTarget renderFramebuffer currentCommandLists |
	super prepareRendering.
	perFrameCommandLists ifNil: [ perFrameCommandLists := WDCPerFrameSimpleCommandList for: engine ].
	currentCommandLists := perFrameCommandLists currentList.
	
	renderTarget :=  window validRenderTarget.
	resolveTarget := window validResolveRenderTarget.
	
	renderFramebuffer := renderTarget currentFramebuffer.
	
	resolveFramebuffer := resolveTarget currentFramebuffer.
	currentCommandLists validCommandAllocator reset.
	
	renderPass ifNil: [ renderPass := renderTarget createRenderPassWithColor: Color white ].
	renderPass setColorClearValue: 0 value: color asAGPUColor4f.
	
	commandList := currentCommandLists validCommandList.
	commandList withPipelineState: nil rebuild: [ :builder |
		builder
			beginRenderPass: renderPass validHandle framebuffer: renderFramebuffer validHandle bundle_content: false asBit;
			endRenderPass.
		renderTarget ~~ resolveTarget ifTrue: [ 
			builder resolveFramebuffer: resolveFramebuffer validHandle sourceFramebuffer: renderFramebuffer validHandle
		]
	].
]

{ #category : #'rendering process stages' }
WDASolidColorViewSample >> sendRenderingCommands [
	super sendRenderingCommands.
	commandList ifNil: [ ^ self ].
	engine graphicsQueue
		addCommandList: commandList validHandle
]
