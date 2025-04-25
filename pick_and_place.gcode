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


















;================================================
; O900: offset_correction()
;================================================
O900
#ref_x = #ref_x + #offset_x
#ref_y = #ref_y + #offset_y
#ref_z = #ref_z + #offset_z
M99