Class {
	#name : #VTLNonInteractiveUI,
	#superclass : #Object,
	#instVars : [
		'output',
		'input'
	],
	#category : #'VTL-UI'
}

{ #category : #accessing }
VTLNonInteractiveUI >> addInput: aString [

	input add: aString
]

{ #category : #accessing }
VTLNonInteractiveUI >> clear [

	output := OrderedCollection new
]

{ #category : #accessing }
VTLNonInteractiveUI >> getAsciiValue [

	| line |
	input isEmpty ifTrue: [ ^ nil ].
	line := input first.
	input removeFirst.
	line isEmpty ifTrue: [ ^ Character cr asciiValue ].
	input addFirst: line copyWithoutFirst.
	^ line first asciiValue
]

{ #category : #initialization }
VTLNonInteractiveUI >> initialize [

	self clear.
	self refresh
]

{ #category : #accessing }
VTLNonInteractiveUI >> input [

	^ input
]

{ #category : #accessing }
VTLNonInteractiveUI >> input: anObject [

	input := anObject
]

{ #category : #accessing }
VTLNonInteractiveUI >> output [

	^ output
]

{ #category : #accessing }
VTLNonInteractiveUI >> output: anObject [

	output := anObject
]

{ #category : #accessing }
VTLNonInteractiveUI >> outputString [

	^ String fromByteArray:
		  (output reject: [ :each | each = 10 ]) asByteArray
]

{ #category : #'input/output' }
VTLNonInteractiveUI >> putAsciiValue: anInteger [

	output add: anInteger
]

{ #category : #accessing }
VTLNonInteractiveUI >> refresh [

	input := OrderedCollection new
]
