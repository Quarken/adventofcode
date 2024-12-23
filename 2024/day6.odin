#+private file
package main

import "core:strings"

Position :: distinct [2]int

Direction :: enum {
	North = 0,
	East = 1,
	South = 2,
	West = 3
}

Direction_Set :: bit_set[Direction]

delta_vectors := [Direction]Position {
	.North = Position{0, -1},
	.East = Position{1, 0},
	.South = Position{0, 1},
	.West = Position{-1, 0}
}

next_direction := [Direction]Direction {
	.North = .East,
	.East = .South,
	.South = .West,
	.West = .North
}

Tile :: struct {
	blocking: bool,
	visited_directions: bit_set[Direction]
}

Tilemap :: struct {
	data: []Tile,
	width: int,
	height: int,
}

outside :: proc(tilemap: ^Tilemap, x, y: int) -> bool {
	if x < 0 || x >= tilemap.width || y < 0 || y >= tilemap.height {
		return true
	} else {
		return false
	}
}

move :: proc(tilemap: ^Tilemap, x, y: int, direction: Direction, path: ^[dynamic]Position) -> bool {
	tile := &tilemap.data[y * tilemap.width + x]
	if tile.blocking {
		return false
	}

	if card(tile.visited_directions) == 0 && path != nil {
		append(path, Position{x, y})
	}
	tile.visited_directions += {direction}
	return true
}

find_path :: proc(tilemap: ^Tilemap, startx, starty: int, path: ^[dynamic]Position) -> bool {
	is_loop := false

	for y in 0..<tilemap.height {
		for x in 0..<tilemap.width {
			tilemap.data[y * tilemap.width + x].visited_directions = {}
		}
	}
	tilemap.data[starty * tilemap.width + startx].visited_directions = {.North}

	guard := Position{startx, starty}
	direction := Direction.North
	for {
		to := guard + delta_vectors[direction]
		if outside(tilemap, to.x, to.y) {
			break
		}

		tile := tilemap.data[to.y * tilemap.width + to.x]
		valid_move := move(tilemap, to.x, to.y, direction, path)
		if valid_move {
			guard = to

			if direction in tile.visited_directions {
				is_loop = true
				break
			}
		} else {
			direction = next_direction[direction]
		}
	}

	return is_loop
}

@(private)
day6 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	lines := strings.split_lines(input)

	tilemap: Tilemap
	tilemap.height = len(lines)
	tilemap.width = len(lines[0])

	startx, starty: int
	direction := Direction.North

	tilemap.data = make([]Tile, tilemap.width * tilemap.height)
	for line, y in lines {
		for char, x in line {
			tile := &tilemap.data[y * tilemap.width + x]
			if char == '#' {
				tile.blocking = true
			}

			if char == '^' {
				startx = x
				starty = y
			}
		}
	}

	path := [dynamic]Position{}
	find_path(&tilemap, startx, starty, &path)
	p1 = len(path) + 1

	for next_pos in path {
		tile := &tilemap.data[next_pos.y * tilemap.width + next_pos.x]

		tile.blocking = true
		p2 += find_path(&tilemap, startx, starty, nil) ? 1 : 0
		tile.blocking = false
	}

	return p1, p2
}
