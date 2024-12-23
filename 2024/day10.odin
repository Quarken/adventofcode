package main

import "core:fmt"
import "core:strings"

Heightfield :: struct {
	data: []i8,
	width: int,
	height: int
}

trailhead_score :: proc(heightfield: ^Heightfield, visited: []bool, x, y: int, in_height: i8, p1: ^int, p2: ^int) {
	if x < 0 || x >= heightfield.width || y < 0 || y >= heightfield.height {
		return
	}

	if heightfield.data[y * heightfield.width + x] != in_height + 1 {
		return
	}

	if in_height+1 == 9 {
		p2^ += 1
		if !visited[y * heightfield.width + x] {
			p1^ += 1
		}
		visited[y * heightfield.width + x] = true
	}

	trailhead_score(heightfield, visited, x, y-1, in_height+1, p1, p2)
	trailhead_score(heightfield, visited, x, y+1, in_height+1, p1, p2)
	trailhead_score(heightfield, visited, x-1, y, in_height+1, p1, p2)
	trailhead_score(heightfield, visited, x+1, y, in_height+1, p1, p2)
}

day10 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	lines := strings.split_lines(input)

	heightfield: Heightfield
	heightfield.width = len(lines)
	heightfield.height = len(lines[0])
	heightfield.data = make([]i8, heightfield.width * heightfield.height)
	for line, y in lines {
		for char, x in line {
			heightfield.data[y * heightfield.width + x] = i8(char - '0')
		}
	}

	for y in 0..<heightfield.height {
		for x in 0..<heightfield.width {
			height := heightfield.data[y * heightfield.width + x]
			if height == 0 {
				visited := make([]bool, heightfield.width * heightfield.height)
				trailhead_score(&heightfield, visited, x, y, -1, &p1, &p2)
			}
		}
	}

	return p1, p2
}