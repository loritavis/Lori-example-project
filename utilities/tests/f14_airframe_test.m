classdef f14_airframe_test < matlab.unittest.TestCase
    %f14_airframe_test_1   MATLAB unit test for the f14_airframe model
    %
    
    properties
        AirframeBusData
    end
    
    methods(TestClassSetup)
        
        function simulateModel(testCase)
            % create input data and assign it to the base workspace
            t = 1:10;
            actualposn = zeros(10, 1);
            actualposn(3) = 1;
            % extract bus object "ACT_BUS" from the buses Data Dictionary
            % and assign in the base workspace
            busDictionary = Simulink.data.dictionary.open('buses.sldd');
            designData = busDictionary.getSection('Design Data');
            ACT_BUS_entry = designData.getEntry('ACT_BUS');
            ACT_BUS = ACT_BUS_entry.getValue;
            assignin('base','ACT_BUS', ACT_BUS);
           
            act_input = Simulink.SimulationData.createStructOfTimeseries('ACT_BUS', {timeseries(actualposn, t), timeseries(0, t)});
            assignin('base', 'act_input', act_input);
            
            % simulate model for 10s and log the output airframe bus
            load_system('f14_airframe');
            output = sim('f14_airframe', ...
                'LoadExternalInput', 'on', ...
                'ExternalInput', 'act_input, []', ...
                'StartTime', '0', ...
                'StopTime', '10', ...
                'SignalLogging', 'on');
            
            % retrieve airframe bus output
            testCase.AirframeBusData = output.get('f14_airframe').get('airframe_bus').Values;
        end
        
    end
    
    methods(Test)
        
        function verifyAlpha(testCase)
            % verify that alpha rad is less than 0.1rad after 10s
            endPoint = testCase.AirframeBusData.alpha_rad.Data(end);
            testCase.verifyLessThan(endPoint, 0.1);
        end
        
        function verifyPitchRate(testCase)
            % verify that the pitch rate is less than 0.1rad/s after 10s
            endPoint = testCase.AirframeBusData.pitchrate_rad_s.Data(end);
            testCase.verifyLessThan(endPoint, 0.1);
        end
        
    end
    
end
