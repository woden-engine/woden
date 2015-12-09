state loading
loadStatesFromFile: aFileName
	| statesJson baseDir |
	baseDir := aFileName asFileReference parent.
	statesJson := self readJsonFromFile: aFileName.
	self loadStructuresFromFile: baseDir / (statesJson at: 'structures').
	self loadShaderSignaturesFromFile: baseDir / (statesJson at: 'shader-signatures').
	self loadVertexLayoutsFromFile: baseDir / (statesJson at: 'vertex-layouts').
	self loadShadersFromFile: baseDir / (statesJson at: 'shaders') prefix: ''.
