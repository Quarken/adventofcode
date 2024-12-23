package main

import "core:fmt"
import "core:strings"
import "core:strconv"

Robot :: struct {
	position: Vec2,
	velocity: Vec2
}

Quadrant :: enum {
	TopLeft,
	TopRight,
	BottomRight,
	BottomLeft,
	Invalid
}

specify_quadrant :: proc(pos: Vec2, mid: Vec2) -> Quadrant {
	if pos.x < mid.x && pos.y < mid.y do return .TopLeft
	if pos.x > mid.x && pos.y < mid.y do return .TopRight
	if pos.x > mid.x && pos.y > mid.y do return .BottomRight
	if pos.x < mid.x && pos.y > mid.y do return .BottomLeft
	return .Invalid
}

day14 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	input := input

	robots: [dynamic]Robot
	for line in strings.split_lines_after_iterator(&input) {
		space_index := strings.index_rune(line, ' ')
		pos_str := line[2:space_index]
		vel_str := line[space_index+3:]

		pos_x, _ := strconv.parse_int(pos_str)
		pos_y, _ := strconv.parse_int(pos_str[strings.index_rune(pos_str, ',')+1:])

		vel_x, _ := strconv.parse_int(vel_str)
		vel_y, _ := strconv.parse_int(vel_str[strings.index_rune(vel_str, ',')+1:])
		append(&robots, Robot{
			position = Vec2{pos_x, pos_y},
			velocity = Vec2{vel_x, vel_y}
		})
	}

	width := 101
	height := 103
	mid := Vec2{(width-1)/2, (height-1)/2}

	quadrants := [Quadrant]int{}
	for robot in robots {
		pos := robot.position + robot.velocity * 100
		pos.x %%= width
		pos.y %%= height

		quadrants[specify_quadrant(pos, mid)] += 1
	}

	highest_found := 0
	for iteration in 0..<(101*103) {
		quads := [Quadrant]int{}
		for &robot in robots {
			quads[specify_quadrant(robot.position, mid)] += 1
			robot.position += robot.velocity
			robot.position.x %%= width
			robot.position.y %%= height
		}

		for size, quad in quads {
			if highest_found < size {
				highest_found = size
				p2 = iteration
			}
		}
	}

	p1 = quadrants[.TopLeft] * quadrants[.TopRight] * quadrants[.BottomRight] * quadrants[.BottomLeft]
	return p1, p2
}