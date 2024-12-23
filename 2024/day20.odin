package main

import "core:strings"
import "core:fmt"

day20 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	width := strings.index_rune(input, '\n')
	// @TODO
	height := len(strings.split_lines(input))
	stride := width+1

	start: Vec2
	end: Vec2
	for y in 0..<height {
		for x in 0..<width {
			tile := input[y * stride + x]
			if tile == 'S' {
				start = Vec2{x, y}
			}
			if tile == 'E' {
				end = Vec2{x, y}
			}
		}
	}

	deltas := [?]Vec2{
		Vec2{0, -1},
		Vec2{1, 0},
		Vec2{0, 1},
		Vec2{-1, 0}
	}

	path := [dynamic]Vec2{start}
	distance := map[Vec2]int{start = 0}

	current := start
	for current != end {
		for d in deltas {
			neighbor := current + d
			if input[neighbor.y * stride + neighbor.x] == '#' do continue
			if !(neighbor in distance) {
				distance[neighbor] = distance[current] + 1
				append(&path, neighbor)
				current = neighbor
				break
			}
		}
	}

	manhattan_distance :: proc(a, b: Vec2) -> int {
		return abs(a.x - b.x) + abs(a.y - b.y)
	}

	for current, index in path {
		for cheat in path[index:] {
			dist := manhattan_distance(current, cheat)
			if current != cheat && distance[cheat] > distance[current] && dist <= 20 {
				saved_time := distance[cheat] - distance[current] - dist
				p1 += dist == 2 && saved_time >= 100 ? 1 : 0
				p2 += saved_time >= 100 ? 1 : 0
			}
		}
	}

	return p1, p2
}