#task_begin = 0
#tracking_successful = 0
#reference_corrected = 0
#drop_corrected = 0

#Kp = 1.0 ; Kp: coefficient of proportional control
#dt_control = 0.05 ; sampling time

#z_max = -300 ; maximum z position for the robot to move to the top position

; object position --> robot position
#offset_x = 0
#offset_y = 0
#offset_z = 0.1

IF [#task_begin == 0] THEN
    M98 P901          ; move to top
    #task_begin = 1   ; set task begin flag
ENDIF

N20
; Step 1: Obtain object's position + velocity + transfer to reference
#O0_X = 100      ; past real-time position (simulated input)
#O0_Y = -50
#O0_Z = -520

#reference_corrected = 0 ; set #reference_corrected = 0 after reading the reference position

#V_X = -0.1        ; past real-time velocity (simulated input)
#V_Y = 0.3

#delay = 0.01        ; processing time (image captured --> controller knows --> current time)

; real-time position
#ref_x = #O0_X + #V_X * #delay
#ref_y = #O0_Y + #V_Y * #delay
#ref_z = #O0_Z

#ref_vx = #V_X
#ref_vy = #V_Y

IF [#reference_corrected == 0] THEN
    M98 P900          ; correct the reference x, y, z position
ENDIF


; Step 2: Move towards reference x, y position
; tracking error
#e_x = #ref_x - #X
#e_y = #ref_y - #Y

M98 P910     ; check_tracking_successful()

; Jump to Step 3 if tracking successful
IF [#tracking_successful == 1] THEN GOTO 100

; reference velocity
#v_ref_x = #ref_vx
#v_ref_y = #ref_vy

; PD control --> velocity command
#v_cmd_x = #v_ref_x + #Kp * #e_x
#v_cmd_y = #v_ref_y + #Kp * #e_y

; velocity command --> position command
#x_target = #X + #v_cmd_x * #dt_control
#y_target = #Y + #v_cmd_y * #dt_control

; give the position command
#v_cmd_coefficient = 1.0        ; no less than 1.0
#v_cmd_mag = #v_cmd_coefficient * #sqrt[#v_cmd_x * #v_cmd_x + #v_cmd_y * #v_cmd_y]
G01 F[#v_cmd_mag]
G01 X[#x_target] Y[#y_target] Z[#z_max]

; loop if tracking not successful
IF [#task_begin == 1] THEN GOTO 20



N100
; Step 3: getting down to the object, assume that the time getting down is negligible for reference velocity x, y
IF [#reference_corrected == 0] THEN
    M98 P900          ; correct the reference x, y, z position
ENDIF
G01 Z[#ref_z] F200



N200
; Step 4: Activate suction
M03 D10            ; start sucking, assume D10 is the suction command
G04 P0.5           ; Establish suction for 0.5s
M07 I1             ; check if the suction is successful, assume I1 is the sensor signal, use #I1 to check the suction status


; Step 5: Move to the top position
M98 P901


; Step 6: Move to the drop position x, y
#drop_x = 200
#drop_y = 100
#drop_z = -520

#drop_corrected = 0 ; set #drop_corrected = 0 after setting the dropping position

IF [#drop_corrected == 0] THEN
    M98 P905          ; correct the drop x, y, z position
ENDIF

G01 X[#drop_x] Y[#drop_y] Z[#z_max] F200 ; move to the drop position x, y



; Step 7: Get down to the drop position
G01 X[#drop_x] Y[#drop_y] Z[#drop_z] F200 ; move to the drop position z


; Step 8: Release the object and reset the robot
M05 D10            ; stop sucking, assume D10 is the suction command
G04 P0.5           ; Release the object for 0.5s
M07 I0             ; check if the release is successful, assume I0 is the sensor signal, use #I0 to check the release status

M98 P901          ; move to top
#task_begin = 0   ; wait for the next task, task completed



;================================================
; O900: offset_correction(): correct the reference x, y, z position
;================================================
O900
#ref_x = #ref_x + #offset_x
#ref_y = #ref_y + #offset_y
#ref_z = #ref_z + #offset_z
#reference_corrected = 1
M99

;================================================
; O905: offset_correction(): correct the drop x, y, z position
;================================================
O905
#drop_x = #drop_x + #offset_x
#drop_y = #drop_y + #offset_y
#drop_z = #drop_z + #offset_z
#drop_corrected = 1
M99


;================================================
; O910: check_tracking_successful()
;================================================
O910
#position_threshold = 1.5
#dx = #abs[#e_x]
#dy = #abs[#e_y]

#tracking_successful = 0

IF [[#dx LT #position_threshold] AND [#dy LT #position_threshold]] THEN #tracking_successful = 1
M99


;================================================
; O901: move_to_top()
;================================================
O901
G01 Z[#z_max] F200 ; move to the top position
M99
