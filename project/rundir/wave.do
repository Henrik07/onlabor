onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_uart/clk_1
add wave -noupdate /tb_uart/rst_n_1
add wave -noupdate /tb_uart/rx_1
add wave -noupdate /tb_uart/tx_1
add wave -noupdate /tb_uart/transmit_1
add wave -noupdate /tb_uart/tx_byte_1
add wave -noupdate /tb_uart/received_1
add wave -noupdate /tb_uart/rx_byte_1
add wave -noupdate /tb_uart/is_receiving_1
add wave -noupdate /tb_uart/is_transmitting_1
add wave -noupdate /tb_uart/recv_error_1
add wave -noupdate /tb_uart/clk_2
add wave -noupdate /tb_uart/rst_n_2
add wave -noupdate /tb_uart/rx_2
add wave -noupdate /tb_uart/tx_2
add wave -noupdate /tb_uart/transmit_2
add wave -noupdate /tb_uart/tx_byte_2
add wave -noupdate /tb_uart/received_2
add wave -noupdate /tb_uart/rx_byte_2
add wave -noupdate /tb_uart/is_receiving_2
add wave -noupdate /tb_uart/is_transmitting_2
add wave -noupdate /tb_uart/recv_error_2
add wave -noupdate /tb_uart/rnd_value
add wave -noupdate /tb_uart/t0
add wave -noupdate /tb_uart/t1
add wave -noupdate /tb_uart/t2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {6306300 ns}
