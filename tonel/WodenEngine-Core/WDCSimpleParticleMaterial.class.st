Class {
	#name : #WDCSimpleParticleMaterial,
	#superclass : #WDCMaterial,
	#instVars : [
		'vertexShader',
		'fragmentShader',
		'shaderLibrary'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #rendering }
WDCSimpleParticleMaterial >> activateForwardOn: stateTracker [
	stateTracker
		vertexShader: self vertexShader;
		fragmentShader: self fragmentShader;
		materialBlendingMode: WDCBlendingMode premultipliedAlphaOver.
		
	stateTracker
		materialDepthWriteMask: false.

	^ true
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> fragmentShader [
	^ fragmentShader ifNil: [ fragmentShader := self shaderLibrary getFragmentStage: #particleFragment ]
]

{ #category : #accessing }
WDCSimpleParticleMaterial >> shaderLibrary [
	^ shaderLibrary ifNil: [ shaderLibrary := engine loadShaderLibrary: 'shaders/material/simple-particle.dastrel' ].

]

{ #category : #accessing }
WDCSimpleParticleMaterial >> vertexShader [
	^ vertexShader ifNil: [vertexShader := self shaderLibrary getVertexStage: #particleVertex ]
]
