function plot_elipse(X_tr, X_ts, Y_tr, Y_ts, nComb, iComb, i, tex)


c1_indx_tr=find(Y_tr==nComb(iComb,1));
c2_indx_tr=find(Y_tr==nComb(iComb,2));

X_tr_c1=X_tr(c1_indx_tr,[1,6]);
X_tr_c2=X_tr(c2_indx_tr,[1,6]);


% Get the line
All_A_tr=[X_tr_c1(:,1) ; X_tr_c2(:,1)];
All_B_tr=[X_tr_c1(:,2) ; X_tr_c2(:,2)];
minA_Tr=min(All_A_tr);
minB_Tr=min(All_B_tr);
maxA_Tr=max(All_A_tr);
maxB_Tr=max(All_B_tr);

figure(i)
g1=scatter(X_tr_c1(:,1),X_tr_c1(:,2),10,'b+'); hold on;
g2=scatter(X_tr_c2(:,1),X_tr_c2(:,2),8,'bo');
% Draw Ellipse
[e1,e2]=f_plot_ellipse(X_tr_c1,X_tr_c2);
hold on;
g3=plot(e1(1,:), e1(2,:), 'b--', 'MarkerSize',4);
g4=plot(e2(1,:), e2(2,:), 'b--', 'MarkerSize',4);

hold on

GT=[ zeros(50,1) ; ones(50,1) ];
[class,err,POSTERIOR,logp,coeff] = classify([X_tr_c1 ; X_tr_c2],[X_tr_c1 ; X_tr_c2],GT);
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h1 = ezplot(f,[minA_Tr maxA_Tr minB_Tr maxB_Tr]);
set(h1,'Color',[0 0 0]);
set(h1,'LineWidth',2);
set(h1,'LineStyle','--');
xlabel('First best feature','FontWeight','bold');
ylabel('Second best feature','FontWeight','bold');
title('{\b Covariate Shift in CSP features}')

% Test Data
c1_indx_ts=find(Y_ts==nComb(iComb,1));
c2_indx_ts=find(Y_ts==nComb(iComb,2));

X_ts_c1=X_ts(c1_indx_ts,[1,6]);
X_ts_c2=X_ts(c2_indx_ts,[1,6]);

% Get the line
All_A_ts=[X_ts_c1(:,1) ; X_ts_c2(:,1)];
All_B_ts=[X_ts_c1(:,2) ; X_ts_c2(:,2)];
minA_Ts=min(All_A_ts);
minB_Ts=min(All_B_ts);
maxA_Ts=max(All_A_ts);
maxB_Ts=max(All_B_ts);


g5=scatter(X_ts_c1(:,1),X_ts_c1(:,2),14,'r+'); hold on;
g6=scatter(X_ts_c2(:,1),X_ts_c2(:,2),12,'ro');
% Draw Ellipse
[e1_ts,e2_ts]=f_plot_ellipse(X_ts_c1,X_ts_c2);
hold on;
g7=plot(e1_ts(1,:), e1_ts(2,:),'r-.o', 'MarkerSize',4);
g8=plot(e2_ts(1,:), e2_ts(2,:),'r-.d', 'MarkerSize',4);

hold on
minA=min(minA_Ts,minA_Tr);
maxA=max(maxA_Ts,maxA_Tr);
minB=min(minB_Ts,minB_Tr);
maxB=max(maxB_Ts,maxB_Tr);

GT=[ zeros(50,1) ; ones(50,1) ];
[class,err,POSTERIOR,logp,coeff] = classify([X_ts_c1 ; X_ts_c2],[X_ts_c1 ; X_ts_c2],GT);
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[minA maxA minB maxB]);
set(h2,'Color',[1 0 0]);
set(h2,'LineWidth',2);
set(h2,'LineStyle','-.');
xlabel('First best feature','FontWeight','bold');
ylabel('Second best feature','FontWeight','bold');
title(tex)
Leg = [g1 g2 g5 g6 h1 h2];
leg1=['Tr_{C' num2str(nComb(iComb,1)), '}']
leg2=['Tr_{C' num2str(nComb(iComb,2)), '}']
leg3=['Ts_{C' num2str(nComb(iComb,1)), '}']
leg4=['Ts_{C' num2str(nComb(iComb,2)), '}']

legend([g1 g2 g5 g6 h1 h2], {leg1, leg2, leg3, leg4,'Tr Plane','Ts Plane'})
% legend([g1 g2 g5 g6 h1 h2], {'Tr_{C1}','Tr_{C2}','Ts_{C1}','Ts_{C2}','Tr Plane','Ts Plane'})

end