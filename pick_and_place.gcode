#offset_x = 0
#offset_y = 0
#offset_z = -20


; Step 1: Obtain object's position + velocity + transfer to reference
#O0_X = 100      ; past real-time position (simulated input)
#O0_Y = -50
#O0_Z = -520

#V_X = -0.1        ; past real-time velocity (simulated input)
#V_Y = 0.3
#V_Z = 0

#delay = 0.2        ; processing time (image captured --> controller knows --> control signal received)

; real-time position
#ref_x = #O0_X + #V_X * #delay
#ref_y = #O0_Y + #V_Y * #delay
#ref_z = #O0_Z + #V_Z * #delay

#ref_vx = #V_X
#ref_vy = #V_Y
#ref_vz = #V_Z

M98 P900    ; correct the reference



; Step 2: Move towards reference
; tracking error
#e_x = #ref_x - #X
#e_y = #ref_y - #Y
#e_z = #ref_z - #Z

; Kp: coefficient of proportional control
#Kp = 1.0

; reference velocity
#v_ref_x = #ref_vx
#v_ref_y = #ref_vy
#v_ref_z = #ref_vz

; PD control --> velocity command
#v_cmd_x = #v_ref_x + #Kp * #e_x
#v_cmd_y = #v_ref_y + #Kp * #e_y
#v_cmd_z = #v_ref_z + #Kp * #e_z

; sampling time
#dt_control = 0.05

; velocity command --> position command
#x_target = #X + #v_cmd_x * #dt_control
#y_target = #Y + #v_cmd_y * #dt_control
#z_target = #Z + #v_cmd_z * #dt_control

; give the position command
#v_cmd_coefficient = 1.0        ; no less than 1.0
#v_cmd_mag = #v_cmd_coefficient * #sqrt[#v_cmd_x * #v_cmd_x + #v_cmd_y * #v_cmd_y + #v_cmd_z * #v_cmd_z]
G01 F[#v_cmd_mag]
G01 X[#x_target] Y[#y_target] Z[#z_target]















;================================================
; O900: offset_correction()
;================================================
O900
#ref_x = #ref_x + #offset_x
#ref_y = #ref_y + #offset_y
#ref_z = #ref_z + #offset_z
M99