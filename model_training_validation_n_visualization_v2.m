

clear all
load Data_RLX_10s   % load extracted 10s relaxation voltages of 28 cells at different degradation phases
load t_Gs           % load timestamps where the relaxation voltages were extracted


%% data pre-processing
data_size = 11;

for k = 1:length(RLX)
    Xo(1,:,:,k) = reshape(RLX(k).volts,[1,data_size,1]);
    Xo(2,:,:,k) = reshape([diff(RLX(k).volts); 0],[1,data_size,1]);
    Yo(:,:,:,k) = reshape(RLX(k).Qd,[1,1,1]);
end

Xo = reshape(Xo, [2, data_size, 1, length(RLX)]);

x1 = Xo(1,:,:,:);
min_x1 = min(x1(:));
max_x1 = max(x1(:));
x2 = Xo(2,:,:,:);
min_x2 = min(x2(:));
max_x2 = max(x2(:));

X(1,:,:,:) = (Xo(1,:,:,:) - min_x1)/(max_x1 - min_x1);
X(2,:,:,:) = (Xo(2,:,:,:) - min_x2)/(max_x2 - min_x2);
X = reshape(X, [2, data_size, 1, length(RLX)]);
Y = (Yo - min(Yo(:)))/(max(Yo(:)) - min(Yo(:)));

%% Get the indices of cells in the "Data_RLX_10s" data file
G1_C9_id = [1, 6, 11, 14, 17, 22, 24, 31, 33, 36, 39, 42, 45, 50, 53, 54, 56, 58];
G1_C15_id = [2, 4, 8, 9, 12, 15, 18, 20, 26, 29, 32, 34, 37, 41, 43, 46, 48, 51, 55, 57, 59];
G1_C20_id = [3, 5, 7, 10, 13, 16, 19, 21, 23, 25, 27, 28, 30, 35, 38, 40, 44, 47, 49, 52];
G2_C3_id = [120, 126, 128, 131, 134, 136, 139, 142, 145, 147, 151] - 60;
G2_C4_id = [122, 127, 130, 132, 137, 141, 144, 148, 150, 152, 154] - 60;
G2_C8_id = [124, 125, 129, 133, 135, 138, 140, 143, 146, 149, 153] - 60;
G3_C10_id = [188, 192, 194, 197, 200, 203, 206, 209, 212, 215, 218, 221, 224, 227, 230, 233, 236, 238, 243, 245] - 93;
G3_C11_id = [189, 193, 195, 198, 201, 204, 207, 210, 213, 216, 219, 222, 225, 228, 231, 234, 237, 239, 241, 244, 246] - 93;
G3_C14_id = [190, 191, 196, 199, 202, 205, 208, 211, 214, 217, 220, 223, 226, 229, 232, 235, 240, 242, 247] - 93;
G4_C12_id = [307, 308, 311, 314, 316, 318, 321, 324, 326, 330, 332] - 152;
G4_C18_id = [309, 312, 315, 317, 319, 322, 325, 327, 329, 333] - 152;
G4_C19_id = [310, 313, 320, 323, 328, 331, 334, 335, 336, 337] - 152;
G5_C5_id = [369, 370, 374, 375, 376, 384, 385, 386, 387, 393, 397, 398, 399, 400, 401] - 183;
G5_C6_id = [371, 377, 378, 379, 388, 389, 390, 391, 394, 402, 403, 404, 405, 406, 412, 414] - 183;
G5_C16_id = [372, 373, 380, 381, 382, 383, 392, 395, 396, 407, 408, 409, 410, 411] - 183;
G6_C1_id = [458:488] - 226;
G7_C4_id = [513, 516, 519, 521, 524, 526, 530] - 250;
G7_C19_id = [514, 517, 520, 522, 525, 527, 531] - 250;
G7_C27_id = [515, 518, 523, 528, 529, 532] - 250;
G8_C5_id = [556, 559, 562, 565, 568, 571, 574, 577] - 273;
G8_C18_id = [557, 560, 563, 566, 569, 572, 575, 578] - 273;
G8_C20_id = [558, 561, 564, 567, 570, 573, 576, 579] - 273;
G9_C1_id = [604, 607, 610, 613, 616, 619, 622, 625] - 297;
G9_C8_id = [605, 608, 611, 614, 617, 620, 623, 626] - 297;
G9_C9_id = [606, 609, 612, 615, 618, 621, 624, 627] - 297;
G10_C2_id = [652, 655, 658, 661, 664, 667, 672, 674, 677, 680, 683, 686] - 321;
G10_C22_id = [653, 656, 659, 662, 665, 668, 670, 673, 676, 678, 681, 684, 688] - 321;
G10_C25_id = [654, 657, 660, 663, 666, 669, 671, 675, 679, 682, 685, 687, 689] - 321;

G_C_ids = cell(28, 1);
G_C_ids{1} = G1_C9_id;
G_C_ids{2} = G1_C15_id;
G_C_ids{3} = G1_C20_id;
G_C_ids{4} = G2_C3_id;
G_C_ids{5} = G2_C4_id;
G_C_ids{6} = G3_C10_id;
G_C_ids{7} = G3_C11_id;

G_C_ids{8} = G2_C8_id;
G_C_ids{9} = G4_C12_id;
G_C_ids{10} = G4_C18_id;
G_C_ids{11} = G4_C19_id;
G_C_ids{12} = G5_C6_id;
G_C_ids{13} = G3_C14_id;
G_C_ids{14} = G5_C5_id;

G_C_ids{15} = G5_C16_id;
G_C_ids{16} = G7_C4_id;
G_C_ids{17} = G7_C19_id;
G_C_ids{18} = G7_C27_id;
G_C_ids{19} = G9_C1_id;
G_C_ids{20} = G6_C1_id;
G_C_ids{21} = G8_C5_id;

G_C_ids{22} = G9_C8_id;
G_C_ids{23} = G9_C9_id;
G_C_ids{24} = G10_C2_id;
G_C_ids{25} = G10_C22_id;
G_C_ids{26} = G10_C25_id;
G_C_ids{27} = G8_C18_id;
G_C_ids{28} = G8_C20_id;

t_ids = cell(28, 1);
t_ids{1} = t_G1_C9;
t_ids{2} = t_G1_C15;
t_ids{3} = t_G1_C20;
t_ids{4} = t_G2_C3;
t_ids{5} = t_G2_C4;
t_ids{6} = t_G3_C10;
t_ids{7} = t_G3_C11;

t_ids{8} = t_G2_C8;
t_ids{9} = t_G4_C12;
t_ids{10} = t_G4_C18;
t_ids{11} = t_G4_C19;
t_ids{12} = t_G5_C6;
t_ids{13} = t_G3_C14;
t_ids{14} = t_G5_C5;

t_ids{15} = t_G5_C16;
t_ids{16} = t_G7_C4;
t_ids{17} = t_G7_C19;
t_ids{18} = t_G7_C27;
t_ids{19} = t_G9_C1;
t_ids{20} = t_G6_C1;
t_ids{21} = t_G8_C5;

t_ids{22} = t_G9_C8;
t_ids{23} = t_G9_C9;
t_ids{24} = t_G10_C2;
t_ids{25} = t_G10_C22;
t_ids{26} = t_G10_C25;
t_ids{27} = t_G8_C18;
t_ids{28} = t_G8_C20;


%% Assign training and validation datasets
rng(0)
valInd = [G3_C10_id, G3_C11_id, G3_C14_id ,G5_C5_id, G6_C1_id, G8_C5_id, G8_C18_id, G8_C20_id]; %G3, G5_C5, G6 and G8
trainInd = setdiff(1:length(RLX),valInd);

%% Train the CNN model

no_cnn_filter1 = 8;
no_cnn_filter2 = 16;
no_cnn_filter3 = 64;
no_cnn_filter4 = 256;
size_filter1 = 5;
size_filter2 = 5;
size_filter3 = 5;
size_filter4 = 5;
no_fc1 = 160;
no_fc2 = 100;
no_fc3 = 20;

[convnet ,info, X_train, X_val, Y_train, Y_val] = CNN_Train_10s_v2(data_size, X, Y, trainInd, valInd,...
    no_cnn_filter1, no_cnn_filter2, no_cnn_filter3, no_cnn_filter4, size_filter1, size_filter2, size_filter3, size_filter4, no_fc1, no_fc2, no_fc3);

%% Calculate model performance metrics, for the whole validation datasets and for each individual validation cell

Y_s = squeeze(Y);
Y_train_Ah = squeeze(Y_train)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));
Y_val_Ah = squeeze(Y_val)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));
YModel = predict(convnet,X_train)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));
YPredicted = predict(convnet,X_val)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));
TrainError = Y_train_Ah - YModel;
predictionError = Y_val_Ah - YPredicted;
val_all_ape = sum(abs(predictionError)./squeeze(Y_val_Ah))/length(squeeze(Y_val_Ah));


val_rmse = zeros(8,1);
val_ape = zeros(8,1);
val_count = 0;

%% Visualize the model performance 
figure
t = tiledlayout(4,9);
err_bnd = 0.03;
err_bnd_perc = err_bnd*100;

nexttile(1,[2 2])
scatter(YModel,squeeze(Y_train)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:)),9,'o','filled')
hold on
scatter(YPredicted,squeeze(Y_val)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:)),11,'^','filled')
plot([2 3.5], [2 3.5],'k--')
axis([2 3.5 2 3.5])
box on
xlabel('Estimated Capacity (Ah)','FontSize',12)
ylabel('Measured Capacity (Ah)','FontSize',12)
leg1 = legend('Training','Validation','Location','northwest');
leg1.ItemTokenSize = [10,10];

nexttile(19,[2 2])
TE = TrainError./squeeze(Y_train_Ah)*100;
PE = predictionError./squeeze(Y_val_Ah)*100;
histogram(TE)
hold on
histogram(PE)
xlim([-10 10])
Y_lim = get(gca,'ylim');
plot([-err_bnd_perc -err_bnd_perc],[Y_lim(1), Y_lim(2)],'k--')
plot([err_bnd_perc err_bnd_perc],[Y_lim(1), Y_lim(2)],'k--')
xlabel({'Histogram of Percent Errors (%)'},'FontSize',12)
ylabel('Count','FontSize',12)
leg2 = legend('Training','Validation','Location','northwest');
leg2.ItemTokenSize = [10,10];

k_out_1 = 0;
k_out_2 = 0;

for j = 1:length(G_C_ids)

    G_C_id = G_C_ids{j};

    if any(j == [1:5, 8:12, 15:19, 22:26])

        nexttile

        xx = t_ids{j}';
        x = xx - xx(1);
        c = Y_s(G_C_id)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));
        c_up = c' + err_bnd*c';
        c_dn = c' - err_bnd*c';

        c_pred = predict(convnet,X(:,:,:,G_C_id))*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));
        
        a1 = plot(x, Y_s(G_C_id)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:)),'color',[0.8500 0.3250 0.0980],'LineWidth',2);
        hold on
        a2 = plot(x, predict(convnet,X(:,:,:,G_C_id))*(max(Yo(:)) - min(Yo(:))) + min(Yo(:)),'b','marker','o','markersize',4);

        x2 = [x, fliplr(x)];
        inBetween = [c_up, fliplr(c_dn)];
        a3 = fill(x2, inBetween, 'b','FaceAlpha',0.05,'EdgeAlpha',0.2);
        box on

        if j < 6
            title(['T-',num2str(j)])
        elseif j > 6 && j < 13
            title(['T-',num2str(j-2)])
        elseif j > 13 && j < 20
            title(['T-',num2str(j-4)])
        else
            title(['T-',num2str(j-6)])
        end

        for n = 1:length(c_pred)
            if c_pred(n) > c_up(n) || c_pred(n) < c_dn(n)
                k_out_1 = k_out_1 + 1;
            end
        end
    else
        val_count = val_count + 1;
        nexttile

        x = t_ids{j}';
        c = Y_s(G_C_id)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));
        c_up = c' + err_bnd*c';
        c_dn = c' - err_bnd*c';

        c_pred = predict(convnet,X(:,:,:,G_C_id))*(max(Yo(:)) - min(Yo(:))) + min(Yo(:));

        val_rmse(val_count) = rms(c - c_pred);
        val_ape(val_count) = sum(abs(c - c_pred)./c)/length(c);

        a4 = plot(x, Y_s(G_C_id)*(max(Yo(:)) - min(Yo(:))) + min(Yo(:)),'color',[0.8500 0.3250 0.0980],'LineWidth',2);
        hold on
        a5 = plot(x, predict(convnet,X(:,:,:,G_C_id))*(max(Yo(:)) - min(Yo(:))) + min(Yo(:)),...
            'color',[0.4660 0.6740 0.1880],'LineWidth',0.8,'marker','^','markersize',4);

        x2 = [x, fliplr(x)];
        inBetween = [c_up, fliplr(c_dn)];
        a6 = fill(x2, inBetween, 'b','FaceAlpha',0.05,'EdgeAlpha',0.2);
        box on
        
        if j < 9
            title(['V-',num2str(j-5)])
        elseif j > 10 && j < 15
            title(['V-',num2str(j-10)])
        elseif j > 16 && j < 22
            title(['V-',num2str(j-15)])
        else
            title(['V-',num2str(j-20)])
        end

        for n = 1:length(c_pred)
            if c_pred(n) > c_up(n) || c_pred(n) < c_dn(n)
                k_out_2 = k_out_2 + 1;
            end
        end

    end
    ylim([2 3.5])

end

legend([a1, a2, a5, a6],{'Measured Capacity','Estimated Capacity (Training)','Estimated Capacity (Validation)',[num2str(err_bnd_perc),'% Error Bound']},...
    'Orientation','horizontal','FontSize',10)
annotation('textbox',[0.06 0.91 0.1 0.1],'String','a','EdgeColor','none','FontWeight','bold','FontSize',20)
annotation('textbox',[0.06 0.42 0.1 0.1],'String','b','EdgeColor','none','FontWeight','bold','FontSize',20)
annotation('textbox',[0.26 0.91 0.1 0.1],'String','c','EdgeColor','none','FontWeight','bold','FontSize',20)

annotation(gcf,'textarrow',...
    [0.925 0.925], [0.58 0.58],...
    'String','Capacity (Ah)', 'HeadStyle', 'none', 'LineStyle', 'none',...
    'FontSize',12, 'color','k', 'TextRotation',90);

annotation('textbox',[0.56 0.03 0.5 0.05],'String','Time (Days)','EdgeColor','none','FontSize',12)

outlayer_train = k_out_1/length(trainInd)*100;
outlayer_val = k_out_2/length(valInd)*100;










