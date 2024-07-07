Class {
	#name : #BaselineOfWodenEngine,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenEngine
}

{ #category : #baselines }
BaselineOfWodenEngine >> baseline: spec [
    <baseline>
    spec for: #'common' do: [
		spec
			blessing: #baseline;
			postLoadDoIt: #postLoadActions;
			baseline: #'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:v17/repository' ];
			baseline: #'AbstractGPU' with: [
				spec repository: 'github://ronsaldo/abstract-gpu/tonel' ];
			baseline: #'AbstractPhysics' with: [
				spec repository: 'github://ronsaldo/abstract-physics/tonel' ];
			baseline: #'Dastrel' with: [
				spec repository: 'github://ronsaldo/dastrel/tonel' ];
			baseline: #'FormSceneGraph' with: [
				spec repository: 'github://ronsaldo/form-scene-graph'; loads: #(AcceleratedAbstractGPU) ];
			baseline: #'OpenAL' with: [
				spec repository: 'github://ronsaldo/pharo-openal/tonel' ];
			baseline: #'Sysmel' with: [
				spec repository: 'github://desromech/sysmel-alpha' ];
			package: #'WodenEngine-NativeStructures' with: [
				spec requires: #(#'Sysmel')];
			package: #'WodenEngine-NativeDastrelBindings' with: [
				spec requires: #(#'Dastrel' #'WodenEngine-NativeStructures')];
			package: #'WodenEngine-Core' with: [
				spec requires: #(#'NeoJSON' #'AbstractGPU' #'Dastrel' #'Sysmel' #'FormSceneGraph' #'WodenEngine-NativeStructures' #'WodenEngine-NativeDastrelBindings')];
			package: #'WodenEngine-Scene' with: [
				spec requires: #('WodenEngine-Core')];
			package: #'WodenEngine-Importers' with: [
				spec requires: #('WodenEngine-Core' #'WodenEngine-Scene')];
			package: #'WodenEngine-Samples' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Scene' 'WodenEngine-EntitySystem' #'WodenEngine-Importers')];
			package: #'WodenEngine-Physics' with: [
				spec requires: #('WodenEngine-Core' 'AbstractPhysics')];
			package: #'WodenEngine-OpenAL' with: [
				spec requires: #('WodenEngine-Core' 'OpenAL')];
			package: #'WodenEngine-EntitySystem' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Scene' 'WodenEngine-Physics' 'WodenEngine-OpenAL')];
			package: #'WodenEngine-Spec2' with: [
				spec requires: #(#'WodenEngine-Core' #'WodenEngine-Roassal')];
			package: #'WodenEngine-Editor-Model' with: [
				spec requires: #(#'WodenEngine-Core')];
			package: #'WodenEngine-Editor-UI' with: [
				spec requires: #(#'WodenEngine-Core' #'WodenEngine-Spec2' #'WodenEngine-Editor-Model')];
			package: #'WodenEngine-CAD' with: [
				spec requires: #(#'Sysmel')];
			package: #'WodenEngine-CAD-Tests' with: [
				spec requires: #(#'WodenEngine-CAD')];
			package: #'WodenEngine-Roassal' with: [
				spec requires: #('WodenEngine-Core'  'WodenEngine-Scene' 'WodenEngine-Physics')];

			group: 'default' with: #(
				'WodenEngine-Core'  'WodenEngine-Samples'
				'WodenEngine-EntitySystem' 'WodenEngine-Roassal' #'WodenEngine-Editor-UI'
			)
	]

]

{ #category : #baselines }
BaselineOfWodenEngine >> postLoadActions [
	"Reduce the idle time of the image."
	self flag: 'FIXME: This hack should not be required when the idle item is computed according to the next pending delay.'.
	(ProcessorScheduler respondsTo: #idleTime:) ifTrue: [
		ProcessorScheduler idleTime: 250.
	].

	"Rebuild the field accessors"
	self flag: 'FIXME: Remove this hack when is not required anymore in Pharo'.
	FFIExternalStructure allSubclassesDo: #rebuildFieldAccessors.

	self class environment at: #SpNullApplication ifPresent: [ :found | found reset ].
	self class environment at: #StPharoApplication ifPresent: [ :found | found current reset ]
]
