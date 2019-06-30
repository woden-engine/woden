Class {
	#name : #WDSSceneRendererCameraLayersStates,
	#superclass : #Object,
	#instVars : [
		'backgroundLayerState',
		'foregroundLayerState',
		'normalLayerState'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'instance creation' }
WDSSceneRendererCameraLayersStates class >> for: anEngine [
	^ self basicNew initializeWithEngine: anEngine
]

{ #category : #accessing }
WDSSceneRendererCameraLayersStates >> backgroundLayerState [
	^ backgroundLayerState
]

{ #category : #accessing }
WDSSceneRendererCameraLayersStates >> foregroundLayerState [
	^ foregroundLayerState
]

{ #category : #initialization }
WDSSceneRendererCameraLayersStates >> initializeWithEngine: anEngine [
	backgroundLayerState := WDSSceneRendererCameraLayerState for: anEngine.
	normalLayerState := WDSSceneRendererCameraLayerState for: anEngine.
	foregroundLayerState := WDSSceneRendererCameraLayerState for: anEngine.
]

{ #category : #accessing }
WDSSceneRendererCameraLayersStates >> normalLayerState [
	^ normalLayerState
]

{ #category : #'as yet unclassified' }
WDSSceneRendererCameraLayersStates >> updateForRenderingViewport: renderingViewport [
]

{ #category : #'as yet unclassified' }
WDSSceneRendererCameraLayersStates >> updateForRenderingViewport: renderingViewport currentTime: currentTime [
	| viewport cameraState screenSize inverseScreenSize normalTransform backgroundTransform foregroundTransform |
	viewport := renderingViewport viewport.
	cameraState := viewport cameraState.
	screenSize := renderingViewport extent asWMVector2F.
	inverseScreenSize := WMVector2F x: screenSize x reciprocalFloatQuiet y: screenSize y reciprocalFloatQuiet.
		
	cameraState
		transform: viewport cameraTransform;
		screenSize: screenSize;
		inverseScreenSize: inverseScreenSize;
		currentTime: currentTime.
		
	normalTransform := viewport cameraTransform.
	backgroundTransform := normalTransform copy translation: WMVector3F zero.
	foregroundTransform := WMReversibleAffineTransformF identity.
	
	backgroundLayerState submitState: cameraState withTransform: backgroundTransform.
	normalLayerState submitState: cameraState withTransform: normalTransform.
	foregroundLayerState submitState: cameraState withTransform: foregroundTransform.
				
	renderingViewport cameraLayersStates: self.

]
