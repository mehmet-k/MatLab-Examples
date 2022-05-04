clc
clear
decision = input("Hazır ses dosyası icin 1, kendi ses dosyam icin 2 tusuna basınız:  ");
if decision == 1
    [tel,fs] = audioread('tel.wav'); 
    n=7;
else
    [tel,fs] = audioread('tel_no.wav');
    n=11;
end

d = floor(length(tel)/n); %the length of each interval
tel_A = zeros(n,d);%tel değişkenini matrix içinde depolamak için matrix oluşturuyorum
                    % n = tuşa kaç kez basıldığı, d = her basılan tuşun süresi
fft_tel = zeros(n,fs);%fft işleminin sonucunu saklamak için matrix oluşturuyorum
                       
for i=1:n
    tel_A(i,1:d) = tel((i-1)*d+1:i*d); %tel_A nın her satırına sırasıyla d aralıklarını kaydediyorum
    fft_tel(i,1:fs) = abs(fft(tel_A(i,1:d),fs));%tel_Anın her satırına önce fft işlemi,sonra abs işlemş
end                                             %uygulayıp fft_tel'in her satırına kaydediyorum

max_x1 = zeros(n,1); %baskın küçük frekansı bulmak için oluşturulan matrix
max_x2 = zeros(n,1);%baskın büyük frekansı bulmak için oluşturulan matrix
for i=1:n
    max1 = fft_tel(i,1); % genlik değerlerini karşılaştırmak için bir değişken
    for j=2:999 
        if max1 < fft_tel(i,j)
            max1 = fft_tel(i,j); %max1'in güncellenmesi
            max_x1(i,1) = j; %bulduğum frekans değerini kaydediyorum
        end
    end
    max1 = fft_tel(i,1); 
    for j=1000:2000
        if max1 < fft_tel(i,j)
            max1 = fft_tel(i,j);
            max_x2(i,1) = j;
        end
    end

end

buttons_pressed = strings(n,1);

fprintf("Basılan tuslar: \n")
for i=1:n %bulduğum frekansların hangi aralığa denk geldiğini karşılaştırarak basılan tuşları buluyorum
    if max_x2(i,1) <= 1300
        if max_x1(i,1) <= 710
            fprintf(" 1 ");
            buttons_pressed(i,1) = '1';
        elseif max_x1(i,1) <= 800
            fprintf(" 4 ");
            buttons_pressed(i,1) = '4';
        elseif max_x1(i,1) <= 900
            fprintf(" 7 ");
            buttons_pressed(i,1) = '7';
        else
            fprintf(" * ");
            buttons_pressed(i,1) = '*';
        end
    elseif max_x2(i,1) <= 1450
        if max_x1(i,1) <= 710
            fprintf(" 2 ");
            buttons_pressed(i,1) = '2';
        elseif max_x1(i,1) <= 800
            fprintf(" 5 ");  
            buttons_pressed(i,1) = '5';
        elseif max_x1(i,1) <= 900
            fprintf(" 8 ");
            buttons_pressed(i,1) = '8';
        else
            fprintf(" 0 ");
            buttons_pressed(i,1) ='0';
         end
    
    elseif max_x2(i,1) <= 2000
        if max_x1(i,1) <=710
            fprintf(" 3 ");
            buttons_pressed(i,1) = '3';
        elseif max_x1(i,1) <= 800
            fprintf(" 6 ");  
            buttons_pressed(i,1) = '6';
        elseif max_x1(i,1) <= 900
           fprintf(" 9 ");
           buttons_pressed(i,1) = '9';
        else
            fprintf(" # ");
            buttons_pressed(i,1) = '#';
        end
    end
end
fprintf("\n")

figure('name','Continous ve Discrete Grafikler');
subplot(2,1,1);
plot(tel);%kaydedilen sesin continous olarak yazdırılması
title("Continous Grafik")
xlabel("zaman")
ylabel("genlik")

subplot(2,1,2);
stem(tel);%kaydedilen sesin discrete olarak yazdırılması
xlabel("zaman")
ylabel("genlik")
title("Discrete Grafik")

figure('name', 'Frekans Spektrumlari'); 
subplot(n,1,1)
for i=1:n
    subplot(n,1,i)
    plot(fft_tel(i,1:fs/2))%her frekans spekturumunun yazdırılması
    title(["basilan tus: "+ buttons_pressed(i,1)]);
end




