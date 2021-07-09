clear all
close all
repetition = 1;
o2_a = 30;
a_b = 200;
o4_b = 80;
o2_o4 = sqrt(50^2 + 150^2);
o4_c = 300;
viper = 200;
d_c = 50;
theta = 1:3:360;
j = 0;
ang_vel = 0;
txt = 0;
global delta terminate_initial
terminate_initial = 0;

delta = button_new(repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt);

theta = 1;
while(1)
animation( repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt)
if(terminate_initial == 1)
    break;
end
end

function [delta,step_size] = button_new( repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt)
global delta step_size;
fig = uifigure;
fig.Position = [400, 50, 600, 250];

btn = uibutton(fig,'text', 'Start Animation',...
               'Position',[420, 218, 100, 22],...
               'ButtonPushedFcn', @(btn,event) plotButtonPushed(btn,...
               repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt));
text_area1 = uitextarea(fig, 'Value', 'Delta', 'FontSize', 14);
text_area1.Position = [45, 30, 200, 60];
sld = uislider(fig,...
               'Position',[100 75 120 3],...
               'ValueChangingFcn',@(sld,event) sliderMoving(event));
    
sld.Limits = [0,30];
delta = sld.Value;
end

function delta = sliderMoving(event)
    global delta;
    delta = event.Value;
% Create the function for the ButtonPushedFcn callback
end

function plotButtonPushed(btn, repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt)
global delta;
global terminate_initial
terminate_initial = 1;
animation( repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt)
end

function animation( repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt)
global delta;
while(j<repetition)
    for i = 1:length(theta)
        angle_new(i) = 0;

    %     position of joints
        o2x(i) = 0;
        o2y(i) = 0;    
        o4x(i) = -150;
        o4y(i) = 50;
    %     additional lengths
        ax(i) = o2x(i) + o2_a*cosd(theta(i));
        ay(i) = o2y(i) + o2_a*sind(theta(i));
    %     required anles
        slope_o2_o4 = atand(50/150);
    %     disp(slope_o2_o4);  %to display the value.

        if theta(i) < 180 - slope_o2_o4 && theta(i) > 360 - slope_o2_o4
            alpha(i) = 180 - theta(i) - slope_o2_04;
        else
            alpha(i) = theta(i) - 180 + slope_o2_o4;
        end

        o4_a(i) = sqrt(o2_a^2 + o2_o4^2 - 2*o2_a*o2_o4*cosd(alpha(i)));
        beta_1(i) = acosd((o4_a(i)^2 + o2_o4^2 - o2_a^2)/(2*o2_o4*o4_a(i)));

        ang_A(i) = acosd((o4_a(i)^2 + a_b^2 - o4_b^2)/(2*o4_a(i)*a_b));

        if theta(i) > 180 - slope_o2_o4 && theta(i) < 360 - slope_o2_o4
            ang_a_b(i) = (slope_o2_o4 + beta_1(i)) - ang_A(i);
            ang_a_b(i) = 180 - ang_a_b(i);
        else
            ang_a_b(i) = ang_A(i) - (slope_o2_o4 - beta_1(i));
            ang_a_b(i) = ang_a_b(i) + 180;
        end


        bx(i) = ax(i) + a_b*cosd(ang_a_b(i));
        by(i) = ay(i) + a_b*sind(ang_a_b(i));


        c1 = clock;
        ang_o4_b(i) = atand((o4y(i) - by(i))/(o4x(i) - bx(i)));

        ang_o4_c(i) = ang_o4_b(i) + delta;
        cx(i) = o4x(i) + o4_c * cosd(ang_o4_c(i));
        cy(i) = o4y(i) + o4_c * sind(ang_o4_c(i));
        if i>2
            ang_vel(i) = omega(c1, c2, ang_o4_b(i), ang_o4_b(i-1));
            
        end
        if i>3
            ang_acc(i) = mu(c1, c2, ang_vel, i);
        end
        

        c2 = c1;
        dx(i) = cx(i) - d_c;
        dy(i) = cy(i);

        o6x(i) = o4x(i) - d_c;
        o6y(i) = o4y(i);

        viperx_1(i) = cx(i);
        vipery_1(i) = cy(i) + 100;
        viperx_2(i) = cx(i);
        vipery_2(i) = cy(i) - 100;

        areax_1(i) = cx(i);
        areay_1(i) = cy(i) + 100;
        areax_2(i) = cx(i);
        areay_2(i) = cy(i) - 100;

        f1 = figure(1);
        f1.Position(3:4) = [450, 350];
        plot(areax_1, areay_1,'m.', areax_2, areay_2,'m.', [o2x(i) ax(i)],...
            [o2y(i) ay(i)], [ax(i) bx(i)], [ay(i) by(i)],...
            [bx(i) o4x(i)], [by(i) o4y(i)], [o4x(i) cx(i)], [o4y(i) cy(i)],...
            [viperx_1(i) viperx_2(i)], [vipery_1(i) vipery_2(i)],...
            [cx(i) dx(i)], [cy(i) dy(i)],[dx(i) o6x(i)], [dy(i) o6y(i)],'LineWidth', 5)
        axis([-350 350 -100 550]);
        axis equal;
        hold off;
        grid on;
        drawnow;
        
        if i>2
            txt = ['omega : ' num2str(ang_vel(i))];
            text(0, 500,txt,'FontSize',10);
        end
        if i>3
            txt2 =['alpha : ' num2str(ang_acc(i)),];
            text(-350, 500, txt2,'FontSize',10);
        end
        
        f2 = figure(2)
        f2.Position(3:4) = [450, 350];
        if i>2
            plot(i, ang_vel(i), 'r.');
        end
        if i>3
            plot(i, ang_acc(i), 'b.');
        end
         hold on;
         axis([-20 130 -10 10]);
        
        drawnow;
        
        
        grid on;
        pause(1/30);
    end
    j = j+1;

end
end

function x = omega(time_stmp1, time_stmp2, ang_new, ang_old)
    t1 = time_stmp1(1, 6);
    t2 = time_stmp2(1, 6);
    x = (ang_new-ang_old)/(t2-t1);
end
function y = mu(time_stmp1, time_stmp2, ang_vel,i)
    t1 = time_stmp1(1,6);
    t2 = time_stmp2(1,6);
    y = (ang_vel(i)-ang_vel(i-1))/(t2-t1);
end


% =====IMPORTANT=================variables==========IMPORTANT=========
% (repetition, o2_a, a_b, o4_b, delta, o2_o4, o4_c, viper, d_c, theta, j, ang_vel, txt)
% =====================================================================

