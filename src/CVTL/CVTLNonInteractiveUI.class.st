Class {
	#name : #CVTLNonInteractiveUI,
	#superclass : #Object,
	#instVars : [
		'output',
		'input'
	],
	#category : #'CVTL-UI'
}

{ #category : #accessing }
CVTLNonInteractiveUI >> addInput: aString [

	input add: aString
]

{ #category : #accessing }
CVTLNonInteractiveUI >> getAsciiValue [

	| line |
	input isEmpty ifTrue: [ ^ nil ].
	line := input first.
	input removeFirst.
	line isEmpty ifTrue: [ ^ Character cr asciiValue ].
	input addFirst: line copyWithoutFirst.
	^ line first asciiValue
]

{ #category : #initialization }
CVTLNonInteractiveUI >> initialize [

	output := OrderedCollection new.
	input := OrderedCollection new
]

{ #category : #accessing }
CVTLNonInteractiveUI >> input [

	^ input
]

{ #category : #accessing }
CVTLNonInteractiveUI >> input: anObject [

	input := anObject
]

{ #category : #accessing }
CVTLNonInteractiveUI >> output [

	^ output
]

{ #category : #accessing }
CVTLNonInteractiveUI >> output: anObject [

	output := anObject
]

{ #category : #accessing }
CVTLNonInteractiveUI >> outputString [

	^ String fromByteArray:
		  (output reject: [ :each | each = 10 ]) asByteArray
]

{ #category : #'input/output' }
CVTLNonInteractiveUI >> putAsciiValue: anInteger [

	output add: anInteger
]
