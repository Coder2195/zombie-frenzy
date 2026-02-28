class_name Zombie extends CharacterBody2D

var movement_speed: float = randf_range(80.0, 200.0);
var movement_target_position: Vector2 = Vector2(50.0, 180.0);
var max_health: float = randi_range(80, 140);

var health: float = max_health;

var duration = 0.0;

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
  $Health.max_value = max_health;
  set_physics_process(false);
  # These values need to be adjusted for the actor's speed
  # and the navigation layout.
  navigation_agent.path_desired_distance = 4.0
  navigation_agent.target_desired_distance = 4.0

  # Make sure to not await during _ready.
  call_deferred("actor_setup")

func actor_setup():
  # Wait for the first physics frame so the NavigationServer can sync.
  await get_tree().physics_frame

  # Now that the navigation map is no longer empty, set the movement target.
  set_movement_target(movement_target_position)
  set_physics_process(true)

func set_movement_target(movement_target: Vector2):
  navigation_agent.target_position = movement_target

func _physics_process(delta):
  set_movement_target(get_tree().get_root().get_node("GameScene/Player").position);

  var current_agent_position: Vector2 = global_position
  var next_path_position: Vector2 = navigation_agent.get_next_path_position()
  var direction = current_agent_position.direction_to(next_path_position);

  var target_rot = direction.angle();

  rotation = lerp_angle(rotation, target_rot, 4 * delta);

  velocity = direction * movement_speed;
  move_and_slide();

  $Health.value = health;
  $Health.global_position = self.global_position + Vector2( - $Health.size.x / 2, -50);
  $Health.rotation = -rotation;

func damage(dmg: float):
  $Hit.play();
  health -= dmg;
  if health <= 0:
    DataTracker.zombies_killed += 1;
    queue_free();

func try_hit():
  var hit = $Area.get_overlapping_bodies()
  for body in hit:
    if body is Player:
      body.damage(5);
