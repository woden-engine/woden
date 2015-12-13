class initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	ShaderBindingTypeMap := IdentityDictionary newFromPairs: {
		#cbv . AGPU_SHADER_BINDING_TYPE_CBV .
		#srv . AGPU_SHADER_BINDING_TYPE_SRV .
		#uav . AGPU_SHADER_BINDING_TYPE_UAV .
		#sampler . AGPU_SHADER_BINDING_TYPE_SAMPLER .
	}.
	
	ShaderLanguageNameMap := Dictionary newFromPairs: {
		AGPU_SHADER_LANGUAGE_GLSL . #glsl .
		AGPU_SHADER_LANGUAGE_EGLSL . #eglsl .
		AGPU_SHADER_LANGUAGE_HLSL . #hlsl .
		AGPU_SHADER_LANGUAGE_BINARY . #binary .
		AGPU_SHADER_LANGUAGE_SPIR_V . #spirv .
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
		'shader-signature' . #setPipeline:shaderSignatureNamed: .
		'render-target-count' . #setPipeline:renderTargetCount: .
		'render-target-formats' . #setPipeline:renderTargetFormats: .
		'depth-stencil-format' . #setPipeline:depthStencilFormat: .
		'vertex-layout' . #setPipeline:vertexLayoutNamed: .
		'primitive-type' . #setPipeline:primitiveTypeNamed: .
		'shader' . #setPipeline:shaderNamed: .
	}.
	
	PrimitiveTypeNameMap := IdentityDictionary newFromPairs: { 
		#point . AGPU_PRIMITIVE_TYPE_POINT .
		#line . AGPU_PRIMITIVE_TYPE_LINE .
		#triangle . AGPU_PRIMITIVE_TYPE_TRIANGLE .
		#patch . AGPU_PRIMITIVE_TYPE_PATCH .
	}.