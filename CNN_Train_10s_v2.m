function [convnet ,info, X_train, X_val, Y_train, Y_val] = CNN_Train_10s_v2(data_size, X, Y, trainInd, valInd, no_cnn_filter1, no_cnn_filter2, no_cnn_filter3, no_cnn_filter4,...
    size_filter1, size_filter2, size_filter3, size_filter4, no_fc1, no_fc2, no_fc3)

rng(0)
X_train = X(:,:,:,trainInd);
X_val = X(:,:,:,valInd);
Y_train = Y(:,:,:,trainInd);
Y_val = Y(:,:,:,valInd);

layers = [
    imageInputLayer([2 data_size])
    
    convolution2dLayer([2 size_filter1],no_cnn_filter1,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    convolution2dLayer([2 size_filter2],no_cnn_filter2,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    convolution2dLayer([2 size_filter3],no_cnn_filter3,'Padding','same')
    batchNormalizationLayer
    reluLayer

    convolution2dLayer([2 size_filter4],no_cnn_filter4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    dropoutLayer(0.2)
    fullyConnectedLayer(no_fc1)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(no_fc2)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(no_fc3)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer];

miniBatchSize  = 50;
validationFrequency = floor(numel(Y_train)/miniBatchSize);
options = trainingOptions('adam', ...
    'MaxEpochs',200, ...
    'InitialLearnRate',1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',40, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{X_val,Y_val}, ...
    'ValidationFrequency',validationFrequency, ...
    'Verbose',false,...
    'ExecutionEnvironment','cpu');

[convnet ,info] = trainNetwork(X_train,Y_train,layers,options);

