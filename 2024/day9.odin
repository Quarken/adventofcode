package main

import "core:fmt"
import "core:strings"

File :: struct {
	id: int,
	blocks_used: int,
	next: ^File,
	prev: ^File
}

insert_after :: proc(a: ^File, b: ^File) {
	a.next.prev = b
	b.next = a.next
	a.next = b
	b.prev = a
}

insert_before :: proc(a: ^File, b: ^File) {
	b.next = a
	b.prev = a.prev
	a.prev.next = b
	a.prev = b
}

day9 :: proc(input: string) -> (Answer, Answer) {
	p1, p2: int
	sentinel := new(File)
	sentinel.next = sentinel
	sentinel.prev = sentinel

	blocks := [dynamic]int{};

	for char, index in input {
		if char >= '0' && char <= '9' {
			id := index % 2 == 0 ? index / 2 : -1
			blocks_used := int(char - '0')
			for i in 0..<blocks_used {
				append(&blocks, id)
			}

			file := new(File, context.temp_allocator)
			file.id = id
			file.blocks_used = blocks_used
			insert_before(sentinel, file)
		}
	}

	i := 0
	j := len(blocks) - 1
	for {
		if i >= j do break
 
		if blocks[i] != -1 {
			i += 1
			continue
		}

		if blocks[j] == -1 {
			j -= 1
			continue
		}

		blocks[i] = blocks[j]
		blocks[j] = -1
	}

	for id, index in blocks {
		if id == -1 do break
		p1 += id * index
	}

	for right := sentinel.prev; right != sentinel.next; right = right.prev {
		if right.id == -1 do continue

		for left := sentinel.next; left != right; left = left.next {
			if left.id != -1 do continue
			if right.blocks_used <= left.blocks_used {
				left.blocks_used -= right.blocks_used

				replacement := new(File, context.temp_allocator)
				replacement.id = -1
				replacement.blocks_used = right.blocks_used
				insert_after(right, replacement)

				right.next.prev = right.prev
				right.prev.next = right.next
				insert_before(left, right)
				right = replacement

				if left.blocks_used == 0 {
					left.next.prev = left.prev
					left.prev.next = left.next
				}
				break
			}
		}
	}


	block_position := 0
	for p := sentinel.next; p != sentinel; p = p.next {
		for i in 0..<p.blocks_used {
			if p.id == -1 {
			} else {
				p2 += p.id * (block_position + i)
			}
		}
		block_position += p.blocks_used
	}

	return p1, p2
}