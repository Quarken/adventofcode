package main

import "core:os"
import "core:fmt"
import "core:strconv"
import "core:sys/windows"
import "core:strings"

Solution :: proc(input: string) -> (p1, p2: int)
solutions := []Solution{
    1 = day1,
    2 = day2,
    3 = day3,
    4 = day4,
    5 = day5
}

main :: proc() {
    arguments := os.args[1:]
    fmt.println(arguments)
    runs := 1000

    if len(arguments) == 0 {
        fmt.println("Please enter a day")
        os.exit(1)
    }

    day, ok := strconv.parse_int(arguments[0])
    if !ok {
        fmt.println(day, "is not valid")
        os.exit(1)
    }

    if len(arguments) > 1 {
        r, ok := strconv.parse_int(arguments[1])
        if !ok {
            fmt.println("Invalid number of runs")
            os.exit(1)
        }
        runs = r
    }

    sb := strings.builder_make()
    strings.write_string(&sb, "day")
    strings.write_int(&sb, day)
    strings.write_string(&sb, ".txt")

    f, success := os.read_entire_file(strings.to_string(sb))
    if !success {
        fmt.println("Error!")
        os.exit(1)
    }
    input := string(f)

    // @TODO: Linux support
    performance_frequency: windows.LARGE_INTEGER = 0
    start_time: windows.LARGE_INTEGER = 0
    end_time: windows.LARGE_INTEGER = 0
    windows.QueryPerformanceFrequency(&performance_frequency)

    average: f64 = 0
    mintime: f64 = 99999999
    maxtime: f64 = 0
    p1, p2 := 0, 0
    for i in 0..<runs {
        windows.QueryPerformanceCounter(&start_time)
        p1, p2 = solutions[day](input)
        windows.QueryPerformanceCounter(&end_time)
        elapsed := end_time - start_time
        elapsed *= 1000000
        elapsed /= performance_frequency

        average += f64(elapsed) / f64(runs)
        maxtime = max(maxtime, f64(elapsed))
        mintime = min(mintime, f64(elapsed))
    }

    fmt.println("Advent of Code 2024 day 5")
    fmt.println("----------------------------------")
    fmt.printfln("Timings for %i runs (ms)", runs)
    fmt.printfln("  Avg: %3f", average / 1000)
    fmt.printfln("  Min: %3f", mintime / 1000)
    fmt.printfln("  Max: %3f", maxtime / 1000)
    fmt.println("----------------------------------")
    fmt.println("Solutions")
    fmt.println("  Part 1:", p1)
    fmt.println("  Part 2:", p2)
}