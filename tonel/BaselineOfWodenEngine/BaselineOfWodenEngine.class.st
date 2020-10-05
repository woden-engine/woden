Class {
	#name : #BaselineOfWodenEngine,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenEngine
}

{ #category : #baselines }
BaselineOfWodenEngine >> baseline: spec [
    <baseline>
    spec for: #'common' do: [
			spec blessing: #baseline.
			spec postLoadDoIt: #postLoadActions.
			spec
				baseline: #'NeoJSON' with: [
					spec
					repository: 'github://svenvc/NeoJSON:v17/repository' ].
			spec
				baseline: #'AbstractGPU' with: [
				spec
					repository: 'github://ronsaldo/abstract-gpu/tonel' ].
			spec
				baseline: #'AbstractPhysics' with: [
				spec
					repository: 'github://ronsaldo/abstract-physics/tonel' ].
			spec
				baseline: #'Dastrel' with: [
				spec
					repository: 'github://ronsaldo/dastrel/tonel' ].
			spec
				baseline: #'BabylonGraphics' with: [
				spec
					repository: 'github://ronsaldo/babylon-graphics/tonel';
                    loads: #(API) ].
			spec
				baseline: #'CyrusToolkit' with: [
				spec
					repository: 'github://ronsaldo/babylon-graphics/tonel' ].

			spec
				baseline: #'OpenAL' with: [
				spec
					repository: 'github://ronsaldo/pharo-openal/tonel' ].
			spec
				baseline: #'Sysmel' with: [
				spec
					repository: 'github://ronsaldo/sysmel' ].
		spec package: #'WodenEngine-NativeStructures' with: [
				spec requires: #(#'Sysmel')].
		spec package: #'WodenEngine-NativeDastrelBindings' with: [
				spec requires: #(#'Dastrel' #'WodenEngine-NativeStructures')].
		spec package: #'WodenEngine-Core' with: [
				spec requires: #(#'NeoJSON' #'AbstractGPU' #'Dastrel' #'Sysmel' #'WodenEngine-NativeStructures' #'WodenEngine-NativeDastrelBindings')].
		spec package: #'WodenEngine-Babylon' with: [
				spec requires: #('WodenEngine-Core' 'BabylonGraphics' 'CyrusToolkit')].
		spec package: #'WodenEngine-Scene' with: [
				spec requires: #('WodenEngine-Core')].
		spec package: #'WodenEngine-Importers' with: [
				spec requires: #('WodenEngine-Core' #'WodenEngine-Scene')].
		spec package: #'WodenEngine-Samples' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Babylon' 'WodenEngine-Scene' 'WodenEngine-EntitySystem' 'WodenEngine-OldGameSystem' #'WodenEngine-Importers')].
		spec package: #'WodenEngine-Physics' with: [
				spec requires: #('WodenEngine-Core' 'AbstractPhysics')].
		spec package: #'WodenEngine-OpenAL' with: [
				spec requires: #('WodenEngine-Core' 'OpenAL')].
		spec package: #'WodenEngine-EntitySystem' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Babylon' 'WodenEngine-Scene' 'WodenEngine-Physics' 'WodenEngine-OpenAL')].
		spec package: #'WodenEngine-OldGameSystem' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Babylon' 'WodenEngine-Scene' 'WodenEngine-Physics' 'WodenEngine-OpenAL')].
		spec package: #'WodenEngine-OldLevelEditor' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Babylon' 'WodenEngine-Scene' 'WodenEngine-Physics' 'WodenEngine-OpenAL' 'WodenEngine-OldGameSystem')].
		spec package: #'WodenEngine-Spec2' with: [
				spec requires: #(#'WodenEngine-Core')].
		spec package: #'WodenEngine-Editor-Model' with: [
				spec requires: #(#'WodenEngine-Core')].
		spec package: #'WodenEngine-Editor-UI' with: [
				spec requires: #(#'WodenEngine-Core' #'WodenEngine-Spec2' #'WodenEngine-Editor-Model')].

		spec package: #'WodenEngine-Roassal' with: [
				spec requires: #('WodenEngine-Core' 'WodenEngine-Babylon' 'WodenEngine-Scene' 'WodenEngine-Physics')].

		spec group: 'default' with: #('WodenEngine-Core' 'WodenEngine-Babylon' 'WodenEngine-Samples' 'WodenEngine-EntitySystem' 'WodenEngine-OldGameSystem' 'WodenEngine-OldLevelEditor' 'WodenEngine-Roassal' #'WodenEngine-Editor-UI')
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

]
