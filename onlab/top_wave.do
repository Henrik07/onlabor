onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_design_top/clk
add wave -noupdate /tb_design_top/rst_n
add wave -noupdate /tb_design_top/rx
add wave -noupdate /tb_design_top/i_design_top/received
add wave -noupdate /tb_design_top/i_design_top/i_uart/received
add wave -noupdate /tb_design_top/tx
add wave -noupdate /tb_design_top/rx_byte
add wave -noupdate /tb_design_top/i_design_top/i_uart/rx_byte
add wave -noupdate /tb_design_top/i_design_top/rx_byte_internal
add wave -noupdate /tb_design_top/i_design_top/address_cmd
add wave -noupdate /tb_design_top/i_design_top/wr_cmd
add wave -noupdate /tb_design_top/i_design_top/data_in_cmd
add wave -noupdate /tb_design_top/i_design_top/received_cmd
add wave -noupdate /tb_design_top/i_design_top/write_data_cmd
add wave -noupdate /tb_design_top/i_design_top/read_data_cmd
add wave -noupdate /tb_design_top/i_design_top/i_cmd_int/read_data_i
add wave -noupdate /tb_design_top/i_design_top/data_out_cmd
add wave -noupdate /tb_design_top/i_design_top/i_cmd_int/cmd_state_d
add wave -noupdate /tb_design_top/i_design_top/i_cmd_int/cmd_state_q
add wave -noupdate /tb_design_top/i_design_top/i_cmd_int/data_received_i
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/data_received_i
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/wr_i
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/address_i
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/data_i
add wave -noupdate /tb_design_top/i_design_top/data_in_reg
add wave -noupdate /tb_design_top/i_design_top/address_reg
add wave -noupdate /tb_design_top/i_design_top/wr_reg
add wave -noupdate /tb_design_top/i_design_top/data_out_reg
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/temp_d
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/temp_q
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/reg_array_d
add wave -noupdate /tb_design_top/i_design_top/i_reg_top/reg_array_q
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_design_top/i_design_top/transmit
add wave -noupdate /tb_design_top/i_design_top/i_uart/received
add wave -noupdate /tb_design_top/i_design_top/i_uart/rx_byte
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3980597015 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {5250 us}
