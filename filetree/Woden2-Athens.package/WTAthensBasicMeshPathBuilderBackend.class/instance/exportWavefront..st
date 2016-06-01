as yet unclassified
exportWavefront: fileReference
	fileReference writeStreamDo: [ :out |
		out truncate.
		vertices do: [ :v | 
			out nextPutAll: 'v '; print: v x; space; print: v y; nextPutAll: ' 0.0'; lf.
		].
	
		0 to: indices size // 3 - 1 do: [ :i |
			out nextPutAll: 'f '; print: (indices at: i*3 + 1) + 1; space; print: (indices at: i*3 + 2) + 1; space; print: (indices at: i*3 + 3) + 1; lf
		]
	]