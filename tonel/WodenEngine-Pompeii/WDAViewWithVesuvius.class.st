Class {
	#name : #WDAViewWithVesuvius,
	#superclass : #WDAViewWithPompeii,
	#instVars : [
		'vsWindow'
	],
	#category : #'WodenEngine-Pompeii-Vesuvius'
}

{ #category : #rendering }
WDAViewWithVesuvius >> drawOnPompeiiCanvas: canvas [
	canvas clear: Color transparent.
	vsWindow fullDrawOn: canvas
]

{ #category : #initialization }
WDAViewWithVesuvius >> initialize [
	super initialize.
	vsWindow := WDVsTkVirtualHostWindow new.
]

{ #category : #'rendering process stages' }
WDAViewWithVesuvius >> prepareRendering [
	vsWindow extent: window drawingSurfaceExtent.
	super prepareRendering
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitKeyDownEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchKeyDownEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitKeyUpEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchKeyUpEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitMouseButtonPressEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseButtonPressEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitMouseButtonReleaseEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseButtonReleaseEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitMouseMoveEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseMoveEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitMouseWheelEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMouseWheelEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitTextInputEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchTextInputEvent: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitWindowCloseEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow close ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitWindowHiddenEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchHidden: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitWindowMoveEvent: anEvent [
	vsWindow ifNotNil: [ vsWindow dispatchMove: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitWindowResizeEvent: anEvent [
	anEvent suppressDefaultAction.
	vsWindow ifNotNil: [ vsWindow dispatchResize: anEvent ]
]

{ #category : #visiting }
WDAViewWithVesuvius >> visitWindowShownEvent: anEvent [
	anEvent suppressDefaultAction.
	vsWindow ifNotNil: [ vsWindow dispatchShown: anEvent ]
]

{ #category : #accessing }
WDAViewWithVesuvius >> vsWindow [
	^ vsWindow
]
