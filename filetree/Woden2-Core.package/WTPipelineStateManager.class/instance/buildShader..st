abstract gpu baking
buildShader: shader
	| stageId |
	shader handleSet: OrderedCollection new.
	shader stages values do: [ :stage |
		stageId := StageNameMap at: stage name.
		shader handleSet add: (self buildShaderStage: stage)
	].

	shader handleSet ifEmpty: [ 
		self error: 'Not valid implementation for shader "', shader name , '" was found.'
	]
	