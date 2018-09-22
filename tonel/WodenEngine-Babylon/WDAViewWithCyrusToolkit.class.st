Class {
	#name : #WDAViewWithCyrusToolkit,
	#superclass : #WDAViewWithBabylon,
	#instVars : [
		'vsWindow'
	],
	#category : #'WodenEngine-Babylon-Vesuvius'
}

{ #category : #rendering }
WDAViewWithCyrusToolkit >> drawOnBabylonCanvas: canvas [
	canvas clear: Color transparent.
	vsWindow fullDrawOn: canvas
]

{ #category : #initialization }
WDAViewWithCyrusToolkit >> initialize [
	super initialize.
	vsWindow := WDCyTkVirtualHostWindow new.
]

{ #category : #'rendering process stages' }
WDAViewWithCyrusToolkit >> prepareRendering [
	vsWindow extent: window drawingSurfaceExtent.
	super prepareRendering
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitKeyDownEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchKeyDownEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitKeyUpEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchKeyUpEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseButtonPressEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseButtonPressEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseButtonReleaseEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseButtonReleaseEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseMoveEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseMoveEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitMouseWheelEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseWheelEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitTextInputEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchTextInputEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowCloseEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow close ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowHiddenEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchHidden: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowMoveEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMove: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowResizeEvent: anEvent [
	anEvent suppressDefaultAction.
	vsWindow ifNotNil: [ vsWindow dispatchResize: anEvent ]
]

{ #category : #visiting }
WDAViewWithCyrusToolkit >> visitWindowShownEvent: anEvent [
	anEvent suppressDefaultAction.
	vsWindow ifNotNil: [ vsWindow dispatchShown: anEvent ]
]

{ #category : #accessing }
WDAViewWithCyrusToolkit >> vsWindow [
	^ vsWindow
]
