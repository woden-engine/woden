Extension { #name : #FLMaterializer }

{ #category : #'*WodenEngine-Core' }
FLMaterializer >> setWodenMigrations [
	{
		StdnVector for: WDCTerrainMeshVertexF32.
		StdnVector for: UInt32.
		StdnVector for: Int32.
	} do: [ :each |
		self migrateClassNamed: each name toClass: each
	].
]

{ #category : #'*WodenEngine-Core' }
FLMaterializer class >> wodenMaterializationFromFileNamed: aFilename [
	^ FLPlatform current
		fileNamed: aFilename 
		readStreamDo: [ :aFileStream | 
			self newDefault setWodenMigrations; materializeFrom: aFileStream ]

]

{ #category : #'*WodenEngine-Core' }
FLMaterializer class >> wodenMaterializeFromFileNamed: aFilename [

	^ (self wodenMaterializationFromFileNamed: aFilename) root

]
