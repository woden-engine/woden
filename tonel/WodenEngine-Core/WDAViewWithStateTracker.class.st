Class {
	#name : #WDAViewWithStateTracker,
	#superclass : #WDAView,
	#instVars : [
		'commandList',
		'renderPass',
		'perFrameCommandLists'
	],
	#category : #'WodenEngine-Core-Application'
}

{ #category : #'rendering process stages' }
WDAViewWithStateTracker >> constructRenderingCommandLists [
	| renderTarget resolveTarget currentCommandLists stateTracker |
	super constructRenderingCommandLists.
	perFrameCommandLists ifNil: [ perFrameCommandLists := WDCPerFrameSimpleCommandList for: engine ].
	currentCommandLists := perFrameCommandLists currentList.
	
	renderTarget := window validRenderTarget.
	resolveTarget := window resolveRenderTarget.

	currentCommandLists validCommandAllocator reset.
	
	self setupMainRenderpass.
	
	commandList := currentCommandLists validCommandList.
	stateTracker := self stateTrackerClass for: engine.
	stateTracker commandList: commandList rebuildWith: [
		self
			doRenderingComputePassWith: stateTracker;
			doRenderingWith: stateTracker.
	
		renderTarget ~~ resolveTarget ifTrue: [ 
			stateTracker resolveRenderTarget: renderTarget into: resolveTarget
		]
	].
]

{ #category : #'rendering process stages' }
WDAViewWithStateTracker >> doRenderingComputePassWith: stateTracker [
	"This is the place for dispatching compute shaders."
]

{ #category : #'rendering process stages' }
WDAViewWithStateTracker >> doRenderingWith: stateTracker [
	stateTracker
		beginRenderPass: renderPass renderTarget: window renderTarget;
		endRenderPass.

]

{ #category : #'rendering process stages' }
WDAViewWithStateTracker >> sendRenderingCommands [
	super sendRenderingCommands.
	commandList ifNil: [ ^ self ].
	engine graphicsQueue
		addCommandList: commandList validHandle
]

{ #category : #'rendering process stages' }
WDAViewWithStateTracker >> setupMainRenderpass [
	renderPass ifNil: [ renderPass := window renderTarget createRenderPassWithColor: Color black ].
]

{ #category : #'rendering process stages' }
WDAViewWithStateTracker >> stateTrackerClass [
	^ WDCStateTracker
]
