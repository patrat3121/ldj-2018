extends TileMap

func hit_by(body):
	body.queue_free()