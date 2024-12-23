package main

import "core:fmt"
import "core:strings"

Map :: struct {
    data: []string,
    w: int,
    h: int
}

get_pos :: proc(xmas_map: ^Map, x, y: int) -> u8 {
    if x >= 0 && x < xmas_map.w && y >= 0 && y < xmas_map.h {
        return xmas_map.data[y][x]
    } else {
        return '.'
    }
}

search :: proc(xmas_map: ^Map, x, y: int) -> int {
    if get_pos(xmas_map, x, y) != 'X' {
        return 0
    }

    count := 0
    directions := [8][4]u8{}
    for i in 0..<4 {
        directions[0][i] = get_pos(xmas_map, x+i, y+0)
        directions[1][i] = get_pos(xmas_map, x+0, y+i)
        directions[2][i] = get_pos(xmas_map, x-i, y+0)
        directions[3][i] = get_pos(xmas_map, x+0, y-i)

        directions[4][i] = get_pos(xmas_map, x+i, y+i)
        directions[5][i] = get_pos(xmas_map, x-i, y-i)
        directions[6][i] = get_pos(xmas_map, x+i, y-i)
        directions[7][i] = get_pos(xmas_map, x-i, y+i)
    }

    for i in 0..<8 {
        if string(directions[i][:]) == "XMAS" {
            count += 1
        }
    }

    return count
}

is_s_or_m :: proc(values: []u8) -> bool {
    for v in values {
        if v != 'S' && v != 'M' {
            return false
        }
    }
    return true
}

search_crosses :: proc(xmas_map: ^Map, x, y: int) -> int {
    if get_pos(xmas_map, x, y) == 'A' {
        ul := get_pos(xmas_map, x-1, y-1)
        ur := get_pos(xmas_map, x+1, y-1)
        ll := get_pos(xmas_map, x-1, y+1)
        lr := get_pos(xmas_map, x+1, y+1)

        if is_s_or_m([]u8{ul, ur, ll, lr}) {
            if ul != lr && ur != ll {
                return 1
            }
        }
    }
    return 0
}

day4 :: proc(input: string) -> (Answer, Answer) {
    p1, p2: int
    data := strings.split_lines(input)
    xmas_map := Map{data, len(data[0]), len(data)}

    for y in 0..<xmas_map.h {
        for x in 0..<xmas_map.w {
            p1 += search(&xmas_map, x, y)
            p2 += search_crosses(&xmas_map, x, y)
        }
    }

    return p1, p2
}
