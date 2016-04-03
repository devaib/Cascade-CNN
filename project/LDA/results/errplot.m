close all
clear all
Tr=importdata('train.log');
Te=importdata('test.log');
%Tr=importdata('train_fixedLpatch.log');
%Te=importdata('test_fixedLpatch.log');
Lte=length(Te.data);
Ltr=length(Tr.data);
Eopt=zeros(size(Te.data));
Epir=zeros(size(Te.data));
idxmin=zeros(size(Te.data));
T=100;
for t=1:Lte;
    [Eopt(t),idxmin(t)]=min(1-Te.data(1:t)/100);
    Epir(t)=max(1-Te.data(max(1,t-T+1):t)/100);
end
figure
subplot(2,1,1)
plot((1:Lte),1-Te.data/100,(1:Ltr),1-Tr.data/100,(1:Lte),Eopt,'LineWidth',2), legend('test','train','Eopt')
title('Test,Train, and minimal test error rate'),xlabel('epochs'),ylabel('error rate'),xlim([0,4000]),ylim([0,.14])
subplot(2,1,2)
plot((1:Lte),1-Te.data/100,(1:Ltr),1-Tr.data/100,(1:Lte),Eopt,'LineWidth',2), legend('test','train','Eopt')
title('Test,Train, and minimal test error rate'),xlabel('epochs'),ylabel('error rate'),xlim([0,12000]),ylim([0,.14])
figure
plot((1:Lte),idxmin), legend('idxmin'),title('Early stopping save point')
xlabel('epochs'),ylabel('Early S. epoch')

Tr12=importdata('trainDropout12.log');
Te12=importdata('testDropout12.log');

Tr1=importdata('trainDropout1.log');
Te1=importdata('testDropout1.log');
Tr2=importdata('trainDropout2.log');
Te2=importdata('testDropout2.log');

Lte1=length(Te1.data);
Ltr1=length(Tr1.data);
Lte2=length(Te2.data);
Ltr2=length(Tr2.data);
Lte12=length(Te12.data);
Ltr12=length(Tr12.data);

Eopt1=zeros(size(Te1.data));
Eopt12=zeros(size(Te12.data));
Eopt2=zeros(size(Te2.data));


idxmin1=zeros(size(Te.data));
idxmin12=zeros(size(Te.data));
idxmin2=zeros(size(Te.data));
T=100;
for t=1:Lte1;
    [Eopt1(t),idxmin(t)]=min(1-Te1.data(1:t)/100);
end
for t=1:Lte12;
    [Eopt12(t),idxmin(t)]=min(1-Te12.data(1:t)/100);
end
for t=1:Lte2;
    [Eopt2(t),idxmin(t)]=min(1-Te2.data(1:t)/100);
end
figure
plot((1:Lte),Eopt,(1:Lte1),Eopt1,(1:Lte12),Eopt12,(1:Lte2),Eopt2,'LineWidth',2), legend('Eopt','Eopt1','Eopt12','Eopt2')
xlabel('epochs'),ylabel('error rate'),xlim([0,4000]),ylim([0,.14])
title('Minimal error rate recorded on test set')