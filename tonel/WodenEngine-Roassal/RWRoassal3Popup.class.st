Class {
	#name : #RWRoassal3Popup,
	#superclass : #RWAbstractPopup,
	#instVars : [
		'visualizationBlock',
		'renderer',
		'roassalCanvas',
		'surfaceSession',
		'surface',
		'extent'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #'instance creation' }
RWRoassal3Popup class >> with: aVisualizationBlock [
	^ self new visualizationBlock: aVisualizationBlock
]

{ #category : #hook }
RWRoassal3Popup >> activeElement: anElement [
	roassalCanvas := RSCanvas new color: Color transparent.
	visualizationBlock cull: roassalCanvas cull: anElement.
]

{ #category : #hooks }
RWRoassal3Popup >> buildUISceneGraphWith: builder for: anElement in3DBillboard: in3DBillboard [
	self ensureSurfaceWithExtent: builder clippingBounds extent ceiling.
	^ (builder rectangle: builder clippingBounds color: roassalCanvas color) ,
		(builder rectangle: builder clippingBounds surface: surface drawWithAthens: [ :drawSurface :scaleFactorX :scaleFactorY |
			self drawOnAthensNodeSurface: drawSurface withScaleX: scaleFactorX Y: scaleFactorY
		])
]

{ #category : #hooks }
RWRoassal3Popup >> drawOnAthensNodeSurface: drawSurface withScaleX: scaleFactorX Y: scaleFactorY [
	roassalCanvas extent = extent ifFalse: [ 
		roassalCanvas extent: extent
	].
	roassalCanvas playAnimations.
	drawSurface drawDuring: [ :athensCanvas | 
		| camera canvasRect |
		roassalCanvas clearBackground
			ifTrue: [ surface clear ].
		"We display the elements that are subject to the camera"
		camera := roassalCanvas camera.
		athensCanvas pathTransform scaleX: scaleFactorX Y: scaleFactorY.
		athensCanvas pathTransform restoreAfter: [ 
			athensCanvas pathTransform
				translateBy: (extent / 2) asFloatPoint;
				scaleBy: camera scale asFloat;
				translateBy: camera position negated asFloatPoint.
			self renderer canvas: athensCanvas.
			canvasRect := roassalCanvas visibleRectangle.
		
			roassalCanvas shapes do: [ :roassalShape | 
				(roassalShape intersects: canvasRect)
					ifTrue: [ roassalShape accept: self renderer ] ].
		].
	
		athensCanvas pathTransform restoreAfter: [ 
			"We display the elements that are _NOT_ subject to the camera"
			roassalCanvas fixedShapes do: [ :roassalShape | 
				roassalShape accept: self renderer ].
		].
	]
		

]

{ #category : #'as yet unclassified' }
RWRoassal3Popup >> ensureSurfaceWithExtent: anExtent [
	(surfaceSession == Smalltalk session and: [surface isNotNil and: [ surface extent = anExtent ]]) ifTrue: [ ^ self ].
	extent := anExtent.
	surface := AthensCairoSurface extent: anExtent.
	surfaceSession := Smalltalk session
]

{ #category : #accessing }
RWRoassal3Popup >> extent [
	^ extent
]

{ #category : #accessing }
RWRoassal3Popup >> renderer [
	^ renderer ifNil: [ renderer := RSAthensRenderer new ]
]

{ #category : #accessing }
RWRoassal3Popup >> visualizationBlock [

	^ visualizationBlock
]

{ #category : #accessing }
RWRoassal3Popup >> visualizationBlock: anObject [

	visualizationBlock := anObject
]
