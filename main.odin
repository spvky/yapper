package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strings"
import rl "vendor:raylib"

DialogueConfig :: struct {
	speed:      f32,
	font_size:  i32,
	line_width: int,
	max_lines:  int,
	color:      rl.Color,
	// render_surface: rl.RenderTexture,
}

// Struct for rendering dialogue boxes (using raylib)
DialogueWriter :: struct {
	writing:         bool,
	config:          DialogueConfig,
	data:            []byte,
	character_index: int,
	timer:           f32,
}

// Creates a dialogue writer containing the bytes from the given file, using the passed config
create_writer :: proc(config: DialogueConfig, filename: string) -> DialogueWriter {
	data, ok := os.read_entire_file(filename)
	return DialogueWriter{config = config, data = data}
}

destroy_writer :: proc(w: DialogueWriter) {
	delete(w.data)
}

advance_writer :: proc(w: ^DialogueWriter, delta: f32) {
	w.timer += delta
	if w.timer > w.config.speed {
		new_index := clamp(w.character_index + 1, 0, len(w.data) - 1)
		w.character_index = new_index
		w.timer = 0
	}
}

writer_text :: proc(w: DialogueWriter) -> string {
	return string(w.data[0:w.character_index])
}

render_writer :: proc(w: DialogueWriter) {
	// rl.BeginTextureMode(w.config.render_surface)
	// // Writing the currently displayable text goes here
	// rl.EndTextureMode()
}

main :: proc() {
	rl.InitWindow(1600, 900, "text")

	writer_config := DialogueConfig {
		speed      = 0.1,
		font_size  = 16,
		line_width = 10,
		max_lines  = 4,
		color      = rl.WHITE,
	}

	writer := create_writer(writer_config, "./test.txt")

	for !rl.WindowShouldClose() {
		frametime := rl.GetFrameTime()
		advance_writer(&writer, frametime)
		string_to_draw := writer_text(writer)
		full_string := string(writer.data[:])
		converted_string := strings.clone_to_cstring(string_to_draw)
		full_converted_string := strings.clone_to_cstring(full_string)
		text_length = rl.TextLength(full_converted_string)

		rl.TextLength()
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawText(converted_string, 0, 0, writer.config.font_size, writer.config.color)
		rl.EndDrawing()
	}

	rl.CloseWindow()
	// data, ok := os.read_entire_file("./test.txt")
	// spaces := make([dynamic]int,0,16)
	// for d,i in data {
	// 	if rune(d) == ' ' {
	// 		append(&spaces, i)
	// 	}
	// }
	// if ok {
	// 	fmt.printf("%v\n%v", string(data[0:10]), string(data[10:24]))
	// 	fmt.printf("%v", spaces)
	// }
}
