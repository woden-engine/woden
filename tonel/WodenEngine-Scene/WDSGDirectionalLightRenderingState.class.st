"
I represent a directional light rendering state.
"
Class {
	#name : #WDSGDirectionalLightRenderingState,
	#superclass : #WDSGShadowLightRenderingStateLayer,
	#instVars : [
		'cameraFrustum',
		'mainCameraTransform',
		'lightVector',
		'extraShadowDistanceFactor',
		'shadowCastingBody'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #accessing }
WDSGDirectionalLightRenderingState >> cameraFrustum [
	^ cameraFrustum ifNil: [cameraFrustum := mainCamera frustum ]
]

{ #category : #'shadow mapping' }
WDSGDirectionalLightRenderingState >> computeUpVectorWithShadowCastingBody: shadowCastingBody [
	| vector viewPosition |
	vector := WMVector3F zero.
	viewPosition := mainCameraTransform translation.
	shadowCastingBody do: [ :point |
		vector := vector + (point - viewPosition)
	].
	^ vector normalized
]

{ #category : #'shadow mapping' }
WDSGDirectionalLightRenderingState >> extractShadowCastingBodyPoints [
	| points worldCorner |
	points := OrderedCollection new.
	self cameraFrustum corners do: [ :corner |
		worldCorner := mainCameraTransform transformPosition3: corner.
		
		points
			add: worldCorner;
			add: worldCorner + (lightVector * extraShadowDistanceFactor);
			add: worldCorner - (lightVector * extraShadowDistanceFactor)
	].

	^ points
]

{ #category : #'as yet unclassified' }
WDSGDirectionalLightRenderingState >> nearDistance: nearDistance farDistance: farDistance [
	cameraFrustum := mainCamera frustumForNearDistance: nearDistance farDistance: farDistance
]

{ #category : #'shadow mapping' }
WDSGDirectionalLightRenderingState >> setupShadowMappingTransforms [
	"
	Light space perspective shadow mapping:
	Michael Wimmer, Daniel Scherzer, and Werner Purgathofer. 2004. Light space perspective shadow maps. In Proceedings of the Fifteenth Eurographics conference on Rendering Techniques (EGSR'04). Eurographics Association, Aire-la-Ville, Switzerland, Switzerland, 143-151. DOI=http://dx.doi.org/10.2312/EGWR/EGSR04/143-151
	
	===========================================================================
	This implementation is based around the sample code from the paper,
	which includes the following copyright notices:
	
http://www.cg.tuwien.ac.at/research/vr/lispsm/

    Copyright and Disclaimer:

    This code is copyright Vienna University of Technology, 2004.
    Please feel FREE to COPY and USE the code to include it in your own work, 
    provided you include this copyright notice.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 

    Authors: 

    Daniel Scherzer (scherzer@cg.tuwien.ac.at)
    Michael Wimmer (wimmer@cg.tuwien.ac.at)

    Date: October 14, 2004
	"
	| frustumBox viewVector viewPosition cosGamma sinGamma lightDepth z_n z_f nearDistance farDistance upVector perspectivePoint perspectiveTransform falloff |
	mainCameraTransform := "self roundCameraTransform:" mainCamera renderTransform.
	extraShadowDistanceFactor := light extraShadowDistanceFactor.
	
	lightVector := light renderTransform matrix transformVector3: (WMVector3F z: -1.0).
	viewPosition := mainCameraTransform translation.
	viewVector := (mainCameraTransform transformVector3: (WMVector3F z: -1.0)) normalized.
	shadowCastingBody := self extractShadowCastingBodyPoints.

	"Compute an initial render transform."	
	upVector := self computeUpVectorWithShadowCastingBody: shadowCastingBody.
	
	"When the up vector and the lightvector are close to parallel, fallback to uniform shadow mapping."
	(upVector dot: lightVector) abs > 0.73 ifTrue: [
		^ self setupUniformShadowMappingTransforms
	].
	
	renderTransform := WMReversibleAffineTransformF from: viewPosition lookAtDirection: lightVector up: upVector.
	
	frustumBox := WMBox3DF empty.
	shadowCastingBody do: [ :point |
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: point).
	].

	"Compute the perspective transformation near and far planes"
	cosGamma := lightVector dot: viewVector.
	sinGamma := (1.0 - (cosGamma*cosGamma)) sqrt.
	falloff := 1.0 / sinGamma.
	
	lightDepth := frustumBox height. "Perspective transform depth"
	z_n := mainCamera nearDistance*falloff.
	z_f := z_n + (lightDepth/falloff).
	nearDistance := (z_n + (z_n*z_f) sqrt)*falloff.
	farDistance := nearDistance + lightDepth.
	
	"Transcript show: nearDistance; space; show: farDistance; cr."

	"Compute the perspective point and the new render transform"
	perspectivePoint := viewPosition - (upVector*(nearDistance - mainCamera nearDistance)).
	renderTransform := WMReversibleAffineTransformF from: perspectivePoint lookAtDirection: lightVector up: upVector.
	
	Transcript show: perspectivePoint; space; show: farDistance; cr.

	perspectiveTransform := WMMatrix4F newFrom: { 
		1.0 . 0.0 . 0.0 . 0.0 .
		0.0 . (farDistance + nearDistance)/(farDistance - nearDistance) . 0.0 . -2.0*farDistance*nearDistance/(farDistance - nearDistance)  .
		0.0 . 0.0 . 1.0 . 0.0 .
		0.0 . 1.0 . 0.0 . 0.0 .
	}.

	frustumBox := WMBox3DF empty.
	shadowCastingBody do: [ :point |
		frustumBox insertPoint: (perspectiveTransform perspectiveTransformPosition3: (renderTransform inverseTransformPosition3: point)).
	].

	shadowProjectionMatrix := frustumBox mappingToNDCCoordinatesReverseDepth * perspectiveTransform
]

{ #category : #'shadow mapping' }
WDSGDirectionalLightRenderingState >> setupUniformShadowMappingTransforms [
	| frustumBox viewVector viewPosition |
	mainCameraTransform := self roundCameraTransform: mainCamera renderTransform.
	extraShadowDistanceFactor := light extraShadowDistanceFactor.
	
	viewPosition := mainCameraTransform translation.
	viewVector := mainCameraTransform transformVector3: (WMVector3F z: -1.0).
	
	renderTransform := WMReversibleAffineTransformF from: viewPosition lookAtDirection: lightVector up: viewVector.
	
	frustumBox := WMBox3DF empty.
	shadowCastingBody do: [ :point |
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: point).
	].

	shadowProjectionMatrix := frustumBox mappingToNDCCoordinatesReverseDepth
]

{ #category : #'shadow mapping' }
WDSGDirectionalLightRenderingState >> viewStateForCameraTransform: cameraTransform [
	| state |
	state := super viewStateForCameraTransform: cameraTransform.
	state
		cascadeSplitOffsets: (WMVector4F x: 0.0 y: 1.0 z: 0.0 w: 0.0);
		cascadeFrustumPlane: (WMVector4F x: 0.0 y: 0.0 z: 0.0 w: 0.0).
	^ state
]
