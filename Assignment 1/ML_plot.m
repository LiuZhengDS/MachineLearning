x=[0 1 10 100 1000 10000];
y1=[4224 4231 4227 4253 5201 31988];
y2=[39.59 39.97 39.84 41.50 45.49 50];
subplot(1,2,1);
plot(x,y1,'Color','r','LineWidth',2);
set(gca,'XScale','log');
hold on;
% plot(x,y2,'Color','b','LineWidth',2);
% set(gca,'XScale','log');
xlabel('lambda');
ylabel('loss');

legend('loss(1000 samples)','true error(1000 samples)');
%%%%%%%%
x=[0 1 10 100 1000 10000];
y1=[39.81 39.95 54.84 362.9 3822 43762];
y2=[47.62 45.88 44.58 50.02 50 50];
subplot(1,2,2);
plot(x,y1,'Color','r','LineWidth',2);
set(gca,'XScale','log');
hold on;
% plot(x,y2,'Color','b','LineWidth',2);
% set(gca,'XScale','log');
xlabel('lambda');
ylabel('loss');

legend('loss(10 samples)','true error(10 samples)');