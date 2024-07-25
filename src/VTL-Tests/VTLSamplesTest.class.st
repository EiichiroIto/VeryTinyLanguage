"
A CVTLSamplesTest is a test class for testing the behavior of CVTLSamples
"
Class {
	#name : #VTLSamplesTest,
	#superclass : #TestCase,
	#category : #'VTL-Tests'
}

{ #category : #constants }
VTLSamplesTest >> defaultRandomSeed [

	^ 12345
]

{ #category : #private }
VTLSamplesTest >> execute: aString [

	| obj ui |
	obj := self newObj.
	self setupFor: obj.
	ui := self newUI.
	aString linesDo: [ :str | ui addInput: str ].
	ui addInput: '#=1'.
	obj ui: ui.
	[ 
	obj doOneCycle.
	obj status isStepping or: [ ui input notEmpty ] ] whileTrue.
	^ ui
]

{ #category : #constants }
VTLSamplesTest >> memorySize [

	^ 1024 * 32
]

{ #category : #'instance creation' }
VTLSamplesTest >> newObj [

	^ VeryTinyLanguage new
]

{ #category : #'instance creation' }
VTLSamplesTest >> newSamples [

	^ VTLSamples new
]

{ #category : #'instance creation' }
VTLSamplesTest >> newUI [

	^ VTLNonInteractiveUI new
]

{ #category : #private }
VTLSamplesTest >> setupFor: aCVTL [

	| memory |
	memory := VTLMemory new.
	aCVTL memory: memory.
	memory allocate: self memorySize.
	aCVTL memoryLimit: self memorySize.
	aCVTL boundary: aCVTL programAddress.
	memory wordAt: aCVTL randomAddress put: self defaultRandomSeed.
	aCVTL status: VTLStatus new
]

{ #category : #tests }
VTLSamplesTest >> testSample1 [

	| samples ui |
	samples := self newSamples.
	ui := self execute: samples sample1.
	self assert: ui outputString equals: '100 A=123
200 ?=A*2
#=1
246
OK
'
]
