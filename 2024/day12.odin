package main

import "core:fmt"
import "core:strings"
import "core:slice"

Plot :: struct {
	region_id: int,
	plant: i8
}

Region :: struct {
	area: int,
	plant: i8,
	mins: Vec2,
	maxs: Vec2
}

Edge :: struct {
	left: bool,
	position: int
}

out_of_bounds :: proc(p: Vec2, width, height: int) -> bool {
	return p.x < 0 || p.x >= width || p.y < 0 || p.y >= height
}

day12 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	lines := strings.split_lines(input)

	region_count := 0
	width := len(lines)
	height := len(lines[0])
	garden := make([]Plot, width * height)

	directions := [4]Vec2{
		Vec2{+0, -1},
		Vec2{+0, +1},
		Vec2{-1, +0},
		Vec2{+1, +0}
	}

	for line, y in lines {
		for char, x in line {
			garden[y * width + x] = Plot{-1, i8(char)}
		}
	}

	stack := [dynamic]Vec2{}
	for y in 0..<height {
		for x in 0..<width {
			plot := &garden[y * width + x]
			if plot.region_id == -1 {

				region_id := region_count
				region_count += 1
				append(&stack, Vec2{x, y})
				for len(stack) > 0 {
					p := pop(&stack)
					current := &garden[p.y * width + p.x]
					if current.region_id == -1 && current.plant == plot.plant {
						current.region_id = region_id
						for dir in directions {
							if !out_of_bounds(p + dir, width, height) {
								append(&stack, p + dir)
							}
						}
					}
				}
			}
		}
	}

	region_areas := make([]int, region_count)
	regions := make([]Region, region_count)
	for &region in regions {
		region.mins = Vec2{width, height}
		region.maxs = Vec2{0, 0}
	}

	for y in 0..<height {
		for x in 0..<width {
			plot := &garden[y * width + x]
			region_areas[garden[y * width + x].region_id] += 1

			region := &regions[plot.region_id]
			region.area += 1
			region.plant = plot.plant
			region.mins.x = min(region.mins.x, x)
			region.mins.y = min(region.mins.y, y)
			region.maxs.x = max(region.maxs.x, x)
			region.maxs.y = max(region.maxs.y, y)
		}
	}

	for y in 0..<height {
		for x in 0..<width {
			plot := &garden[y * width + x]
			sides := 0

			for dir in directions {
				dx, dy := dir[0], dir[1]
				if !out_of_bounds(Vec2{x+dx, y+dy}, width, height) {
					sides += garden[(y+dy) * width + (x+dx)].region_id != plot.region_id ? 1 : 0
				} else {
					sides += 1
				}
			}

			p1 += region_areas[plot.region_id] * sides
		}
	}

	for region, id in regions {
		sides := 0

		prev_edges := [dynamic]Edge{}
		for y in region.mins.y..=region.maxs.y {
			edges := [dynamic]Edge{}
			is_inside := false
			for x in region.mins.x..=region.maxs.x {
				plot := &garden[y * width + x]
				if !is_inside && plot.plant == region.plant && plot.region_id == id {
					is_inside = true
					append(&edges, Edge{true, x})
				} else if is_inside && plot.plant != region.plant {
					is_inside = false
					append(&edges, Edge{false, x})
				}
			}
			if is_inside {
				append(&edges, Edge{false, region.maxs.x+1})
			}

			for edge in edges {
				if !slice.contains(prev_edges[:], edge) {
					sides += 1
				}
			}

			delete(prev_edges)
			prev_edges = edges
		}
		p2 += 2 * sides * region.area
	}

	return p1, p2
}