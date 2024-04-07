set wave_patterns {
                           /*
}

set wave_radices {
                           hexadecimal {data q}
}

proc r  {} {uplevel #0 source uart_compile.tcl}
proc rr {} {global last_compile_time
            set last_compile_time 0
            r                            }
proc q  {} {quit -force                  }

set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

set PrefMain(font) {Courier 10 roman normal}

set time_now [clock seconds]
if [catch {set last_compile_time}] {
  set last_compile_time 0
}
set last_compile_time $time_now

vsim -gui test_lib.tb_uart -do wave.do
#nem nyitja meg modelsim gui-t?

#modelsim test_lib.tb_uart
#ezesetben viszont megall itt a do file

run -all

if [llength $wave_patterns] {
  if $tk_ok {wave zoomfull}
}

puts {
  Script commands are:

  r = Recompile changed and dependent files
 rr = Recompile everything
  q = Quit without confirmation
}

if {[file isfile start_time.txt] == 0} {
  set f [open start_time.txt w]
  puts $f "Start time was [clock seconds]"
  close $f
} else {
  set f [open start_time.txt r]
  set line [gets $f]
  close $f
  regexp {\d+} $line start_time
  set total_time [expr ([clock seconds]-$start_time)/60]
  puts "Project time is $total_time minutes"
}