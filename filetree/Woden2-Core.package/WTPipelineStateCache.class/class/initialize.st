class initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	ShaderBindingTypeMap := IdentityDictionary newFromPairs: {
		#'uniform-buffer' . AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER .
		#'storage-buffer' . AGPU_SHADER_BINDING_TYPE_STORAGE_BUFFER .
		#'uniform-texel-buffer' . AGPU_SHADER_BINDING_TYPE_UNIFORM_TEXEL_BUFFER .
		#'storage-texel-buffer' . AGPU_SHADER_BINDING_TYPE_STORAGE_TEXEL_BUFFER .
		#'sampled-image' . AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE .
		#'storage-image' . AGPU_SHADER_BINDING_TYPE_STORAGE_IMAGE .
		#sampler . AGPU_SHADER_BINDING_TYPE_SAMPLER .
	}.
	
	ShaderLanguageNameMap := Dictionary newFromPairs: {
		AGPU_SHADER_LANGUAGE_NONE . #none .
		AGPU_SHADER_LANGUAGE_GLSL . #glsl .
		AGPU_SHADER_LANGUAGE_EGLSL . #eglsl .
		AGPU_SHADER_LANGUAGE_HLSL . #hlsl .
		AGPU_SHADER_LANGUAGE_BINARY . #binary .
		AGPU_SHADER_LANGUAGE_SPIR_V . #'spir-v' .
		AGPU_SHADER_LANGUAGE_METAL . #metal .
		AGPU_SHADER_LANGUAGE_METAL_AIR . #'metal-air'
	}.
	
	StageNameMap := Dictionary newFromPairs: {
		#fragment . AGPU_FRAGMENT_SHADER .
		#vertex . AGPU_VERTEX_SHADER .
		#geometry . AGPU_GEOMETRY_SHADER .
		#'tessellation-control' . AGPU_TESSELLATION_CONTROL_SHADER .
		#'tessellation-evaluation' . AGPU_TESSELLATION_EVALUATION_SHADER .
		#compute . AGPU_COMPUTE_SHADER .
	}.
	
	PipelineStateObjectAttributeParser := Dictionary newFromPairs: { 
		'abstract' . #setPipeline:dummyAttribute: .
		'inherit-from' . #setPipeline:dummyAttribute: .
		'mixin-variants' . #setPipeline:dummyAttribute: .
		'shader-signature' . #setPipeline:shaderSignatureNamed: .
		'front-face' . #setPipeline:frontFace: .
		'cull-mode' . #setPipeline:cullMode: .
		'render-target-count' . #setPipeline:renderTargetCount: .
		'render-target-formats' . #setPipeline:renderTargetFormats: .
		'depth-stencil-format' . #setPipeline:depthStencilFormat: .
		'depth-state' . #setPipeline:depthState: .
		'vertex-layout' . #setPipeline:vertexLayoutNamed: .
		'primitive-type' . #setPipeline:primitiveTypeNamed: .
		'shader' . #setPipeline:shaderNamed: .
		'sample-description' . #setPipeline:sampleDescription: .
		'stencil-state' . #setPipeline:stencilState: .
		'stencil-operations' . #setPipeline:stencilOperations: .
		'stencil-front-operations' . #setPipeline:stencilFrontOperations: .
		'stencil-back-operations' . #setPipeline:stencilBackOperations: .
		'blend-state' . #setPipeline:blendState: .
		'color-mask' . #setPipeline:colorMask:
	}.
	
	PrimitiveTopologyNameMap := IdentityDictionary newFromPairs: { 
		#points . AGPU_POINTS .
		#lines . AGPU_LINES .
		#'lines-adjacency' . AGPU_LINES_ADJACENCY .
		#'line-strip' . AGPU_LINE_STRIP .
		#'line-strip-adjacency' . AGPU_LINE_STRIP_ADJACENCY .
		#triangles . AGPU_TRIANGLES .
		#'triangles-adjacency' . AGPU_TRIANGLES_ADJACENCY .
		#'triangle-strip' . AGPU_TRIANGLE_STRIP .
		#'triangle-strip-adjacency' . AGPU_TRIANGLE_STRIP_ADJACENCY .
		#patches . AGPU_PATCHES .
	}.
	
	BlendingFactorNameMap := Dictionary newFromPairs: {
		#zero . AGPU_BLENDING_ZERO.
		#one . AGPU_BLENDING_ONE.
		#'source-color' . AGPU_BLENDING_SRC_COLOR.
		#'inverted-source-color' . AGPU_BLENDING_INVERTED_SRC_COLOR.
		#'source-alpha' . AGPU_BLENDING_SRC_ALPHA.
		#'inverted-source-alpha' . AGPU_BLENDING_INVERTED_SRC_ALPHA.
		#'dest-alpha' . AGPU_BLENDING_DEST_ALPHA.
		#'inverted-dest-alpha' . AGPU_BLENDING_INVERTED_DEST_ALPHA.
		#'dest-color' . AGPU_BLENDING_DEST_COLOR.
		#'inverted-dest-color' . AGPU_BLENDING_INVERTED_DEST_COLOR.
		#'source-alpha-sat' . AGPU_BLENDING_SRC_ALPHA_SAT.
	}.

	BlendingOperationNameMap := Dictionary newFromPairs: {
		#add . AGPU_BLENDING_OPERATION_ADD.
		#subtract . AGPU_BLENDING_OPERATION_SUBTRACT.
		#'reverse-subtract' . AGPU_BLENDING_OPERATION_REVERSE_SUBTRACT.
		#max . AGPU_BLENDING_OPERATION_MAX.
		#min . AGPU_BLENDING_OPERATION_MIN.
	}.
	
	CompareFunctionNameMap := Dictionary newFromPairs: {
		#always . AGPU_ALWAYS.
		#never . AGPU_NEVER.
		#less . AGPU_LESS.
		#'less-equal' . AGPU_LESS_EQUAL.
		#equal . AGPU_EQUAL.
		#'not-equal' . AGPU_NOT_EQUAL.
		#greater . AGPU_GREATER.
		#'greater-equal' . AGPU_GREATER_EQUAL.
	}.
	
	StencilOperationNameMap := Dictionary newFromPairs: {
		#keep . AGPU_KEEP.
		#zero . AGPU_ZERO.
		#replace . AGPU_REPLACE.
		#invert . AGPU_INVERT.
		#increase . AGPU_INCREASE.
		#'increase-wrap' . AGPU_INCREASE_WRAP.
		#decrease . AGPU_DECREASE.
		#'decrease-wrap' . AGPU_DECREASE_WRAP.
	}.
	
	CullModeNameMap := Dictionary newFromPairs: {
		#none . AGPU_CULL_MODE_NONE.
		#front . AGPU_CULL_MODE_FRONT.
		#back . AGPU_CULL_MODE_BACK.
		#'front-and-back' . AGPU_CULL_MODE_FRONT_AND_BACK.
	}.
	
	FaceWindingNameMap := Dictionary newFromPairs: {
		#clockwise . AGPU_CLOCKWISE .
		#'counter-clockwise' . AGPU_COUNTER_CLOCKWISE .
	}.
	