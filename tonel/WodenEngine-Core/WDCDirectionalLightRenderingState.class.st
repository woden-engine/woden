"
I represent a directional light rendering state.
"
Class {
	#name : #WDCDirectionalLightRenderingState,
	#superclass : #WDCShadowLightRenderingStateLayer,
	#instVars : [
		'cameraFrustum',
		'mainCameraTransform',
		'lightVector',
		'shadowCastingBody',
		'cameraNearDistance',
		'cameraFarDistance'
	],
	#category : #'WodenEngine-Core-Lighting'
}

{ #category : #accessing }
WDCDirectionalLightRenderingState >> cameraFarDistance [
	^ cameraFarDistance ifNil: [ mainCamera farDistance ]
]

{ #category : #accessing }
WDCDirectionalLightRenderingState >> cameraFrustum [
	^ cameraFrustum ifNil: [cameraFrustum := mainCamera frustum ]
]

{ #category : #accessing }
WDCDirectionalLightRenderingState >> cameraNearDistance [
	^ cameraNearDistance ifNil: [ mainCamera nearDistance ]
]

{ #category : #'shadow mapping' }
WDCDirectionalLightRenderingState >> computeUpVectorWithViewVector: v lightVector: l [
	| ln |
	ln := l normalized.
	^ ((ln cross: v) normalized cross: ln) normalized
]

{ #category : #'shadow mapping' }
WDCDirectionalLightRenderingState >> computeViewVectorWithShadowCastingBody: body [
	| vector viewPosition |
	vector := WMVector3F zero.
	viewPosition := mainCameraTransform translation.
	body do: [ :point |
		vector := vector + (point - viewPosition)
	].
	^ vector normalized
]

{ #category : #'shadow mapping' }
WDCDirectionalLightRenderingState >> extractShadowCastingBodyPoints [
	| points worldCorner sceneBoundingBox shadowCastingVector shadowCastingMaxExtent flattenedWorldCorner |
	points := OrderedCollection new.
	shadowCastingVector := lightVector negated.
	shadowCastingMaxExtent := Float negativeInfinity.
	sceneBoundingBox := renderingLight node scene normalLayer globalBoundingBox.
	
	sceneBoundingBox cornersDo: [ :corner |
		| extent |
		extent := corner dot: shadowCastingVector.
		shadowCastingMaxExtent := shadowCastingMaxExtent max: extent.
	].
	
	self cameraFrustum corners do: [ :corner |
		worldCorner := mainCameraTransform transformPosition3: corner.
		flattenedWorldCorner := worldCorner - (shadowCastingVector* (shadowCastingVector dot: worldCorner)).
		
		points
			add: worldCorner;
			add: flattenedWorldCorner + (shadowCastingVector * shadowCastingMaxExtent).
	].

	^ points
]

{ #category : #'as yet unclassified' }
WDCDirectionalLightRenderingState >> nearDistance: nearDistance farDistance: farDistance [
	cameraFrustum := mainCamera frustumForNearDistance: nearDistance farDistance: farDistance.
	cameraNearDistance := nearDistance.
	cameraFarDistance := farDistance
]

{ #category : #'shadow mapping' }
WDCDirectionalLightRenderingState >> setupShadowMappingTransforms [
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
	| frustumBox viewVector viewPosition cosGamma sinGamma lightDepth z_n z_f nearDistance farDistance upVector perspectivePoint perspectiveTransform falloff bodyNearDistance shadowMapWarpNearDistance |
	mainCameraTransform := "self roundCameraTransform:" mainCamera globalTransform.
	
	lightVector := renderingLight transform matrix transformVector3: (WMVector3F z: -1.0).
	viewPosition := mainCameraTransform translation.
	viewVector := (mainCameraTransform transformVector3: (WMVector3F z: -1.0)) normalized.
	shadowCastingBody := self extractShadowCastingBodyPoints.

	"Compute an initial render transform."	
	upVector := self computeUpVectorWithViewVector: viewVector lightVector: lightVector.
	"self computeUpVectorWithShadowCastingBody: shadowCastingBody."

	"When the up vector and the lightvector are close to parallel, fallback to uniform shadow mapping."
	"(viewVector dot: lightVector) abs > 0.999 ifTrue: [
		^ self setupUniformShadowMappingTransforms
	]."
	
	renderTransform := WMReversibleAffineTransformF from: viewPosition lookAtDirection: lightVector up: upVector.
	
	frustumBox := WMBox3DF empty.
	shadowCastingBody do: [ :point |
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: point).
	].

	"Compute the perspective transformation near and far planes. This is based on the sample code of the paper."
	cosGamma := lightVector dot: viewVector.
	sinGamma := (1.0 - (cosGamma*cosGamma)) sqrt.
	falloff := 1.0 / sinGamma.

	bodyNearDistance := frustumBox min y.
	shadowMapWarpNearDistance := 1.0.
	
	lightDepth := frustumBox height.
	z_n := shadowMapWarpNearDistance *falloff.
	z_f := z_n + (lightDepth/falloff).
	nearDistance := (z_n + (z_n*z_f) sqrt)*falloff.
	
	"Mix the near distance distributions"
	farDistance := nearDistance + lightDepth.

	"Compute the perspective point and the new render transform"
	perspectivePoint := viewPosition - (upVector*(nearDistance - bodyNearDistance)).
	renderTransform := WMReversibleAffineTransformF from: perspectivePoint lookAtDirection: lightVector up: upVector.

	perspectiveTransform := WMMatrix4F newFrom: { 
		1.0 . 0.0 . 0.0 . 0.0 .
		0.0 . (farDistance + nearDistance)/(farDistance - nearDistance) . 0.0 . -2.0*farDistance*nearDistance/(farDistance - nearDistance)  .
		0.0 . 0.0 . 1.0 . 0.0 .
		0.0 . 1.0 . 0.0 . 0.0 .
	}.
	"perspectiveTransform := WMMatrix4F identity."

	frustumBox := WMBox3DF empty.
	shadowCastingBody do: [ :point |
		frustumBox insertPoint: (perspectiveTransform perspectiveTransformPosition3: (renderTransform inverseTransformPosition3: point)).
	].

	"Transcript show: frustumBox; cr."
	shadowProjectionMatrix := (frustumBox mappingToNDCCoordinatesReverseDepth: engine engine projectionInvertedY) * perspectiveTransform
]

{ #category : #'shadow mapping' }
WDCDirectionalLightRenderingState >> setupUniformShadowMappingTransforms [
	| frustumBox viewVector viewPosition |
	mainCameraTransform := self roundCameraTransform: mainCamera globalTransform.
	
	viewPosition := mainCameraTransform translation.
	viewVector := mainCameraTransform transformVector3: (WMVector3F z: -1.0).
	
	"renderTransform := WMReversibleAffineTransformF from: viewPosition lookAtDirection: lightVector up: viewVector."
	renderTransform := renderingLight transform.
	
	frustumBox := WMBox3DF empty.
	shadowCastingBody do: [ :point |
		frustumBox insertPoint: (renderTransform inverseTransformPosition3: point).
	].

	shadowProjectionMatrix := frustumBox mappingToNDCCoordinatesReverseDepth: engine projectionInvertedY
]

{ #category : #'shadow mapping' }
WDCDirectionalLightRenderingState >> viewStateForCameraTransform: cameraTransform [
	| state |
	state := super viewStateForCameraTransform: cameraTransform.
	state
		cascadeSplitOffsets: (WMVector4F x: 0.0 y: 1.0 z: 0.0 w: 0.0);
		cascadeFrustumPlane: (WMVector4F x: 0.0 y: 0.0 z: 0.0 w: 0.0).
	^ state
]
