function[]=plotRBFs2D()

N = 50; 
pnorm = 2;
[x,y] = meshgrid(linspace(-2,2,N),linspace(-2,2,N));
%y = meshgrid(linspace(-2,2,10));
r = sqrt(abs(x.^2) + abs(y.^2));
e = 1; 
fontsize = 30; 
linewidth=1;

figure(1)
hold on;
p1=mesh(x,y,MQ(r,e), 'LineWidth', linewidth);
hold off;
set(gca,'FontSize',20);
shading interp;
colormap(winter);
%invgray = flipud(get(gcf,'colormap'));
%set(gcf,'colormap',invgray);
axis([-2 2 -2 2 1 3.0]);
%title('MQ','FontSize',fontsize,'Interpreter','Latex');
xlabel('$x$','FontSize',fontsize,'Interpreter','Latex');
ylabel('$y$','FontSize',fontsize,'Interpreter','Latex');
zlabel('$\phi(r(\mathbf{x}))$','Interpreter','Latex','FontSize',fontsize);
grid on; 
print -deps mq_rbf2d.eps


figure(2)
p2=mesh(x,y,IMQ(r,e),'LineWidth',linewidth);
set(gca,'FontSize',18);
shading interp
set(gcf,'colormap',winter);
axis([-2 2 -2 2 0.25 1]);
%title('IMQ','FontSize',fontsize,'Interpreter','Latex');
xlabel('$x$','FontSize',fontsize,'Interpreter','Latex');
ylabel('$y$','FontSize',fontsize,'Interpreter','Latex');
zlabel('$\phi(r(\mathbf{x}))$','FontSize',fontsize,'Interpreter','Latex');
%grid on; 
print -deps imq_rbf2d.eps

figure(3)
p3=mesh(x,y,GA(r,e),'LineWidth',linewidth); 
set(gca,'FontSize',18);
shading interp
set(gcf,'colormap',winter);
axis([-2 2 -2 2 0 1]);
%title('GA','FontSize',fontsize,'Interpreter','Latex');
xlabel('$x$','FontSize',fontsize,'Interpreter','Latex');
ylabel('$y$','FontSize',fontsize,'Interpreter','Latex');
zlabel('$\phi(r(\mathbf{x}))$','Interpreter','Latex','FontSize',fontsize);
%grid on; 
print -deps ga_rbf2d.eps

return

[x,y] = meshgrid(linspace(-1.25,1.25,N/2),linspace(-1.25,1.25,N/2));
%y = meshgrid(linspace(-2,2,10));
r = sqrt(abs(x.^2) + abs(y.^2))

figure(4)
p4=mesh(x,y,TPS(r,e),'LineWidth',linewidth); 
set(gca,'FontSize',fontsize);
shading interp
set(gcf,'colormap',winter);
axis([-1 1 -1 1 -0.5 1.5]);
title('TPS','FontSize',fontsize);
xlabel('x','FontSize',fontsize);
ylabel('y','FontSize',fontsize);
zlabel('\phi(||x-x_j||)','FontSize',fontsize);
%grid on; 
print -deps tps_rbf2d.eps

figure(5)
p5=mesh(x,y,W2(r,e),'LineWidth',linewidth); 
set(gca,'FontSize',fontsize);
shading interp
set(gcf,'colormap',winter);
axis([-1 1 -1 1 -0.5 1.5]);
title('W2');
xlabel('x');
ylabel('y');
zlabel('\phi(r)');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 4]);
print -deps w2_rbf2d.eps
%grid on; 
end

function[phi] = MQ(r,eps)
    phi=sqrt(1+(eps.*r).^2);
end

function[phi] = IMQ(r,eps)
    phi=1./(sqrt(1.+(eps.*r).^2));
end

function[phi] = GA(r,eps)
    phi=exp(-(eps.*r).^2);
end

function[phi] = TPS(r,eps)
    phi=(r.^2) .* log(r);
end

function[phi] = W2(r,eps)
    phi=((1-eps.*r).^4) .* (4.*eps.*r + 1);
end