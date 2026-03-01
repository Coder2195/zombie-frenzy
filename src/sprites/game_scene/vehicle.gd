@abstract
class_name Vehicle extends RigidBody2D;

var passenger: Player = null;

var durability: float = 100.0;

func ride(player: Player):
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
  if passenger != null:
    motion = Input.get_axis("up", "down");
    var turn = Input.get_axis("left", "right");
    
    rotate(turn * delta * 5.0);

    if (Input.is_action_just_pressed("dismount")):
      dismount();


  apply_central_force(Vector2(0, 100000 * motion).rotated(rotation) - linear_velocity * 500);
  if passenger != null:
    passenger.position = self.position;
