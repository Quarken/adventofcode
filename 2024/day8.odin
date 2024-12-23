package main

import "core:fmt"
import "core:strings"

Tilemap :: struct {
	antennae: map[Vec2]rune,
	antinodes: map[Vec2]bool,
	antinodesp2: map[Vec2]bool,
	width: int,
	height: int
}

outside :: proc(tilemap: ^Tilemap, p: Vec2) -> bool {
	return p.x < 0 || p.x >= tilemap.width || p.y < 0 || p.y >= tilemap.height
}

day8 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	lines := strings.split_lines(input)

	tilemap: Tilemap
	tilemap.height = len(lines)
	tilemap.width = len(lines[0])
	for line, y in lines {
		for char, x in line {
			if char != '.' {
				pos := Vec2{x, y}
				tilemap.antennae[pos] = char
			}
		}
	}

	for key1, val1 in tilemap.antennae {
		for key2, val2 in tilemap.antennae {
			if key1 == key2 do continue
			if val1 != val2 do continue

			dp := Vec2{key1.x - key2.x, key1.y - key2.y}
			pos := Vec2{key1.x, key1.y}

			if !outside(&tilemap, pos + dp) {
				tilemap.antinodes[pos + dp] = true
			}

			for !outside(&tilemap, pos) {
				tilemap.antinodesp2[pos] = true
				pos += dp
			}
		}
	}

	return len(tilemap.antinodes), len(tilemap.antinodesp2)
}