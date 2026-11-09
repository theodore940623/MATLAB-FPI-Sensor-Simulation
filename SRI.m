% ——————————————
% 1. 參數設定（dB 單位）
% ——————————————
A_min_dB = -12;     % 最小光強度 (dB)，請自行設定
A_max_dB = -27;     % 最大光強度 (dB)，請自行設定
n_1      = 1.00;    % 光纖折射率
L_1_um   = 50;     % 腔長（μm）

% ——————————————
% 2. 建立波長軸（1450 nm～1650 nm，共 2001 點）
% ——————————————
lambda_nm = linspace(1450, 1650, 2001);   % 波長 (nm)
% FSR_nm = 20;
FSR_nm = 1550^2 / (2 * n_1 * L_1_um * 1e3);

% ——————————————
% 3. 計算 FPI 反射譜 (dB)
%    spec_dB = A_min_dB + (A_max_dB - A_min_dB) * (cos(...) + 1)/2
% ——————————————
% spec_dB = A_min_dB + (A_max_dB - A_min_dB) .* ...
%           (cos(4 * pi * n_1 * (L_1_um*1e-6) ./ (lambda_nm*1e-9)) + 1) / 2;
spec_dB = A_min_dB + (A_max_dB - A_min_dB) .* ...
          (cos(2 * pi * lambda_nm / FSR_nm) + 1) / 2;

% ——————————————
% 4. 計算 FSR（nm）
%    FSR = 1550^2 / (2 * n * L * 10^3)
%    其中 L 以 μm 為單位
% ——————————————
% FSR_nm = 1550^2 / (2 * n_1 * L_1_um * 1e3);

% ——————————————
% 5. 繪圖並在圖中標示 FSR
% ——————————————
figure;
plot(lambda_nm, spec_dB, 'LineWidth',1.2);
xlabel('Wavelength (nm)', 'FontSize',12);
ylabel('Intensity (dB)',    'FontSize',12);
title(('Simulated FPI Reflection Spectrum'), 'FontSize',14);
grid on;
hold on;

% 在波長 1550 nm 處標示 FSR 數值
x_text = 1550;
y_text = A_min_dB + 0.8*(A_max_dB - A_min_dB);
text(x_text, y_text, sprintf('FSR = %.2f nm', FSR_nm), ...
     'FontSize',12, 'BackgroundColor','white', 'EdgeColor','black');

hold off;

% ——————————————
% 6. 輸出成 Excel（每列一組資料：第一欄波長，第二欄光強）
% ——————————————
data     = [lambda_nm(:), spec_dB(:)];    % 5001×2 矩陣：col1=wavelength, col2=intensity
filename = ['FPI_spectrum_' num2str(FSR_nm, '%.2f') '.xlsx'];
writematrix(data, filename);
