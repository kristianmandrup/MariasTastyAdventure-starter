extends KinematicBody
class_name Enemy

export var health = 1
export var speed = 5
export var attack_speed = 10

enum EnemyState {
    Idle,
    Moving,
    Attacking,
    Dying
}

var state

func _ready():
    add_to_group("enemies")
    state = EnemyState.Idle

func attack():
    state = EnemyState.Attacking

func take_damage(damage):
    health -= damage
    if health < 0:
        health = 0