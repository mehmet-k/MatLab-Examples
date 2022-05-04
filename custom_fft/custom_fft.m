%NOT: dosyayı 20011103.m şeklinde kaydettiğimde ve matlab sayıyla başlayan
% dosyaları çalıştıramdığı için dosya adının en başına bir harf eklemek 
% zorunda kaldım.
clc

fprintf("Please enter your function with most elements first!\n");
func_a = input('Please enter your first function with [ ] around them\n');
zero_a = input('Zero point of your first function?: ');
size_a = length(func_a);

fprintf("Your first function: ");
print_function(func_a,size_a,zero_a);%fonksiyonu vektörel olarak yazdırır
                                     %print_function sayfanın en altında tanımlı           
func_b = input('Please enter your second function with [ ] around them\n');
zero_b = input('Zero point of your second function?: ');
size_b = length(func_b);

fprintf("Your second function: ");
print_function(func_b,size_b,zero_b);

func_conv_length = size_a + size_b - 1;

if zero_a >= zero_b
    index = zero_a %konvolüsyon sonucu için sıfır noktasının belirlenmesi
else
    index = zero_b
end

func_conv = myconv(func_a,func_b,size_a,size_b);%kendi yazdığım fonksiyonun kullanılması,
                                               %fonksiyon sayfanın altında
                                               %tanımlı

fprintf("With my function:\n");
print_function(func_conv,func_conv_length,index);

func_conv_2 = conv(func_a,func_b);%matlab fonksiyonunun kullanılması
fprintf("\nWith Built-in function:\n");
print_function(func_conv_2,func_conv_length,index);

%NOT: set_my_axis fonksiyonu en aşağıda tanımlı
axis = set_my_axis(zero_a,size_a); %grafik çizdirirken sıfır noktasını ayarlama
subplot(2,2,1); 
stem(axis,func_a,'LineWidth',2),xlabel('n'), ylabel('x[n]'), title('Function A');


axis = set_my_axis(zero_b,size_b);
subplot(2,2,2);
stem(axis,func_b,'LineWidth',2),xlabel('n'), ylabel('x[n]'), title('Function B');

axis = set_my_axis(index,func_conv_length);
subplot(2,2,3);
stem(axis,func_conv,'LineWidth',2),xlabel('n'), ylabel('x[n]'), title('With My Function');

subplot(2,2,4)
stem(axis,func_conv_2,'LineWidth',2),xlabel('n'), ylabel('x[n]'), title('Built-in Function');

recObj = audiorecorder; %% kayıt başlatma nesnesi
disp('Start speaking.') %% ekrana mesaj
recordblocking(recObj, 5); %% kayıt işlemi
disp('End of Recording.'); %% ekrana mesaj
sound1 = getaudiodata(recObj); %% kaydedilen sesi x değişkenine saklama

recObj = audiorecorder; %% kayıt başlatma nesnesi
disp('Start speaking.') %% ekrana mesaj
recordblocking(recObj, 10); %% kayıt işlemi
disp('End of Recording.'); %% ekrana mesaj
sound2 = getaudiodata(recObj); %% kaydedilen sesi x değişkenine saklama

length_s1 = length(sound1);%kaydedilen 1.sesin uzunluğu
length_s2 = length(sound2);%kaydedilen 1.sesin uzunluğu

h1 = zeros(1,801); 
h1(1) = 1;
h1(401) = 0.4;
h1(801) = 0.4;%konvensiyon işlemi için h[n] fonksiyonun oluşturulması
length_h1 = length(h1);%h1 uzunluğu

my_conv1 = myconv(sound1,h1,length_s1,length_h1);%seslere konvolüsyon uygulama
conv1 = conv(sound1,h1);

my_conv2 = myconv(sound2,h1,length_s2,length_h1);
conv2 = conv(sound2,h1);

sound(sound1)%seslendirme
pause(6);
sound(my_conv1)
pause(6);
sound(conv1)
pause(6);

sound(sound2)
pause(11);
sound(my_conv2)
pause(11);
sound(conv2)
pause(11);


function [func_conv] = myconv(func_a,func_b,size_a,size_b)%konvolüsyon için yazdığım fonksiyon
    func_conv_length = size_a + size_b - 1;
    func_conv = zeros(1,func_conv_length);
    for i=1:1:func_conv_length
        for j=1:1:i
              if j<=size_a && i-j+1<=size_b % işlemin dizi eleman sayısını aşmaması için kontrol
                func_conv(i) = func_conv(i) + func_a(j)*func_b(i-j+1);
              end
        end
    end
end

function [] = print_function(func_f,size_f,zero_f)%vektörel gösterimin ekrana yazdırılması
    for i=1:size_f
        if i==zero_f
            fprintf(' [%d] ',func_f(i))
        else
            fprintf(' %d ',func_f(i))
        end
    end
    fprintf('\n');
end

function [axis] = set_my_axis(zero_f,size_f)%grafik çizdirirken sıfır noktasını ayarlamak
    axis = -(zero_f-1):1:size_f-zero_f;     %için yazdığım fonksiyon
end