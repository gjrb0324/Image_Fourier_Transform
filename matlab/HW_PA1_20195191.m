%05.23. 현재까지 최종 제출물
start = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\start.jpg'));
img1 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0010.jpg'));
img2 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0020.jpg'));
img3 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0030.jpg'));
img4 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0040.jpg'));
img5 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0050.jpg'));
img6 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0060.jpg'));
img7 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0070.jpg'));
img8 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0080.jpg'));
img9 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0090.jpg'));
img10 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0100.jpg'));
f1= figure;
f2 = figure;
f3 = figure;
img_list = [img1, img2, img3, img4, img5, img6, img7, img8, img9, img10];
patch = start(138:187, 272:321);
fig_list = [f1, f2, f3];
figure(f1);
k = 0;
for loop = 1:10
    r = rem(loop,4);
    if r==1
        k = k+1;
        figure(fig_list(k));
    end
    if r ==0
        r =4;
    end
    subplot(2,2,r);
    img= img_list(1:360, 1+480*(loop-1):480+480*(loop-1));
    imshow(img);
    [i,j] = pc(patch,img);
    rectangle('Position',[j i 49 49]);
end
function t_img = fourier_trans(s_img)
     s_img_d = cast(s_img,'double');
     h = size(s_img,1);
     w = size(s_img,2);
     wy = zeros(h,h);
     wx= zeros(w,w);
     for y = 1:h
        for m = 1:h
            wy(y,m)=exp((-2i)*pi*m*y/h);
        end
     end
     for x = 1:w
        for n = 1:w
              wx(x,n) = exp((-2i)*pi*n*x/w);
        end
     end
     wy = circshift(wy, [1 1]);
     wx = circshift(wx, [1 1]);
     t_img = (wy*s_img_d*wx);
end
function in_dft = inverse_ft(img_t)
     h = size(img_t,1);
     w = size(img_t,2);
     wy = ones(h,h);
     wx= ones(w,w);
     for y = 1:h
        for m = 1:h
           wy(y,m)=exp((2i)*pi*m*y/h);
        end
     end
     for x = 1:w
        for n = 1:w 
              wx(x,n) = exp((2i)*pi*n*x/w);
        end
     end
          wy = circshift(wy, [1 1]);
          wx = circshift(wx, [1 1]);
     in_dft = (wy*img_t*wx)./(h*w);
end
%angle 쓰지 않은 점 설명, angle썼을때 값들의 아주 미세한 차이도 캡쳐해서 보여주기
function [i,j]= pc(start,target_img)
     h = size(start,1);
     w = size(start,2); 
     r = ones(360-h,480-w);
     start_t = fft2(start);
     for y = 1:(360-h)
        for x = 1:(480-w)
            target_patch = target_img(y:y+(h-1), x:x+(w-1));
            target_t = fft2(target_patch);  
            C =(start_t.*conj(target_t))./abs(start_t.*conj(target_t));
            R = ifft2(C);
            r(y,x) = max(max(abs(R)));
        end
     end
    [i, j]= find(r == max(max(r))); 
end
