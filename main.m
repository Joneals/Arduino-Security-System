% Arduino Security System
% Created by :
% Hayden Sutton - hsutton5
% Jacob Reynolds - jreyno51
% Matt Trotsky - mtrotsky
% Purpose : Detect any motion in a room due to intruders, sound an alarm
% when motion is detected.
% INPUTS : Push button, Motion Sensor
% OUTPUTS : LED, Speaker
% USAGE : Place motion sensor in location where it has view of the room.
% Push the button once to arm the device.

clear all, close all, clc

a = arduino('COM3', 'uno');
h = figure(gui);

pause(.5);

% Define pin constants
pinLED = 'D11';
pinSpeaker = 'D10';
pinButton = 'D7';
pinMotion = 'D8';

threshold = 0.3;  % Value between 0 and 1, tweak for more or less sensitive detection
loopDelay = 0.01;

configurePin(a, pinButton, 'pullup'); % Both devices are active when pulled low
configurePin(a, pinMotion, 'pullup');

bButton = false;
bLED = false;
global bArmed;
bArmed = false;
global bTripped;
bTripped = false;

buffer = zeros(10);
lastTime = 0;

while 1
    
    bButtonLast = bButton; % Store the previous state of the button to prevent rapid firing
    bButton = (~readDigitalPin(a,pinButton));  % Reads the state of the button, 0 - off, 1 - pressed.  Inverted becuase of pullup
    if bButton && ~bButtonLast  % Ignore button holds, only activate on rising edge
        bArmed = ~bArmed; % Toggle state
        bLED = 0; % Turn off the led when unarmed
        if(bArmed)
            h.Children(2).String = 'Armed';
        else
            h.Children(2).String = 'Disarmed';
        end
        h.Children(2).Value = bArmed;
    end
    
    % Flash LED
    if (bArmed && ~bTripped)
       if (cputime - lastTime) > 1 % If time elapsed is more than 2 seconds
          bLED = ~bLED;
          lastTime = cputime;
       end
    end
    
    % Detect motion and set tripped state while armed
    if (bArmed)
        motion = ~readDigitalPin(a, pinMotion);
        buffer = [motion buffer(1,1:end-1)];  % Fill a circular buffer to compute the rolling average
        avgMotion = mean(buffer)
        if (avgMotion > threshold) %If the average motion is over the threshold, SOUND THE ALARMS
            bTripped = 1;
            avgMotion = 0;
        end
    else
        bTripped = 0;
    end
  
    % If the alarm is tripped, be annoying as possible
    if (bTripped)
       playTone(a, pinSpeaker, 2000, .02) 
       if (cputime - lastTime) > .2
          bLED = ~bLED; 
       end
    end
    
    
    writeDigitalPin(a, pinLED, bLED) %update the led
    
    pause(loopDelay)
    %disp(avgMotion);
end
