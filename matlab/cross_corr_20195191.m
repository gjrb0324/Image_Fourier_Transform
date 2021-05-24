%Cross_corr 2021.05.24구현
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
    [i,j] = sliding_window(patch,img);
    rectangle('Position',[j i 49 49]);
end
function sum = corr(patch, patch_t)
    h = size(patch,1);
    w = size(patch,2);
    sum =0.0;
    avg_p = mean(mean(patch));
    avg_t = mean(mean(patch_t));
    std_p = std2(patch);
    std_t = std2(patch_t);
    for  y = 1: h
        for x = 1:w
            a1 =patch(y,x)-avg_p;
            a2 = patch_t(y,x)-avg_t;
            sum = sum +((patch(y,x)-avg_p)*(patch_t(y,x)-avg_t))/(std_p*std_t);
        end
    end
    sum = sum/(h*w);
end
function [i,j]= sliding_window(patch,target_img)
    r = 1;
    h = size(patch,1);
    w = size(patch,2);
    patch = cast(patch,'double');
    target_img= cast(target_img,'double');
    for y = 1:360-h
         for x = 1:480-w
            patch_t = target_img(y:y+(h-1), x:x+(w-1));
            r(y,x) = corr(patch, patch_t);
         end
    end
    m = max(max(r));
     [i, j]= find(r == max(max(r)));
end
