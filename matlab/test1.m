start = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\start.jpg'));
img_1 = rgb2gray(imread('D:\Kyu\Study\2021 Signal & System\HW1\dataset\0010.jpg'));
patch_1 = start(140:168, 274:297);
subplot(1,2,1);
imshow(start);
rectangle('Position',[274 140 24 29]);
subplot(1,2,2);
poi = [274 140];
imshow(img_1);
[i,j] = pc(patch_1,img_1,poi);
rectangle('Position',[j i 25 29]);
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
     t_img = (wy*s_img_d*wx)./(h*w);
end
function in_dft = inverse_ft(img_t)
     h = size(img_t,1);
     w = size(img_t,2);
     wy = ones(h,h);
     wx= ones(w,w);
     for y = 1:h
        for m = 1:h
            angle = 2*pi*(m*y/h);
            wy(y,m)=complex(cos(angle)+(1i)*(sin(angle)));
        end
     end
     for x = 1:w
        for n = 1:w 
              angle = 2*pi*(n*x/w);
              wx(x,n)=complex(cos(angle)+(1i)*(sin(angle)));
        end
     end
          wy = circshift(wy, [1 1]);
          wx = circshift(wx, [1 1]);
     in_dft = wy*img_t*wx;
end
%p_point(prior point)는 이전 사진에서 찾은 얼굴 좌표를 나타냄.
function [i,j]= pc(start,target_img, p_point)
%      kernel = [-1 -1 -1;-1 8 -1;-1 -1 -1];
%      img_f = imfilter(target_img,kernel,'same');
     h = size(start,1);
     w = size(start,2); 
     start_t = fft2(start);
     k1 = 1; k2 = 1;
     for y = 1:360-h
        for x = p_point(1)-30:p_point(1)+30
            target_patch =target_img(y:y+(h-1), x:x+(w-1));
            target_t = fft2(target_patch);  
            C =(start_t.*conj(target_t))./abs(start_t.*conj(target_t));
            R = ifft2(C);
            r(k1,k2) = max(max(abs(R)));
            k2 = k2+1;
        end
        k1= k1+1;
        k2 = 1;
     end
    [i, j]= find(r == max(max(r)));
    i = i + p_point(2) -30;
    j = j + p_point(1) -30;
end
