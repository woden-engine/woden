"
I am an importer for wavefront obj .mtl material library files.
"
Class {
	#name : #WDIWavefrontMTLImporter,
	#superclass : #Object,
	#instVars : [
		'currentDirectory',
		'currentMaterial',
		'materialLibrary'
	],
	#classVars : [
		'CommandDictionary'
	],
	#category : #'WodenEngine-Importers-Obj'
}

{ #category : #initialization }
WDIWavefrontMTLImporter class >> initialize [
	super initialize.
	CommandDictionary := Dictionary newFromPairs: {
		#newmtl . [ :myself :arguments | myself beginMaterial: arguments second ].
		#Ka . [ :myself :arguments | myself parseAmbientColor: arguments ].
		#map_Ka . [ :myself :arguments | myself parseAmbientMap: arguments second ].
		
		#Kd . [ :myself :arguments | myself parseDiffuseColor: arguments ].
		#map_Kd . [ :myself :arguments | myself parseDiffuseMap: arguments second ].
		
		#Ks . [ :myself :arguments | myself parseSpecularColor: arguments ].
		#map_Ks . [ :myself :arguments | myself parseSpecularMap: arguments second].
		
		#illum . [ :myself :arguments | myself parseIlluminationMode: arguments second ].
	}
]

{ #category : #initialization }
WDIWavefrontMTLImporter class >> loadFromFile: aFileName [
	^ self new loadFromFile: aFileName
]

{ #category : #'as yet unclassified' }
WDIWavefrontMTLImporter >> beginMaterial: materialName [
	currentMaterial := WDCGenericSurfaceMaterial new.
	materialLibrary at: materialName put: currentMaterial
]

{ #category : #'as yet unclassified' }
WDIWavefrontMTLImporter >> loadFromFile: aFileName [
	| fileRef |
	fileRef := aFileName asFileReference.
	currentDirectory := fileRef parent.
	^ fileRef readStreamDo: [ :fin |
		self parseLinesWith: (WDCLineReader on: fin)
	]
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseAmbientColor: parameters [
	"Ignored"
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseAmbientMap: textureName [
	"Ignored"
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseDiffuseColor: parameters [
	| r g b color |
	currentMaterial ifNil: [ ^ self ].
	r := parameters second asNumber.
	g := parameters third asNumber.
	b := parameters fourth asNumber.
	color := WMVector4F x: r y: g z: b w: currentMaterial albedoColor w.
	currentMaterial albedoColor: color
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseDiffuseMap: textureName [
	currentMaterial albedoTexture: (currentDirectory resolve: textureName)
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseIlluminationMode: parameters [
	"Ignored"
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseLine: line [
	| components command |
	line ifEmpty: [ ^ self ].
	line first = $# ifTrue: [ ^ self ].
	
	components := line splitOn: ' '.
	command := components first.
	(CommandDictionary at: command ifAbsent: [ ^ self ]) value: self value: components
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseLinesWith: lineReader [
	materialLibrary := Dictionary new.
	[lineReader atEnd] whileFalse: [ 
		self parseLine: lineReader nextLine
	].

	^ materialLibrary
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseSpecularColor: parameters [
	"Ignored because of PBR"
]

{ #category : #parsing }
WDIWavefrontMTLImporter >> parseSpecularMap: textureName [
	"Ignored because of PBR"
]
