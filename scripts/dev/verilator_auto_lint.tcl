# Get active project directory from Quartus through the get_project_directory command
# use inotify to monitor all .sv files for changes and run the verilator linting whenever a change is detected
# pipe the result into stdout for now

# Get the project directory
# set project_directory [get_project_directory] (PROD)

# Get the project directory (TEST)
set project_directory "/mnt/c/Users/seany/documents/github/risc-v-processor/risc-v-processor/scripts/dev/"

# Get all SystemVerilog files in the project directory
set sv_files [glob -nocomplain -directory $project_directory *.sv]

# DEBUG: print list of SystemVerilog files
# puts "SystemVerilog files found in project directory:"  DEBUG
# puts $sv_files DEBUG

# Check if list is empty, if it is throw error
if {[llength $sv_files] == 0} {
    puts "No SystemVerilog files were found in the project directory"
    exit 1
}

# Join the list of files into a single string
set sv_files_str [join $sv_files " "]

# Initialize inotify and watch only the SystemVerilog files
# inotify options: -m for monitoring, -e for events, close_write for file close after write (i.e. save)
set inotify [open "|inotifywait -m -e close_write $project_directory" r]

# If inotify fails to open, throw error
if {[eof $inotify]} {
    puts "Failed to open inotify"
    exit 1
}

# If inotify is sucessful, print success message
puts "Watching SystemVerilog files for changes..."

# If inotify finds a change, run the verilator linting only on the changed file
while {1} {
    set line [gets $inotify]
    
    # puts "LINE: $line" DEBUG

    if {[regexp {(.+)\s+CLOSE_WRITE,CLOSE\s+(.+\.sv)$} $line all part1 part2]} {

        exec clear >@ stdout

        set match $part1$part2

        # puts $match DEBUG
        
        # Match the extracted filepath with one of the filepaths in sv_files
        foreach file $sv_files {
            if {[string equal -nocase [lindex $match 0] $file]} {
                set matched_file $file
                break
            }
        }

        if {$matched_file ne ""} {
            puts "Running verilator linting on $part2"
            if {[catch {exec verilator --lint-only $matched_file} result]} {
                puts "Verilator detects errors in $part2: $result"
            } else {
                puts $result
            }
            set matched_file ""
        } else {
            puts "No matching file found for $filepath"
        }
    }
}
