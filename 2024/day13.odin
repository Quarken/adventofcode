package main

import "core:fmt"
import "core:strings"
import "core:strconv"

day13 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	lines := strings.split_lines(input)

	for i := 0; i < len(lines); i += 4 {
		ax, _ := strconv.parse_int(lines[i+0][11:14])
		ay, _ := strconv.parse_int(lines[i+0][17:20])
		bx, _ := strconv.parse_int(lines[i+1][11:14])
		by, _ := strconv.parse_int(lines[i+1][17:20])
		prize_parts := strings.split(lines[i+2], " ")
		target_x, _ := strconv.parse_int(prize_parts[1][2:])
		target_y, _ := strconv.parse_int(prize_parts[2][2:])

		a := Vec2{ax, ay}
		b := Vec2{bx, by}
		t := Vec2{target_x, target_y}

		det :=  a.x * b.y - a.y * b.x

		{
			ca := (t.x * b.y - t.y * b.x) / det
			cb := (t.y * a.x - t.x * a.y) / det
			if ca * a + cb * b == t {
				p1 += 3*ca + cb
			}
		}

		{
			tx := t.x + 10000000000000
			ty := t.y + 10000000000000
			target := Vec2{tx, ty}

			ca := (tx * b.y - ty * b.x) / det
			cb := (ty * a.x - tx * a.y) / det
			if ca * a + cb * b == target {
				p2 += 3*ca + cb
			}
		}
	}

	return p1, p2
}