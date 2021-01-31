Class {
	#name : #WDIWavefrontObjExporter,
	#superclass : #WDCSimpleModelExporter,
	#category : #'WodenEngine-Importers-Obj'
}

{ #category : #'as yet unclassified' }
WDIWavefrontObjExporter class >> extension [
	^ 'obj'
]

{ #category : #'as yet unclassified' }
WDIWavefrontObjExporter >> encodeAsString [
	^ ByteString streamContents: [ :out |
		self writeToStream: out
	]
]

{ #category : #'as yet unclassified' }
WDIWavefrontObjExporter >> writeToFileNamed: aFileName [
	^ aFileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self writeToStream: out
	]
]

{ #category : #writing }
WDIWavefrontObjExporter >> writeToStream: out [
	positions do: [ :position |
		out nextPutAll: 'v '; print: position x; space; print: position y; space; print: position z; lf
	].

	texcoords do: [ :texcoord |
		out nextPutAll: 'vt '; print: texcoord x; space; print: texcoord y; space; lf
	].

	normals do: [ :normal |
		out nextPutAll: 'vn '; print: normal x; space; print: normal y; space; print: normal z; lf
	].

	submeshes do: [ :submesh |
		submesh facesDo: [ :faceIndices |
			faceIndices size > 2 ifTrue: [
				out nextPut: $f.
				faceIndices do: [ :index |
					| vertexIndex |
					vertexIndex := (indices at: index + 1) + 1.
					out space; print: vertexIndex.
					(texcoords isNotEmpty or: [normals isNotEmpty]) ifTrue: [ 
						texcoords ifEmpty: [ 
							out nextPutAll: '//'; print: vertexIndex.
						] ifNotEmpty: [ 
							out nextPut: $/.
							out print: vertexIndex.
							
							normals ifNotEmpty: [ 
								out nextPut: $/; print: vertexIndex
							]
						].
					].
				]
			] ifFalse: [
				out nextPutAll: 'l '.
				faceIndices do: [ :index |
					| vertexIndex |
					vertexIndex := (indices at: index + 1) + 1.
					out space; print: vertexIndex.
				]
			].
		
			out lf.
		].
	]


]
