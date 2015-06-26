function plotResultsOutput_withSkin(dataBaseFolder,XUpt, XPred,P, tK, yM,source)

if(nargin<2)
    load(strcat(dataBaseFolder,'filter_result_data.mat'));
    tK = tKalman;
    yM = yMeas;
    source = 2;
    XUpt = Xupdt;
    XPred = Xhat;
    tMin = tK(1);
end

idx = 1;

% wrench above foot
% stateVar = 7:12;
% pT.titleText = {'Expectation of force f_o',...
%                 'Expectation of Moment u_o',...
%                 '',...
%                 '',...
%                 '',...
%                 ''
% };
pT.xlabelText = {'Time t(sec)',...
                 'Time t(sec)',...
                 'Time t(sec)',...
                 'Time t(sec)',...
                 'Time t(sec)',...
                 'Time t(sec)'
 };
% pT.ylabelText = {'E(f_x) N',...
%                  'E(u_x) Nm',...
%                  'E(f_y) N',...
%                  'E(u_y) Nm',...
%                  'E(f_z) N'....
%                  'E(u_z) Nm'
% };
% cols = {'b','b','g','g','r','r'};
% plotFilterResultTimeSeries(tK(idx:end),XUpt(idx:end,:),yM(idx:end,:),P(:,:,idx:end),stateVar,pT,cols,[3,2]);

% wrench below foot
% stateVar = 13:18;
% pT.titleText = {'Expectation of force f_c',...
%                 'Expectation of Moment u_c',...
%                 '',...
%                 '',...
%                 '',...
%                 ''
% };
% cols = {'b','b','g','g','r','r'};
% plotFilterResultTimeSeries(tK(idx:end),XUpt(idx:end,:),yM(idx:end,:),P(:,:,idx:end),stateVar,pT,cols,[3,2]);


% velocities
stateVar = 1:6;
pT.titleText = {'Expectation of Translation Velocity v_B',...
                'Expectation of Angular Velocity \omega_B',...
                '',...
                '',...
                '',...
                ''
};
pT.ylabelText = {'E(v_B_x) m/sec',...
                 'E(\omega_B_x) rad/sec',...
                 'E(v_B_y) N',...
                 'E(\omega_B_y) m/sec',...
                 'E(v_B_z) N'....
                 'E(\omega_B_z) rad/sec'
};
cols = {'b','b','g','g','r','r'};
%plotFilterResultTimeSeries(tK(idx:end),XUpt(idx:end,:),yM(idx:end,:),P(:,:,idx:end),stateVar,pT,cols,[3,2]);
plotFilterResultTimeSeries(tK(idx:end),XUpt(idx:end,:),[],P(:,:,idx:end),stateVar,pT,cols,[3,2]);

% orientation
stateVar = 19:21;
pT.titleText = {'Expectation of Orientation',...
                '',...
                '',...
                ''
};
pT.ylabelText = {'E(\phi_x) degs',...
                 'E(\phi_y) degs',...
                 'E(\phi_z) degs'
};
cols = {'b','g','r'};
plotFilterResultTimeSeries(tK(idx:end),rad2deg(XUpt(idx:end,:)),[],P(:,:,idx:end),stateVar,pT,cols,[]);


% % stiffness of virtual spring
% stateVar = 22:24;
% pT.titleText = {'Expectation of Stiffness of virtual spring Kx',...
%                 '',...
%                 '',...
%                 ''
% };
% pT.ylabelText = {'E(K_xx) Nm/rad',...
%                  'E(K_xy) Nm/rad',...
%                  'E(K_xz) Nm/rad',...
%                  
% };
% cols = {'b','g','r'};
% plotFilterResultTimeSeries(tK(idx:end),XUpt(idx:end,:),[],P(:,:,idx:end),stateVar,pT,cols,[]);
% 
% stateVar = 25:27;
% pT.titleText = {'Expectation of Stiffness of virtual spring Ky',...
%                 '',...
%                 '',...
%                 ''
% };
% pT.ylabelText = {'E(K_yx) Nm/rad',...
%                  'E(K_yy) Nm/rad',...
%                  'E(K_yz) Nm/rad',...
%                  
% };
% cols = {'b','g','r'};
% plotFilterResultTimeSeries(tK(idx:end),XUpt(idx:end,:),[],P(:,:,idx:end),stateVar,pT,cols,[]);
% 
% stateVar = 28:30;
% pT.titleText = {'Expectation of Stiffness of virtual spring Kz',...
%                 '',...
%                 '',...
%                 ''
% };
% pT.ylabelText = {'E(K_zx) Nm/rad',...
%                  'E(K_zy) Nm/rad',...
%                  'E(K_zz) Nm/rad'
% };
% cols = {'b','g','r'};
% 
% plotFilterResultTimeSeries(tK(idx:end),XUpt(idx:end,:),[],P(:,:,idx:end),stateVar,pT,cols,[]);


% FRI
% if(source==2)
%      plot_FRI(XUpt,P,XPred, P,tK, idx,length(tK));%,'b',index+5+figPreN);
%  end
% 

end
