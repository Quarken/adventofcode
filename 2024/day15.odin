package main

import "core:strings"
import "core:fmt"

Entity :: enum {
	None = 0,
	Wall,
	Box,
	BoxLeft,
	BoxRight
}

move_robot :: proc(moves: []rune, start: Vec2, tilemap: []Entity, width, height: int) -> (result: int) {
	robot_pos := start
	for move in moves {
		delta: Vec2
		switch move {
			case '<': delta = Vec2{-1, 0}
			case '^': delta = Vec2{0, -1}
			case '>': delta = Vec2{1, 0}
			case 'v': delta = Vec2{0, 1}
		}

		trace_pos := robot_pos
		invalid_move := false
		positions: [dynamic]Vec2
		boxes_to_move: [dynamic]Vec2

		append(&positions, robot_pos + delta)
		for len(positions) > 0 {
			p := pop_front(&positions)
			switch tilemap[p.y * width + p.x] {
				case .None: {}

				case .Wall: {
					invalid_move = true
					break
				}

				case .Box: {
					append(&positions, p + delta)
					append(&boxes_to_move, p)
				}

				case .BoxLeft: {
					append(&boxes_to_move, p)
					if delta.y == 0 {
						append(&positions, p + delta * 2)
					} else {
						append(&positions, p + delta)
						append(&positions, p + delta + Vec2{1, 0})
					}
				}

				case .BoxRight: {
					append(&boxes_to_move, Vec2{p.x-1, p.y})
					if delta.y == 0 {
						append(&positions, p + delta * 2)
					} else {
						append(&positions, p + delta)
						append(&positions, p + delta + Vec2{-1, 0})
					}
				}
			}
		}

		if invalid_move do continue
		robot_pos += delta

		for i := len(boxes_to_move)-1; i >= 0; i -= 1 {
			box := boxes_to_move[i]
			new_box := box + delta

			type := tilemap[box.y * width + box.x]
			if type == .Box {
				tilemap[box.y * width + box.x] = .None
				tilemap[new_box.y * width + new_box.x] = .Box
			} else {
				tilemap[box.y * width + box.x + 0] = .None
				tilemap[box.y * width + box.x + 1] = .None

				tilemap[new_box.y * width + new_box.x + 0] = .BoxLeft
				tilemap[new_box.y * width + new_box.x + 1] = .BoxRight
			}
		}
	}

	for y in 0..<height {
		for x in 0..<width {
			type := tilemap[y * width + x]
			if type == .Box || type == .BoxLeft {
				result += 100 * y + x
			}
		}
	}

	return result
}

day15 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	parts := strings.split(input, "\n\n")
	map_lines := strings.split_lines(parts[0])

	width := len(map_lines[0])
	height := len(map_lines)
	tilemap := make([]Entity, width * height)
	tilemap2 := make([]Entity, 2 * width * height)

	moves: [dynamic]rune
	robot_pos: Vec2

	for line, y in map_lines {
		for char, x in line {
			pos := Vec2{x, y}
			switch char {
				case '#': {
					tilemap[y * width + x] = .Wall
					tilemap2[y * width * 2 + 2*x+0] = .Wall
					tilemap2[y * width * 2 + 2*x+1] = .Wall
				}
				case 'O': {
					tilemap[y * width + x] = .Box
					tilemap2[y * width * 2 + 2*x+0] = .BoxLeft
					tilemap2[y * width * 2 + 2*x+1] = .BoxRight
				}
				case '@': robot_pos = pos
			}
		}
	}

	for char in parts[1] {
		append(&moves, (char))
	}

	p1 = move_robot(moves[:], robot_pos, tilemap, width, height)
	p2 = move_robot(moves[:], robot_pos * Vec2{2, 1}, tilemap2, width*2, height)

	return p1, p2
}