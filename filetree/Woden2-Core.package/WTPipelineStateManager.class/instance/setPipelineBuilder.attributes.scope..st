pipeline state object building
setPipelineBuilder: builder attributes: attributes scope: anScope
	| basePSO attributeSetter |
	"Set the base attributes"
	attributes at: 'inherit-from' ifPresent: [ :baseName |
		basePSO := pipelineStateObjects at: baseName asSymbol ifAbsent: nil.
		basePSO ifNil: [ basePSO := pipelineStateObjects at: (anScope , baseName) asSymbol ifAbsent: nil ].
		basePSO ifNil: [ self error: 'unknown base PSO ' , baseName ].
		self setPipelineBuilder: builder attributes: basePSO description scope: basePSO scope.
	].
	
	"Set my attributes"
	attributes keysAndValuesDo: [ :attribute :value |
		attributeSetter := PipelineStateObjectAttributeParser at: attribute.
		self perform: attributeSetter with: builder with: value
	].
