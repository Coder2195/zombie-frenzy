@abstract
class_name Vehicle extends RigidBody2D;

var passenger: Player = null;

var durability: float = 100.0;

var explosion_scene = preload("res://sprites/game_scene/explosion.tscn");

func ride(player: Player):
  if player.vehicle != null:
    return ;
  if durability <= 0:
    return ;
  passenger = player;
  player.set_collision_layer_value(6, false);
  player.vehicle = self ;
  set_collision_mask_value(1, false);


func dismount():
  passenger.vehicle = null;
  passenger.set_collision_layer_value(6, true);
  passenger = null;
  set_collision_mask_value(1, true);
  

func _physics_process(delta):
  var motion = 0;
  var turn = 0
  if passenger != null:
    motion = Input.get_axis("up", "down");
    turn = Input.get_axis("left", "right");
    
    
    if (Input.is_action_just_pressed("dismount")):
      dismount();

  apply_torque(turn * 600000 - angular_velocity * 4000);
  apply_central_force(Vector2(0, 100000 * motion).rotated(rotation) - linear_velocity * 500);
  if passenger != null:
    passenger.position = self.position;
  $Durability.value = durability;
  $Durability.rotation = - rotation;
  $Durability.global_position = self.global_position + Vector2(-$Durability.size.x / 2, -90);

func damage(dmg: float):
  durability -= dmg;
  if durability <= 0:
    if passenger != null:
      dismount();
    var root = get_tree().get_root().get_node("GameScene/");
    if root != null:
      var explosion = explosion_scene.instantiate();
      explosion.global_position = global_position;
      root.add_child(explosion);
    queue_free();
