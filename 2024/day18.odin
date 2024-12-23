package main

import "core:fmt"
import "core:strings"
import "core:strconv"

try_path :: proc(bytes: []Vec2, bytes_to_fall: int) -> (int, bool) {
	dim :: 71
	Grid :: [dim*dim]i8
	grid: Grid

	for i in 0..<bytes_to_fall {
		wall := bytes[i]
		grid[wall.y * dim + wall.x] = '#'
	}

	start := Vec2{0, 0}
	end := Vec2{dim-1, dim-1}

	frontier: [dynamic]Vec2
	steps: map[Vec2]int
	defer delete(frontier)
	defer delete(steps)

	append(&frontier, start)
	found_end := false
	for len(frontier) > 0 {
		current := pop_front(&frontier)
		if current == end {
			found_end = true
			break
		}

		delta := [?]Vec2{
			Vec2{0, -1},
			Vec2{1, 0},
			Vec2{0, 1},
			Vec2{-1, 0}
		}

		for d in delta {
			neighbor := current + d
			if !(neighbor in steps) && neighbor.x >= 0 && neighbor.x < dim && neighbor.y >= 0 && neighbor.y < dim {
				if grid[neighbor.y * dim + neighbor.x] != '#' {
					append(&frontier, neighbor)
					steps[neighbor] = steps[current] + 1
				}
			}
		}
	}

	return steps[end], found_end
}

day18 :: proc(input: string) -> (p1, p2: Answer) {
	lines := strings.split_lines(input)
	bytes: [dynamic]Vec2

	for line in lines {
		x, _ := strconv.parse_int(line)
		y, _ := strconv.parse_int(line[strings.index_rune(line, ',')+1:])
		append(&bytes, Vec2{x, y})
	}

	p1_ans, ok := try_path(bytes[:], 1024)
	p1 = p1_ans

	left := 1024
	right := len(bytes)-1
	for left <= right {
		mid := (left + right) / 2
		_, ok := try_path(bytes[:], mid)
		if ok {
			left = mid + 1
		} else {
			right = mid - 1
		}
	}

	return p1, bytes[right]
}