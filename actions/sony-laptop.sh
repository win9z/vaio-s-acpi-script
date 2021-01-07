#!/bin/bash
# ACPI action script for sony-laptops

# notify function
notify() {
    title="$1"
    body="$2"
    
    SENT=""
    for USER in $(users); do
        case $SENT in
            "$USER") ;;
            *" $USER") ;;
            "$USER "*) ;;
            *" $USER "*) ;;
            *) SENT="$SENT $USER"; DISPLAY=:0.0  su $USER -c "notify-send \"$title\" \"$body\"" ;;
        esac
    done
}


# handle the STAMINA/SPEED switch
if [ $3 == "00000003" ] ; then
    if [ $4 == "00000000" ] ; then
        echo "performance" > /sys/devices/platform/sony-laptop/thermal_control
        tlp ac
        notify "SPEED mode"  
    elif [ $4 == "00000001" ] ; then
        echo "silent" > /sys/devices/platform/sony-laptop/thermal_control  
        tlp bat 
        notify "STAMINA mode"              
    fi

# handle other buttons
elif [ $3 == "00000001" ] ; then

    switch=$(</sys/devices/platform/sony-laptop/gfx_switch_status)
    touchpad=$(</sys/devices/platform/sony-laptop/touchpad)
    kblight=$(</sys/devices/platform/sony-laptop/kbd_backlight)
    kbtimeout=$(</sys/devices/platform/sony-laptop/kbd_backlight_timeout) 
    fan=$(</sys/devices/platform/sony-laptop/fan_forced)   
    
    # FN zoom-out and zoom-in keys 
    # decreases / increases keyboard backlight timeout
    
    if [ $4 == "00000014" ] || [ $4 == "00000015" ] ; then
        if [ $4 == "00000014" ] ; then
            if [ $kbtimeout == -1 ] ; then
                kbtimeout= "1"
            fi
			
            if [ $kbtimeout != 0 ] ; then
                kbtimeout=$(($kbtimeout-1)) 
            fi
        fi
        
        if [ $4 == "00000015" ] ; then
            if [ $kbtimeout == -1 ] ; then
                kbtimeout= "1"
            fi 
            
            if [ $kbtimeout != 3 ] ; then        
                kbtimeout=$(($kbtimeout+1))
            fi
        fi
        
        echo $kbtimeout > /sys/devices/platform/sony-laptop/kbd_backlight_timeout
                
        if [ $kbtimeout == 1 ] ; then
            notify "Keyboard backlight timeout: 10 seconds"
        fi
    
        if [ $kbtimeout == 2 ] ; then
          notify "Keyboard backlight timeout: 30 seconds"
        fi
    
        if [ $kbtimeout == 3 ] ; then
          notify "Keyboard backlight timeout: 60 seconds"
        fi    
    
        if [ $kbtimeout == 0 ] ; then
          notify "Keyboard backlight timeout: disabled"
        fi  
        
        break
    fi
    
    # VAIO button switches keyboard backlight mode
    
    if [ $4 == "00000049" ] ; then
        if [ $kblight == "0" ] || [ $kblight == "-1" ] ; then
            echo "1" > /sys/devices/platform/sony-laptop/kbd_backlight
            notify "Keyboard backlight: Auto mode"    
            break       
        fi
        
        if [ $kblight == "1" ]  ; then
            echo "2" > /sys/devices/platform/sony-laptop/kbd_backlight
            notify "Keyboard backlight: Enabled"    
            break       
        fi
        
        if [ $kblight == "2" ] ; then
            echo "0" > /sys/devices/platform/sony-laptop/kbd_backlight
            notify "Keyboard backlight: Disabled"    
            break       
        fi        
    fi    

    # ASSIST button switches force fan mode    
    
    if [[ $4 == "00000028" && $fan == 0 ]] ; then      
        echo "1" > /sys/devices/platform/sony-laptop/fan_forced
        notify "Fan force mode enabled"  
        break
    elif [[ $4 == "00000028" && $fan == 1 ]] ; then        
        echo "0" > /sys/devices/platform/sony-laptop/fan_forced 
        notify "Fan force mode disabled"    
        break        
    fi     
    
    # FN touchpad toggle button  
    
    if [[ $4 == "0000000c" && $touchpad == 1 ]] ; then      
        echo "0" > /sys/devices/platform/sony-laptop/touchpad
        notify "TouchPad Disabled"  
        break
    elif [[ $4 == "0000000c" && $touchpad == 0 ]] ; then        
        echo "1" > /sys/devices/platform/sony-laptop/touchpad 
        notify "TouchPad Enabled"
        break        
    fi     
fi
# win9z 2019
