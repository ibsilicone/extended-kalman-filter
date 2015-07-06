function [model,tMax,leg_ft,foot_ft,skin,inertial,transforms] = modelSensorParams_footWithoutlegFT(whichLeg,whichSkin,numberOfExperiment,t_max,measurementType,dataset)
%% function returns the model parameters for treating the complete leg as a single rigid body. 
%The function for now only returns the values corresponding to right leg


% model.m = 4.9580;
model.m = 0.761;

%% obtaining mass-matrix from mexWBIModel (stored in utils)

% load('./utils/MIni','M_at_q0');

%% TODO We need to extract foot's instead.
% Mjts = M_at_q0(7:end,7:end);            % Leg mass matrix 
% %MI_at_thigh = Mjts(14:16,14:16);
% 
% %%% checkup if this is for left leg or right leg. Not entirely sure if it will be different
% %Tl = [0 1 0; 1 0 0 ; 0 0 -1];
% %% Transformation of the mass matrix to COM reference frame
% %Ic = Tl*MI_at_thigh*Tl' - S([0 0 -0.18102]')*S([0 0 -0.18102]')';
% MI_at_thigh_r = Mjts(20:22,20:22);
%  Tl_r = [0 -1 0; 1 0 0 ; 0 0 1];
%  Ic = Tl_r*MI_at_thigh_r*Tl_r' - S([0 0 -0.18102]')*S([0 0 -0.18102]')';

% disp(Ic);
% model.I = Ic;

model.I = [0.00253893, -4.51893e-6, -0.000903578;...
          -4.51893e-6,  0.00407487, 3.68679e-5;...
          -0.000903578, 3.68679e-5, 0.00208378];
           
%model.x0 = [zeros(3,1);omega(1,:)';fo(:,1);muo(:,1);fc(:,1);muc(:,1);zeros(3,1)];
model.phi0 = [0,0.5*pi,0]';
%model.acclSign = -1;

%% world gravity
model.B0_g = [0;0;9.8];
B_R_G = euler2dcm(model.phi0);
model.G_g = -B_R_G'*model.B0_g;

%% Set Dataset Paths and FT Offsets
if(strcmp(dataset,'new')==1)
   expPath     = ['./robotData/compliant-surface-dataset-foot/bwdTippingOnCompliantSurface/backwardTippingCompliant300620150' ...
                num2str(numberOfExperiment) '/dumper/icub/'];
   [FT2 FT3 FT4 FT5] = readFTOffsets(strcat(expPath,'../../'));
    offsets.FT2 = FT2;
    offsets.FT3 = FT3;
    offsets.FT4 = FT4;
    offsets.FT5 = FT5;         
end


if(strcmp(dataset,'old')==1)
expPath     = ['./robotData/backwardTipping/dumperTippingSetup0' ...
                num2str(numberOfExperiment) '/icub/'];    
% Left leg
offsets.FT2 = [-4.11735 111.148 -131.104 -13.423 1.36924 -1.04304];
% LEft Foot
offsets.FT3 = [-52.0296 -5.64247 -18.0923 -0.516052 9.91345 0.717567];
% Right Leg
offsets.FT4 = [-5.65084 -10.5031 -24.6174 1.95779 2.61084 0.0036913];
% Right foot
offsets.FT5 = [-17.4992 -0.910681 18.0613 -0.824831 3.32657 -0.252851];
end

left_leg_ft_offset = offsets.FT2;
right_leg_ft_offset = offsets.FT4;
left_foot_ft_offset = offsets.FT3;
right_foot_ft_offset = offsets.FT5;

%% Loading data from the datasets

leg_choice  = whichLeg;
skin_choice = whichSkin;



% Leg F/T analog sensor
if(strcmp(measurementType,'withoutlegFT')~=1 && strcmp(measurementType,'dualStateWithoutlegFT')~=1)
leg_ft_data   = importdata(strcat(expPath,leg_choice,'_leg/analog:o/data.log'));
end
% Foot F/T analog sensor
foot_ft_data  = importdata(strcat(expPath,leg_choice,'_foot/analog:o/data.log'));
% Foot skin data
skin_data     = importdata(strcat(expPath,'skin/',skin_choice,'_foot/data.log'));
% Inertial sensor attached to the foot (right)
inertial_data = importdata(strcat(expPath,'inertial/data.log'));


if(strcmp(leg_choice,'left')==1)
    leg_ft_offset = left_leg_ft_offset;
    foot_ft_offset = left_foot_ft_offset;
else
    leg_ft_offset = right_leg_ft_offset;
    foot_ft_offset = right_foot_ft_offset;
end
 
if(strcmp(measurementType,'withoutlegFT')~=1 && strcmp(measurementType,'dualStateWithoutlegFT')~=1)
leg_ft.t = leg_ft_data(:,2)-leg_ft_data(1,2);
leg_ft.idx = leg_ft_data(:,1) - leg_ft_data(1,1);
leg_ft_data(:,3:8) = leg_ft_data(:,3:8) - repmat(leg_ft_offset,size(leg_ft_data,1),1);
leg_ft.f = leg_ft_data(:,3:5);
leg_ft.mu = leg_ft_data(:,6:8);
else
leg_ft = struct([]);
end

foot_ft.t = foot_ft_data(:,2)-foot_ft_data(1,2);
foot_ft.idx = foot_ft_data(:,1) - foot_ft_data(1,1);
foot_ft_data(:,3:8) = foot_ft_data(:,3:8) - repmat(foot_ft_offset,size(foot_ft_data,1),1);
foot_ft.f = foot_ft_data(:,3:5);
foot_ft.mu = foot_ft_data(:,6:8);


skin.t = skin_data(:,2) - skin_data(1,2);
skin.idx = skin_data(:,1) - skin_data(1,1);
skin.data = skin_data(:,3:end);

inertial.t = inertial_data(:,2)-inertial_data(1,2);
inertial.idx = inertial_data(:,1) - inertial_data(1,1);
inertial.data = inertial_data(:,3:end);

if(strcmp(measurementType,'withoutlegFT')~=1 && strcmp(measurementType,'dualStateWithoutlegFT')~=1)
tMax = min([leg_ft.t(end),foot_ft.t(end),skin.t(end),inertial.t(end),t_max]);
else
tMax = min([foot_ft.t(end),skin.t(end),inertial.t(end),t_max]);
end


% leg_p_B = [0 0 0.18102]';
% ankle_p_B = [0 0 -0.18102]';


% leg to ankle
leg_p_ankle = [0 0 0.4776]';%[0.4776 0 0]' ;
% ankle to foot COM
ankle_p_com = [0.024069 -0.000613931 0.0425846]';

transforms.B_adjT_ankle = [eye(3) zeros(3) ; -eye(3)*S(ankle_p_com) eye(3) ];

if(strcmp(measurementType,'withoutlegFT')~=1 && strcmp(measurementType,'dualStateWithoutlegFT')~=1)
    transforms.ankle_adjT_leg = [eye(3) zeros(3) ; -eye(3)*S(leg_p_ankle) eye(3) ];
    transforms.B_adjT_leg = transforms.B_adjT_ankle * transforms.ankle_adjT_leg;
end

%%Not Valid if uncommented -> %Obtained generically through a function in the realMeasurement.m script
%rather than from file.
load('IMUOffset_New.mat','com_R_imu');
transforms.B_R_imu = com_R_imu;
end