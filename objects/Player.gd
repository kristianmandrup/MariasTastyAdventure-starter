extends KinematicBody
export var speed = 5
export var running_speed = 10
export var jump_velocity = 9
export var mouse_sensitivity = 10
var current_speed

export var max_gravity = 20
export var gravity_alt_pct = 0.7
var gravity = 20
var mouse_input = Vector2()
var direction = Vector3()
var y_velocity = Vector3()
var velocity = Vector3()

onready var camera = $Camera
onready var camera_v = $Camera/cam_v

func _ready():
    camera.set_as_toplevel(true)
    current_speed = speed
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
    direction = Vector3.ZERO

    var basis = camera.global.transform.basis
    if Input.is_action_pressed("up"):
        direction -= basis.z
    if Input.is_action_pressed("down"):
        direction += basis.z
    if Input.is_action_pressed("left"):
        direction -= basis.x
    if Input.is_action_pressed("right"):
        direction += basis.x

    if Input.is_action_pressed("jump") and y_velocity.y > 0:
        gravity = max_gravity * gravity_alt_pct
    else:
        gravity = max_gravity

    velocity = direction.normalized() * current_speed
    if not is_on_floor():
        y_velocity.y -= gravity * delta
    else:
        y_velocity.y = -0.1
    
    if is_on_ceiling():
        y_velocity.y = -1

    if Input.is_action_just_pressed("jump") and is_on_floor():
        y_velocity.y = jump_velocity

    velocity = move_and_slide(velocity + y_velocity, Vector3.UP)
    updateCamera(delta)

    if Input.is_action_just_pressed("pause"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func updateCamera(delta):
    camera.global_transform.origin = global_transform.origin
    camera.rotation.degrees.y -= mouse_input.x * mouse_sensitivity * delta
    
    camera_v.rotation.degrees.x -= mouse_input.y * mouse_sensitivity * delta
    camera_v.rotation.degrees.x = clamp(camera_v.rotation.degrees.x, -90, 90)

    mouse_input = Vector3.ZERO

func _input(event):
    if event is InputEventMouseMotion:
        mouse_input = event.relative

func on_stump_area_body(body):
    if body.is_in_group("enemies"):
        body.take_damage(1)
