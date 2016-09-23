clear
% The value of the PWM duty cycle must be specified as a number between 0 and 1.
a = arduino('COM3', 'uno');
configureDigitalPin(a, 8, 'pullup');%in future releases use configurePin
configureDigitalPin(a, 7, 'pullup');
pause(3);

pinLED = 11;
pinSpeaker = 10;
pinButton = 7;
pinMotion = 8;

state = 'unarmed';
bButton = 0;
bLED = false;


while 1
    bButtonLast = bButton;
    bButton = (~readDigitalPin(a,pinButton));  % Reads the state of the button, 1 - off, 0 - pressed
    if bButton && ~bButtonLast  % DO button logic
        switch state
            case 'unarmed'
                state = 'armed';
            case 'armed'
                state = 'unarmed';
                writeDigitalPin(pinLED, 0)
                
        end
    end
    
    % Flash LED
    if strcmp(state,'armed')
        bLED = ~bLED;
       writeDigitalPin(pinLED, bLED)
    end
    
    
    pause(.1)
    disp(state);
end