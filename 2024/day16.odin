package main

import "core:fmt"
import "core:strings"
import pq "core:container/priority_queue"

Facing :: enum {
	North,
	East,
	South,
	West
}

PathNode :: struct {
	position: Vec2,
	facing: Facing
}

CostNode :: struct {
	node: PathNode,
	cost: int
}

day16 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	width := strings.index_rune(input, '\n')
	height := len(strings.split_lines(input))
	stride := width+1

	start: Vec2
	goal: Vec2
	for y in 0..<height {
		for x in 0..<width {
			mark := input[y * stride + x]
			if mark == 'S' {
				start = Vec2{x, y}
			}

			if mark == 'E' {
				goal = Vec2{x, y}
			}
		}
	}

	deltas := [Facing]Vec2{
		.North = Vec2{0, -1},
		.East = Vec2{1, 0},
		.South = Vec2{0, 1},
		.West = Vec2{-1, 0}
	}

	opposite := [Facing]Facing {
		.North = .South,
		.East = .West,
		.South = .North,
		.West = .East
	}

	sides := [Facing][2]Facing {
		.North = {.West, .East},
		.East = {.North, .South},
		.South = {.West, .East},
		.West = {.North, .South}
	}

	frontier: pq.Priority_Queue(CostNode)


	cost: map[PathNode]int
	cost[PathNode{start, .East}] = 0

	less := proc(a, b: CostNode) -> bool {
		return a.cost < b.cost
	}

	pq.init(&frontier, less, pq.default_swap_proc(CostNode), 4096)
	pq.push(&frontier, CostNode{PathNode{start, .East}, 0})

	for pq.len(frontier) > 0 {
		current := pq.pop(&frontier)
		curr_pos := current.node.position
		curr_facing := current.node.facing

		for facing in Facing {
			new_pos := curr_pos + (facing == curr_facing ? deltas[facing] : Vec2{0,0})
			new_cost := facing == curr_facing ? 1 : 1000
			new_node := PathNode{new_pos, facing}
			if input[new_pos.y * stride + new_pos.x] == '#' do continue


			new_cost += cost[current.node]
			old_cost, has_cost := cost[new_node]
			if !has_cost || new_cost < old_cost {
				cost[new_node] = new_cost
				pq.push(&frontier, CostNode{new_node, new_cost})
			}
		}
	}

	goal_node := CostNode{cost=0xFFFFFFFF}
	for facing in Facing {
		n := PathNode{goal, facing}
		if cost[n] < goal_node.cost {
			goal_node = CostNode{n, cost[n]}
		}
	}

	p1 = goal_node.cost
	visited: map[Vec2]bool
	path_queue := [dynamic]CostNode{goal_node}
	for len(path_queue) > 0 {
		current := pop_front(&path_queue)
		pos := current.node.position
		facing := current.node.facing

		if !visited[pos] {
			p2 += 1
			visited[pos] = true
		}

		next_nodes := []CostNode{
			CostNode{PathNode{pos - deltas[facing], facing}, current.cost - 1},
			CostNode{PathNode{pos, sides[facing][0]}, current.cost - 1000},
			CostNode{PathNode{pos, sides[facing][1]}, current.cost - 1000}
		}

		for next in next_nodes {
			node := PathNode{next.node.position, next.node.facing}
			if cost[node] == next.cost {
				append(&path_queue, next)
			}
		}
	}

	return p1, p2
}