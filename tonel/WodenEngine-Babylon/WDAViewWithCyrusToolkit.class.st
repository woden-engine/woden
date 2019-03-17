Class {
	#name : #WDAViewWithCyrusToolkit,
	#superclass : #WDAViewWithBabylon,
	#instVars : [
		'cyrusWindow'
	],
	#category : #'WodenEngine-Babylon-Cyrus'
}

{ #category : #'rendering process stages' }
WDAViewWithCyrusToolkit >> addRenderingElementsToGraph: aRenderingGraph [
	self flag: 'FIXME: Remove this hack for the sub views'.
	cyrusWindow extent: window drawingSurfaceExtent.
	super addRenderingElementsToGraph: aRenderingGraph
]

{ #category : #accessing }
WDAViewWithCyrusToolkit >> cyrusWindow [
	^ cyrusWindow
]

{ #category : #rendering }
WDAViewWithCyrusToolkit >> drawOnBabylonCanvas: canvas [
	canvas clear: Color transparent.
	cyrusWindow fullDrawOn: canvas
]

{ #category : #initialization }
WDAViewWithCyrusToolkit >> initialize [
	super initialize.
	cyrusWindow := WDCyTkVirtualHostWindow new.
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitKeyDownEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchKeyDownEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitKeyUpEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchKeyUpEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseButtonPressEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchMouseButtonPressEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseButtonReleaseEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchMouseButtonReleaseEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseMoveEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchMouseMoveEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseWheelEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchMouseWheelEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitTextInputEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchTextInputEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowCloseEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow close ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowHiddenEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchHidden: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowMoveEvent: anEvent [
	cyrusWindow ifNotNil: [ cyrusWindow dispatchMove: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowResizeEvent: anEvent [
	anEvent suppressDefaultAction.
	cyrusWindow ifNotNil: [ cyrusWindow dispatchResize: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowShownEvent: anEvent [
	anEvent suppressDefaultAction.
	cyrusWindow ifNotNil: [ cyrusWindow dispatchShown: anEvent ]
]
