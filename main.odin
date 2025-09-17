package main

import "core:math"
import "core:os"
import "core:slice"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1920, 1080, "text boxes")

	for !rl.WindowShouldClose() {
		draw()
	}
}

DialogueConfig :: struct {
	speed:          f32,
	font_size:      int,
	line_width:     int,
	max_lines:      int,
	color:          rl.Color,
	render_surface: rl.RenderTexture,
}

DialogueWriter :: struct {
	writing:         bool,
	config:          DialogueConfig,
	data:            []byte,
	character_index: int,
	timer:           f32,
}

init_dialogue :: proc(config: DialogueConfig) {
	context.user_ptr = nil
	cfg := new(DialogueConfig)
	cfg.speed = config.speed
	cfg.font_size = config.font_size
	cfg.line_width = config.line_width
	cfg.max_lines = config.max_lines
	cfg.color = config.color
	cfg.render_surface = config.render_surface
	context.user_ptr = &cfg
}

// Creates a dialogue writer containing the bytes from the given file, using the config from the context
create_writer_context_config :: proc(filename: string) -> DialogueWriter {
	data, ok := os.read_entire_file(filename)
	return DialogueWriter{config = (^DialogueConfig)(context.user_ptr)^, data = data}
}

// Creates a dialogue writer containing the bytes from the given file, using the passed config
create_writer_with_config :: proc(config: DialogueConfig, filename: string) -> DialogueWriter {
	data, ok := os.read_entire_file(filename)
	return DialogueWriter{config = config, data = data}
}

close_dialogue :: proc() {
	free((^DialogueWriter)(context.user_ptr))
}

advance_writer :: proc(w: ^DialogueWriter, delta: f32) {
	w.timer += delta
	if w.timer > w.config.speed {
		new_index := clamp(w.character_index + 1, 0, len(w.data) - 1)
		w.character_index = new_index
		w.timer = 0
	}
}

render_writer :: proc(w: DialogueWriter) {
	rl.BeginTextureMode(w.config.render_surface)
	// Writing the currently displayable text goes here
	rl.EndTextureMode()
}

draw :: proc() {

}
