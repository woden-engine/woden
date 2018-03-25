"
VR headset description.

This implementation is based on: https://support.google.com/cardboard/manufacturers/answer/6324808?hl=en&ref_topic=6322188 and https://github.com/borismus/webvr-boilerplate/blob/d91cc2866bd54e65d59022800f62c7e160dc9fee/src/device-info.js
"
Class {
	#name : #WDCVRHeadsetDescription,
	#superclass : #Object,
	#instVars : [
		'extent',
		'dpi',
		'fov',
		'interLensDistance',
		'screenVerticalAlignment',
		'screenLensDistance',
		'distortionCoefficients',
		'ipd',
		'leftProjection',
		'rightProjection',
		'nearDistance',
		'farDistance',
		'invertedY',
		'state',
		'physicalExtent',
		'bevelLength',
		'leftUndistortedProjection',
		'rightUndistortedProjection',
		'validMatrices'
	],
	#classVars : [
		'InverseDistortRadiusEpsilon',
		'MetersPerInch'
	],
	#category : 'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCVRHeadsetDescription class >> default [
	^ self psVR
]

{ #category : #initialization }
WDCVRHeadsetDescription class >> initialize [
	MetersPerInch := 0.0254.
	InverseDistortRadiusEpsilon := 0.0001
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription class >> psVR [
	"Parameters obtained from https://github.com/gusmanb/PSVRFramework/blob/master/VRVideoPlayer/vrdevice.h"
	^ self new
		extent: 1920 @ 1080 dpi: 386.47 @ 386.47;

		fov: 68.0;
		interLensDistance: 0.0630999878;
		screenLensDistance: 0.0354;
		screenVerticalAlignment: 0.0394899882;
		distortionCoefficients: (WMVector2F x: 0.22 y: 0.24);
		yourself
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeDistortedLeftEyeFOV [
	
	| centerLeftDistance centerRightDistance bottomDistance topDistance centerLeftAngle centerRightAngle bottomAngle topAngle maxFovAngle eyeToScreenDistance |
	centerLeftDistance := (physicalExtent x - interLensDistance) / 2.
	centerRightDistance := interLensDistance / 2.
	bottomDistance := screenVerticalAlignment - bevelLength.
	topDistance := physicalExtent y - bottomDistance.
	
	maxFovAngle := fov degreesToRadians.

	eyeToScreenDistance := screenLensDistance.
	
	centerLeftAngle := (self distortRadius: centerLeftDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	centerRightAngle := (self distortRadius: centerRightDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	bottomAngle := (self distortRadius: bottomDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	topAngle := (self distortRadius: topDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	
	^ WDCVREyeFieldOfView new
		left: centerLeftAngle; right: centerRightAngle;
		bottom: bottomAngle; top: topAngle;
		yourself
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeLeftEyeFov: distorted [
	^ distorted ifTrue: [self computeDistortedLeftEyeFOV] ifFalse: [ self computeUndistortedLeftEyeFOV ]
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeLeftProjectionMatrix: distorted [
	| eyeFov |
	eyeFov := self computeLeftEyeFov: distorted.
	^ eyeFov reverseDepthNear: nearDistance far: farDistance invertedY: invertedY
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeProjectionMatrices [
	| leftEyeProjection rightEyeProjection leftEyeUndistortedProjection rightEyeUndistortedProjection |
	validMatrices ifTrue: [ ^ true ].
	
	leftProjection := self computeLeftProjectionMatrix: true.
	leftUndistortedProjection := self computeLeftProjectionMatrix: false.
	
	rightProjection := self computeRightProjectionMatrix: true.
	rightUndistortedProjection := self computeRightProjectionMatrix: false.
		
	leftEyeProjection := WMMatrix3F ndcToTexcoord2D * leftProjection as2DProjectionMatrix.
	leftEyeUndistortedProjection := WMMatrix3F ndcToTexcoord2D * leftUndistortedProjection as2DProjectionMatrix.
	rightEyeProjection := WMMatrix3F ndcToTexcoord2D * rightProjection as2DProjectionMatrix.
	rightEyeUndistortedProjection := WMMatrix3F ndcToTexcoord2D * rightUndistortedProjection as2DProjectionMatrix.
	
	state := WTVRState new
		leftProjectionTransform: leftEyeProjection as2DProjectionVector;
		leftUndistortedProjectionInverseTransform: leftEyeUndistortedProjection as2DInverseProjectionVector;
		rightProjectionTransform: rightEyeProjection as2DProjectionVector;
		rightUndistortedProjectionInverseTransform: rightEyeUndistortedProjection as2DInverseProjectionVector;
		distortionCoefficients: distortionCoefficients;
		yourself.
		
	validMatrices := true.

]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeRightEyeFov: distorted [
	| leftEyeFov |
	"For the right eye, just swap the left and right angles."
	leftEyeFov := self computeLeftEyeFov: distorted.
	^ WDCVREyeFieldOfView new
		left: leftEyeFov right;
		right: leftEyeFov left;
		bottom: leftEyeFov bottom;
		top: leftEyeFov top;
		yourself
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeRightProjectionMatrix: distorted [
	| eyeFov |
	eyeFov := self computeRightEyeFov: distorted.
	^ eyeFov reverseDepthNear: nearDistance far: farDistance invertedY: invertedY
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeUndistortedLeftEyeFOV [
	| params |
	params := self computeUndistortedParameters.
	
	^ WDCVREyeFieldOfView new
		left: params outside arcTan; right: params inner arcTan;
		bottom: params bottom arcTan; top: params top arcTan;
		yourself
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> computeUndistortedParameters [
	| eyeToScreenDistance halfLensDistance screenWidth screenHeight eyePositionX eyePositionY viewerMaxDistance outerDistance innerDistance bottomDistance topDistance |
	eyeToScreenDistance := screenLensDistance.
	halfLensDistance := (interLensDistance / 2) / eyeToScreenDistance.
	screenWidth := physicalExtent x / eyeToScreenDistance.
	screenHeight := physicalExtent y / eyeToScreenDistance.

	eyePositionX := screenWidth / 2 - halfLensDistance.
	eyePositionY := (screenVerticalAlignment - bevelLength) / eyeToScreenDistance.

	viewerMaxDistance := self inverseDistortRadius: fov degreesToRadians tan.
	
	outerDistance := eyePositionX min: viewerMaxDistance.
	innerDistance := halfLensDistance min: viewerMaxDistance.
	bottomDistance := eyePositionY min: viewerMaxDistance.
	topDistance := screenHeight - bottomDistance min: viewerMaxDistance.

	^ WDCVREyeViewportParameters new
		outside: outerDistance;
		inner: innerDistance;
		bottom: bottomDistance;
		top: topDistance;
		eyeX: eyePositionX;
		eyeY: eyePositionY;
		yourself
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> distortFactor: aRadius [
	| r2 r4 |
	r2 := aRadius*aRadius.
	r4 := r2*r2.
	^ 1.0 + (r2*distortionCoefficients x) + (r4*distortionCoefficients y)
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> distortPoint: aPoint [
	^ aPoint * (self distortFactor: aPoint length)
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> distortRadius: radius [
	^ radius * (self distortFactor: radius)
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> distortRadiusDerivative: radius [
	| r2 r4 |
	r2 := radius*radius.
	r4 := r2*r2.
	^ 1.0 + (3.0*distortionCoefficients x *r2) + (5.0*distortionCoefficients x *r4)
]

{ #category : #accessing }
WDCVRHeadsetDescription >> distortionCoefficients [
	^ distortionCoefficients
]

{ #category : #accessing }
WDCVRHeadsetDescription >> distortionCoefficients: anObject [
	distortionCoefficients := anObject
]

{ #category : #accessing }
WDCVRHeadsetDescription >> dpi [
	^ dpi
]

{ #category : #accessing }
WDCVRHeadsetDescription >> extent [
	^ extent
]

{ #category : #accessing }
WDCVRHeadsetDescription >> extent: anExtent dpi: horizontalAndVerticalDPI [
	extent := anExtent.
	dpi := horizontalAndVerticalDPI.
	physicalExtent := ((extent x / horizontalAndVerticalDPI x) * MetersPerInch) @ ((extent y / horizontalAndVerticalDPI y) * MetersPerInch).
	self invalidate
]

{ #category : #accessing }
WDCVRHeadsetDescription >> farDistance [
	^ farDistance
]

{ #category : #accessing }
WDCVRHeadsetDescription >> farDistance: anObject [
	farDistance := anObject.
	self invalidate
]

{ #category : #accessing }
WDCVRHeadsetDescription >> fov [
	^ fov
]

{ #category : #accessing }
WDCVRHeadsetDescription >> fov: anObject [
	fov := anObject.
	self invalidate
]

{ #category : #initialization }
WDCVRHeadsetDescription >> initialize [
	bevelLength := 0.004. "Meters"
	nearDistance := 0.01.
	farDistance := 10000.0.
	invertedY := false.
	
	ipd := 0.064.
	
	validMatrices := false.
]

{ #category : #accessing }
WDCVRHeadsetDescription >> interLensDistance [
	^ interLensDistance
]

{ #category : #accessing }
WDCVRHeadsetDescription >> interLensDistance: anObject [
	interLensDistance := anObject.
	
	self flag: 'TODO: Check and handle this properly.'.
	ipd := interLensDistance.
	self invalidate
]

{ #category : #scrolling }
WDCVRHeadsetDescription >> invalidate [
	validMatrices := false.
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> inverseDistortRadius: distortedRadius [
	| radius nextRadius eps |
	radius := distortedRadius.
	[
		nextRadius := radius - (((self distortRadius: radius) - distortedRadius) / (self distortRadiusDerivative: radius)).
		eps := (radius - nextRadius).
		radius := nextRadius
	] doWhileFalse: [ InverseDistortRadiusEpsilon negated <= eps and: [ eps <= InverseDistortRadiusEpsilon ]  ].
	^ radius
]

{ #category : #accessing }
WDCVRHeadsetDescription >> invertedY [
	^ invertedY
]

{ #category : #accessing }
WDCVRHeadsetDescription >> invertedY: anObject [
	invertedY := anObject.
	self invalidate
]

{ #category : #accessing }
WDCVRHeadsetDescription >> ipd [
	^ ipd
]

{ #category : #accessing }
WDCVRHeadsetDescription >> ipd: anObject [
	ipd := anObject.
	self invalidate
]

{ #category : #accessing }
WDCVRHeadsetDescription >> leftProjection [
	self computeProjectionMatrices.
	^ leftProjection
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> leftTranslation [
	^ WMVector3F x: ipd * -0.5
]

{ #category : #accessing }
WDCVRHeadsetDescription >> leftUndistortedProjection [
	self computeProjectionMatrices.
	^ leftUndistortedProjection
]

{ #category : #accessing }
WDCVRHeadsetDescription >> nearDistance [
	^ nearDistance
]

{ #category : #accessing }
WDCVRHeadsetDescription >> nearDistance: anObject [
	nearDistance := anObject.
	self invalidate
]

{ #category : #accessing }
WDCVRHeadsetDescription >> rightProjection [
	self computeProjectionMatrices.
	^ rightProjection
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> rightTranslation [
	^ WMVector3F x: ipd * 0.5
]

{ #category : #accessing }
WDCVRHeadsetDescription >> rightUndistortedProjection [
	self computeProjectionMatrices.
	^ rightUndistortedProjection
]

{ #category : #accessing }
WDCVRHeadsetDescription >> screenLensDistance [
	^ screenLensDistance
]

{ #category : #accessing }
WDCVRHeadsetDescription >> screenLensDistance: anObject [
	screenLensDistance := anObject
]

{ #category : #accessing }
WDCVRHeadsetDescription >> screenVerticalAlignment [
	^ screenVerticalAlignment
]

{ #category : #accessing }
WDCVRHeadsetDescription >> screenVerticalAlignment: anObject [
	screenVerticalAlignment := anObject
]

{ #category : #accessing }
WDCVRHeadsetDescription >> state [
	self computeProjectionMatrices.
	^ state
]

{ #category : #'as yet unclassified' }
WDCVRHeadsetDescription >> undistort: aPoint [
	^ aPoint / (self undistortRadius: aPoint length)
]
