% UWB_location(function)
function [p_out] = UWBlocation(p,err)
% p = [5,5;10,9;15,12;20,22;25,3]; %real location
p_out = p./p;
X_ = p(:,1);
Y_ = p(:,2);
baseP = [5,10;10,5;30,25;25,30]; %Location of signal transmission
baseX_ = baseP(:,1);
baseY_ = baseP(:,2);
R = zeros(length(X_),length(baseX_)); %radius
for i=1:length(X_)
    R(i,:) = ((X_(i)-baseX_).^2+(Y_(i)-baseY_).^2).^0.5;
end
time = R/(3e8);
time_actually = time + err*randn(length(X_),length(baseX_)).*time;
R_calcu = time_actually*3e8; %radius calculated
H = [
    baseX_(2)-baseX_(1),baseY_(2)-baseY_(1);
    baseX_(3)-baseX_(1),baseY_(3)-baseY_(1);
    baseX_(4)-baseX_(1),baseY_(4)-baseY_(1)];
for i=1:length(X_)
    % HX=a
    a = 0.5*[
        baseX_(2).^2+baseY_(2).^2-R_calcu(i,2).^2-baseX_(1).^2-baseY_(1).^2+R_calcu(i,1).^2;
        baseX_(3).^2+baseY_(3).^2-R_calcu(i,3).^2-baseX_(1).^2-baseY_(1).^2+R_calcu(i,1).^2;
        baseX_(4).^2+baseY_(4).^2-R_calcu(i,4).^2-baseX_(1).^2-baseY_(1).^2+R_calcu(i,1).^2];
    p_out(i,:) = (pinv(H)*a)';
end
%% plot
fig(p,p_out);
%% function
    function fig(p,p_out)
        figure;
        scatter(p(:,1),p(:,2),'g');
        hold on
        scatter(p_out(:,1),p_out(:,2),'r');
        legend('ideal','calcu');
    end
end