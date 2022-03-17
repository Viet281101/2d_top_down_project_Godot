extends Area2D

signal attack_finished

enum STATES { IDLE, ATTACK }
var state = null

enum ATTACK_INPUT_STATES { IDLE, LISTENING, REGISTERED }
var attack_input_state = ATTACK_INPUT_STATES.IDLE
var ready_for_next_attack = false
const MAX_COMBO_COUNT = 3
var combo_count = 0

var attack_current = {}
var combo = [{
		'damage': 1,
		'animation': 'Attack_A',
		'effect': null
	},
	{
		'damage': 1,
		'animation': 'attack_fast',
		'effect': null
	},
	{
		'damage': 3,
		'animation': 'attack_medium',
		'effect': null
	}]

var hit_objects = []

func _ready():
	$AnimationPlayer.connect('animation_finished', self, "_on_animation_finished")
	self.connect("body_entered", self, "_on_body_entered")
	_change_state(STATES.IDLE)

func _change_state(new_state):
	match state:
		STATES.ATTACK:
			hit_objects = []
			attack_input_state = ATTACK_INPUT_STATES.IDLE
			ready_for_next_attack = false

	match new_state:
		STATES.IDLE:
			combo_count = 0
			$AnimationPlayer.stop()
			visible = false
			monitoring = false
		STATES.ATTACK:
			attack_current = combo[combo_count -1]
			$AnimationPlayer.play(attack_current['animation'])
			visible = true
			monitoring = true
	state = new_state
