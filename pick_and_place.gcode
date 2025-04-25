; Step 1: Obtain object's position + velocity + transfer to reference
#O0_X = 100      ; past real-time position (simulated input)
#O0_Y = -50
#O0_Z = -520

#V_X = -0.1        ; past real-time velocity (simulated input)
#V_Y = 0.3
#V_Z = 0

#dt = 0.2        ; processing time (image captured --> controller knows --> control signal received)

; real-time position
#ref_x = #O0_X + #V_X * #dt
#ref_y = #O0_Y + #V_Y * #dt
#ref_z = #O0_Z + #V_Z * #dt

#ref_vx = #V_X
#ref_vy = #V_Y
#ref_vz = #V_Z




