extends Sprite2D;

const grass_1: Texture = preload ("res://images/tiles/grass_1.png");
const grass_2: Texture = preload ("res://images/tiles/grass_2.png");
const grass_3: Texture = preload ("res://images/tiles/grass_3.png");
const grass_4: Texture = preload ("res://images/tiles/grass_4.png");

const tile_set = [grass_1, grass_2, grass_3, grass_4];

static var noise = FastNoiseLite.new();

@export var player_offset: Vector2 = Vector2(0, 0);

# Called when the node enters the scene tree for the first time.
func _ready():
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

  var cam = get_viewport().get_camera_2d().global_position;
  cam = Vector2(roundf(cam.x / 64), roundf(cam.y / 64));

  position = (cam + player_offset) * 64;
  
  var grass = noise.get_noise_2dv(position);

  texture = tile_set[int(grass * 4)];
