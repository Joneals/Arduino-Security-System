% Arduino Security System
% Created by 
% Hayden Sutton - hsutton5
% Jacob Reynolds - jreyno51
% Matt Trotsky - mtrotsky
% Purpose : Detect any motion in a room due to intruders, sound an alarm
% when motion is detected.
% INPUTS : Push button, Motion Sensor
% OUTPUTS : LED, Speaker
% USAGE : Place motion sensor in location where it has view of the room.
% Push the button once to arm the device.
function main()
clear all, close all, clc

a = arduino('COM3', 'uno');

pause(3);

% Define pin constants
pinLED = 11;
pinSpeaker = 10;
pinButton = 7;
pinMotion = 8;

configureDigitalPin(a, pinButton, 'pullup'); % Both devices are active when pulled low
configureDigitalPin(a, pinMotion, 'pullup');

state = 'unarmed';
bButton = false;
bLED = false;
bArmed = false;


while 1
    bButtonLast = bButton;
    bButton = (~readDigitalPin(a,pinButton));  % Reads the state of the button, 0 - off, 1 - pressed.  Inverted becuase of pullup
    if bButton && ~bButtonLast  % Ignore button holds, only activate on falling edge
        bArmed = ~bArmed; % Toggle state
    end
    
    % Flash LED
    if strcmp(state,'armed')
        bLED = ~bLED;
       writeDigitalPin(pinLED, bLED)
    end
    
    
    pause(.1)
    disp(state);
end
end