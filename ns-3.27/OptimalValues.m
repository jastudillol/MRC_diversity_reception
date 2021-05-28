function [mT,omegaT] = OptimalValues(N,fading,PrW)
Num_samples=40000;
for i=1:size(fading,2)
    
    samples=zeros(1,Num_samples);
    for jj=1:size(fading,1)
       pd= makedist('Nakagami','mu',fading(jj,i),'omega',PrW(jj,i));
       samples=samples+random(pd,1,Num_samples).^2;
    end
    samples=sqrt(samples);
    %calculo de OmegaTotal
    omegaT(i)=sum(samples.^2)/Num_samples;
    delta=log(sum(samples.^2)/Num_samples)-(sum(log(samples.^2)))/Num_samples;
    mT(i)=(1+sqrt(1+4.*delta/3))/(4.*delta);
    
    
    
    
    
    
    
    

end

end

