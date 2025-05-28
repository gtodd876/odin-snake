package main

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

direction :: enum {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

main :: proc() {
	number_of_grid_cells :: 25

	snake_head_color := rl.GREEN
	snake_tail_color := rl.DARKGREEN
	grid_line_color := rl.WHITE
	// need square window
	screen_width: i32 : 800
	screen_height: i32 : 800
	// an array of arrays in odin
	snake_segments: [number_of_grid_cells * number_of_grid_cells][2]i32
	snake_head_index: i32 = 0
	snake_length := 1
	rl.InitWindow(screen_width, screen_height, "Snake 2")
	rl.SetTargetFPS(60)

	snake_direction: direction = .RIGHT
	// timer to control the speed of the snake
	// the snake will move every 10 frames
	snake_frame_timer: i32 = 0
	number_of_frames_until_snake_can_move: i32 = 10
	cell_size := screen_width / number_of_grid_cells


	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		// defer of the end drawing procedure will wait to the 
		// end of this scope to call the function
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLUE)

		for grid_x: i32 = 0; grid_x < screen_width; grid_x += cell_size {
			rl.DrawLine(grid_x, 0, grid_x, screen_height, grid_line_color)
		}
		for grid_y: i32 = 0; grid_y < screen_height; grid_y += cell_size {
			rl.DrawLine(0, grid_y, screen_width, grid_y, grid_line_color)
		}
		if rl.IsKeyPressed(.LEFT) {
			snake_direction = .LEFT
		}
		if rl.IsKeyPressed(.RIGHT) {
			snake_direction = .RIGHT
		}
		if rl.IsKeyPressed(.UP) {
			snake_direction = .UP
		}
		if rl.IsKeyPressed(.DOWN) {
			snake_direction = .DOWN
		}

		snake_frame_timer += 1
		can_snake_move := snake_frame_timer % number_of_frames_until_snake_can_move == 0

		if can_snake_move {
			if snake_direction == .LEFT {
				for i: i32 = len(snake_segments) - 2; i >= snake_head_index; i -= 1 {
					snake_segments[i + 1] = snake_segments[i]
				}
				snake_segments[snake_head_index].x -= 1
			} else if snake_direction == .RIGHT {
				for i: i32 = len(snake_segments) - 2; i >= snake_head_index; i -= 1 {
					snake_segments[i + 1] = snake_segments[i]
				}
				snake_segments[snake_head_index].x += 1
			}
			if snake_direction == .UP {
				for i: i32 = len(snake_segments) - 2; i >= snake_head_index; i -= 1 {
					snake_segments[i + 1] = snake_segments[i]
				}
				snake_segments[snake_head_index].y -= 1
			}
			if snake_direction == .DOWN {
				for i: i32 = len(snake_segments) - 2; i >= snake_head_index; i -= 1 {
					snake_segments[i + 1] = snake_segments[i]
				}
				snake_segments[snake_head_index].y += 1
			}
		}

		is_snake_head_out_of_bounds :=
			snake_segments[snake_head_index].x > number_of_grid_cells ||
			snake_segments[snake_head_index].x < 0 ||
			snake_segments[snake_head_index].y > number_of_grid_cells ||
			snake_segments[snake_head_index].y < 0

		if is_snake_head_out_of_bounds {
			snake_head_index = 0
			snake_segments[snake_head_index] = [2]i32{5, 0}
			snake_segments[snake_head_index + 1] = [2]i32{4, 0}
			snake_segments[snake_head_index + 2] = [2]i32{3, 0}
			snake_direction = .RIGHT
			snake_frame_timer = 0
		}

		head_pos := snake_segments[snake_head_index] * cell_size
		rl.DrawRectangle(head_pos.x, head_pos.y, cell_size, cell_size, snake_head_color)

		for snake_segment in snake_segments[1:len(snake_segments)] {
			segment_pos: [2]i32 = snake_segment * cell_size
			rl.DrawRectangle(segment_pos.x, segment_pos.y, cell_size, cell_size, snake_tail_color)
		}
	}
}
